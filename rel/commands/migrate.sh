#!/bin/sh

echo "Running migrations"

release_ctl eval --mfa "Akyuu.ReleaseTasks.migrate/1" --argv -- "$@"
