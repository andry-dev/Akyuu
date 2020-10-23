#!/bin/sh

echo "Running seeds"

release_ctl eval --mfa "Akyuu.ReleaseTasks.seed/1" --argv -- "$@"
