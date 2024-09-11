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

## TODO List

This plugin is still evolving, and the next features planned are:

- training the model with new attack
- add integration and unit tests cases
- publish a release of the plugin at luarocks.org
- add support to configure message to user by plugin configuration
- add support gRPC communication between kong and upstream 

## Credits

made with :heart: by Mateus Fonseca (https://www.linkedin.com/in/mateus-lima-fonseca/) and Matheus Mattioli (https://www.linkedin.com/in/matheusmattioli/)