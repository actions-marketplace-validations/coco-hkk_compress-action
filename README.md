# Compress action

![Compress File](https://github.com/coco-hkk/compress-action/workflows/Compress%20File/badge.svg)

First github action for learning.

Compress specific suffix file with specific compress tools in the target path directory and it's sub directories.

## Inputs

### `suffix`

Compressed file suffix. Such as tex, md, txt, pdf, etc.

### `path`

Target path directory

### `method`

Compress tools, such as gzip,bzip2,zip,etc.

## Outputs

### `archive`

Archive file in GITHUB_WORKSPACE

## Env

### `env.error_value`

`0` : no error

`1` : commpress method unsupport

`2` : path directory not exist

## Example Usage

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
      if [ "0"x != "${{ env.error_value }}"x ]; then
        echo "archive create failed, exit"
      else
        tar -tzvf ${{ steps.step1.outputs.archive }}
      fi
```
