#!/usr/bin/env nu

def main [filename: string --nosixel] {
    let filetype = ($filename | path type);
    if $filetype == "symlink" {
        main ($filename | path expand)
        exit
    }

    if $filetype == "dir" {
         ls | sort-by --reverse modified | first 10
    } else if $filetype == "file" {
        if $filename =~ '(png|jpe?g|gif|webm)$' {
            if $nosixel {
                file $filename
                ls -l $filename | first
            } else {
                img2sixel $filename
            }
        } else if $filename =~ '(mp4|mkv|mpeg|mp3)$' {
            file $filename
            ls -l $filename | first
        } else {
            bat --style=plain --pager=never --color=always $filename
        }
    }
}
