# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/windows.bash"

if [ -z "$BATS_TMPDIR" ]; then
  export BATS_TMPDIR=${TEMP:-/tmp}/bats/
  mkdir -p "$BATS_TMPDIR"
fi

EXE="${EXE:-}"
CRYSTAL="${CRYSTAL:-crystal${EXE}}"
SHARDS="${SHARDS:-shards${EXE}}"
MAKE="${MAKE:-make${EXE}}"

function git_checkout() {
  local URL="$1"
  local TARGET="$BATS_TMPDIR/${1##*/}"

  if [ -d "$TARGET" ]; then
    cd "$TARGET" || exit 1
    git checkout --force origin/HEAD
    git pull origin HEAD
    git submodule update --init
  else
    git clone --recursive "$URL" "$TARGET"
    cd "$TARGET" || exit 1
  fi
}

function shard_checkout() {
  git_checkout "$1"

  # --skip-postinstall to prevent ameba building itself many times over
  # --skip-executables is required with --skip-postinstall because postinstall
  # executables are missing (https://github.com/crystal-lang/shards/issues/498).
  $SHARDS install --skip-postinstall --skip-executables
}

function crystal_spec() {
  $CRYSTAL spec --junit_output ".junit/interpreter-std_spec.$BATS_TEST_NAME.xml"
}
