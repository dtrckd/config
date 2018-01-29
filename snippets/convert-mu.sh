# m4a
ffmpeg -i my.m4a -acodec mp3 -ac 2 -ab 192k my.mp3

# mp4
ffmpeg -i my.mp4 -vn -acodec libmp3lame -ac 2 -ab 160k -ar 48000 my.mp3

# ogg
ffmpeg -i my.ogg -c:a libmp3lame -q:a 2 my.mp3 # avconv

# flac
ffmpeg -i my.flac -qscale:a 0 my.mp3

#wav
ffmpeg -i test.wav -acodec mp3 -ab 64k test.mp3

#for f in *.ogg; do avconv -i "$f" -c:a libmp3lame -q:a 2 "${f/ogg/mp3}"; done

