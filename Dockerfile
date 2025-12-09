# Dockerfile
# Multi-stage build using Nix for reproducible builds

FROM nixos/nix:latest AS builder

# Enable flakes
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

WORKDIR /build

# Copy source
COPY . .

# Build with Nix (includes all CLI tools)
RUN nix build .#full --no-link --print-out-paths > /tmp/store-path

# Create a minimal runtime image
FROM nixos/nix:latest

# Enable flakes
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

# Copy the built package from builder
COPY --from=builder /tmp/store-path /tmp/store-path

# Copy the actual store paths
RUN --mount=type=cache,target=/nix/store,from=builder,source=/nix/store \
    STORE_PATH=$(cat /tmp/store-path) && \
    nix-store --realise $STORE_PATH && \
    ln -s $STORE_PATH /app

# Set PATH to include the tools
ENV PATH="/app/bin:${PATH}"

# Run as non-root
RUN adduser -D mcp
USER mcp

WORKDIR /home/mcp

ENTRYPOINT ["modern-cli-mcp"]
