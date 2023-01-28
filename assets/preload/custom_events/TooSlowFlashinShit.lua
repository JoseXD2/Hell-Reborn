function onCreate()
makeAnimatedLuaSprite('screenstatic', 'exe/screenstatic', 0, 0);
addAnimationByPrefix('screenstatic', 'screenstatic', 'screenstatic', 24, true);  
objectPlayAnimation('screenstatic', 'screenstatic', true)
addLuaSprite('screenstatic', true);
scaleLuaSprite('screenstatic', 1, 1);
setObjectCamera('screenstatic','other')
setPropertyLuaSprite('screenstatic', 'alpha', 0)
end

function onEvent(name,value1,value2)
if name == 'TooSlowFlashinShit' then
setPropertyLuaSprite('screenstatic', 'alpha', 0.4)
objectPlayAnimation('screenstatic', 'screenstatic', true)
playSound('simplejumpsound', 0.3)
runTimer('AdiosHomosexual', 0.15, 1)
end
end

function onTimerCompleted(tag, loops, loopsLeft)
if tag == 'AdiosHomosexual' then
setPropertyLuaSprite('screenstatic', 'alpha', 0)
end
end