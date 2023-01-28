function onEvent(s, e, x)
  if s == 'Fire' then
    if e == 'on' then
      setProperty('fire.visible', true);
    elseif e == 'off' then
      setProperty('fire.visible', false);
    end
  end
end

function onCreate()
  makeAnimatedLuaSprite('fire', 'FIRE', -500, -300)
  addAnimationByPrefix('fire', 'me', 'Burn', 40, true)
  playAnim('fire', 'me')
  setScrollFactor('fire', 0, 0)
  scaleObject('fire', 3, 3)
  setProperty('fire.visible', false);
  addLuaSprite('fire', true)
  screenCenter('fire', 'X')
end