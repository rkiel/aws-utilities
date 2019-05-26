## Introduction

This is a collection of simple command-line scripts, bash aliases, and bash utilities that make using the AWS CLI even easier.

The command-line scripts include:

- [awssu](docs/AWSSU.md) - makes working with multiple AWS CLI profiles easier
- [awscc](docs/CODECOMMIT.md) - makes setup and configuration of AWS CodeCommit easier

The command-line scripts are written in Ruby 2.x using just the standard libraries and do not require any gems to be installed.
For OS X users, these should just work out-of-box.

## Installation

Clone the repository

```
mkdir -p ~/GitHub/rkiel && cd $_
git clone https://github.com/rkiel/aws-utilities.git
```

To update your `.bash_profile` and `.bashrc`.

```
cd ~/GitHub/rkiel/aws-utilities
./install/bin/setup
```

## Documention

- [See awssu](docs/AWSSU.md)
- [See awscc](docs/CODECOMMIT.md)
