dev: .venv
	uv pip install -e .

.venv:
	uv venv

clean:
	rm -r .venv