#!/bin/bash

# Download latest apollo-ios-cli
./download.sh

# Fetch schema
./apollo-ios-cli fetch-schema

# Generate Swift (iOS) library
./apollo-ios-cli generate

# Remove apollo-ios-cli
rm -rf ./apollo-ios-cli
