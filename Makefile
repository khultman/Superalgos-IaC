

.PHONY: diagrams test


diagrams:
	@python3 scripts/diagram.py -o design


test:
	$(MAKE) -C tests

