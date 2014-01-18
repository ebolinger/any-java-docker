#!/bin/bash
#
# Use foreman GEM to start the most recent ZIP file under /data directory.
#
# Note: Dockerfile sets PWD to /opt/local/app

DATA_DIR=/data

shopt -s nocaseglob nullglob

# wars=`/bin/ls -t ${DATA_DIR}/*.war | head -1`
wars=""

# Fetch the most recent ZIP file
zips=`/bin/ls -t ${DATA_DIR}/*.zip | head -1`

file=${1:-${wars:-${zips:-undefined}}}

echo "zips: $zips"
echo "file: $file"
echo "pwd: $PWD"

# Only supports ZIP file for now, need to extract WAR as well
/bin/jar xvf $file

/usr/local/bin/foreman start


