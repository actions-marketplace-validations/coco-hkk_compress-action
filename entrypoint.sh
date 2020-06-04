#!/bin/sh -l

set -e

file_type="${1}"
path="${2}"
method="${3}"

# lowercase
method=${method,,}

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

case $method in
    zip)
        zip -rq archive.zip archive
        ;;
    gzip)
        tar -czf archive.tar.gz archive
        ;;
    bzip2)
        tar -cjf archive.tar.bz2 archive
        ;;
    tar)
        tar -cf archive.tar archive
        ;;
esac

time=$(date)

echo ::set-output name=time::$time

# clean
rm file
rm -rf archive

