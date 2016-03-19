Run JupyterHub / Jupyter
========================

Self-contained dependencies for JupyterHub and Jupyter; All you need
is Python 2.x and a C compiler. Builds Python 3.x and Nodejs for you
using hashdist. Nothing is installed globally, you don't need root for
anything.


Quickstart
----------

Check out the repository and run

    make

This builds and launches the multi-user jupyterhub (without SSL!, see
below) at http://localhost:8000. You'll have to log in with your
system username and password because it is multi-user. But you can
only log in as your own user since you did not (and should not) run
this as root.


Link the Sage Kernel
--------------------

To link the sage kernel into your jupyter[hub] run:

    make link-sage

This picks up Sage from the PATH, that is, just running "sage" on the
commandline must work.


Jupyter without Hub
-------------------

Just the single-user Jupyter notebook:

    make jupyter


Running on a Server
===================


Configuration
-------------

For anything but quickstart you should have a configuration
file. Generate a default `jupyterhub_config.py` with the command

    ./jupyterhub --generate-config

This configuration file is automatically used by the `./jupyterhub`
launcher script.


Privileged Ports
----------------

You probably want to run on the normal https port 443, and the
letsencrypt client must be able to bind to 80, 443. Of course you
don't want to run as root all the time, so we convey just the
capability to listen to priviledged ports to our self-compiled Python
and Nodejs binary:

    sudo make capabilities

This is the only place where you actually need root. You can run
Jupyter Hub without root on an alternate port, but you won't be able
to get a free letsencrypt certificate (see
https://github.com/letsencrypt/acme-spec/issues/33)


SSL/TLS
-------

First of all, you absolutely want to transfer data encrypted between
you and your server. To obtain a free certificate, run

    make letsencrypt-dry-run DOMAIN=my.domain.com

and replace `my.domain.com` with your domain name. Once you are
satisfied that everything works, run

    make letsencrypt DOMAIN=my.domain.com

to obtain the actual certificate. To use the certificate, edit the
configuration file (see above) to include the lines:

    c.JupyterHub.ssl_cert = 'letsencrypt/etc/live/my.domain.com/cert.pem'
    c.JupyterHub.ssl_key = 'letsencrypt/etc/live/my.domain.com/privkey.pem'


