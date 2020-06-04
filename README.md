# Compress action

# Usage

`file_type` file suffix

`path` appointed path

`method` compress tools, such as gzip,bzip2,zip,etc.

```yaml
- name: Compress txt with gzip
uses: ./
id: step1
with:
  file_type: 'txt'
  path: 'test'
  method: 'gzip'
- name: Get archive
run: |
  # archive
  echo "archive : ${{ steps.step1.outputs.archive }}"
  tar -tzvf ${{ steps.step1.outputs.archive }}
```

最近比较坑爹，总是看错字符

action看成actions导致浪费很长时间
