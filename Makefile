AIDO_REGISTRY ?= docker.io
PIP_INDEX_URL ?= https://pypi.org/simple

build_options=\
 	--build-arg AIDO_REGISTRY=$(AIDO_REGISTRY)\
 	--build-arg PIP_INDEX_URL=$(PIP_INDEX_URL)

repo=challenge-aido_lf-minimal-agent
# repo=$(shell basename -s .git `git config --get remote.origin.url`)
branch=$(shell git rev-parse --abbrev-ref HEAD)
tag=$(AIDO_REGISTRY)/duckietown/$(repo):$(branch)

update-reqs:
	pur --index-url $(PIP_INDEX_URL) -r requirements.txt -f -m '*' -o requirements.resolved
	aido-update-reqs requirements.resolved

build: update-reqs
	docker build --pull -t $(tag) $(build_options) .

build-no-cache: update-reqs
	docker build --pull -t $(tag) $(build_options)  --no-cache .

push: build
	docker push $(tag)

test-data1-direct:
	./minimal_agent.py < test_data/in1.json > test_data/out1.json

test-data1-docker:
	docker run -i $(tag) < test_data/in1.json > test_data/out1.json


submit: update-reqs
	dts challenges submit


submit-bea: update-reqs
	dts challenges submit --impersonate 1639 --challenge all --retire-same-label

# submit-robotarium:
# 	dts challenges submit --challenge aido2_LF_r_pri,aido2_LF_r_pub

# submit-baseline-sim:
# 	dts challenges submit --impersonate 1639 --user-label "straight" --challenge aido3-LF-sim-validation,aido3-LF-sim-testing,aido3-LFV-sim-validation,aido3-LFV-sim-testing,aido3-LFVI-sim-validation,aido3-LFVI-sim-testing
#
# submit-baseline-real-validation:
# 	dts challenges submit --impersonate 1639 --user-label "straight" --challenge aido3-LF-real-validation,aido3-LFV-real-validation

submit-baseline:
	dts challenges submit --impersonate 1639 --user-label "straight" --challenge aido3-LF-sim-validation,aido3-LF-sim-testing,aido3-LFV-sim-validation,aido3-LFV-sim-testing,aido3-LFVI-sim-validation,aido3-LFVI-sim-testing,aido3-LF-real-validation,aido3-LFV-real-validation
