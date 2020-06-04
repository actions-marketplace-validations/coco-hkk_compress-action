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
    apk add tar
fi

case $method in
    zip)
        if [ $(which zip | wc -l) = '0' ]; then
           apk add zip
        fi
        ;;
    gzip)
        if [ $(which gzip | wc -l) = '0' ]; then
           apk add gzip
        fi
        ;;
    bzip2)
        if [ $(which bzip2 | wc -l) = '0' ]; then
            apk add bzip2
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

mkdir compress_dir
cat file | xargs -i cp {} compress_dir/

target=$(date +%Y-%m-%d_%H_%M)
case $method in
    zip)
        archive=$(echo "archive_"$target"."$method)
        zip -rq $archive compress_dir
        ;;
    gzip)
        archive=$(echo "archive_"$target".tar.gz")
        tar -czf $archive compress_dir
        ;;
    bzip2)
        archive=$(echo "archive_"$target".tar.bz2")
        tar -cjf $archive compress_dir
        ;;
    tar)
        archive=$(echo "archive_"$target".tar")
        tar -cf $archive compress_dir
        ;;
esac

echo ::set-output name=archive::$archive

# clean
rm file
rm -rf compress_dir
