#!/bin/bash

# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 2 Community License Agreement.

read -p "https://download2.llamameta.net/*?Policy=eyJTdGF0ZW1lbnQiOlt7InVuaXF1ZV9oYXNoIjoiNWg0dXpneGsyeWxpczBsYjRoNG5iYWMwIiwiUmVzb3VyY2UiOiJodHRwczpcL1wvZG93bmxvYWQyLmxsYW1hbWV0YS5uZXRcLyoiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3MTIxODY0Nzl9fX1dfQ__&Signature=lQZjuD45GT5BYwB2S3Glr%7EAeIAuW4SZgKhNHC10Iov4tklckfW5sjMRKT9PGb473cmfDpg263Ae1m%7EnmeBDcJSALxrH928%7EujyFVSori6UOIZjLcfuCT88PwP2dXR8ql%7ELPL3BEKKJ9zjC1KyHOoRuAkxYaW-92yjyWWEOrcemrXw%7EsnEivj7YM2uxqCXYnUYfVSDocZYIvpKaEJpq6n9bA%7EEcQ9qwWYKdUNYncR1pz7dLwY7Zm%7ErxMvMIr8dGfGE9MhuSH0srcJ540tWVHs28DsGzo7p8r4BjxhbIEKcASwXxjBGu09SUt65ahW6M7dM4nEjQgHZJUoszTAIET1pQ__&Key-Pair-Id=K15QRJLYKIFSLZ&Download-Request-ID=384771927787190" PRESIGNED_URL
echo ""
ALL_MODELS="7b,13b,34b,70b,7b-Python,13b-Python,34b-Python,70b-Python,7b-Instruct,13b-Instruct,34b-Instruct,70b-Instruct"
read -p "Enter the list of models to download without spaces ($ALL_MODELS), or press Enter for all: " MODEL_SIZE
TARGET_FOLDER="."             # where all files should end up
mkdir -p ${TARGET_FOLDER}

if [[ $MODEL_SIZE == "" ]]; then
    MODEL_SIZE=$ALL_MODELS
fi

echo "Downloading LICENSE and Acceptable Usage Policy"
wget --continue ${PRESIGNED_URL/'*'/"LICENSE"} -O ${TARGET_FOLDER}"/LICENSE"
wget --continue ${PRESIGNED_URL/'*'/"USE_POLICY.md"} -O ${TARGET_FOLDER}"/USE_POLICY.md"

for m in ${MODEL_SIZE//,/ }
do
    case $m in
      7b)
        SHARD=0 ;;
      13b)
        SHARD=1 ;;
      34b)
        SHARD=3 ;;
      70b)
        SHARD=7 ;;
      7b-Python)
        SHARD=0 ;;
      13b-Python)
        SHARD=1 ;;
      34b-Python)
        SHARD=3 ;;
      70b-Python)
        SHARD=7 ;;
      7b-Instruct)
        SHARD=0 ;;
      13b-Instruct)
        SHARD=1 ;;
      34b-Instruct)
        SHARD=3 ;;
      70b-Instruct)
        SHARD=7 ;;
      *)
        echo "Unknown model: $m"
        exit 1
    esac

    MODEL_PATH="CodeLlama-$m"
    echo "Downloading ${MODEL_PATH}"
    mkdir -p ${TARGET_FOLDER}"/${MODEL_PATH}"

    for s in $(seq -f "0%g" 0 ${SHARD})
    do
        wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/consolidated.${s}.pth"
    done

    wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/params.json"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/params.json"
    wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/tokenizer.model"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/tokenizer.model"
    wget --continue ${PRESIGNED_URL/'*'/"${MODEL_PATH}/checklist.chk"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/checklist.chk"
    echo "Checking checksums"
    (cd ${TARGET_FOLDER}"/${MODEL_PATH}" && md5sum -c checklist.chk)
done
