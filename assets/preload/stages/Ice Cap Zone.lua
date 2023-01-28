function onCreate()
	-- background shit

	makeLuaSprite('Back', 'Jinx/Back', -1800, -500);
	makeLuaSprite('Floor', 'Jinx/Floor', -1800, -1500);
	makeLuaSprite('bg2', 'Jinx/Bg2', -1800, -1500);


    addLuaSprite('Back', false);
    addLuaSprite('bg2', false);
    addLuaSprite('Floor', false);
    scaleObject('Back', 3, 3);
    scaleObject('Floor', 3, 3);
    scaleObject('bg2', 3, 3);

	
end
