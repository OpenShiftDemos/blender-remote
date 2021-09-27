#! /bin/bash

if [[ -n $DEBUG ]]
then
  if [ "$DEBUG" = "1" ]
  then
    echo "Debug enabled, setting -x"
    set -x
  fi
fi

echo "Checking environment"

if [[ -z "$BLEND_LOCATION" ]]
then
  echo "BLEND_LOCATION not specified"
  exit 255
fi

if [[ -z "$RENDER_TYPE" ]]
then
  echo "RENDER_TYPE not specified"
  exit 255
fi

if [[ !("$RENDER_TYPE" = "animation" || "$RENDER_TYPE" = "image") ]]
then
  echo "RENDER_TYPE not 'animation' or 'image'"
  exit 255
fi

if [[ -z "$S3_ENDPOINT" ]]
then
  echo "S3_ENDPOINT not specified"
  exit 255
fi

if [[ -z "$S3_KEY" ]]
then
  echo "S3_KEY not specified"
  exit 255
fi

if [[ -z "$S3_SECRET" ]]
then
  echo "S3_SECRET not specified"
  exit 255
fi

echo "Setting UUID for job"
export UUID=$(uuidgen)
echo "Job UUID: $UUID"

echo "Fetching the blend file"
echo "Location: $BLEND_LOCATION"
wget $BLEND_LOCATION -O /tmp/job.blend

if [ "$RENDER_TYPE" = "image" ]
then
  echo "Rendering an image"
  ./blender -b /tmp/job.blend -o /tmp/$UUID -f 1
fi

# TODO: if the render fails, abort

if [ "$RENDER_TYPE" = "animation" ]
then
  echo "Rendering an animation"
  ./blender -b /tmp/job.blend -o /tmp/$UUID -a
fi

# TODO: if the render fails, abort

# TODO: this is probably fragile
export OUTPUTFILE=$(find /tmp -name "$UUID*")
export FILENAME=$(echo $OUTPUTFILE | cut -d/ -f3)

echo "Configuring minio client"
mc alias set destination $S3_ENDPOINT $S3_KEY $S3_SECRET
mc mb destination/$UUID
mc cp $OUTPUTFILE destination/$UUID

echo "File is located in bucket at: $UUID/$FILENAME"