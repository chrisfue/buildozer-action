FROM kivy/buildozer:latest
# See https://github.com/kivy/buildozer/blob/master/Dockerfile

# Buildozer will be installed in entrypoint.py
# This is needed to install version specified by user
RUN pip3 uninstall -y buildozer


# Switch to root to install packages
USER root

# Install packages
RUN apt-get update && apt-get install -y gettext autopoint
RUN apt update && apt install -y \
    ffmpeg \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev

RUN apt install -y \
    libswscale-dev \
    libswresample-dev \
    libpostproc-dev

RUN apt install -y \
    libsdl2-dev \
    libsdl2-2.0-0 \
    libsdl2-mixer-2.0-0 \
    libsdl2-mixer-dev \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Optional: Switch back to the non-root user after installing packages for security
USER user  

# Remove a lot of warnings
# sudo: setrlimit(RLIMIT_CORE): Operation not permitted
# See https://github.com/sudo-project/sudo/issues/42
RUN echo "Set disable_coredump false" | sudo tee -a /etc/sudo.conf > /dev/null

# By default Python buffers output and you see prints after execution
# Set env variable to disable this behavior
ENV PYTHONUNBUFFERED=1

COPY entrypoint.py /action/entrypoint.py
ENTRYPOINT ["/action/entrypoint.py"]
