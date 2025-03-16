FROM alpine:3.18

# Install dependencies
RUN apk add --no-cache bash inotify-tools

# Copy the file processing script into the container
COPY process.sh /usr/local/bin/process.sh
RUN chmod +x /usr/local/bin/process.sh

# Set default environment variables (can be overridden)
ENV WATCH_DIR=/ftp
ENV DEST_DIR=/dest
ENV OWNER=newuser:newgroup
ENV PERMS=0644
ENV STABLE_INTERVAL=5

CMD ["/usr/local/bin/process.sh"]
