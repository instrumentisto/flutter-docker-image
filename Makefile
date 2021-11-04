###############################
# Common defaults/definitions #
###############################

comma := ,

# Checks two given strings for equality.
eq = $(if $(or $(1),$(2)),$(and $(findstring $(1),$(2)),\
                                $(findstring $(2),$(1))),1)




######################
# Project parameters #
######################

FLUTTER_VER ?= $(strip \
	$(shell grep 'ARG flutter_ver=' Dockerfile | cut -d '=' -f2))
BUILD_REV ?= $(strip \
	$(shell grep 'ARG build_rev=' Dockerfile | cut -d '=' -f2))

NAMESPACES := instrumentisto \
              ghcr.io/instrumentisto \
              quay.io/instrumentisto
NAME := flutter
TAGS ?= $(FLUTTER_VER)-r$(BUILD_REV) \
        $(FLUTTER_VER) \
        $(strip $(shell echo $(FLUTTER_VER) | cut -d '.' -f1,2)) \
        $(strip $(shell echo $(FLUTTER_VER) | cut -d '.' -f1)) \
        latest
VERSION ?= $(word 1,$(subst $(comma), ,$(TAGS)))




###########
# Aliases #
###########

image: docker.image

push: docker.push

release: git.release

tags: docker.tags

test: test.docker




###################
# Docker commands #
###################

docker-namespaces = $(strip $(if $(call eq,$(namespaces),),\
                            $(NAMESPACES),$(subst $(comma), ,$(namespaces))))
docker-tags = $(strip $(if $(call eq,$(tags),),\
                      $(TAGS),$(subst $(comma), ,$(tags))))


# Build Docker image with the given tag.
#
# Usage:
#	make docker.image [tag=($(VERSION)|<docker-tag>)]] [no-cache=(no|yes)]
#	                  [FLUTTER_VER=<android-ndk-version>]
#	                  [BUILD_REV=<build-revision>]

docker.image:
	docker build --network=host --force-rm \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		--build-arg flutter_ver=$(FLUTTER_VER) \
		--build-arg build_rev=$(BUILD_REV) \
		-t instrumentisto/$(NAME):$(or $(tag),$(VERSION)) ./


# Manually push Docker images to container registries.
#
# Usage:
#	make docker.push [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]
#	                 [namespaces=($(NAMESPACES)|<prefix-1>[,<prefix-2>...])]

docker.push:
	$(foreach tag,$(subst $(comma), ,$(docker-tags)),\
		$(foreach namespace,$(subst $(comma), ,$(docker-namespaces)),\
			$(call docker.push.do,$(namespace),$(tag))))
define docker.push.do
	$(eval repo := $(strip $(1)))
	$(eval tag := $(strip $(2)))
	docker push $(repo)/$(NAME):$(tag)
endef


# Tag Docker image with the given tags.
#
# Usage:
#	make docker.tags [of=($(VERSION)|<docker-tag>)]
#	                 [tags=($(TAGS)|<docker-tag-1>[,<docker-tag-2>...])]
#	                 [namespaces=($(NAMESPACES)|<prefix-1>[,<prefix-2>...])]

docker.tags:
	$(foreach tag,$(subst $(comma), ,$(docker-tags)),\
		$(foreach namespace,$(subst $(comma), ,$(docker-namespaces)),\
			$(call docker.tags.do,$(or $(of),$(VERSION)),$(namespace),$(tag))))
define docker.tags.do
	$(eval from := $(strip $(1)))
	$(eval repo := $(strip $(2)))
	$(eval to := $(strip $(3)))
	docker tag instrumentisto/$(NAME):$(from) $(repo)/$(NAME):$(to)
endef


docker.test: test.docker




####################
# Testing commands #
####################

# Run Bats tests for Docker image.
#
# Documentation of Bats:
#	https://github.com/bats-core/bats-core
#
# Usage:
#	make test.docker [tag=($(VERSION)|<tag>)]

test.docker:
ifeq ($(wildcard node_modules/.bin/bats),)
	@make npm.install
endif
	IMAGE=instrumentisto/$(NAME):$(or $(tag),$(VERSION)) \
	node_modules/.bin/bats \
		--timing $(if $(call eq,$(CI),),--pretty,--formatter tap) \
		tests/main.bats




################
# NPM commands #
################

# Resolve project NPM dependencies.
#
# Usage:
#	make npm.install [dockerized=(no|yes)]

npm.install:
ifeq ($(dockerized),yes)
	docker run --rm --network=host -v "$(PWD)":/app/ -w /app/ \
		node \
			make npm.install dockerized=no
else
	npm install
endif




################
# Git commands #
################

# Release project version (apply version tag and push).
#
# Usage:
#	make git.release [ver=($(VERSION)|<proj-ver>)]

git-release-tag = $(strip $(or $(ver),$(VERSION)))

git.release:
ifeq ($(shell git rev-parse $(git-release-tag) >/dev/null 2>&1 && echo "ok"),ok)
	$(error "Git tag $(git-release-tag) already exists")
endif
	git tag $(git-release-tag) master
	git push origin refs/tags/$(git-release-tag)




##################
# .PHONY section #
##################

.PHONY: image push release tags test \
        docker.image docker.push docker.tags docker.test \
        git.release \
        npm.install \
        test.docker
