NPM = npm
BOWER = ./node_modules/.bin/bower
GRUNT = ./node_modules/.bin/grunt

# install required components
install:
	@$(NPM) install
	@$(BOWER) install

# launch serve static server for ui debugging (without php server)
debug:
	@$(GRUNT)

# build assets for production
build:
	@$(GRUNT) build

.PHONY:

