.PHONY: all install build deploy clean
all install build deploy clean:
	make -C lr2_client $@
