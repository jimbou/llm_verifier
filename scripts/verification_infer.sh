#!/bin/bash
INFER_IMAGE_NAME="infer_image"
CONTAINER="infer_container1"

# Ensure the infer container is running
# docker run -dit --name $CONTAINER $INFER_IMAGE_NAME /bin/bash

echo "Running infer analysis"
# Create the directory
docker exec $CONTAINER mkdir -p /infer-examples

# Copy the file into the container
docker cp ../intermidiate_files/infer_analysis.c $CONTAINER:/infer-examples/

rm -rf ../reports/infer_report.txt
# Execute the analysis
docker exec $CONTAINER /bin/bash -c "cd /infer-examples; infer -- clang -c infer_analysis.c >infer_report.txt"
rm -rf ../reports/error_report_infer.txt
# Copy the result back
docker cp $CONTAINER:/infer-examples/infer-out/report.txt ../reports/error_report_infer.txt
docker cp $CONTAINER:/infer-examples/infer_report.txt ../reports/

docker stop $CONTAINER
docker rm $CONTAINER