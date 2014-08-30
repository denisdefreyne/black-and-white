run:
	killall love || true
	/Applications/love.app/Contents/MacOS/love .

test:
	busted -m ./\?/init.lua engine/spec/systems/physics_spec.lua
