FROM linuxmintd/mint21-amd64

# Install sudo and other dependencies
RUN apt-get update && apt-get install -y sudo systemd systemd-sysv apt-utils dialog

# Create a non-root user with sudo privileges
RUN useradd -m developer && \
    echo "developer:developer" | chpasswd && \
    adduser developer sudo && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/developer

# Copy the setup script into the container
COPY setup_dev_environment.sh /home/developer/setup_dev_environment.sh
RUN chown developer:developer /home/developer/setup_dev_environment.sh && \
    chmod +x /home/developer/setup_dev_environment.sh

# Pre-install some heavy packages to speed up testing
RUN apt-get update && \
    apt-get install -y git curl wget zsh unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to the non-root user
USER developer
WORKDIR /home/developer

# Set up a mock script for interactive inputs during testing
RUN echo '#!/bin/bash\n\
echo "Test User"\n\
echo "test@example.com"\n\
echo "test@example.com"\n\
' > /home/developer/test_inputs.sh && \
    chmod +x /home/developer/test_inputs.sh

# Set the entrypoint to bash
ENTRYPOINT ["/bin/bash"] 