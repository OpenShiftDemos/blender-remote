#! /bin/bash

if [[ -n $DEBUG ]]
then
  if [ "$DEBUG" = "1" ]
  then
    echo "Debug enabled, setting -x"
    set -x
  fi
fi

echo "Setting UUID for job"
export UUID=$(uuidgen)
echo $UUID

echo "Fetching the blend file"
echo "Location: $BLEND_LOCATION"
wget $BLEND_LOCATION -O /tmp/job.blend

if [ "$RENDER_TYPE" = "image" ]
then
  echo "Rendering an image"
  ./blender -b /tmp/job.blend -o /tmp/$UUID-# -F TIFF -f 1
fi

echo "Configuring minio client"
mc alias set destination $S3_ENDPOINT $S3_KEY $S3_SECRET
mc mb destination/$UUID
mc cp /tmp/$UUID-1.tif destination/$UUID