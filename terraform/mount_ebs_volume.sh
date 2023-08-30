#!/bin/bash

sudo mkdir -p /home/llama
sleep 30  # wait for attaching process to finish
sudo mount /dev/xvdf1 /home/llama
df / /home/llama
