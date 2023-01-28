function onCreate()
	-- background shit
	makeAnimatedLuaSprite('For', 'Fun/For', 350, 580);
	luaSpriteAddAnimationByPrefix('For', 'first', 'boom', 24, false);
    luaSpritePlayAnimation('For', 'first');
	makeLuaSprite('Smile', 'Fun/Smile', -930, -400);
	makeLuaSprite('The', 'Fun/The', -850, -100);
	makeAnimatedLuaSprite('Camera', 'Fun/Camera', -1100, 100);
    luaSpriteAddAnimationByPrefix('Camera', 'first', 'Bounce', 24, false);
    luaSpritePlayAnimation('Camera', 'first');
    scaleObject('Smile', 1.5, 1.5);
    scaleObject('Camera', 1.9, 1.9);
    scaleObject('The', 1.5, 1.5)
    addLuaSprite('The', false);
	addLuaSprite('Camera', true);
	addLuaSprite('Smile', false);
	addLuaSprite('For', false);
end

function onBeatHit()
	-- triggered 4 times per section
	if curBeat % 0.5 == 0 then
       luaSpritePlayAnimation('Camera', 'first');
       luaSpritePlayAnimation('For', 'first');
	end
end

function onCountdownTick(counter)
	-- counter = 0 -> "Three"
	-- counter = 1 -> "Two"
	-- counter = 2 -> "One"
	-- counter = 3 -> "Go!"
	-- counter = 4 -> Nothing happens lol, tho it is triggered at the same time as onSongStart i think
	if counter % 4 == 0 then
       luaSpritePlayAnimation('Camera', 'first');
       luaSpritePlayAnimation('For', 'first');
	end
end