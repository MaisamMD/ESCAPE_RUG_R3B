#!/bin/bash
set -e
python /opt/escape-datalake/configure.py
exec "$@"
