function onCreate()
	-- background shit
	makeLuaSprite('Mountain', 'Green Hill/Mountain', -300, -150);
	setScrollFactor('Mountain', 0.7, 0.7);
	scaleObject('Mountain', 1, 1);

	makeLuaSprite('Stars', 'Green Hill/Stars', -300, -150);
	setScrollFactor('Stars', 1.4, 1.4);
	scaleObject('Stars', 1, 1);
	
	makeLuaSprite('Grass', 'Green Hill/Grass', -450, 20);
	scaleObject('Grass', 1, 1);

	makeLuaSprite('Hand', 'Green Hill/Hand', -80, 700);
	scaleObject('Hand', 0.5, 0.5);
	setProperty('Hand.visible', false);
	addLuaSprite('Stars', false);
	addLuaSprite('Mountain', false);
	addLuaSprite('Grass', false);
	addLuaSprite('Hand', false);

    makeLuaSprite('Dead Mountain', 'Green Hill/Dead Mountain', -300, -150);
	setScrollFactor('Dead Mountain', 0.7, 0.7);
	scaleObject('Dead Mountain', 1, 1);

	makeLuaSprite('The sky looks great tonight, fox', 'Green Hill/The sky looks great tonight, fox.', -300, -150);
	setScrollFactor('The sky looks great tonight, fox', 1.4, 1.4);
	scaleObject('The sky looks great tonight, fox', 1, 1);
	
	makeLuaSprite('Dead Grass', 'Green Hill/Dead Grass', -450, 20);
	scaleObject('Dead Grass', 1, 1);

	addLuaSprite('The sky looks great tonight, fox', false);
	addLuaSprite('Dead Mountain', false);
	addLuaSprite('Dead Grass', false);

	setProperty('The sky looks great tonight, fox.visible', false);
    setProperty('Dead Grass.visible', false);
    setProperty('Dead Mountain.visible', false);
end

function onEvent(name,value1,value2)
	if name == 'Spawn' then
		
		if value1 == 'Dead' then
			setProperty('The sky looks great tonight, fox.visible', true);
			setProperty('Dead Grass.visible', true);
			setProperty('Dead Mountain.visible', true);
		end
		if value1 == 'Alive' then
			setProperty('The sky looks great tonight, fox.visible', false);
			setProperty('Dead Grass.visible', false);
			setProperty('Dead Mountain.visible', false);
		end
	end
end