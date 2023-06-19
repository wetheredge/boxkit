FROM docker.io/library/rust:slim as helix

RUN apt update -y && apt install -y git build-essential
RUN git clone https://github.com/wetheredge/helix && \
    cd helix && \
    rm rust-toolchain.toml && \
    cargo build --release


FROM registry.fedoraproject.org/fedora-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="me@wetheredge.com"

COPY extra-packages /
RUN dnf upgrade -y && \
    grep -v '^#' /extra-packages | xargs dnf install -y
RUN rm /extra-packages

COPY --from=helix /helix/target/release/hx /usr/bin/hx
COPY --from=helix /helix/runtime /usr/share/helix/runtime
RUN echo 'export HELIX_RUNTIME="/usr/share/helix/runtime"' >> /etc/profile.d/helix-runtime.sh && \
    echo 'set -gx HELIX_RUNTIME /usr/share/helix/runtime' >> /usr/share/fish/vendor_conf.d/helix-runtime.fish

RUN ln -fs /bin/sh /usr/bin/sh && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
