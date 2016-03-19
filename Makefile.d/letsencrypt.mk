

# BUG: this does not work yet inside hashdist
#
# Allow Python to bind to priviledged ports (requires root). This is
# necessary for the letsencrypt client and for running jupyterhub over
# ssl/tls, both will bind on port 443
capabilities:
	echo "Enabling python to bind to port 80 and 443"
	./tools/set_capabilities.py ./tools/py2/bin/python*
	./tools/set_capabilities.py ./tools/py2/bin/node
	./tools/set_capabilities.py ./tools/py3/bin/python*

# This needs to be run as root (meh!) or with capabilities (preferred!)
letsencrypt:
	./tools/py2/activate letsencrypt certonly \
	    --config-dir=./letsencrypt/etc \
	    --work-dir=./letsencrypt/var \
	    --logs-dir=./letsencrypt/log \
	    --standalone -d $(DOMAIN)

# Dry run (this will not generate a valid certificate, and is not
# rate-limited by the server)
letsencrypt-dry-run:
	./tools/py2/activate letsencrypt certonly \
	    --test-cert \
	    --config-dir=./letsencrypt/etc \
	    --work-dir=./letsencrypt/var \
	    --logs-dir=./letsencrypt/log \
	    --standalone -d $(DOMAIN)

# Configure firewall (requires root)
# This is temporary; Add --permanent to persist after a reboot
firewalld:
	firewall-cmd --add-service http
	firewall-cmd --add-service https


.PHONY: capabilities letsencrypt letsencrypt-dry-run firewalld
