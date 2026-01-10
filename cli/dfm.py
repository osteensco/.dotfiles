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
REPO_ROOT = Path(__file__).parent.parent.resolve()
REPO_HOME = REPO_ROOT / "home"
MAP_FILE = REPO_ROOT / "mappings.json"
IS_MAC = platform.system().lower() == "darwin"



def load_mappings():
    try:
        with open(MAP_FILE, 'r') as f:
            return json.load(f)
    except FileNotFoundError:
        return None


def resolve_mapping(filepath, mappings):
    """
    Check if a config filepath has an OS-specific mapping.
    Returns corrected filepath.
    """
    if not mappings:
        return filepath
    if IS_MAC and "mac" in mappings:
        for k,v in mappings["mac"].items():
            if Path(k) == filepath:
                return Path(v)
    return filepath
    
def resolve_reverse_mapping(filepath, mappings):
    """
    Find where a system file belongs in the repo.
    Returns corrected filepath
    """
    if not mappings:
        return filepath
    if IS_MAC and "mac" in mappings:
        for k,v in mappings["mac"].items():
            if Path(v) == filepath:
                return Path(k)
    return filepath

def copy_file(src, dst):
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    print(f"Copied {src} -> {dst}")

def command_apply(args):
    """Repo -> System"""
    print("Applying dotfiles...")
    
    mappings = load_mappings()
    
    if REPO_HOME.exists():
        for root, dirs, files in os.walk(REPO_HOME):
            for file in files:
                repo_file = Path(root) / file
                rel_path = repo_file.relative_to(REPO_HOME)
                target = resolve_mapping(rel_path, mappings)
                target = HOME / target
                copy_file(repo_file, target)


def command_add(args):
    """System -> Repo (Specific file)"""
    target_file = Path(args.file).resolve()
    if not target_file.exists():
        print(f"Error: File {target_file} does not exist.")
        sys.exit(1)
    if not target_file.is_relative_to(HOME):
        print("Error: Can only add files from your home directory.")
        sys.exit(1)
    
    target_file = target_file.relative_to(HOME)
    mappings = load_mappings()
    repo_file = resolve_reverse_mapping(target_file, mappings)
    repo_file = REPO_HOME / repo_file
    copy_file(HOME / target_file, repo_file)

def command_update_all(args):
    """System -> Repo (All tracked files)"""
    print("Updating repo from system...")
    mappings = load_mappings()
    
    if REPO_HOME.exists():
        for root, dirs, files in os.walk(REPO_HOME):
            for file in files:
                repo_file = Path(root) / file
                rel_path = repo_file.relative_to(REPO_HOME)
                system_src = resolve_mapping(rel_path, mappings)
                system_src = HOME / system_src
                
                if system_src.exists():
                    copy_file(system_src, repo_file)
                else:
                    print(f"Warning: System file {system_src} missing, skipping update.")


def main():
    parser = argparse.ArgumentParser(description="Dotfiles Manager")
    subparsers = parser.add_subparsers(dest="command", required=True)
    
    parser_add = subparsers.add_parser("add", help="Add a file to dotfiles")
    parser_add.add_argument("file", help="Path to file to add")
    
    parser_apply = subparsers.add_parser("apply", help="Apply dotfiles to system")
    
    parser_update_all = subparsers.add_parser("update", help="Update repo from system")
    
    args = parser.parse_args()
    
    if args.command == "add":
        command_add(args)
    elif args.command == "apply":
        command_apply(args)
    elif args.command == "update":
        command_update_all(args)

if __name__ == "__main__":
    main()
