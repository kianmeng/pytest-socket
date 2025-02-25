.PHONY: all clean poetry test dist testrelease release

INSTALL_STAMP := .install.stamp
POETRY := $(shell command -v poetry 2> /dev/null)
PYTEST_FLAGS :=

all: test

clean:
	@find . -name \*.pyc -delete
	@find . -name __pycache__ -delete
	@rm -fr $(INSTALL_STAMP) .cache/ .coverage .pytest_cache/ *.egg-info/ dist/ htmlcov/

install: $(INSTALL_STAMP)
poetry.lock:
$(INSTALL_STAMP): pyproject.toml poetry.lock
ifndef POETRY
	$(error "poetry is not available, please install it first.")
endif
	@poetry install
	@touch $(INSTALL_STAMP)

test: $(INSTALL_STAMP)
	@poetry run coverage run -m pytest $(PYTEST_FLAGS) ; coverage report --show-missing

dist: clean $(INSTALL_STAMP)
	@poetry build

testrelease: dist
	# Requires config: `repositories.testpypi.url = "https://test.pypi.org/simple"`
	@poetry publish --repository testpypi

release: dist
	@poetry publish
