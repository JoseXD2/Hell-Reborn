function onCreate()
	-- background shit
	makeLuaSprite('sunky', 'sunky', -600, -300);
	setScrollFactor('sunky', 0.9, 0.9);



	addLuaSprite('sunky', false);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end