.PHONY: clone pull serve build check format sync

# First time only — clone the repo together with the content submodule
clone:
	git clone --recurse-submodules git@github.com:js-bruno/garden.git

# Update this repo and the content submodule
pull:
	git pull --recurse-submodules
	git submodule update --init --recursive

serve:
	npx quartz build --serve

build:
	npx quartz build

check:
	npm run check

format:
	npm run format

sync:
	npx quartz sync
