export REPO_ROOT:=$(shell git rev-parse --show-toplevel)
TOOL2:=tools/py2/activate
TOOL3:=tools/py3/activate


default: jupyterhub

jupyter: $(TOOL3)
	$(TOOL3) jupyter notebook --log-level=DEBUG 

jupyterhub: $(TOOL2) $(TOOL3)
	source $(TOOL2) && source $(TOOL3) && jupyterhub --log-level=DEBUG




# Build instructions for the tools
PYTHON3=tools/bootstrap/bin/python3

$(PYTHON3): tools/toolaid/bootstrap
	./$^

tools/%/activate: $(PYTHON3) tools/%.yaml
	$(PYTHON3) ./tools/toolaid/bin/toolaid --build tools/$*.yaml

clean:
	rm -rf tools/py2 tools/py3 tools/bootstrap

.PHONY: jupyter jupyterhub default clean

