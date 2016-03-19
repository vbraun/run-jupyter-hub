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

# Run IPython
ipython: $(TOOL3)
	 $(TOOL3) ipython3


# Link the Sage kernel(s)
link-sage:
	mkdir -p tools/py3/share/jupyter/kernels
	ln -sf $(shell sage -sh -c 'echo $$SAGE_LOCAL')/share/jupyter/kernels/* \
	    tools/py3/share/jupyter/kernels/


# BUG: this does not work yet inside hashdist
#
# Allow Python to bind to priviledged ports (requires root). This is
# necessary for the letsencrypt client and for running jupyterhub over
# ssl/tls, both will bind on port 443
capabilities:
	echo "Enabling python to bind to port 80 and 443"
	setcap CAP_NET_BIND_SERVICE=+eip $(shell readlink ./tools/py2/bin/python)
	setcap CAP_NET_BIND_SERVICE=+eip $(shell readlink ./tools/py3/bin/python)

# This needs to be run as root or with capabilities
letsencrypt:
	echo ./tools/py2/activate letsencrypt certonly \
	    --config-dir=./letsencrypt/etc \
	    --work-dir=./letsencrypt/var \
	    --logs-dir=./letsencrypt/log \
	    --standalone -d $(DOMAIN)

# Build instructions for the tools
PYTHON3=tools/bootstrap/bin/python3

$(PYTHON3): tools/toolaid/bootstrap
	./$^

tools/%/activate: $(PYTHON3) tools/%.yaml
	$(PYTHON3) ./tools/toolaid/bin/toolaid --build tools/$*.yaml

clean-kernels:
	rm -rf tools/py3/share/jupyter/kernels

clean: clean-kernels
	rm -rf tools/py2 tools/py3 tools/bootstrap

.PHONY: jupyter jupyterhub default clean-kernels clean link-sage
