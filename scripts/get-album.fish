#! /bin/fish

if test (count $argv) -lt 1
    echo "Usage: "(basename (status -f))" <url> [<url2> ...]" >&2
    exit 1
end

set i 0
for i in (seq (count $argv))
    set -l arg $argv[$i]
    echo "---------- Downloading album $arg ($i/"(count $argv)") ----------"

    spotdl download $arg \
        --lyrics synced \
        --generate-lrc \
        --output '{album-artist}/{album}/{disc-number}-{track-number} {artist} - {title}.{output-ext}' \
        --yt-dlp-args '--remote-components ejs:github' \
        --print-errors

end
