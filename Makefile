all: check test

check:
	v fmt -w .
	v vet .

test:
	v -enable-globals test .
	DEBUG=debug v -enable-globals test .
	NO_COLOR=1 DEBUG=debug v -enable-globals test .
	TERM=dumb FORCE_COLOR=1 v -enable-globals test .

version:
	npx conventional-changelog-cli -p angular -i CHANGELOG.md -s
