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

NAMESPACES := instrumentisto \
              ghcr.io/instrumentisto \
              quay.io/instrumentisto
NAME := flutter
TAGS ?= $(FLUTTER_VER) \
        latest
VERSION ?= $(word 1,$(subst $(comma), ,$(TAGS)))




###########
# Aliases #
###########

image: docker.image

push: docker.push

release: git.release

test: test.docker




###################
# Docker commands #
###################

docker-namespaces = $(strip $(if $(call eq,$(namespaces),),\
                            $(NAMESPACES),$(subst $(comma), ,$(namespaces))))
docker-tags = $(strip $(if $(call eq,$(tags),),\
                      $(TAGS),$(subst $(comma), ,$(tags))))

# Runs `docker buildx build` command allowing to customize it for the purpose of
# re-tagging or pushing.
define docker.buildx
	$(eval namespace := $(strip $(1)))
	$(eval tag := $(strip $(2)))
	$(eval no-cache := $(strip $(3)))
	$(eval args := $(strip $(4)))
	docker buildx build --force-rm $(args) \
		$(if $(call eq,$(no-cache),yes),--no-cache --pull,) \
		--build-arg flutter_ver=$(FLUTTER_VER) \
		-t $(namespace)/$(NAME):$(tag) .
endef


# Pre-build cache for Docker image builds.
#
# WARNING: This command doesn't apply tag to the built Docker image, just
#          creates a build cache. To produce a Docker image with a tag, use
#          `docker.image` command right after running this one.
#
# Usage:
#	make docker.build.cache
#		[no-cache=(no|yes)]
#		[FLUTTER_VER=<flutter-version>]

docker.build.cache:
	$(call docker.buildx,\
		instrumentisto,\
		build-cache,\
		$(no-cache),\
		--output 'type=image$(comma)push=false')


# Build Docker image on the given platform with the given tag.
#
# Usage:
#	make docker.image
#		[tag=($(VERSION)|<tag>)]
#		[no-cache=(no|yes)]
#		[FLUTTER_VER=<flutter-version>]

docker.image:
	$(call docker.buildx,\
		instrumentisto,\
		$(or $(tag),$(VERSION)),\
		$(no-cache),\
		--load)


# Push Docker images to their repositories (container registries).
#
# Usage:
#	make docker.push
#		[namespaces=($(NAMESPACES)|<prefix-1>[,<prefix-2>...])]
#		[tags=($(TAGS)|<tag-1>[,<tag-2>...])]
#		[FLUTTER_VER=<flutter-version>]

docker.push:
	$(foreach namespace,$(docker-namespaces),\
		$(foreach tag,$(docker-tags),\
			$(call docker.buildx,\
				$(namespace),\
				$(tag),\
				--push)))


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
	IMAGE=instrumentisto/$(NAME):$(if $(call eq,$(tag),),$(VERSION),$(tag)) \
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

.PHONY: image push release test \
        docker.build.cache docker.image docker.push docker.test \
        git.release \
        npm.install \
        test.docker
