.PHONY: all
all: install clean build deploy
	
.PHONY: install
install: package.json
	sudo npm install -g brunch
	npm install

.PHONY: build
build:
	brunch build

.PHONY: deploy
deploy:
	rsync -rlpt --delete --progress public/ root@lemon:/var/www/littleRunner2/

.PHONY: clean
clean:
	rm -rf public
