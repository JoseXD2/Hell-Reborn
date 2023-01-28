function onCreate()
	makeLuaSprite('warrn', 'RedVG', 0, 0);
	setScrollFactor('warrn', 1, 1);
	setObjectCamera('warrn', 'hud');
	setObjectOrder('warrn', 999);
	addLuaSprite('warrn', false);
	setProperty('warrn.alpha', 0)
end
function onUpdate()
	if getProperty('health') > 0.3 then
		doTween('warrn', 'warrn', {alpha = 0}, 0.5, 'elasticInOut')
		runTimer('faders', 0.5)
	end
	if getProperty('health') < 0.3 then
		setProperty('warrn.alpha', 1)
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'faders' then
		setProperty('warrn.alpha', 0)
	end
end
