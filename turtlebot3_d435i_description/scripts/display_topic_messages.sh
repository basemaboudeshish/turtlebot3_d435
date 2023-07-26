#!/bin/bash

# Get the list of all topics
topics=$(rostopic list)

# Iterate over each topic and display the associated message type
for topic in $topics
do
    echo "Topic: $topic"
    rostopic info $topic | grep "Type: "
    echo "---------------------------"
done
