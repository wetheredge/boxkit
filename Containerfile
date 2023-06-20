FROM registry.fedoraproject.org/fedora-toolbox:latest

LABEL com.github.containers.toolbox="true" \
      usage="This image is meant to be used with the toolbox or distrobox command" \
      summary="A cloud-native terminal experience" \
      maintainer="me@wetheredge.com"

COPY coprs /
RUN for copr in $(grep -v '^#' /coprs); do dnf copr enable -y $copr; done && \
    rm /coprs

COPY extra-packages /
RUN dnf upgrade -y && \
    grep -v '^#' /extra-packages | xargs dnf install -y && \
    rm /extra-packages

COPY npm-packages /
RUN grep -v '^#' /npm-packages | xargs npm install --global && \
    rm /npm-packages

COPY helix/hx /usr/bin/hx
COPY helix/runtime /usr/share/helix/runtime
RUN chmod +x /usr/bin/hx && \
    echo 'export HELIX_RUNTIME="/usr/share/helix/runtime"' >> /etc/profile.d/helix-runtime.sh && \
    echo 'set -gx HELIX_RUNTIME /usr/share/helix/runtime' >> /usr/share/fish/vendor_conf.d/helix-runtime.fish

RUN curl --proto '=https' --tlsv1.2 -sSfL https://github.com/yt-dlp/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-linux64-gpl.tar.xz \
    | tar -xJ && \
    rm -rf ffmpeg-master-latest-*/doc && \
    mkdir /usr/share/yt-dlp && \
    mv ffmpeg-master-latest-*/ /usr/share/yt-dlp/ffmpeg

RUN ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/docker && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/flatpak && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/podman && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/rpm-ostree && \
    ln -fs /usr/bin/distrobox-host-exec /usr/local/bin/transactional-update
