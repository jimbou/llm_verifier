FROM docker:latest

# Install Python (if not already available), Bash, and the requests library
RUN apk add --no-cache \
    python3 \
    bash \
    py3-requests  # This line installs the requests library

# In the docker:latest image, Python 3 might already be installed and set as the default Python interpreter.
# If you've verified that `/usr/bin/python` points to Python 3, you can remove the symlink creation command.

# Copy your scripts into the container
COPY . /app

# Set the working directory to /app
WORKDIR /app

# Command to keep the container running (You might replace this with your own command or script that needs to be executed)
CMD ["tail", "-f", "/dev/null"]
