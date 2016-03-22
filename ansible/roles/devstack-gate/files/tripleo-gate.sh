#!/bin/bash -xe
export TOCI_JOBTYPE=nonha

# ZUUL Doesn't set these for periodic jobs
export ZUUL_PROJECT=openstack/puppet-ironic
export ZUUL_BRANCH=${ZUUL_BRANCH:-master}
export ZUUL_REF=${ZUUL_REF:-None}

export BRANCH_OVERRIDE={branch-override}
if [ "$BRANCH_OVERRIDE" != "default" ] ; then
export OVERRIDE_ZUUL_BRANCH=$BRANCH_OVERRIDE
fi

export PYTHONUNBUFFERED=true
export DEVSTACK_GATE_TEMPEST=0
export DEVSTACK_GATE_EXERCISES=0

export PROJECTS="openstack/instack $PROJECTS"
export PROJECTS="openstack/instack-undercloud $PROJECTS"
export PROJECTS="openstack/puppet-aodh $PROJECTS"
export PROJECTS="openstack/puppet-barbican $PROJECTS"
export PROJECTS="openstack/puppet-ceilometer $PROJECTS"
export PROJECTS="openstack/puppet-ceph $PROJECTS"
export PROJECTS="openstack/puppet-cinder $PROJECTS"
export PROJECTS="openstack/puppet-glance $PROJECTS"
export PROJECTS="openstack/puppet-gnocchi $PROJECTS"
export PROJECTS="openstack/puppet-heat $PROJECTS"
export PROJECTS="openstack/puppet-horizon $PROJECTS"
export PROJECTS="openstack/puppet-ironic $PROJECTS"
export PROJECTS="openstack/puppet-keystone $PROJECTS"
export PROJECTS="openstack/puppet-mistral $PROJECTS"
export PROJECTS="openstack/puppet-neutron $PROJECTS"
export PROJECTS="openstack/puppet-nova $PROJECTS"
export PROJECTS="openstack/puppet-openstack_extras $PROJECTS"
export PROJECTS="openstack/puppet-openstacklib $PROJECTS"
export PROJECTS="openstack/puppet-oslo $PROJECTS"
export PROJECTS="openstack/puppet-pacemaker $PROJECTS"
export PROJECTS="openstack/puppet-sahara $PROJECTS"
export PROJECTS="openstack/puppet-swift $PROJECTS"
export PROJECTS="openstack/puppet-tripleo $PROJECTS"
export PROJECTS="openstack/puppet-vswitch $PROJECTS"
export PROJECTS="openstack/puppet-zaqar $PROJECTS"
export PROJECTS="openstack/python-ironic-inspector-client $PROJECTS"
export PROJECTS="openstack/python-tripleoclient $PROJECTS"
export PROJECTS="openstack/tripleo-common $PROJECTS"
export PROJECTS="openstack/tripleo-puppet-elements $PROJECTS"

export WORKSPACE=/home/jenkins/workspace/testing
mkdir -p $WORKSPACE
export REPO_URL=https://git.openstack.org
cd $WORKSPACE \
    && rm -rf devstack-gate \
    && git clone --depth 1 $REPO_URL/openstack-infra/devstack-gate

# sudo chown -hR $(whoami) /opt/git
function gate_hook {
	bash -xe /opt/stack/new/tripleo-ci/toci_gate_test.sh
}
export -f gate_hook
cp devstack-gate/devstack-vm-gate-wrap.sh ./safe-devstack-vm-gate-wrap.sh
./safe-devstack-vm-gate-wrap.sh
