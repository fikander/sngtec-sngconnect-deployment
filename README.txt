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

FAQ
---

1. How to add new instance?

    - update puppet/manifests/base.pp to add new nginx vhost and sngconnect
      database etc.
    - push to git
    - on the server:

        $ cd /root/sngconnect-deployment && git pull
        $ cd /root && ./run_puppet.sh

    - initialise databases for the new instance

        $ sudo -u sngconnect bash
        $ cd /opt/sngconnect
        $ . bin/activate
        $ sng_initialize_database /etc/sngconnect/{INSTANCE_ID}.ini
        $ sng_initialize_cassandra /etc/sngconnect/{INSTANCE_ID}.ini

    - you don't need to start new sngconnect instance manually, since monit
      will do it for you within 20 seconds(check
      /etc/monit/conf.d/{INSTANCE_ID}.conf to see monit configuration created
      by puppet). If you do need to start it manually, use:

        $ sudo /etc/init.d/{INSTANCE_ID} start

2. How to upgrade sngconnect package?

    - as a root: clone repo, activate venv,
      uninstall sngconnect and reinstall new one from repo

        $ sudo su
        $ git clone <git_server>:<git_repo> /tmp/sngconnect
        $ . /opt/sngconnect/bin/activate

    - stop pserve servers

        $ /etc/init.d/demo_sngconnect_com stop
        $ /etc/init.d/XXX stop

    - uninstall and install sngconnect

        $ pip uninstall sngconnect
        $ pip install file:/tmp/sngconnect

    - start pserve servers

        $ /etc/init.d/demo_sngconnect_com start
        $ /etc/init.d/XXX start

    - change owner and group for these files to sngconnect:

        $ chown sngconnect:sngconnect /opt/sngconnect/lib/python2.7/site-packages/sngconnect/static/.webassets-cache
        $ chown sngconnect:sngconnect /opt/sngconnect/lib/python2.7/site-packages/sngconnect/static/compressed

3. How to start pshell for an sngconnect instance

    $ sudo -u sngconnect bash
    $ cd /opt/sngconnect
    $ . bin/activate
    $ pshell /etc/sngconnect/{INSTANCE}.ini

4. How to start postgres cli

   $ sudo -u postgres psql
   postgres=# \l
   postgres=# \c DATABASE_NAME
