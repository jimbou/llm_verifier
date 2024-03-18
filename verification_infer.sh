#!/bin/bash
INFER_IMAGE_NAME="infer_image"
CONTAINER="infer_runner"

# Ensure the infer container is running
docker run -dit --name $CONTAINER $INFER_IMAGE_NAME /bin/bash

# Create the directory
docker exec $CONTAINER mkdir -p /infer-examples

# Copy the file into the container
docker cp infer_analysis.c $CONTAINER:/infer-examples/

rm -rf infer_report.txt
# Execute the analysis
docker exec $CONTAINER /bin/bash -c "cd /infer-examples; infer -- clang -c infer_analysis.c >infer_report.txt"

# Copy the result back
docker cp $CONTAINER:/infer-examples/infer_report.txt .

docker stop $CONTAINER
docker rm $CONTAINER