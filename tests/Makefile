REPO=github.com/DarkLight-Ventures/Superalgos-IaC.git
TESTFILES=$(wildcard $(PWD)/*.go)


.PHONY: all init test

all: init test

init:
	go mod init $(REPO)
	go tidy

test:
	go test -v -count=1 -timeout 30m -p 1 ./

