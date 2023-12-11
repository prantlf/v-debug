all: check test

check:
	v fmt -w .
	v vet .

test:
	v -use-os-system-to-run test .
	DEBUG=debug v -use-os-system-to-run test .
	NO_COLOR=1 DEBUG=debug v -use-os-system-to-run test .
	TERM=dumb FORCE_COLOR=1 v -use-os-system-to-run test .
