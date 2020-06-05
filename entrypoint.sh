#!/bin/bash

set -e

target=""
_time=""
archive=""

suffix="${1}"
path="${2}"
method="${3}"

# lowercase
# method=${method,,}
method=$(echo $method | tr '[A-Z]' '[a-z]')

if [[ "$method" =~ ^(tar|zip|gzip|bzip2)$ ]]
then
    target=$(date +%Y-%m-%d_%H_%M)
else
    echo "unsupport tool: $method, exit"
    echo "::set-env name=error_value::1"
    exit
fi

if [ ! -d "$path" ]; then
    echo "path $path not exist, exit"
    echo "::set-env name=error_value::1"
    exit
fi

cat << EOF

suffix : $suffix
path   : $path
method : $method

EOF

find $path -name "*.$suffix" | tee file

[ $(cat file | wc -l) = '0' ] && echo "no $suffix file exist. To be generating empty archive"

mkdir $target
cat file | xargs -i cp {} $target/

case $method in
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
