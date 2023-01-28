local fuck = 0;
function onEvent(name, value1, value2)
	if name == "Static Sound" then
		fuck = value2;
		makeLuaSprite('image', 'static', 0, 0);
		addLuaSprite('image', true);
		playSound('staticBUZZ', 1);
		setObjectCamera('image', 'other');
		runTimer('start', fuck);
	end
end

function onTimerCompleted(tag, loops, loopsleft)
	if tag == 'start' then
		runTimer('wait', fuck / 2);
	end
	if tag == 'wait' then
		doTweenAlpha('byebye', 'image', 0, 1.8, 'circOut');
	end
end

function onTweenCompleted(tag)
	if tag == 'byebye' then
		removeLuaSprite('image', false);
	end
end