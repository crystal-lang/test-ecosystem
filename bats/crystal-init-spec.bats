#!/usr/bin/env bats

@test "crystal version" {
  run crystal --version
  # [[ "$output" =~ 0\.23\.1 ]]
  [[ "$output" =~ 0\.24\.1 ]]
}

@test "crystal eval" {
  run crystal eval 'puts "Hello world"'
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Hello world" ]]
}

@test "crystal init and spec command" {
  cd /tmp
  rm -rf test01
  crystal init app test01
  cd test01
  run crystal spec
  [ "$status" -eq 1 ]
}

@test "crystal spec with backtrace" {
  run crystal eval 'Colorize.enabled = false; require "spec"; it "foo" { expect_raises(ArgumentError){ raise "" } }'
  [ "$status" -eq 1 ]
  [[ "${lines[-1]}" =~ "crystal spec eval:1 # foo" ]]
}
