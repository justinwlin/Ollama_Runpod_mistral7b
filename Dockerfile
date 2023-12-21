# Use an official and specific version tag if possible, instead of 'latest'
FROM ollama/ollama:latest

# Environment variables
ENV PYTHONUNBUFFERED=1 

# Set up the working directory
WORKDIR /app

# Install dependencies in a single RUN command to reduce layers
# Clean up in the same layer to reduce image size
RUN apt-get update --yes --quiet && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    software-properties-common \
    gpg-agent \
    build-essential \
    apt-utils \
    ca-certificates \
    curl && \
    add-apt-repository --yes ppa:deadsnakes/ppa && \
    apt-get update --yes --quiet && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes --quiet --no-install-recommends \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    python3.11-venv \
    python3.11-lib2to3 \
    python3.11-gdbm \
    python3.11-tk && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1 && \
    update-alternatives --auto python3

# Install pip manually
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3.11 get-pip.py && \
    rm get-pip.py

# Create and activate a Python virtual environment
RUN python3 -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir runpod==1.4.2 && \
    pip install --no-cache-dir langchain==0.0.259


# Copy only the necessary files
# Use .dockerignore file to exclude files not needed in the container
COPY handler.py /app/handler.py
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

# Set the entrypoint
ENTRYPOINT ["/bin/bash", "start.sh"]
CMD ["mistral:7b"]
