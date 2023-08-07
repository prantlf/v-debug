all: check test

check:
	v fmt -w .
	v vet .

test:
	v test .
	DEBUG=debug v test .
	NO_COLOR=1 DEBUG=debug v test .
	TERM=dumb FORCE_COLOR=1 v test .

version:
	npx conventional-changelog-cli -p angular -i CHANGELOG.md -s
