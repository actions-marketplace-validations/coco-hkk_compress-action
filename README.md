# Compress action v2.1

![Compress File](https://github.com/coco-hkk/compress-action/workflows/Compress%20File/badge.svg)

First github action for learning.

Use the specified compression tool to compress all the specified file suffix in the specified directory.

## Inputs

### `file-suffix`

Compressed file suffix. Such as tex, md, txt, pdf, etc.

- require: true

- default: pdf

### `target-directory-path`

Target directory path

- require: true

- default: ./

### `compress-tool`

Compress tools, such as gzip,bzip2,zip,brotli,etc.

- require: true

- default: gzip

## Outputs

### `state`

Action state when generating archive.

- `0` : normal

- `1` : unsupport tool

- `2` : bad target directory path

### `archive`

Final generated archive file in GITHUB_WORKSPACE.

## Example Usage

```yaml
- name: Compress txt with gzip
    uses: coco-hkk/compress-action@v2.1
    id: step1
    with:
      file-suffix: 'txt'
      target-directory-path: 'tes'
      compress-tool: 'gzip'
  - name: Get archive
    run: |
      if [ "0"x != "${{ steps.step1.outputs.state }}"x ]; then
        echo "archive create failed, exit"
      else
        tar -tzvf ${{ steps.step1.outputs.archive }}
      fi
```

### `brotli`

Brotli only support one input file, so make input directory as one tarball with tar.
