.PHONY: all install build deploy clean
all install build deploy clean:
	$(MAKE) -C lr2_client $@
