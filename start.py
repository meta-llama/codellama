import argparse
from transformers import AutoTokenizer
import transformers
import torch


def generate_code(pretrained_model, input_string):
    tokenizer = AutoTokenizer.from_pretrained(pretrained_model)
    pipeline = transformers.pipeline(
        "text-generation",
        model=pretrained_model,
        torch_dtype=torch.float16,
        device_map="auto",
    )
    try:
        sequences = pipeline(
            input_string,
            do_sample=True,
            top_k=10,
            temperature=0.1,
            top_p=0.95,
            num_return_sequences=1,
            eos_token_id=tokenizer.eos_token_id,
            max_length=200,
        )
        for seq in sequences:
            print(f"Result: {seq['generated_text']}")
    except Exception as e:
        print(f"An error occurred: {str(e)}")


def main():
    parser = argparse.ArgumentParser(description='Generate code from natural language or code input')
    parser.add_argument('-f', '--pretrained_model', required=True, help='Path to the folder with the pretrained model')
    parser.add_argument('-s', '--input_string', required=True, help='Natural language or code used to generate code')
    args = parser.parse_args()

    pretrained_model = args.pretrained_model
    input_string = args.input_string

    generate_code(pretrained_model, input_string)


if __name__ == '__main__':
    main()


