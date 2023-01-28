function onCreate()
	
	makeLuaSprite('seemslikefarmland', 'Cycles/floor', -400, -450);
	makeLuaSprite('sharpcrap', 'Cycles/hills1', -600, -300);
	makeLuaSprite('ppsky', 'Cycles/sky', -800, -400);
	makeLuaSprite('ppskyefx', 'Cycles/skyeffect', -800, -400);
	makeLuaSprite('fronttree', 'Cycles/front_trees', -800, -200);
	makeLuaSprite('cloud1', 'Cycles/Clouds1', -800, -300);
	makeLuaSprite('cloud', 'Cycles/Clouds', -800, -300);
	
	makeAnimatedLuaSprite('thing1', 'Cycles/smallflower', 100, 500);
	addAnimationByPrefix('thing1', 'okay', 'Idle', 24, true);

	makeAnimatedLuaSprite('thing2', 'Cycles/smallflower2', 1750, 250);
	addAnimationByPrefix('thing2', 'lol', 'Idle', 24, true);

	scaleObject('ppsky', 1, 1);
	scaleObject('seemslikefarmland', 0.8, 0.8);
	scaleObject('sharpcrap', 1, 1);
	scaleObject('thing1', 1, 1);
	scaleObject('thing2', 1, 1);
	scaleObject('fronttree', 1.5, 1.5);

	setScrollFactor('ppsky', 0.9, 0.9);
	setScrollFactor('sharpcrap', 0.8, 0.8);
	setScrollFactor('cloud', 0.9, 0.9);
	setScrollFactor('cloud1', 0.5, 0.5);

	addLuaSprite('ppsky', false)
	addLuaSprite('cloud1', false)
	addLuaSprite('cloud', false)
	addLuaSprite('sharpcrap', false)
	addLuaSprite('seemslikefarmland', false)
	addLuaSprite('thing1', false)
	addLuaSprite('thing2', false)
	addLuaSprite('fronttree', true)
	addLuaSprite('ppskyefx', true)
	

end