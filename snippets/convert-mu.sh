# m4a
ffmpeg -i test.m4a -acodec mp3 -ac 2 -ab 192k test.mp3

# mp4
ffmpeg -i test.mp4 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 test.mp3

# ogg
ffmpeg -i test.ogg -c:a libmp3lame -q:a 2 test.mp3 # avconv

# flac
ffmpeg -i test.flac -qscale:a 0 test.mp3

#wav
ffmpeg -i test.wav -acodec mp3 -ab 64k test.mp3

# webm
ffmpeg -i test.webm -qscale 0 test.mp4

#for f in *.ogg; do avconv -i "$f" -c:a libmp3lame -q:a 2 "${f/ogg/mp3}"; done

