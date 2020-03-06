#!make

.PHONY: build
build:
	docker build -t plaid-python .

.PHONY: lint
lint: build
	docker run plaid-python flake8 plaid

.PHONY: test
test: lint
	docker run plaid-python tox

.PHONY: docs
docs:
	-rm -r docs/
	sphinx-build docs_source/ docs/ -b html
	touch docs/.nojekyll

# Clean the /dist directory for a new publish
.PHONY: package-clean
package-clean:
	@rm -rf dist/*

# Build a new package into the /dist directory
.PHONY: package-build
package-build:
	python setup.py sdist

# Test new package before publish
.PHONY: package-check
package-check:
	twine check dist/*

# Publish the new /dist package to Pypi
.PHONY: package-publish
package-publish:
	twine upload dist/*
