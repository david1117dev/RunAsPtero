## Introduction

This is a simple script to test docker images like they were inside of Pterodactyl panel.

It basically creates a docker container with the same settings as Pterodactyl would. So you can test you Pterodactyl eggs without a development panel.

## Getting started

1. Clone this repo:

```bash
git clone https://github.com/david1117dev/RunAsPtero
```

2. Move the run.sh script to a place in your $PATH and make it executable. For example:

```bash
cp RunAsPtero/run.sh /usr/local/bin/runasptero
chmod +x /usr/local/bin/runasptero
```

3. You're good to go!

## Usage

RunAsPtero expects a Docker image, and optionally the entrypoint command to run inside the container.

```bash
runasptero <image> [command]
```

Examples:

```bash
# Use the image's default CMD/ENTRYPOINT specified in the Dockerfile. (usually starts $STARTUP configured bellow)
runasptero ghcr.io/org/your-image:latest

# Running something different.
runasptero ghcr.io/org/image:latest bash
runasptero ghcr.io/org/image:latest /alternative-start.sh
```

Notes:

> RunAsPtero creates `.runasptero-data/` and mounts it to `/home/container` inside the container

## Configuration

RunAsPtero looks for a file named `.runasptero`, if it exists in your project root, it will be used as an env file for the container.

The format is the same as any .env file.

If `.runasptero` is missing, RunAsPtero uses these defaults:

```env
TZ=UTC
SERVER_MEMORY=10240
SERVER_PORT=1117
SERVER_IP=10.17.1.1
P_SERVER_LOCATION=DevLand
P_SERVER_UUID=87d2b0e0-3c25-424e-b403-ea787d562fd1
P_SERVER_ALLOCATION_LIMIT=10
STARTUP="bash"
HOME=/home/container
```

## Contributing

Feel free to improve RunAsPtero by submitting your changes!