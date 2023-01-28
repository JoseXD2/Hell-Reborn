function onEvent(s, e, x)
  if s == 'static' then
    if e == 'on' then
      setProperty('boyfriend.color', getColorFromHex '000000')
      setProperty('gf.color', getColorFromHex '000000')
      setProperty('dad.color', getColorFromHex '000000')
      setProperty('black.visible', true);
      setProperty('static.visible', true);
    elseif e == 'off' then
      setProperty('boyfriend.color', getColorFromHex  '0xFFffffff')
      setProperty('gf.color', getColorFromHex '0xFFffffff')
      setProperty('dad.color', getColorFromHex  '0xFFffffff')
      setProperty('static.visible', false);
      setProperty('black.visible', false);
    end
  end
end

function onCreate()
  makeAnimatedLuaSprite('static', 'hitStatic', -500, -300)
  makeLuaSprite('black', 'black', -500, -300)
  scaleObject ('black', 3, 3)
  setScrollFactor('black', 0, 0)
  setProperty('black.visible', false);
  addLuaSprite('black', false)
  addAnimationByPrefix('static', 'me', 'staticANIMATION', 24, true)
  playAnim('static', 'me')
  setScrollFactor('static', 0, 0)
  scaleObject('static', 3, 3)
  setProperty('static.visible', false);
  addLuaSprite('static', false)
  screenCenter('black', 'X')
  screenCenter('static', 'X')
end