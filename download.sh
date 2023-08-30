#!/bin/bash

# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 2 Community License Agreement.

# Fill this in if you wish
PRESIGNED_URL=''
if [[ $PRESIGNED_URL == "" ]]; then
    read -p "Enter the URL from email: " PRESIGNED_URL
fi
echo ""

# Fill this in if you wish
MODEL_SIZE=''
ALL_MODELS="7b,13b,34b,7b-Python,13b-Python,34b-Python,7b-Instruct,13b-Instruct,34b-Instruct"
if [[ $MODEL_SIZE == "" ]]; then
    read -p "Enter the list of models to download without spaces ($ALL_MODELS), or press Enter for all: " MODEL_SIZE
    if [[ $MODEL_SIZE == "" ]]; then
        MODEL_SIZE=$ALL_MODELS
    fi
fi

TARGET_FOLDER="."             # where all files should end up
mkdir -p ${TARGET_FOLDER}

echo "Downloading LICENSE and Acceptable Usage Policy"
if [[ ! -f ${TARGET_FOLDER}"/LICENSE" ]]; then
    wget "${PRESIGNED_URL/'*'/"LICENSE"}" -O ${TARGET_FOLDER}"/LICENSE"
fi
if [[ ! -f ${TARGET_FOLDER}"/USE_POLICY.md" ]]; then
    wget "${PRESIGNED_URL/'*'/"/USE_POLICY.md"}" -O ${TARGET_FOLDER}"/USE_POLICY.md"
fi


for m in ${MODEL_SIZE//,/ }
do
    case $m in
      7b|7b-Python|7b-Instruct)
        SHARD=0 ;;
      13b|13b-Python|13b-Instruct)
        SHARD=1 ;;
      34b|34b-Python|34b-Instruct)
        SHARD=3 ;;
      *)
        echo "Unknown model: $m"
        exit 1
    esac

    MODEL_PATH="CodeLlama-$m"
    echo "Downloading ${MODEL_PATH}"
    mkdir -p ${TARGET_FOLDER}"/${MODEL_PATH}"

    for s in $(seq -f "0%g" 0 ${SHARD})
    do
        wget --timeout 20 --continue --tries=10 --progress=bar:noscroll ${PRESIGNED_URL/'*'/"${MODEL_PATH}/consolidated.${s}.pth"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/consolidated.${s}.pth"
    done

    wget -c ${PRESIGNED_URL/'*'/"${MODEL_PATH}/params.json"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/params.json"
    wget -c ${PRESIGNED_URL/'*'/"${MODEL_PATH}/tokenizer.model"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/tokenizer.model"
    wget -c ${PRESIGNED_URL/'*'/"${MODEL_PATH}/checklist.chk"} -O ${TARGET_FOLDER}"/${MODEL_PATH}/checklist.chk"
    echo "Checking checksums"
    (cd ${TARGET_FOLDER}"/${MODEL_PATH}" && md5sum -c checklist.chk)
done
