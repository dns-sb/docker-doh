IMAGE=satishweb/doh-server
ALPINE_PLATFORMS=linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6
DEBIAN_PLATFORMS=linux/amd64,linux/arm/v7
WORKDIR=$(shell pwd)
TAGNAME?=$(shell curl -s https://api.github.com/repos/m13253/dns-over-https/tags|jq -r '.[0].name')
OSF?=debian

# Set L to + for debug
L=@

DEBIAN_IMAGE=debian:stable-slim
ALPINE_IMAGE=alpine:3.24

ifdef PUSH
	EXTRA_BUILD_PARAMS = --push-images --push-git-tags
endif

ifdef LATEST
	EXTRA_BUILD_PARAMS += --mark-latest
endif

ifdef NO-CACHE
	EXTRA_BUILD_PARAMS += --no-cache
endif

all: build-alpine build-debian

build-alpine:
	$(L)./build.sh \
	  --image-name "${IMAGE}" \
	  --platforms "${ALPINE_PLATFORMS}" \
	  --work-dir "${WORKDIR}" \
	  --git-tag "${TAGNAME}-alpine" \
	  --docker-file "Dockerfile.alpine" \
	  ${EXTRA_BUILD_PARAMS}

build-debian:
	$(L)./build.sh \
	  --image-name "${IMAGE}" \
	  --platforms "${DEBIAN_PLATFORMS}" \
	  --work-dir "${WORKDIR}" \
	  --git-tag "${TAGNAME}-debian" \
	  --docker-file "Dockerfile.debian" \
	  $$(echo ${EXTRA_BUILD_PARAMS}|sed 's/--mark-latest//')

test:
	$(L)docker build -t ${IMAGE}:${TAGNAME} -f ./Dockerfile.${OSF} .
