function onCreate()
	-- background shit

	makeAnimatedLuaSprite('rain', 'rain', 0, 0);
	setLuaSpriteScrollFactor('rain', 0.3, 0.3);
	scaleObject('rain', 0.85, 0.85);
	addLuaSprite('rain', true);
	addAnimationByPrefix('rain', 'loop', 'rain loop', 15, true);
	setObjectCamera('rain', 'hud')
	makeLuaSprite('black vig', 'blackvignette', 0, 0);
	setObjectCamera('black vig', 'hud')
	screenCenter('black vig', 'X')
	makeLuaSprite('Floor', 'Tyrant/Floor', -1200, -800);
	scaleObject('Floor', 1, 1);
	makeLuaSprite('Behind Floor Layer', 'Tyrant/Behind Floor Layer', -1200, -800);
	scaleObject('Behind Floor Layer', 1, 1);
	makeLuaSprite('Behind Floor Layer 2', 'Tyrant/Behind Floor Layer 2', -1200, -800);
	scaleObject('Behind Floor Layer 2', 1, 1);
	makeLuaSprite('Behind Floor Layer 3', 'Tyrant/Behind Floor Layer 3', -1200, -800);
	scaleObject('Behind Floor Layer 3', 1, 1);
    makeLuaSprite('Behind Floor Layer 4', 'Tyrant/Behind Floor Layer 4', -1200, -800);
	scaleObject('Behind Floor Layer 4', 1, 1);
	makeLuaSprite('Behind Floor Layer 5', 'Tyrant/Behind Floor Layer 5', -1200, -800);
	scaleObject('Behind Floor Layer 5', 1, 1);
	makeLuaSprite('Behind Floor Layer 6', 'Tyrant/Behind Floor Layer 6', -1200, -800);
	scaleObject('Behind Floor Layer 6', 1, 1);
	makeLuaSprite('Behind Floor Layer 7', 'Tyrant/Behind Floor Layer 7', -1200, -800);
	scaleObject('Behind Floor Layer 7', 1, 1);
	makeLuaSprite('Furthest Back', 'Tyrant/Furthest Back', -1200, -800);
	scaleObject('Furthest Back', 1, 1);
	addLuaSprite('Furthest Back', false);
	addLuaSprite('Behind Floor Layer 7', false);
	addLuaSprite('Behind Floor Layer 6', false);
	addLuaSprite('Behind Floor Layer 5', false);
	addLuaSprite('Behind Floor Layer 4', false);
	addLuaSprite('Behind Floor Layer 3', false);
	addLuaSprite('Behind Floor Layer 2', false);
	addLuaSprite('Behind Floor Layer', false);
	addLuaSprite('Floor', false);
	addLuaSprite('black vig', true);
end