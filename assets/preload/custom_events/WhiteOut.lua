function onEvent(name, value1, value2)
	if name == 'WhiteOut' then
		if value1 == 'true' then
		makeLuaSprite('whiteout', 'whiteout', -700, 0);
		scaleObject('whiteout', 18, 22);
		addLuaSprite('whiteout', true)
		setProperty('whiteout.visible', true);
		elseif value1 == 'false' then
		setProperty('whiteout.visible', false)
			end
		end
	end