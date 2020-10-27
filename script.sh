ASSETSFOLDER=assets/timeline
for mediaFile in `ls $ASSETSFOLDER | grep .mp4`; do
  # corta a extensão e a resolução do arquivo
  FILENAME=$(echo $mediaFile | sed -n 's/.mp4//p' | sed -n 's/-1920x1080//p')
  INPUT=$ASSETSFOLDER/$mediaFile

  # criar pasta para cada arquivo original
  FOLDER_TARGET=$ASSETSFOLDER/$FILENAME
  mkdir -p $FOLDER_TARGET

  # criar arquivos de resoluções diferentes em cada pasta
  OUTPUT=$ASSETSFOLDER/$FILENAME/$FILENAME
  DURATION=$(./bin/ffprobe.exe -i $INPUT -show_format -v quiet | sed -n 's/duration=//p')
  
  OUTPUT144=$OUTPUT-$DURATION-144
  OUTPUT360=$OUTPUT-$DURATION-360
  OUTPUT720=$OUTPUT-$DURATION-720

  echo 'rendering in 720p'
  ./bin/ffmpeg.exe -y -i $INPUT \
    -c:a aac -ac 2 \
    -vcodec h264 -acodec aac \
    -ab 128k \
    -movflags frag_keyframe+empty_moov+default_base_moof \
    -b:v 1500k \
    -maxrate 1500k \
    -bufsize 1000k \
    -vf "scale=-1:720" \
    -v quiet \
    $OUTPUT720.mp4

  echo 'rendering in 360p'
  ./bin/ffmpeg.exe -y -i $INPUT \
    -c:a aac -ac 2 \
    -vcodec h264 -acodec aac \
    -ab 128k \
    -movflags frag_keyframe+empty_moov+default_base_moof \
    -b:v 400k \
    -maxrate 400k \
    -bufsize 400k \
    -vf "scale=-1:360" \
    -v quiet \
    $OUTPUT360.mp4

  echo 'rendering in 144p'
  ./bin/ffmpeg.exe -y -i $INPUT \
    -c:a aac -ac 2 \
    -vcodec h264 -acodec aac \
    -ab 128k \
    -movflags frag_keyframe+empty_moov+default_base_moof \
    -b:v 300k \
    -maxrate 300k \
    -bufsize 300k \
    -vf "scale=-256:144" \
    -v quiet \
    $OUTPUT144.mp4

  echo $OUTPUT144.mp4
  echo $OUTPUT360.mp4
  echo $OUTPUT720.mp4
done