# File Processor

This repository contains a lightweight containerized solution for monitoring an FTP directory,
processing PDF files only when they're fully written (using a file size stability check), and then
moving them to a destination directory while adjusting ownership and permissions.

## Features

- **Configurable:** Define watch/destination directories, ownership, permissions, and stabilization interval via environment variables.
- **Portable:** Deploy via Docker Compose. Easily integrated with Portainer or any container management platform.
- **Robust:** Uses inotify to efficiently monitor the FTP directory and process files only when they're ready.

## Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/funguy-tech/safe-copy.git
   cd safe-copy
