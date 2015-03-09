#!/bin/bash
set -ex
trap "exit 1" TERM

WGET_OPTIONS="--no-check-certificate"

# use the STORM_REPO env variable for the repo, or default to the develop repo
STORM_REPO=${STORM_REPO:-http://radiohead.cnaf.infn.it:9999/view/REPOS/job/repo_storm_develop_SL6/lastSuccessfulBuild/artifact/storm_develop_sl6.repo}

# install emi-release package
wget $WGET_OPTIONS http://emisoft.web.cern.ch/emisoft/dist/EMI/3/sl6/x86_64/base/emi-release-3.0.0-2.el6.noarch.rpm
yum localinstall --nogpgcheck -y emi-release-3.0.0-2.el6.noarch.rpm

# install the storm repo
wget $WGET_OPTIONS $STORM_REPO -O /etc/yum.repos.d/storm.repo

# install
yum clean all

# add some users
adduser -u 498 -r storm

# install storm packages
#yum install -y emi-storm-backend-mp emi-storm-frontend-mp emi-storm-globus-gridftp-mp emi-storm-gridhttps-mp
yum install -y emi-storm-frontend-mp 

# install yaim configuration
sh ./install-yaim-configuration.sh

# configure with yaim
#/opt/glite/yaim/bin/yaim -c -s /etc/storm/siteinfo/storm.def -n se_storm_backend -n se_storm_frontend -n se_storm_gridftp -n se_storm_gridhttps
/opt/glite/yaim/bin/yaim -c -s /etc/storm/siteinfo/storm.def -n se_storm_frontend
