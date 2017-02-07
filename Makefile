$(TARGET): $(shell find lr2_client -type f)
	docker build -t littlerunner2-client lr2_client
	docker run --rm -v $(TARGET):/web/littleRunner2/public littlerunner2-client
