function onCreate()
	-- background shit

    makeLuaSprite('Sky1', 'Resistance/Egg', -1000, 200)
	scaleObject('Sky1', 1.6, 1.6)
	addLuaSprite('Sky1', false)

	makeLuaSprite('Sky2', 'Resistance/Ground', -1000, 200)
	scaleObject('Sky2', 1.6, 1.6)
	addLuaSprite('Sky2', false)

	makeLuaSprite('overlay', 'Resistance/overlay', -6000, 1000)
	scaleObject('overlay', 6.3, 6.3)
	addLuaSprite('overlay', true)

end
