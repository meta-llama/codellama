# Copyright (c) Meta Platforms, Inc. and affiliates.
# This software may be used and distributed according to the terms of the Llama 2 Community License Agreement.

import os
from logging import getLogger
from typing import List, Optional

from sentencepiece import SentencePieceProcessor


logger = getLogger()


class Tokenizer:
    def __init__(self, model_path: str):
        # reload tokenizer
        assert os.path.isfile(model_path), model_path
        self.sp_model = SentencePieceProcessor(model_file=model_path)
        logger.info(f"Reloaded SentencePiece model from {model_path}")

        # BOS / EOS token IDs
        self.n_words: int = self.sp_model.vocab_size()
        self.bos_id: int = self.sp_model.bos_id()
        self.eos_id: int = self.sp_model.eos_id()
        self.pad_id: int = self.sp_model.pad_id()

        # token IDs for special infilling tokens
        self.prefix_id: Optional[int] = self.sp_model.piece_to_id("▁<PRE>") or None
        self.middle_id: Optional[int] = self.sp_model.piece_to_id("▁<MID>") or None
        self.suffix_id: Optional[int] = self.sp_model.piece_to_id("▁<SUF>") or None
        self.eot_id: Optional[int] = self.sp_model.piece_to_id("▁<EOT>") or None
        logger.info(
            f"#words: {self.n_words} - BOS ID: {self.bos_id} - EOS ID: {self.eos_id} "
            f"- PRE ID: {self.prefix_id} - MID ID: {self.middle_id} - SUF ID: {self.suffix_id} - EOT ID: {self.eot_id}"
        )
        assert self.sp_model.vocab_size() == self.sp_model.get_piece_size()

    def encode(self, s: str, bos: bool, eos: bool) -> List[int]:
        assert type(s) is str
        t = self.sp_model.encode(s)
        if bos:
            t = [self.bos_id] + t
        if eos:
            t = t + [self.eos_id]
        return t

    def decode(self, t: List[int]) -> str:
        return self.sp_model.decode(list(filter(lambda tk: tk != -1, t)))

    def encode_infilling(self, s: str) -> List[int]:
        """Encode a string without an implicit leading space."""
        return self.sp_model.encode("☺" + s)[2:]

    def decode_infilling(self, t: List[int]) -> str:
        """Decode a string without an implicit leading space."""
        return self.sp_model.decode([self.sp_model.piece_to_id("☺")] + t)[1:]
