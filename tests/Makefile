GOCMD=go
GOINIT=$(GOCMD) mod init
GOTEST=$(GOCMD) test
GOTESTOPTS=-v -count=1 -timeout 30m -p 1
GOTIDY=$(GOCMD) tidy
GOVET=$(GOCMD) vet
REPO=github.com/DarkLight-Ventures/Superalgos-IaC.git
TESTFILES=$(wildcard $(PWD)/*.go)


.PHONY: all init test $(TESTFILES)

all: init test

init:
	$(GOINIT) $(REPO)
	$(GOTIDY)

test: $(TESTFILES)
	$(GOTEST) $(GOTESTOPTS) ./

