#!/usr/bin/env python3
"""Bump this tap's formulae to the latest upstream GitHub release.

For every formula configured below, fetch the latest release of its upstream
repository, download each platform asset, compute its SHA-256, and rewrite the
formula's url/sha256 pairs in place.

The formulae in this tap use the following layout, which this script expects:

    on_macos do
      on_arm do
        url "..."
        sha256 "..."
      end
      ...
    end

    on_linux do
      ...
    end

If a formula's layout or an upstream asset name changes, the script raises an
error instead of writing a partially updated formula.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import sys
import urllib.request
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
USER_AGENT = "wgzhao-homebrew-tap-autobump"

FORMULAE = [
    {
        "formula": "Formula/hdfs-go.rb",
        "repo": "wgzhao/hdfs-go",
        "assets": {
            ("macos", "arm"): "gohdfs-{tag}-darwin-arm64.tar.gz",
            ("macos", "intel"): "gohdfs-{tag}-darwin-amd64.tar.gz",
            ("linux", "arm"): "gohdfs-{tag}-linux-arm64.tar.gz",
            ("linux", "intel"): "gohdfs-{tag}-linux-amd64.tar.gz",
        },
    },
    {
        "formula": "Formula/hive-go.rb",
        "repo": "wgzhao/hive-go",
        "assets": {
            ("macos", "arm"): "hive-{tag}-darwin-arm64.tar.gz",
            ("macos", "intel"): "hive-{tag}-darwin-amd64.tar.gz",
            ("linux", "arm"): "hive-{tag}-linux-arm64.tar.gz",
            ("linux", "intel"): "hive-{tag}-linux-amd64.tar.gz",
        },
    },
    {
        "formula": "Formula/lingbox.rb",
        "repo": "wgzhao/ling-box",
        "assets": {
            ("macos", "arm"): "lingbox-macos-arm64",
            ("macos", "intel"): "lingbox-macos-x86-64",
            ("linux", "arm"): "lingbox-linux-arm64",
            ("linux", "intel"): "lingbox-linux-x86-64",
        },
    },
]

URL_VERSION_RE = re.compile(r"/releases/download/(v?[^/\"]+)/")


def api_request(url: str) -> dict:
    headers = {
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
        "User-Agent": USER_AGENT,
    }
    token = os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
    if token:
        headers["Authorization"] = f"Bearer {token}"
    request = urllib.request.Request(url, headers=headers)
    with urllib.request.urlopen(request, timeout=60) as response:
        return json.load(response)


def latest_release(repo: str) -> tuple[str, dict[str, str]]:
    release = api_request(f"https://api.github.com/repos/{repo}/releases/latest")
    tag = release.get("tag_name")
    if not tag:
        raise RuntimeError("latest release has no tag_name")
    assets = {
        asset["name"]: asset["browser_download_url"]
        for asset in release.get("assets", [])
    }
    return tag, assets


def remote_sha256(url: str) -> str:
    request = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    digest = hashlib.sha256()
    with urllib.request.urlopen(request, timeout=300) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def current_version(text: str) -> str:
    versions = {
        match.group(1).removeprefix("v")
        for match in URL_VERSION_RE.finditer(text)
    }
    if len(versions) != 1:
        raise RuntimeError(
            f"expected one pinned version in the formula, found: {sorted(versions)}"
        )
    return versions.pop()


def version_key(version: str) -> tuple[int, ...]:
    return tuple(
        int(match.group()) if (match := re.match(r"\d+", part)) else -1
        for part in re.split(r"[.+-]", version)
    )


def enclosing_platform(stack: list[dict]) -> tuple[str | None, str | None]:
    os_name = next((entry["os"] for entry in reversed(stack) if entry["os"]), None)
    arch = next((entry["arch"] for entry in reversed(stack) if entry["arch"]), None)
    return os_name, arch


def rewrite_formula(
    text: str,
    new_urls: dict[tuple[str, str], str],
    new_sha256: dict[tuple[str, str], str],
) -> str:
    lines = text.splitlines(keepends=True)
    stack: list[dict] = []
    output: list[str] = []
    replaced_urls: set[tuple[str, str]] = set()
    replaced_sha256: set[tuple[str, str]] = set()

    for line in lines:
        stripped = line.strip()
        indent = len(line) - len(line.lstrip(" \t"))
        content = line.rstrip("\r\n")

        if stripped == "end":
            while stack and indent <= stack[-1]["indent"]:
                stack.pop()
        elif match := re.fullmatch(r"on_(macos|linux) do", stripped):
            stack.append({"indent": indent, "os": match.group(1), "arch": None})
        elif match := re.fullmatch(r"on_(arm|intel) do", stripped):
            os_name, _ = enclosing_platform(stack)
            stack.append({"indent": indent, "os": os_name, "arch": match.group(1)})
        elif match := re.fullmatch(r'(\s*)url "([^"]*)"', content):
            platform = enclosing_platform(stack)
            if platform in new_urls:
                line = f'{match.group(1)}url "{new_urls[platform]}"\n'
                replaced_urls.add(platform)
        elif match := re.fullmatch(r'(\s*)sha256 "([^"]*)"', content):
            platform = enclosing_platform(stack)
            if platform in new_sha256:
                line = f'{match.group(1)}sha256 "{new_sha256[platform]}"\n'
                replaced_sha256.add(platform)

        output.append(line)

    missing_urls = set(new_urls) - replaced_urls
    missing_sha256 = set(new_sha256) - replaced_sha256
    if missing_urls or missing_sha256:
        raise RuntimeError(
            "formula layout not understood; could not replace "
            f"urls for {sorted(missing_urls)} and sha256 for {sorted(missing_sha256)}"
        )

    return "".join(output)


def bump_formula(spec: dict, dry_run: bool) -> str | None:
    path = REPO_ROOT / spec["formula"]
    text = path.read_text()
    current = current_version(text)

    tag, assets = latest_release(spec["repo"])
    version = tag.removeprefix("v")

    if version_key(version) <= version_key(current):
        return None

    new_urls: dict[tuple[str, str], str] = {}
    new_sha256: dict[tuple[str, str], str] = {}
    missing: list[str] = []

    for platform, template in spec["assets"].items():
        asset_name = template.format(tag=tag)
        asset_url = assets.get(asset_name)
        if not asset_url:
            missing.append(asset_name)
            continue
        new_urls[platform] = asset_url
        new_sha256[platform] = remote_sha256(asset_url)

    if missing:
        available = ", ".join(sorted(assets)) or "none"
        raise RuntimeError(
            f"{spec['repo']} {tag} is missing assets {missing}; available: {available}"
        )

    updated = rewrite_formula(text, new_urls, new_sha256)
    if updated == text:
        raise RuntimeError("computed update produced no changes")

    if not dry_run:
        path.write_text(updated)

    return f"{path.stem}: {current} -> {version}"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="compute and validate updates without writing formula files",
    )
    args = parser.parse_args()

    lines: list[str] = []
    errors = 0
    updated = 0

    for spec in FORMULAE:
        name = Path(spec["formula"]).stem
        try:
            message = bump_formula(spec, args.dry_run)
        except Exception as exc:  # noqa: BLE001 - report per formula and continue
            errors += 1
            message = f"{name}: update failed: {exc}"
            print(f"::warning file={spec['formula']}::{message}")
        else:
            if message is None:
                message = f"{name}: already up to date"
                print(message)
            else:
                updated += 1
                print(message)
        lines.append(message)

    summary_path = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary_path:
        with open(summary_path, "a", encoding="utf-8") as summary:
            summary.write("### Autobump\n\n")
            for line in lines:
                summary.write(f"- {line}\n")

    if errors and not updated:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
