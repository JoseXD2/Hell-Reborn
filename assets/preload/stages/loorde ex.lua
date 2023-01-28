function onCreate()
	-- background shit
	makeLuaSprite('Loorde-ex', 'Loorde-ex', -600, -300);
	makeLuaSprite('vig', 'vig', -600, -300);



	addLuaSprite('Loorde-ex', false);
    addLuaSprite('vig', true);
	
	close(true); --For performance reasons, close this script once the stage is fully loaded, as this script won't be used anymore after loading the stage
end