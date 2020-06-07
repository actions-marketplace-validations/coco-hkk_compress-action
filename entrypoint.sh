#!/bin/bash

set -e

target=""
_time=""
archive=""

suffix="${1}"
path="${2}"
tool="${3}"

# lowercase
# tool=${tool,,}
tool=$(echo $tool | tr '[A-Z]' '[a-z]')

echo "::set-output name=state::0"

if [[ "$tool" =~ ^(tar|zip|gzip|bzip2)$ ]]
then
    target=$(date +%Y-%m-%d_%H_%M)
else
    echo "compress tool not supported: $tool."
    echo "::set-output name=state::1"
    exit
fi

if [ ! -d "$path" ]; then
    echo "target directory path not exist: $path"
    echo "::set-output name=state::2"
    exit
fi

cat << EOF

file-suffix             : $suffix
target-directory-path   : $path
compress-tool           : $tool

EOF

find $path -name "*.$suffix" | tee file

[ $(cat file | wc -l) = '0' ] && echo "no suffix $suffix file exist. To be
generating an empty archive"

mkdir $target
cat file | xargs -i cp {} $target/

case $tool in
    zip)
        archive=$(echo "archive_"$target".zip")
        zip -rq $archive $target
        ;;
    gzip)
        archive=$(echo "archive_"$target".tar.gz")
        tar -czf $archive $target
        ;;
    bzip2)
        archive=$(echo "archive_"$target".tar.bz2")
        tar -cjf $archive $target
        ;;
    tar)
        archive=$(echo "archive_"$target".tar")
        tar -cf $archive $target
        ;;
esac

# outputs.archive
echo ::set-output name=archive::$archive

# clean
rm file
rm -rf $target
