# shellcheck disable=SC1091
source "$(dirname "${BASH_SOURCE[0]}")/windows.bash"

if [ -z "$BATS_TMPDIR" ]; then
  export BATS_TMPDIR=${TEMP:-/tmp}/bats/
  mkdir -p "$BATS_TMPDIR"
fi

EXE="${EXE:-}"
CRYSTAL="${CRYSTAL:-crystal${EXE}}"
CRYSTAL_BASE="${CRYSTAL_BASE:-crystal${EXE}}"
SHARDS="${SHARDS:-shards${EXE}}"
MAKE="${MAKE:-make${EXE}}"

function git_checkout() {
  local URL="$1"
  local TARGET="$BATS_TMPDIR/workdir/${1##*/}"

  if [ -d "$TARGET" ]; then
    cd "$TARGET" || exit 1
    git checkout --force origin/HEAD
    git pull origin HEAD
    git submodule update --init
  else
    git clone --recursive "$URL" "$TARGET"
    cd "$TARGET" || exit 1
  fi

  git describe --tags
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

function crystal_format() {
  $CRYSTAL tool format --check || {
    retval=$?

    # Print formatter diff
    $CRYSTAL tool format
    git diff && git checkout -- .

    return $retval
  }
}

function crystal_format_with_base() {
  echo "Running '$CRYSTAL_BASE tool format' for a baseline"
  $CRYSTAL_BASE tool format
  git add -u

  crystal_format || {
    retval=$?

    git reset --hard HEAD
    return $retval
  }

  git diff --check || echo "Baseline formatting issues detected, but no formatting changes on top of baseline"
  git reset --hard HEAD
}

function check_crystal_format() {
  shard_checkout "$1"

  if [ "$CRYSTAL" != "$CRYSTAL_BASE" ]; then
    crystal_format_with_base
  else
    crystal_format
  fi

}
