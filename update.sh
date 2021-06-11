#!/bin/bash
set -e
./stop.sh

git pull
./update2.sh
