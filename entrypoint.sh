#!/bin/bash

set -e

source_file=""
_time=""
archive=""

suffix="${1}"
path="${2}"
tool="${3}"

# lowercase
# tool=${tool,,}
tool=$(echo $tool | tr '[A-Z]' '[a-z]')

echo "::set-output name=state::0"

if [[ "$tool" =~ ^(tar|zip|gzip|bzip2|brotli)$ ]]
then
    source_file=$tool"_"$(date +%Y-%m-%d_%H_%M_%S)
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

find $path -name "*.$suffix" | tee source_file_path.txt

[ $(cat source_file_path.txt | wc -l) = '0' ] && echo "no suffix $suffix file exist. To be generating an empty archive"

[ -d "$source_file" ] || mkdir $source_file

cat source_file_path.txt | xargs -i cp {} $source_file/

case $tool in
    zip)
        archive=$(echo "archive_"$source_file".zip")
        zip -rq $archive $source_file
        ;;
    gzip)
        archive=$(echo "archive_"$source_file".tar.gz")
        tar -czf $archive $source_file
        ;;
    bzip2)
        archive=$(echo "archive_"$source_file".tar.bz2")
        tar -cjf $archive $source_file
        ;;
    tar)
        archive=$(echo "archive_"$source_file".tar")
        tar -cf $archive $source_file
        ;;
    brotli)
        archive=$(echo "archive_"$source_file".tar.br")
	tar -cf temp.tar $source_file
        brotli -Z temp.tar -o $archive 
	rm -f temp.tar
        ;;
esac

# outputs.archive
echo ::set-output name=archive::$archive

# clean
rm source_file_path.txt
rm -rf $source_file
