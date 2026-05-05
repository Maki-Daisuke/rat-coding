#!/usr/bin/env sh
set -eu

usage() {
  cat <<'EOF'
Usage: install.sh [--force] [--source PATH] [--repository URL] [--ref REF]

Installs Rat-Coding into the current workspace by default.

Options:
  --force, -f          Overwrite existing Rat-Coding files when they differ.
  --source PATH        Install from a local Rat-Coding source checkout.
  --repository URL     GitHub repository URL to download from.
  --ref REF            Branch name to download. Defaults to main.
  --help, -h           Show this help.
EOF
}

force=0
source_dir=${RAT_CODING_SOURCE:-}
repository=${RAT_CODING_REPOSITORY:-https://github.com/yanother/rat-coding}
ref=${RAT_CODING_REF:-main}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --force|-f)
      force=1
      shift
      ;;
    --source)
      source_dir=$2
      shift 2
      ;;
    --repository)
      repository=$2
      shift 2
      ;;
    --ref)
      ref=$2
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

need_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Required command not found: $1" >&2
    exit 1
  fi
}

checksum_file() {
  if command -v sha256sum >/dev/null 2>&1; then
    sha256sum "$1" | awk '{print $1}'
  elif command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | awk '{print $1}'
  else
    echo "Required command not found: sha256sum or shasum" >&2
    exit 1
  fi
}

files_equal() {
  [ -f "$2" ] && [ "$(checksum_file "$1")" = "$(checksum_file "$2")" ]
}

directories_equal() {
  [ -d "$2" ] || return 1

  first_list=$(mktemp)
  second_list=$(mktemp)
  first_hashes=$(mktemp)
  second_hashes=$(mktemp)

  (cd "$1" && find . -type f | sort) > "$first_list"
  (cd "$2" && find . -type f | sort) > "$second_list"

  if ! cmp -s "$first_list" "$second_list"; then
    rm -f "$first_list" "$second_list" "$first_hashes" "$second_hashes"
    return 1
  fi

  while IFS= read -r path; do
    printf '%s  %s\n' "$(checksum_file "$1/$path")" "$path"
  done < "$first_list" > "$first_hashes"

  while IFS= read -r path; do
    printf '%s  %s\n' "$(checksum_file "$2/$path")" "$path"
  done < "$second_list" > "$second_hashes"

  if cmp -s "$first_hashes" "$second_hashes"; then
    rm -f "$first_list" "$second_list" "$first_hashes" "$second_hashes"
    return 0
  fi

  rm -f "$first_list" "$second_list" "$first_hashes" "$second_hashes"
  return 1
}

copy_file_checked() {
  source_file=$1
  destination_file=$2

  if [ -e "$destination_file" ]; then
    if files_equal "$source_file" "$destination_file"; then
      echo "Up to date: $destination_file"
      return 0
    fi
    if [ "$force" -ne 1 ]; then
      echo "Refusing to overwrite existing file: $destination_file. Re-run with --force if this is intentional." >&2
      exit 1
    fi
  fi

  mkdir -p "$(dirname "$destination_file")"
  cp "$source_file" "$destination_file"
  echo "Installed: $destination_file"
}

copy_directory_checked() {
  source_path=$1
  destination_path=$2

  if [ -e "$destination_path" ]; then
    if directories_equal "$source_path" "$destination_path"; then
      echo "Up to date: $destination_path"
      return 0
    fi
    if [ "$force" -ne 1 ]; then
      echo "Refusing to overwrite existing directory: $destination_path. Re-run with --force if this is intentional." >&2
      exit 1
    fi
  fi

  mkdir -p "$destination_path"
  cp -R "$source_path"/. "$destination_path"/
  echo "Installed: $destination_path"
}

temporary_root=
cleanup() {
  if [ -n "$temporary_root" ] && [ -d "$temporary_root" ]; then
    rm -rf "$temporary_root"
  fi
}
trap cleanup EXIT INT TERM

if [ -n "$source_dir" ]; then
  source_root=$source_dir
else
  need_command curl
  need_command tar

  temporary_root=$(mktemp -d)
  archive_url="${repository%/}/archive/refs/heads/$ref.tar.gz"
  archive_path="$temporary_root/rat-coding.tar.gz"

  echo "Downloading Rat-Coding from $archive_url"
  curl -fsSL "$archive_url" -o "$archive_path"
  tar -xzf "$archive_path" -C "$temporary_root"
  source_root=$(find "$temporary_root" -mindepth 1 -maxdepth 1 -type d | head -n 1)
fi

if [ ! -f "$source_root/AGENTS.md" ]; then
  echo "Rat-Coding source is missing AGENTS.md: $source_root/AGENTS.md" >&2
  exit 1
fi

if [ ! -d "$source_root/.agents/skills" ]; then
  echo "Rat-Coding source is missing .agents/skills: $source_root/.agents/skills" >&2
  exit 1
fi

target_root=$(pwd)

copy_file_checked "$source_root/AGENTS.md" "$target_root/AGENTS.md"
mkdir -p "$target_root/.agents/skills"

for skill_dir in "$source_root"/.agents/skills/*; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  copy_directory_checked "$skill_dir" "$target_root/.agents/skills/$skill_name"
done

echo "Rat-Coding installed for workspace scope at $target_root"