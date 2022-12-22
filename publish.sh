#!/usr/bin/env bash

set -e

# install dependencies
apt update && apt install -y ca-certificates gnupg jq less tree

# install aptly
echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list
gpg --no-default-keyring --keyring trustedkeys.gpg --keyserver keyserver.ubuntu.com --recv-keys A0546A43624A8331
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
gpg --no-default-keyring --keyring trustedkeys.gpg \
  --keyserver keyserver.ubuntu.com --recv-keys C320FD3D3BF10DA7415B29F700CCEE392D0CA761
aptly mirror create unifi-blueberry-stretch https://apt.unifiblueberry.io/ stretch
aptly mirror update unifi-blueberry-stretch

# create new repo
aptly repo create -distribution=stretch -component=main unifi-blueberry-stretch

# import mirror
aptly repo import unifi-blueberry-stretch unifi-blueberry-stretch 'Name (~ .*)'

# add new package
aptly repo add unifi-blueberry-stretch out/*.deb

# import pgp key
echo "$PGP_KEY" | base64 -d | gpg --batch --import

# publish
aptly publish repo -passphrase $PGP_PASS unifi-blueberry-stretch s3:apt.unifiblueberry.io:
