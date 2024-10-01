SHELL := /bin/bash

.PHONY: images podman-build pull-all docs docs-watch

.ONESHELL:
images: docker/*/Dockerfile docker/Dockerfile.*

.ONESHELL:
pull-all:
	for file in $$(find docker/ -maxdepth 1 -type f -iname 'Dockerfile.*'); do \
		NAME=$$(echo $$file | sed 's/^.*\.//'); \
		echo "=> Pulling image $$NAME"; podman pull "ghcr.io/docjyj/nextcloud-dev-$${NAME}"; \
	done
	for file in $$(find podman -maxdepth 2 -type f -iname 'Dockerfile'); do \
		NAME=$$(basename $$(dirname $$file)); \
		echo "=> Pulling image $$NAME"; podman pull "ghcr.io/docjyj/nextcloud-dev-$${NAME}"; \
	done

pull-installed:
	podman image ls | grep docjyj/nextcloud-dev | cut -f 1 -d " "
	podman image ls | grep docjyj/nextcloud-dev | cut -f 1 -d " " | xargs -L 1 podman pull

# Empty target to always build
podman-build:

docker/%/Dockerfile: podman-build
	NAME=$$(basename $$(dirname $@)); \
	echo "=> Building dockerfile" $@ as ghcr.io/docjyj/nextcloud-dev-$$NAME:latest; \
	(cd podman && podman build -t ghcr.io/docjyj/nextcloud-dev-$$NAME:latest -f $$NAME/Dockerfile .)

docker/Dockerfile.%: podman-build
	NAME=$$(echo $$(basename $@) | sed 's/^.*\.//'); \
	echo "=> Building dockerfile" $@ as ghcr.io/docjyj/nextcloud-dev-$$NAME:latest; \
	(cd podman && podman build -t ghcr.io/docjyj/nextcloud-dev-$$NAME:latest -f Dockerfile.$$NAME .)

check: dockerfilelint shellcheck

.ONESHELL:
dockerfilelint:
	for file in $$(find docker/ -type f -iname 'Dockerfile.*' -maxdepth 1); do dockerfilelint $$file; done;
	for file in $$(find podman -type f -iname 'Dockerfile' -maxdepth 2); do dockerfilelint $$file; done;

.ONESHELL:
shellcheck:
	for file in $$(find . -type f -iname '*.sh' -not -path './wip/*'); do shellcheck --format=gcc -x $$file; done;
	for file in $$(find ./scripts -type f); do shellcheck --format=gcc -x $$file; done;

.ONESHELL:
template-apply:
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:7.1/' > docker/Dockerfile.php71
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:7.2/' > docker/Dockerfile.php72
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:7.3/' > docker/Dockerfile.php73
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:7.4/' > docker/Dockerfile.php74
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:8.0/' > docker/Dockerfile.php80
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:8.1/' > docker/Dockerfile.php81
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:8.2/' > docker/php82/Dockerfile
	cat docker/Dockerfile.php.template | sed 's/php:8.2/php:8.3/' > docker/php83/Dockerfile

docs:
	pip3 install mkdocs
	mkdocs

docs-watch:
	pip3 install mkdocs
	mkdocs serve
