function onEvent(name, value1, value2)
	if name == 'BlackOut' then
		if value1 == 'true' then
		setProperty('BlackFlash.visible', true);
		elseif value1 == 'false' then
		setProperty('BlackFlash.visible', false)
			end
		end
	end

function onCreate()
  makeLuaSprite('BlackFlash', 'BlackFlash', -800, -900)
  scaleObject ('BlackFlash', 18, 22)
  setScrollFactor('BlackFlash', 0, 0)
  screenCenter('BlackFlash ', 'X')
  setProperty('black.visible', false);
  addLuaSprite('BlackFlash', true)
  setProperty('BlackFlash.visible', false)
end