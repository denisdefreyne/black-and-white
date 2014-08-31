LOVE_FILENAME=BlackAndWhite.love

.PHONY: default
default: run

.PHONY: run
run:
	killall love || true
	/Applications/love.app/Contents/MacOS/love .

.PHONY: test
test:
	busted -m ./\?/init.lua engine/spec/systems/physics_spec.lua

.PHONY: pkg
pkg: ${LOVE_FILENAME}

.PHONY: ${LOVE_FILENAME}
${LOVE_FILENAME}:
	zip -9 -q -r $@ .

.PHONY: clean
clean:
	rm -f ${LOVE_FILENAME}
