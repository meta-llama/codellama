#!/bin/bash

# Function to check for prerequisites
check_prerequisites() {
    missing=false
    command -v wget >/dev/null 2>&1 || { missing=true; echo "wget is missing."; }
    command -v md5sum >/dev/null 2>&1 || { missing=true; echo "md5sum is missing."; }
    
    if [ "$missing" = true ]; then
        echo "Would you like to install the missing prerequisites? (y/n)"
        read install
        if [ "$install" == "y" ]; then
            sudo apt update
            sudo apt install -y wget coreutils
        else
            echo "Exiting because prerequisites are not met."
            exit 1
        fi
    fi
}

# Function to log messages with colors
log() {
    echo -e "$1"
}

# Function to download a file
download_file() {
    wget -c --quiet --show-progress $1 -O $2 &
}

# Function to download and verify a model
download_model() {
    local model=$1
    local shard=$2
    local presigned_url=$3
    local target_folder=$4
    local model_path="CodeLlama-$model"

    log "${YELLOW}📦 Downloading ${model_path}${NC}"
    mkdir -p ${target_folder}/${model_path}

    for s in $(seq -f "%02g" 0 ${shard})
    do
        log "${YELLOW}   Downloading ${model_path}/consolidated.${s}.pth${NC}"
        download_file ${presigned_url/'*'/"${model_path}/consolidated.${s}.pth"} ${target_folder}/${model_path}/consolidated.${s}.pth
    done
    wait

    download_file ${presigned_url/'*'/"${model_path}/params.json"} ${target_folder}/${model_path}/params.json
    download_file ${presigned_url/'*'/"${model_path}/tokenizer.model"} ${target_folder}/${model_path}/tokenizer.model
    download_file ${presigned_url/'*'/"${model_path}/checklist.chk"} ${target_folder}/${model_path}/checklist.chk
    wait

    log "${YELLOW}🔍 Checking checksums for ${model_path}${NC}"
    (cd ${target_folder}/${model_path} && md5sum -c checklist.chk)
    if [ $? -eq 0 ]; then
        log "${GREEN}✅ All files for ${model_path} downloaded and verified successfully!${NC}"
    else
        log "${RED}❌ Checksum verification failed for ${model_path}${NC}"
        exit 1
    fi
}

# Main script logic
main() {
    check_prerequisites
    
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[0;33m'
    NC='\033[0m'

    log "${GREEN}======================================"
    log " Llama Model Download Utility "
    log "======================================${NC}"

    log "${YELLOW}📨 Enter the URL from the email: ${NC}"
    read PRESIGNED_URL
    log ""
    ALL_MODELS="7b,13b,34b,7b-Python,13b-Python,34b-Python,7b-Instruct,13b-Instruct,34b-Instruct"
    log "${YELLOW}📜 Enter the list of models to download ($ALL_MODELS) example: 7b,13b , or press Enter for all: ${NC}"
    read MODEL_SIZE
    log "Press 'c' to cancel or any other key to continue."
    read -n 1 cont
    if [ "$cont" == "c" ]; then
        log "${RED}❌ User canceled the operation.${NC}"
        exit 0
    fi

    TARGET_FOLDER="downloaded_models"
    mkdir -p ${TARGET_FOLDER}

    if [[ $MODEL_SIZE == "" ]]; then
        MODEL_SIZE=$ALL_MODELS
    fi

    log "${YELLOW}📥 Downloading LICENSE and Acceptable Usage Policy ${NC}"
    download_file ${PRESIGNED_URL/'*'/"LICENSE"} ${TARGET_FOLDER}"/LICENSE"
    download_file ${PRESIGNED_URL/'*'/"USE_POLICY.md"} ${TARGET_FOLDER}"/USE_POLICY.md"
    wait
    log "${GREEN}✅ LICENSE and Acceptable Usage Policy downloaded successfully!${NC}"

    for m in ${MODEL_SIZE//,/ }
    do
        local SHARD=0
        case $m in
            7b) SHARD=0 ;;
            13b) SHARD=1 ;;
            34b) SHARD=3 ;;
            7b-Python) SHARD=0 ;;
            13b-Python) SHARD=1 ;;
            34b-Python) SHARD=3 ;;
            7b-Instruct) SHARD=0 ;;
            13b-Instruct) SHARD=1 ;;
            34b-Instruct) SHARD=3 ;;
            *)
                log "${RED}❌ Unknown model: $m${NC}"
                exit 1
        esac
        download_model $m $SHARD $PRESIGNED_URL $TARGET_FOLDER
    done

    log "${GREEN}========================================="
    log " Congratulations! Download Completed "
    log "=========================================${NC}"
}

# Execute the main function
main "$@"
