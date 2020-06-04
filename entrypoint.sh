#!/bin/sh -l

set -e

target=""
_time=""
archive=""

file_type="${1}"
path="${2}"
method="${3}"

# lowercase
# method=${method,,}
# method=$(echo $method | tr '[A-Z]' '[a-z]')

if [ $(which tar | wc -l) = '0' ]; then
    apt-get install tar -y
fi

case $method in
    zip)
        if [ $(which zip | wc -l) = '0' ]; then
            apt-get install zip -y
        fi
        ;;
    gzip)
        if [ $(which gzip | wc -l) = '0' ]; then
            apt-get install gzip -y
        fi
        ;;
    bzip2)
        if [ $(which bzip2 | wc -l) = '0' ]; then
            apt-get install bzip2 -y
        fi
        ;;
    tar)
        ;;
    *)
        echo "unsupport compress tool"
        echo "::set-env name=error_value::1"
        exit
        ;;
esac

cat << EOF

file type  : $file_type
path       : $path
method     : $method

EOF

find $path -name "*.$file_type" | tee file

mkdir archive
cat file | xargs -i cp {} archive/

target=$(date +%Y-%m-%d_%H_%M)
case $method in
    zip)
        target=$(echo "archive_"$target"."$method)
        zip -rq $target archive
        ;;
    gzip)
        target=$(echo "archive_"$target".tar.gz")
        tar -czf $target archive
        ;;
    bzip2)
        target=$(echo "archive_"$target".tar.bz2")
        tar -cjf $target archive
        ;;
    tar)
        target=$(echo "archive_"$target".tar")
        tar -cf $target archive
        ;;
esac

archive=$(echo "${{ GITHUB_WORKSPACE }}/$target")
echo ::set-output name=archive::$archive

# clean
rm file
rm -rf archive

