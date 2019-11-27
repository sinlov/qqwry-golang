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

# can use as https://goproxy.io/ https://gocenter.io https://mirrors.aliyun.com/goproxy/
ENV_GO_PROXY ?= https://goproxy.io/

checkEnvGo:
ifndef GOPATH
	@echo Environment variable GOPATH is not set
	exit 1
endif

init:
	@echo "~> start init this project"
	@echo "-> check version"
	go version
	@echo "-> check env golang"
	go env
	@echo "~> you can use [ make help ] see more task"
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod vendor

checkDepends:
	# in GOPATH just use GO111MODULE=on go mod init to init
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod verify

tidyDepends:
	-GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod tidy

dep: checkDepends
	@echo "just check depends info below"

dependenciesGraph:
	GOPROXY="$(INFO_GO_PROXY)" GO111MODULE=on go mod graph

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

runTest:
	go test -v qqwry/*.go

runTestConveyQQWry:
	@echo "-> use goconvey at https://github.com/smartystreets/goconvey"
	@echo "-> see report at http://localhost:8080"
	which goconvey
	goconvey -depth=1 -launchBrowser=false -workDir=$$PWD/qqwry

runTestConveyCase:
	go test -cover -coverprofile=coverage.txt -covermode=atomic -v qqwry/*.go

buildMain:
	@echo "-> start build local OS"
	@go build -o build/main main.go

buildARCH:
	@echo "-> start build OS:$(DIST_OS) ARCH:$(DIST_ARCH)"
	@GOOS=$(DIST_OS) GOARCH=$(DIST_ARCH) go build -o build/main main.go

dev: buildMain
	@echo "bin file at ./build/main"
	-./build/main

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
	@echo "make dep - check depends of project"
	@echo "make dependenciesGraph - see depends graph of project"
	@echo "make tidyDepends - tidy depends graph of project"
	@echo "make clean - remove binary file and log files"
	@echo ""
	@echo "-- now build name: $(ROOT_NAME) version: $(DIST_VERSION)"
	@echo "-- testOS or releaseOS will out abi as: $(DIST_OS) $(DIST_ARCH) --"
	@echo "make test - build dist at $(ROOT_TEST_DIST_PATH)"
	@echo "make testOS - build dist at $(ROOT_TEST_OS_DIST_PATH)"
	@echo "make testOSTar - build dist at $(ROOT_TEST_OS_DIST_PATH) and tar"
	@echo "make release - build dist at $(ROOT_REPO_DIST_PATH)"
	@echo "make releaseOS - build dist at $(ROOT_REPO_OS_DIST_PATH)"
	@echo "make releaseOSTar - build dist at $(ROOT_REPO_OS_DIST_PATH) and tar"
	@echo ""
	@echo "make runTest - run test case"
	@echo "make dev - run server use conf/config.yaml"
