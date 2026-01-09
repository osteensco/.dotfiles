#!/usr/bin/env python3
import os
import sys
import shutil
import json
import platform
import argparse
from pathlib import Path

# Constants
HOME = Path.home()
REPO_ROOT = Path(__file__).parent.resolve()
REPO_HOME = REPO_ROOT / "home"
CONFIG_FILE = REPO_ROOT / "config.json"

def load_config():
    if not CONFIG_FILE.exists():
        return {"mappings": []}
    with open(CONFIG_FILE, 'r') as f:
        return json.load(f)

def get_os_key():
    system = platform.system().lower()
    if system == "darwin":
        return "macos"
    elif system == "linux":
        return "linux"
    elif system == "windows":
        return "windows"
    return "unknown"

def resolve_mapping(repo_rel_path, config):
    """
    Check if a repo path has an OS-specific mapping.
    Returns the target system path (Path object).
    """
    current_os = get_os_key()
    
    for mapping in config.get("mappings", []):
        # check if this mapping applies to the current file
        # The mapping key in json might be "repo_path"
        if mapping.get("repo_path") == str(repo_rel_path):
             # Check for OS specific override
            if current_os in mapping:
                return Path(mapping[current_os]).expanduser()
            # Check for generic 'target_path'
            if "target_path" in mapping:
                return Path(mapping["target_path"]).expanduser()
                
    # Default behavior: mirror path relative to home
    # repo_rel_path is something like ".config/nvim/init.lua"
    return HOME / repo_rel_path

def resolve_reverse_mapping(system_abs_path, config):
    """
    Find where a system file belongs in the repo.
    Returns (repo_full_path, repo_rel_path_str)
    """
    try:
        sys_rel_home = system_abs_path.relative_to(HOME)
    except ValueError:
        sys_rel_home = None # Not under home

    current_os = get_os_key()
    
    # Check explicit mappings first
    for mapping in config.get("mappings", []):
        target = None
        if current_os in mapping:
            target = Path(mapping[current_os]).expanduser()
        elif "target_path" in mapping:
            target = Path(mapping["target_path"]).expanduser()
            
        if target and target.resolve() == system_abs_path.resolve():
            return (REPO_ROOT / mapping["repo_path"], mapping["repo_path"])

    # Default mapping
    if sys_rel_home:
        return (REPO_HOME / sys_rel_home, str(sys_rel_home))
    
    return (None, None)

def copy_file(src, dst):
    if src.is_dir():
        if dst.exists():
            shutil.rmtree(dst)
        shutil.copytree(src, dst, dirs_exist_ok=True)
    else:
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(src, dst)
    print(f"Copied {src} -> {dst}")

def command_apply(args):
    """Repo -> System"""
    print("Applying dotfiles...")
    config = load_config()

    # 1. Walk REPO_HOME and copy to HOME (default mirror)
    # But we need to check if any of these are overridden by config
    # Actually, iterate all files in REPO_HOME
    
    if REPO_HOME.exists():
        for root, dirs, files in os.walk(REPO_HOME):
            for name in files + dirs:
                repo_path = Path(root) / name
                rel_path = repo_path.relative_to(REPO_HOME)
                
                # Logic: Check if this file/dir is part of a mapping
                # If it IS in mapping, map it.
                # If NOT, mirror it.
                
                # Note: This simple walk might process a child of a mapped dir. 
                # If we map "home/.config/nvim", we don't want to double copy children.
                # So we should probably do a smarter traversal or just explicit + mirror.
                
                # Simplified approach:
                # 1. Process explicit mappings
                # 2. Process everything else in REPO_HOME that ISN'T covered by a mapping
                pass

    # Better approach:
    # 1. Gather all "sources" from REPO_HOME and Config.
    # 2. execute copy.
    
    # Let's just walk REPO_HOME.
    # If a directory is encountered, and the directory ITSELF is mapped, copy it and skip recursion?
    # For now, let's assume mappings are usually files or top-level config dirs.
    
    # Copy from REPO_HOME (Mirroring)
    if REPO_HOME.exists():
        # shutil.copytree with dirs_exist_ok is easiest for the bulk mirror, 
        # but we need to respect mappings.
        # We'll walk.
        
        for root, dirs, files in os.walk(REPO_HOME):
            # Sort to ensure consistent order
            dirs.sort()
            files.sort()
            
            # Filter out excluded dirs/files if necessary
            
            for file in files:
                repo_file = Path(root) / file
                rel_path = repo_file.relative_to(REPO_HOME)
                
                # Check mapping
                # We need to see if this file OR any of its parents are mapped?
                # Actually, our resolve_mapping takes the repo_rel_path.
                
                # Does config.json map this specific file?
                target = resolve_mapping(str(rel_path), config)
                copy_file(repo_file, target)

    # Handle mappings that might live outside REPO_HOME? 
    # The prompt implies: "json path map from dotfiles repo to real file location"
    # Files usually live in REPO_HOME or a specific 'os_specific' dir?
    # For now, we assume everything valid is under REPO_HOME or defined in mappings pointing to files inside REPO_ROOT.
    
    for mapping in config.get("mappings", []):
        repo_path = REPO_ROOT / mapping["repo_path"]
        if repo_path.exists():
             # We might have already copied it if it was in REPO_HOME and we walked it.
             # But if resolve_mapping works correctly, it returned the mapped path.
             # If the file is NOT in REPO_HOME (e.g. repo/misc/config), we need to explicit copy.
             if not str(repo_path).startswith(str(REPO_HOME)):
                 target = resolve_mapping(mapping["repo_path"], config)
                 copy_file(repo_path, target)

def command_add(args):
    """System -> Repo (Specific file)"""
    target_file = Path(args.file).resolve()
    if not target_file.exists():
        print(f"Error: File {target_file} does not exist.")
        sys.exit(1)
        
    config = load_config()
    repo_dst, rel_path = resolve_reverse_mapping(target_file, config)
    
    if not repo_dst:
        print(f"Error: Could not determine repo location for {target_file}. Is it under $HOME?")
        sys.exit(1)
        
    copy_file(target_file, repo_dst)
    print(f"Added {target_file} to {repo_dst}")

def command_update(args):
    """System -> Repo (All tracked files)"""
    print("Updating repo from system...")
    config = load_config()
    
    # Walk REPO_HOME and reverse-copy
    if REPO_HOME.exists():
        for root, dirs, files in os.walk(REPO_HOME):
            for file in files:
                repo_file = Path(root) / file
                rel_path = repo_file.relative_to(REPO_HOME)
                
                # Find where this file comes from on system
                # By default: HOME / rel_path
                # Or check mapping
                
                # We can reuse resolve_mapping to find the system target, then copy system->repo
                system_src = resolve_mapping(str(rel_path), config)
                
                if system_src.exists():
                    # Check for diff? Prompt says "changes always forced overwrite"
                    copy_file(system_src, repo_file)
                else:
                    print(f"Warning: System file {system_src} missing, skipping update.")

    # Also handle mapped files outside REPO_HOME if any
    for mapping in config.get("mappings", []):
         repo_path = REPO_ROOT / mapping["repo_path"]
         if not str(repo_path).startswith(str(REPO_HOME)):
             system_src = resolve_mapping(mapping["repo_path"], config)
             if system_src.exists():
                 copy_file(system_src, repo_path)


def main():
    parser = argparse.ArgumentParser(description="Dotfiles Manager")
    subparsers = parser.add_subparsers(dest="command", required=True)
    
    parser_add = subparsers.add_parser("add", help="Add a file to dotfiles")
    parser_add.add_argument("file", help="Path to file to add")
    
    parser_apply = subparsers.add_parser("apply", help="Apply dotfiles to system")
    
    parser_update = subparsers.add_parser("update", help="Update repo from system")
    
    args = parser.parse_args()
    
    if args.command == "add":
        command_add(args)
    elif args.command == "apply":
        command_apply(args)
    elif args.command == "update":
        command_update(args)

if __name__ == "__main__":
    main()
