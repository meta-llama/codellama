# Code Llama

## **Model Details**

**Model Developers** Meta AI 

**Variations** Code Llama comes in three model sizes, and three variants: 
1) Code Llama: our base models are designed for general code synthesis and understanding
2) Code Llama - Python: designed specifically for Python 
3) Code Llama - Instruct: for instruction following and safer deployment 
 
All variants are available in sizes of 7B, 13B and 34B parameters.

**Input** Models input text only.

**Output** Models output text only.

**Model Architecture** Code Llama and its variants are autoregressive language models using optimized transformer architectures. Code Llama 7B and 13B additionally support infilling text generation. All models were fine-tuned with up to 16K tokens, and support up to 100K tokens at inference time.

**Model Dates** Code Llama and its variants have been trained between January 2023 and July 2023.

**Status** This is a static model trained on an offline dataset. Future versions of Code Llama - Instruct will be released  as we improve model safety with community feedback.

**Licence** A custom commercial license is available at: [https://ai.meta.com/resources/models-and-libraries/llama-downloads/](https://ai.meta.com/resources/models-and-libraries/llama-downloads/). 

**Research Paper** More information can be found in the paper "[Code Llama: Open Foundation Models for Code](https://ai.meta.com/research/publications/code-llama-open-foundation-models-for-code/)".

**Where to send comments** Instructions on how to provide feedback or comments on the model can be found in the model [README](README.md), or by opening an issue in the GitHub repository ([https://github.com/facebookresearch/codellama/](https://github.com/facebookresearch/codellama/)).

## **Intended Use**
**Intended Use Cases** Code Llama and its variants are intended for commercial and research use in English and relevant programming languages. The base model Code Llama can be adapted for a variety of code synthesis and understanding tasks, Code Llama - Python is designed specifically to handle the Python programming language, and Code Llama - Instruct is intended to be safer to use for code assistance and generation applications.

**Out-of-Scope Uses** Use in any manner that violates applicable laws or regulations (including trade compliance laws). Use in languages other than English. Use in any other way that is prohibited by the Acceptable Use Policy and Licensing Agreement for Code Llama and its variants.

## **Hardware and Software**
**Training Factors**
We used custom training libraries. The training and fine-tuning of the released models have been performed by Meta’s Research Super Cluster.

**Carbon Footprint** In aggregate, training all 9 Code Llama models required 400K GPU hours of computation on hardware of type A100-80GB (TDP of 350-400W). Estimated total emissions were 65.3 tCO2eq, 100% of which were offset by Meta’s sustainability program.

**Training data**
All experiments reported here and the released models have been trained and fine-tuned using the same data as Llama 2 with different weights (see Section 2 and Table 1 in the [research paper](https://ai.meta.com/research/publications/code-llama-open-foundation-models-for-code/) for details).
Code Llama - Instruct uses additional instruction fine-tuning data.

**Evaluation Results**
See evaluations for the main models and detailed ablations in Section 3 and safety evaluations in Section 4 of the research paper.

## **Ethical Considerations and Limitations**
Code Llama and its variants are a new technology that carries risks with use. Testing conducted to date has been in English, and has not covered, nor could it cover all scenarios. For these reasons, as with all LLMs, Code Llama’s potential outputs cannot be predicted in advance, and the model may in some instances produce inaccurate or objectionable responses to user prompts. Therefore, before deploying any applications of Code Llama, developers should perform safety testing and tuning tailored to their specific applications of the model.

Please see the Responsible Use Guide available available at [https://ai.meta.com/llama/responsible-user-guide](https://ai.meta.com/llama/responsible-user-guide).

