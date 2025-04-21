#!/bin/bash
# ./paper-latest-jq [output-file] [MC-Version]
# Download the latest version of paper
# Requires `jq` and `wget`

# Text Colors >:D
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'

output=$1
if [ -z "$1" ]; then
    output='paper.jar'
fi

version=$2
if [ -z "$2" ]; then
    version=$(wget -O- https://api.papermc.io/v2/projects/paper | jq -r '.versions[-1]')
    echo "latest version: ${version}" >&2
fi

build=$(wget -O- https://api.papermc.io/v2/projects/paper/versions/${version} | jq -r '.builds[-1]')
echo "latest build: ${build}" >&2
file="paper-${version}-${build}.jar"
url="https://api.papermc.io/v2/projects/paper/versions/${version}/builds/${build}/downloads/${file}"
echo "latest url: ${url}" >&2

wget -O $output $url
printf "${GREEN}Downloaded latest Paper version:\n\
${BLUE}Version: ${YELLOW}${version}\n\
${BLUE}Build: ${YELLOW}${build}\n\
${BLUE}Output File: ${YELLOW}${output}\n"
