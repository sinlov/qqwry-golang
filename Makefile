.PHONY: test check clean build dist all

TOP_DIR := $(shell pwd)

# ifeq ($(FILE), $(wildcard $(FILE)))
# 	@ echo target file not found
# endif

DIST_VERSION := 1.0.0
DIST_OS := linux
DIST_ARCH := amd64

ROOT_BUILD_PATH ?= ./build
ROOT_DIST ?= ./dist
ROOT_TEST_DIST_PATH ?= $(ROOT_DIST)/test/$(DIST_VERSION)
ROOT_TEST_OS_DIST_PATH ?= $(ROOT_DIST)/$(DIST_OS)/test/$(DIST_VERSION)
ROOT_REPO_DIST_PATH ?= $(ROOT_DIST)/release/$(DIST_VERSION)
ROOT_REPO_OS_DIST_PATH ?= $(ROOT_DIST)/$(DIST_OS)/release/$(DIST_VERSION)

ROOT_LOG_PATH ?= ./log
ROOT_SWAGGER_PATH ?= ./docs

checkEnvGo:
ifndef GOPATH
	@echo Environment variable GOPATH is not set
	exit 1
endif

init: checkEnvGo
	@echo "~> start init this project"
	@echo "-> check version"
	go version
	@echo "-> check env golang"
	go env
	@echo "-> check env dep fix as [ go get -v -u github.com/golang/dep/cmd/dep ]"
	which dep
	@echo "-> check env swag if error fix as [ go get -v -u github.com/swaggo/swag/cmd/swag && go get -v github.com/alecthomas/template]"
	which swag
	swag --help
	@echo "~> you can use [ make help ] see more task"

checkDepends: checkEnvGo
	-dep ensure -v

cleanBuild:
	@if [ -d ${ROOT_BUILD_PATH} ]; then rm -rf ${ROOT_BUILD_PATH} && echo "~> cleaned ${ROOT_BUILD_PATH}"; else echo "~> has cleaned ${ROOT_BUILD_PATH}"; fi

cleanLog:
	@if [ -d ${ROOT_LOG_PATH} ]; then rm -rf ${ROOT_LOG_PATH} && echo "~> cleaned ${ROOT_LOG_PATH}"; else echo "~> has cleaned ${ROOT_LOG_PATH}"; fi

clean: cleanBuild cleanLog
	@echo "~> clean finish"

checkTestDistPath:
	@if [ ! -d ${ROOT_TEST_DIST_PATH} ]; then mkdir -p ${ROOT_TEST_DIST_PATH} && echo "~> mkdir ${ROOT_TEST_DIST_PATH}"; fi

checkTestOSDistPath:
	@if [ ! -d ${ROOT_TEST_OS_DIST_PATH} ]; then mkdir -p ${ROOT_TEST_OS_DIST_PATH} && echo "~> mkdir ${ROOT_TEST_OS_DIST_PATH}"; fi

checkReleaseDistPath:
	@if [ ! -d ${ROOT_REPO_DIST_PATH} ]; then mkdir -p ${ROOT_REPO_DIST_PATH} && echo "~> mkdir ${ROOT_REPO_DIST_PATH}"; fi

checkReleaseOSDistPath:
	@if [ ! -d ${ROOT_REPO_OS_DIST_PATH} ]; then mkdir -p ${ROOT_REPO_OS_DIST_PATH} && echo "~> mkdir ${ROOT_REPO_OS_DIST_PATH}"; fi

buildSwagger:
	which swag
	swag --version
	@if [ -d ${ROOT_SWAGGER_PATH} ]; then rm -rf ${ROOT_SWAGGER_PATH} && echo "~> cleaned ${ROOT_SWAGGER_PATH}"; else echo "~> has cleaned ${ROOT_SWAGGER_PATH}"; fi
	swag init

buildMain: buildSwagger
	@go build -o build/main main.go

buildARCH: buildSwagger
	@GOOS=$(DIST_OS) GOARCH=$(DIST_ARCH) go build -o build/main main.go

dev: buildMain
	-./build/main -c ./conf/config.yaml

test: buildMain checkTestDistPath
	cp ./build/main $(ROOT_TEST_DIST_PATH)
	cp ./conf/config.yaml $(ROOT_TEST_DIST_PATH)
	@echo "=> pkg at: $(ROOT_TEST_DIST_PATH)"

testOS: buildARCH checkTestOSDistPath
	@echo "=> Test at: $(DIST_OS) ARCH as: $(DIST_ARCH)"
	cp ./build/main $(ROOT_TEST_OS_DIST_PATH)
	cp ./conf/test/config.yaml $(ROOT_TEST_OS_DIST_PATH)
	@echo "=> pkg at: $(ROOT_TEST_OS_DIST_PATH)"

release: buildMain checkReleaseDistPath
	cp ./build/main $(ROOT_REPO_DIST_PATH)
	cp ./conf/config.yaml $(ROOT_REPO_DIST_PATH)
	@echo "=> pkg at: $(ROOT_REPO_DIST_PATH)"

releaseOS: buildARCH checkReleaseOSDistPath
	@echo "=> Release at: $(DIST_OS) ARCH as: $(DIST_ARCH)"
	cp ./build/main $(ROOT_REPO_OS_DIST_PATH)
	cp ./conf/config.yaml $(ROOT_REPO_OS_DIST_PATH)
	@echo "=> pkg at: $(ROOT_REPO_OS_DIST_PATH)"

help:
	@echo "make init - check base env of this project"
	@echo "make checkDepends - check depends of project"
	@echo "make clean - remove binary file and log files"
	@echo "make test - build dist at $(ROOT_TEST_DIST_PATH)"
	@echo "make testOS - build dist at $(ROOT_TEST_OS_DIST_PATH)"
	@echo ""
	@echo "make release - build dist at $(ROOT_REPO_DIST_PATH)"
	@echo "make releaseOS - build dist at $(ROOT_REPO_OS_DIST_PATH)"
	@echo ""
	@echo "make dev - run server use conf/config.yaml"
