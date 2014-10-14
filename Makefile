NPM = npm
BOWER = ./node_modules/.bin/bower
GRUNT = ./node_modules/.bin/grunt

# install required components
setup:
	@$(NPM) install && $(NPM) prune
	@$(BOWER) install && $(BOWER) prune

# launch serve static server for ui debugging (without php server)
debug: setup
	@NODE_ENV=development $(GRUNT)

# build assets for production
build: setup
	@NODE_ENV=production $(GRUNT) build

# remove all useless files
release: setup build
	@rm -rf public/vendor public/config*

.PHONY:

