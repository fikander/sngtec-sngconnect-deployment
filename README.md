SNG:connect deployment configuration
====================================

Entire deployment environment is managed with
[Puppet 2.7](http://docs.puppetlabs.com/puppet/2.7/reference/) using
configuration from this repository. Specifics as to which machine runs which
services are defined in deployment-specific configuration file in
`puppet/manifests` directory. Modyfying these files and creating new deployment
configurations require basic Puppet understanding.

System requirements
-------------------

The recommended and tested architecture and operating system is
[Ubuntu Server 12.04 LTS](http://releases.ubuntu.com/precise/) on amd64
machines.

Initalizing new server
----------------------

After the fresh system was booted the `puppet-common` and `git` packages must
be installed:

    $ aptitude install puppet-common git

And the puppet configuration cloned:

    $ cd /root
    $ git clone https://github.com/sngtec/sngconnect-deployment.git

To apply the configuration following simple script may come handy:

    #!/bin/bash
    PUPPET=/usr/bin/puppet
    CONFIGURATION=/root/sngconnect-deployment/puppet
    MANIFEST=base.pp
    $PUPPET apply --modulepath=$CONFIGURATION/modules:$CONFIGURATION/services $CONFIGURATION/manifests/$MANIFEST

If saved in `/root/run_puppet.sh` it can be run with:

    $ chmod +x run_puppet.sh
    $ ./run_puppet.sh

After that the server should be fully functional.
