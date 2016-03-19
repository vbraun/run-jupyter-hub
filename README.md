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

Sage Kernel
-----------

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

SSL/TLS
-------

First of all, you absolutely want to transfer data encrypted between
you and your server.


Configuration
-------------

For anything but quickstart you should have a configuration
file. Generate a default `jupyterhub_config.py` with the command

    ./jupyterhub --generate-config

This configuration file is automatically used by the `./jupyterhub`
launcher script.

