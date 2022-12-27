#!/usr/bin/env bash

set -e

# install dependencies
apt update && apt install -y ca-certificates gnupg jq less tree bzip2 xz-utils

# install aptly
echo installing aptly...
echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A0546A43624A8331
apt update
apt install -y aptly

cat <<EOT > $HOME/.aptly.conf
{
  "S3PublishEndpoints":{
    "apt.unifiblueberry.io":{
      "region":"us-west-2",
      "bucket":"apt.unifiblueberry.io"
    }
  }
}
EOT

# create mirror of existing repo
echo creating mirror...
gpg --no-default-keyring --keyring trustedkeys.gpg \
  --keyserver keyserver.ubuntu.com --recv-keys C320FD3D3BF10DA7415B29F700CCEE392D0CA761
aptly mirror create unifi-blueberry-stable https://apt.unifiblueberry.io/ stable
aptly mirror update unifi-blueberry-stable

# create new repo
echo creating new repo...
aptly repo create -distribution=stable -component=main -architectures=arm64 unifi-blueberry-stable

# import mirror
echo importing mirror...
aptly repo import unifi-blueberry-stable unifi-blueberry-stable 'Name (~ .*)'

# add new package
echo adding new package...
aptly repo add unifi-blueberry-stable out/*.deb

# import pgp key
echo importing pgp key...
echo "$PGP_KEY" | base64 -d | gpg --batch --import

# publish
echo publishing...
aptly publish repo -batch -passphrase="$PGP_PASS" -architectures=arm64 unifi-blueberry-stable s3:apt.unifiblueberry.io:
