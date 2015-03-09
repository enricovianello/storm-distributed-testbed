#!/bin/bash
modules_dir="/etc/puppet/modules"
manifest="deploy-manifest.pp"

echo "Creating manifest file"

cat << EOF > deploy-manifest.pp
include puppet-egi-trust-anchors
include puppet-test-ca
include puppet-infn-ca
include puppet-robot-framework
include puppet-storm
include puppet-users
include puppet-voms-repos
include puppet-voms::install-clients
include puppet-test-vos
include puppet-jenkins-slave
EOF

echo "Installing base puppet modules"

puppet module install --force maestrodev-wget
puppet module install --force gini-archive
puppet module install --force puppetlabs-stdlib
puppet module install --force maestrodev-maven
puppet module install --force puppetlabs-java

echo "Fetching puppet modules from: https://github.com/cnaf/ci-puppet-modules"

if [ ! -e "ci-puppet-modules" ]; then
git clone https://github.com/cnaf/ci-puppet-modules.git
else
pushd ci-puppet-modules
git pull
popd
fi

echo "Applying the following puppet manifest: $manifest"
cat $manifest

puppet apply --debug -v \
--modulepath "/etc/puppet/modules:$(pwd)/ci-puppet-modules/modules" \
$manifest