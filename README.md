# Compress action

![Compress File](https://github.com/coco-hkk/compress-action/workflows/Compress%20File/badge.svg)

First github action for learning.

Main function is compressing file with specific suffix under
specific path with specific compress tools.

## Usage

`suffix` file suffix

`path`   appointed path

`method` compress tools, such as gzip,bzip2,zip,etc.

`steps.step1.outputs.archive` archive

`env.error_value` 1 for method unsupport, action exit


### example

```yaml
- name: Compress txt with gzip
    uses: coco-hkk/compress-action@master
    id: step1
    with:
      file_type: 'txt'
      path: 'test'
      method: 'gzip'
- name: Get archive
    run: |
      # archive
      echo "archive : ${{ steps.step1.outputs.archive }}"
      if [ "1"x = "${{ env.error_value }}"x ]; then
        echo "archive create failed, exit"
      else
        tar -tzvf ${{ steps.step1.outputs.archive }}
      fi
```

最近比较坑爹，总是看错字符

action看成actions导致浪费很长时间
