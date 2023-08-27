SHELL := /bin/zsh

.PHONY: chat
chat:
	torchrun --nproc_per_node 1 chat.py \
    --ckpt_dir CodeLlama-7b-Instruct/ \
    --tokenizer_path CodeLlama-7b-Instruct/tokenizer.model \
    --max_seq_len 512 --max_batch_size 4