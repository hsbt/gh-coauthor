#!/usr/bin/env bats

SCRIPT_PATH="$BATS_TEST_DIRNAME/../gh-coauthor"

setup() {
  # Create a temporary directory for the test repo
  export TEST_TEMP_DIR="$(mktemp -d)"
  cd "$TEST_TEMP_DIR"
  
  # Set up a test git repository
  git init .
  git config user.name "Test User"
  git config user.email "test@example.com"
  
  # Create a test file and make initial commit
  echo "Test content" > test.txt
  git add test.txt
  git commit -m "Initial commit"
  
  # Mock the gh command to avoid actual API calls during tests
  function gh() {
    if [[ "$*" == "api /users/testuser" ]]; then
      echo '{"id": 12345, "name": "Test User", "email": "testuser@example.com"}'
    elif [[ "$*" == "api /users/noemail" ]]; then
      echo '{"id": 67890, "name": "No Email User", "email": null}'
    else
      echo "Unexpected gh command: $*" >&2
      return 1
    fi
  }
  export -f gh
}

teardown() {
  # Clean up the test directory
  rm -rf "$TEST_TEMP_DIR"
}

@test "version command shows version number" {
  run "$SCRIPT_PATH" version
  [ "$status" -eq 0 ]
  [[ "$output" =~ ^gh-coauthor\ [0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "help command shows usage information" {
  run "$SCRIPT_PATH" --help
  [ "$status" -eq 0 ]
  [[ "$output" =~ "Add a GitHub user as co-author to the latest commit" ]]
}

@test "adds co-author with email from GitHub API" {
  run "$SCRIPT_PATH" testuser
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✓ Added Test User as co-author to the latest commit" ]]
  
  # Check the commit message contains the co-author
  run git log -1 --pretty=%B
  [[ "$output" =~ "Co-authored-by: Test User <testuser@example.com>" ]]
}

@test "adds co-author with fallback email when GitHub email is null" {
  run "$SCRIPT_PATH" noemail
  [ "$status" -eq 0 ]
  [[ "$output" =~ "✓ Added No Email User as co-author to the latest commit" ]]
  
  # Check the commit message contains the co-author with fallback email
  run git log -1 --pretty=%B
  [[ "$output" =~ "Co-authored-by: No Email User <67890+noemail@users.noreply.github.com>" ]]
}
