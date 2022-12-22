.PHONY: build
build:
	DOCKER_BUILDKIT=1 docker build \
		--build-arg PACKAGE_VERSION="${PACKAGE_VERSION}" \
		--target=artifact \
		--output type=local,dest=./out/ .

.PHONY: publish
publish:
	docker run --rm \
		-e PGP_KEY="${PGP_KEY}" \
		-e PGP_PASS="${PGP_PASS}" \
		-e AWS_ACCESS_KEY_ID="${AWS_ACCESS_KEY_ID }" \
		-e AWS_SECRET_ACCESS_KEY="${AWS_SECRET_ACCESS_KEY }" \
		-e AWS_SESSION_TOKEN="${AWS_SESSION_TOKEN }" \
		-w /work \
		-v ${PWD}:/work \
		debian:bullseye \
		bash /work/publish.sh
