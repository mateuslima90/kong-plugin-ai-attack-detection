# kong-plugin-ai-attack-detection

## About this project

This project is a Lua-based plugin for Kong API Gateway that allows you to define routes and services that check if contains malicious code.

The plugins works by intercepting the requests being made and confirmating in AI Model if the payload/query_params doesnt have malicious code.

<b>We are testing this plugin yet, so It is possible to find some bugs. Please report bugs!</b>

## The Problem

The number of attacks on APIs increases every year, so it is necessary to implement a WAF to enhance security and mitigate both basic and more advanced attacks.

### Plugin configuration parameters

| Parameter name       | Required | Description | Default value | Type   |
|----------------------|----------|-------------|---------------|--------|
| backend_url          | true         | Base Url for the TOTP backend (the vault)           |               | String |
| backend_path         | true         | Base Path for the TOTP backend (the vault)          |               | String |

## AI Model

In this plugin, we explore artificial intelligence within one of its major subfields, deep learning, by utilizing a popular transformer model for natural language processing, the BERT model (Bidirectional Encoder Representations from Transformers). Introduced in 2018 by Google researchers, BERT shares the common architecture of transformer models but stands out due to its bidirectional attention to text context, enabling a deeper understanding of the overall content compared to previous models.

BERT is a pre-trained transformer (PT), large language model (LLM), that has been trained on a massive amount of data, thereby accumulating substantial knowledge. To ensure it works effectively for SQL Injection detection tasks, we fine-tuned this knowledge using a dataset specific to this type of attack, thus specializing the model's understanding for our context. After this fine-tuning stage, we applied a Convolutional Neural Network (CNN) to classify the input as either an attack or non-attack.

Repo: https://github.com/matheustmattioli/BERT-SQL-API

## TODO List

This plugin is still evolving, and the next features planned are:

- training the AI Model with new attack
- add cache layer in AI Model
- improve response time
- add integration and unit tests cases
- publish a release of the plugin at luarocks.org
- add support to configure message to user by plugin configuration
- add support gRPC communication between kong and upstream 

## Credits

made with :heart: by Mateus Fonseca (https://www.linkedin.com/in/mateus-lima-fonseca/) and Matheus Mattioli (https://www.linkedin.com/in/matheusmattioli/)