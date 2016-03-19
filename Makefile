export REPO_ROOT:=$(shell git rev-parse --show-toplevel)
TOOL2:=tools/py2/activate
TOOL3:=tools/py3/activate


default: jupyterhub

# Run the single-user Jupyter notebook
jupyter: $(TOOL3)
	./jupyter notebook --log-level=DEBUG 

# Run Jupyter Hub without SSL
jupyterhub: $(TOOL2) $(TOOL3)
	./jupyterhub --no-ssl --log-level=DEBUG

# Run Jupyter Hub with SSL
jupyterhub-ssl: $(TOOL2) $(TOOL3)
	./jupyterhub --log-level=DEBUG

# Run command-line IPython
ipython: $(TOOL3)
	 $(TOOL3) ipython3


# Link the Sage kernel(s)
link-sage:
	mkdir -p tools/py3/share/jupyter/kernels
	ln -sf $(shell sage -sh -c 'echo $$SAGE_LOCAL')/share/jupyter/kernels/* \
	    tools/py3/share/jupyter/kernels/

# Delete all linked kernels
clean-kernels:
	rm -rf tools/py3/share/jupyter/kernels

clean: clean-kernels clean-tools


include Makefile.d/tools.mk Makefile.d/letsencrypt.mk

.PHONY: default ipython jupyter jupyterhub jupyterhub-ssl clean-kernels clean link-sage
