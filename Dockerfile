# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04 as builder

# Disable interactive mode in apt-get to prevent prompts during build
ARG DEBIAN_FRONTEND=noninteractive

# Update the system and install dependencies
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev uuid-dev libsecp256k1-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/mpc-lib
COPY . .
RUN make

# Copy library to clean image
FROM alpine:latest

COPY --from=builder ./usr/src/mpc-lib/src/common/libcosigner.so ./usr/lib/