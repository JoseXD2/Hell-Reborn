function onCreate()
	-- back1stground shit

	makeLuaSprite('Sky', 'Casino/Sky', -1300, -1150);
	
	makeLuaSprite('FrontTree', 'Casino/FrontTree', -1300, -1150);

	makeLuaSprite('1sttrees', 'Casino/1sttrees', -1300, -1150);

	makeLuaSprite('2ndtrees', 'Casino/2ndtrees', -1300, -1150);

	makeLuaSprite('3rd trees', 'Casino/2ndground', -1300, -1150);

	makeLuaSprite('2ndground', 'Casino/3rd trees', -1300, -1150);

	makeLuaSprite('4th trees', 'Casino/4th trees', -1300, -1150);

	makeLuaSprite('1stground', 'Casino/1stground', -1300, -1150);



	addLuaSprite('Sky', false);
	addLuaSprite('4th trees', false);
	addLuaSprite('3rd trees', false);
	addLuaSprite('2ndtrees', false);
	addLuaSprite('2ndground', false);
	addLuaSprite('1sttrees', false);
	addLuaSprite('1stground', false);
	addLuaSprite('1stsground', false);
	addLuaSprite('FrontTree', true);
end
