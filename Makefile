.PHONY: build check serve install-mkdocs

install-mkdocs:
	poetry install

build:
	poetry run mkdocs build --strict

chect: build

serve:
	poetry run mkdocs serve --clean --strict --watch docs/
