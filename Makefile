all:
	$(MAKE) -C docker $@

run: clean
	$(MAKE) -C docker $@

test:
	$(MAKE) -C docker $@

clean:
	$(MAKE) -C docker $@
