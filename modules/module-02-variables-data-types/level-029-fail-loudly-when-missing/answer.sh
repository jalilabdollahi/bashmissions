#!/usr/bin/env bash
# Nightly backup. ${DB_HOST:?message} prints "DB_HOST: message" on stderr and
# ends the script with status 1 when DB_HOST is unset or empty.

echo "backup job starting"

host=${DB_HOST:?DB_HOST must be set}

echo "dumping database on $host"
