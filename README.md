# YAMLFish CLI

This is the command line interface for [YAMLFish](https:://yamlfish.dev), the simple and powerful translation management platform.

## Installation

The YAMLFish CLI is available as a Ruby gem.
First, make sure you have Ruby installed on your machine. You can follow the [official Ruby installation guide](https://www.ruby-lang.org/en/documentation/installation/) for your operating system.

Then, to install the YAMLFish CLI, run:

```bash
gem install yamlfish --pre
```

YAMLFish is still in beta, hence the `--pre` flag to install the latest RC.

## Configuration

Before you can use the YAMLFish CLI, you need to configure it with your API key and project token.

To do this, create a `.yamlfish.yml` file in your project's root directory with the following content:

```yaml
api_key: YOUR_API_KEY
project_token: YOUR_PROJECT_TOKEN
```

Those secrets can be found in the footer of your project's page on YAMLFish.

## Usage

For usage instructions, please refer to the [official documentation](https://yamlfish.dev/docs/).
