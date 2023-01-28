function onCreate()
	-- background shit

	makeLuaSprite('waterintro', 'Final Escape Intro/water', -15650, -11000);
	
	makeLuaSprite('Crystals', 'Final Escape Intro/crystal', -15650, -11000);

	makeLuaSprite('Rings', 'Final Escape Intro/ring', -15650, -11000);

	makeLuaSprite('tassle', 'Final Escape Intro/white', -15650, -11000);

	scaleObject('waterintro', 15, 15);
     scaleObject('Crystals', 15, 15);
     scaleObject('Rings', 15, 15);
     scaleObject('tassle', 15, 15);
     setProperty('Crystals.antialiasing',false)
     setProperty('Rings.antialiasing',false)
     setProperty('tassle.antialiasing',false)
     setProperty('waterintro.antialiasing',false)

	addLuaSprite('waterintro', false);
	addLuaSprite('Crystals', false);
	addLuaSprite('Rings', false);
	addLuaSprite('tassle', true);
	setProperty('waterintro.visible', false);
	setProperty('Crystals.visible', false);
	setProperty('Rings.visible', false);
	setProperty('tassle.visible', false);
end

function onEvent(name,value1,value2)
	if name == 'Spawn' then
		
		if value1 == '1' then
			setProperty('tassle.visible', true);
			setProperty('Rings.visible', true);
			setProperty('Crystals.visible', true);
		end
	end
end