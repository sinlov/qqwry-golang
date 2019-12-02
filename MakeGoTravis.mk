# this file must use as base Makefile

INFO_TRAVIS_TARGET ?= ./qqwry/

travisTest:
	GO111MODULE=on go test -v $(INFO_TRAVIS_TARGET)... -timeout 1m

travisTestFail:
	GO111MODULE=on go test -v $(INFO_TRAVIS_TARGET)... -timeout 1m | grep FAIL --color

travisConvey:
	GO111MODULE=on go test -cover -coverprofile=coverage.txt -covermode=atomic -v $(INFO_TRAVIS_TARGET)...

travisConveyLocal:
	@echo "-> use goconvey at https://github.com/smartystreets/goconvey"
	@echo "-> see report at http://localhost:8080"
	which goconvey
	goconvey -depth=1 -launchBrowser=false -workDir=$$PWD

helpGoTravis:
	@echo "Help: MakeTravis.mk"
	@echo "~> make travisTest - run project test"
	@echo "~> make travisTestFail - run project test fast find FAIL"
	@echo "~> make travisConvey - run project convery"
	@echo "~> make travisConveyLocal - run project convery local as tools https://github.com/smartystreets/goconvey"
	@echo ""