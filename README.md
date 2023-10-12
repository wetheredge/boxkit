# boxkit

Personal Fedora-based image with the tools I use on a regular basis. See
[the upstream readme](https://github.com/ublue-os/boxkit#readme) for more
information.

## Usage

If you use distrobox:

```shell
$ distrobox create -i ghcr.io/wetheredge/boxkit -n boxkit
$ distrobox enter boxkit
```

If you use toolbx:

```shell
$ toolbox create -i ghcr.io/wetheredge/boxkit -c boxkit
$ toolbox enter boxkit
```

## Verification

This image is signed with sisgstore's [cosign](https://docs.sigstore.dev/cosign/
overview/). You can verify the signature by downloading the `cosign.pub` key
from this repo and running the following command:

```shell
$ cosign verify --key cosign.pub ghcr.io/wetheredge/boxkit
```
