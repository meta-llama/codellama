#!/bin/bash

# Not complete, but you get the idea. 

python convert_to_hf.py --input_dir CodeLlama-7b-Python --model_size 7B --output_dir codellama-7b-python-hf --safe_serialization True
echo "13b python"
python convert_to_hf.py --input_dir CodeLlama-13b-Python --model_size 13B --output_dir codellama-13b-python-hf --safe_serialization True
echo "13b instruct"
python convert_to_hf.py --input_dir CodeLlama-13b-Instruct --model_size 13B --output_dir codellama-13b-instruct-hf --safe_serialization True