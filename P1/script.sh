#!/bin/bash

echo "->Building host"
docker build -t 'host_aleconte' host/

echo "->Building router"
docker build -t 'router_aleconte' router/
