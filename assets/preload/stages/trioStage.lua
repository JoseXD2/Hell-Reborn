function onCreate()
	-- background shit

	makeLuaSprite('Glitch', 'Lord X stage/Glitch', -1300, -1150);
	
	makeLuaSprite('FrontTrees', 'Lord X stage/FrontTrees', -1300, -1150);

	makeLuaSprite('FarBG1', 'Lord X stage/FarBG1', -1300, -1150);

	makeLuaSprite('FarBG2', 'Lord X stage/FarBG2', -1300, -1150);

	makeLuaSprite('FarBG3', 'Lord X stage/FarBG2.5', -1300, -1150);

	makeLuaSprite('FarBG2.5', 'Lord X stage/FarBG3', -1300, -1150);

	makeLuaSprite('FarBG4', 'Lord X stage/FarBG4', -1300, -1150);

	makeLuaSprite('Ground', 'Lord X stage/Ground', -1300, -1150);


	addLuaSprite('Glitch', false);
	addLuaSprite('FarBG4', false);
	addLuaSprite('FarBG3', false);
	addLuaSprite('FarBG2', false);
	addLuaSprite('FarBG2.5', false);
	addLuaSprite('FarBG1', false);
	addLuaSprite('Ground', false);
	addLuaSprite('FrontTrees', true);


	makeAnimatedLuaSprite('GF', 'GirlFriend', 500, 200);
    luaSpriteAddAnimationByPrefix('GF', 'first', 'idle', 24, false);
    luaSpritePlayAnimation('GF', 'first');
    addLuaSprite('GF', false);
    scaleObject('GF', 0.8, 0.8);

	makeAnimatedLuaSprite('sexualintercourse', 'characters/BOYFRIEND', 1500, 200);
	addAnimationByPrefix('sexualintercourse', 'first', 'Idle', 24, false);
	objectPlayAnimation('sexualintercourse', 'first');
	addLuaSprite('sexualintercourse', false); -- false = add behind characters, true = add over characters
	setProperty('sexualintercourse.visible', false);
	addLuaSprite('sexualintercourse', false);

	
end

function onEvent(name,value1,value2)
	if name == 'Play Animation' then
		
		if value1 == '1' then
				setProperty('Glitch.visible', true);
			setProperty('NewTitleMenuBG.visible', false);
		end

		if value1 == '3' then
		    setProperty('sexualintercourse.visible', true);

		end

		if value1 == '4' then
		    setProperty('sexualintercourse.visible', false);
		end
	end
end

-- Gameplay interactions
function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 2 == 0 then
		objectPlayAnimation('sexualintercourse', 'first');
		luaSpritePlayAnimation('GF', 'first');
	end
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think
	if counter % 2 == 0 then
		objectPlayAnimation('sexualintercourse', 'first');
		luaSpritePlayAnimation('GF', 'first');
	end
end