#!/bin/bash
docker build -t manager_image .
docker run -d --name manager_container -v /var/run/docker.sock:/var/run/docker.sock manager_image


docker pull klee/klee:3.0

docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
ollama run llama2
curl -X POST http://localhost:11434/api/generate -H "Content-Type: application/json" -d '{
  "model": "llama2",
  "prompt": "'"$(< template_modified.c)"'",
  "stream": false
}'


docker-compose up -d