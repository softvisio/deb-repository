# Debian package repository

### Install repository

```sh
/usr/bin/env bash <(curl -fsSL "https://raw.githubusercontent.com/softvisio/deb/main/setup.sh") install
```

### Remove repository

```sh
/usr/bin/env bash <(curl -fsSL "https://raw.githubusercontent.com/softvisio/deb/main/setup.sh") remove
```

### Manually install GPG key

Import public key

```sh
curl -fsSL "https://raw.githubusercontent.com/softvisio/deb/main/public-key.asc" | gpg --dearmor -o "/usr/share/keyrings/softvisio-archive-keyring.gpg"
```

### GPG

Generate key:

```sh
export GNUPGHOME="$(mktemp -d)"

gpg --batch --generate-key << EOF
    Key-Type: EdDSA
    Key-Curve: Ed25519
    Key-Usage: cert
    Subkey-Type: EdDSA
    Subkey-Curve: Ed25519
    Subkey-Usage: sign
    Name-Email: deb@softvisio.net
    # Name-Real:
    # Name-Comment:
    Expire-Date: 0
    Keyserver: hkps://keyserver.ubuntu.com
    %no-protection
    %commit
EOF

gpg --export --armor --output public-key.asc deb@softvisio.net
gpg --export-secret-key --armor --output private-key.asc deb@softvisio.net
```

Sign:

```sh
gpg --import private-key.asc

gpg --clearsign private-key.asc
```

### Init repository

```sh
# clone "main" branch
git clone --single-branch --branch main git@github.com:softvisio/deb.git

# clone "dists" branch
git clone --single-branch --branch dists git@github.com:softvisio/deb.git dists

# init "dists" branch
git switch --orphan dists
git commit --allow-empty -m "chore: init"
git push -u origin dists
```

### Work with packages

You need `@softvisio/cli` package:

```sh
npm install --global @softvisio/cli
```

Build docker images:

```sh
softvisio-cli deb build-images
```

Build packages:

```sh
# build all packages
softvisio-cli debian-repository build-packages

# build "nginx-latest" package
softvisio-cli debian-repository build-packages nginx-latest
```

Update repository data:

```sh
softvisio-cli debian-repository update
```
