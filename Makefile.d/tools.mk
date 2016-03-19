
# Build instructions for the tools
PYTHON3=tools/bootstrap/bin/python3

$(PYTHON3): tools/toolaid/bootstrap
	./$^

tools/%/activate: $(PYTHON3) tools/%.yaml
	$(PYTHON3) ./tools/toolaid/bin/toolaid --build tools/$*.yaml

clean-tools:
	rm -rf tools/py2 tools/py3 tools/bootstrap

.PHONY: clean-tools
