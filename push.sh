#!/usr/bin/env bash

git add $1.md &&
git cm -m "$1" &&
git push origin main
