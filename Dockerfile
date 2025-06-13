# Dockerfile for nca-toolkit-worker

# Stage 1: Build Image - Use an Ubuntu base image as it's common for FFmpeg
# If your NCA Toolkit involves complex GPU-based AI models, you might need
# 'nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04' as the base.
# However, for general video processing with FFmpeg, a standard Ubuntu is often sufficient
# and makes FFmpeg installation straightforward.
FROM ubuntu:22.04

# Set working directory inside the container
WORKDIR /app

# Install necessary packages: Python, pip, and FFmpeg (CRITICAL for video processing)
RUN apt-get update && \
    apt-get install -y python3 python3-pip ffmpeg && \
    rm -rf /var/lib/apt/lists/* # Clean up apt cache to keep image smaller

# Copy requirements.txt and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your application code into the container
COPY . .

# Expose the port your FastAPI application will run on
# This is the CONTAINER PORT (8002 for NCA Toolkit worker)
EXPOSE 8002

# Define environment variable for the API key (will be set by Salad.io during deployment)
ENV API_SECRET_KEY=

# Command to run your FastAPI application when the container starts
# Make sure to specify the correct host and port
# 'main:app' means run the 'app' object from 'main.py'
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8002"]
