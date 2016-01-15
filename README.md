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

This builds and launches the multi-user jupyterhub at
http://localhost:8000. You'll have to log in with your system username
and password because it is multi-user.


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