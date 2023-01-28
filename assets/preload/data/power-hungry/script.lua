function onCreate()
	makeAnimatedLuaSprite('rain', 'rain', 0, 0);
	setLuaSpriteScrollFactor('rain', 2, 2);
	scaleObject('rain', 2, 2);
    setObjectCamera('rain', 'hud');

	addLuaSprite('rain', true);
	addAnimationByPrefix('rain', 'loop', 'rain loop', 15, true);
end