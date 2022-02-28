# PiSS (Pinning and Sorting Script)

Niche file managing script for pinning files to the top of name-ordered folders.

I use it for taskbar toolbars. Don't use it on anything that's depended on (program files, etc.)

## Usage

```
PIN [-h] [--top | --remove | --up | --down] item_name
```

### Arguments

- `--top` or `-t`
  - Pin item to the top of a folder, even above other pinned items.
- `--remove` or `-r`
  - Unpin item.
- `--up` or `-u`
  - Move pinned item up. For sorting among pinnned items.
- `--down` or `-d`
  - Move pinned item down. For sorting among pinnned items.

## Context menu

Gives access to commands from the context menu.
