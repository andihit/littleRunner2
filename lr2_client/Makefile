DEPLOY_DIR=/var/www/littleRunner2/

.PHONY: all
all: install clean build deploy

.PHONY: install
install: package.json
	sudo npm install -g brunch
	npm install

.PHONY: build
build: public

.PHONY: deploy
deploy: build
	rsync -rlpt --delete --progress public/ root@$(HOST):$(DEPLOY_DIR)

.PHONY: clean
clean:
	rm -rf public

public: $(shell git ls-files)
	$(MAKE) clean
	brunch build
