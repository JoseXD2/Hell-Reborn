function onCreate()
	makeAnimatedLuaSprite('StaticStuff', 'TailsDollStatic', -400, -400);
	scaleObject('StaticStuff', 3, 3);
	addAnimationByPrefix('StaticStuff', 'vhs', 'Static', 24, true);
	objectPlayAnimation('StaticStuff', 'vhs');
	addLuaSprite('StaticStuff', true); -- false = add behind characters, true = add over characters
	setObjectCamera('StaticStuff', 'other');
	makeAnimatedLuaSprite('Cave', 'Cave', -400, -400);
	scaleObject('Cave', 3, 3);
	addAnimationByPrefix('Cave', 'spin', 'THREADED LIES', 24, true);
	objectPlayAnimation('Cave', 'spin');
	addLuaSprite('Cave2', false);
	addLuaSprite('Cave', false);
	makeAnimatedLuaSprite('Cave2', 'Cave', -200, -200);
	scaleObject('Cave2', 3, 3);
	addAnimationByPrefix('Cave2', 'spin2', 'THREADED LIES', 24, true);
	objectPlayAnimation('Cave2', 'spin2');
	addLuaSprite('Cave2', false);
	makeAnimatedLuaSprite('Dark', 'Dark', -200, -200);
	scaleObject('Dark', 3, 3);
	addLuaSprite('Dark', false);
	setProperty('Dark.visible', false);
end

function onEvent(name,value1,value2)
	if name == 'Play Animation' then
		
		if value1 == '1' then
			setProperty('Cave2.visible', false);
			setProperty('Cave.visible', false);
			setProperty('Dark.visible', true);
		end
	end
end