#!/usr/bin/env bash
echo "--- child.sh (./script.sh) ---"
echo "child.sh 안의 MY_VAR: $MY_VAR"
MY_VAR="Modified by child (subshell)"
echo "child.sh 안에서 MY_VAR 변경: $MY_VAR"
CHILD_VAR="Child variable (subshell)"
echo "child.sh 안의 CHILD_VAR: $CHILD_VAR"
