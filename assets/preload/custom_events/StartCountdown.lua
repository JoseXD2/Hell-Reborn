--↓ ↓ ↓ CHANGE THE SPRITE OFFSETS HERE
SpriteX = 300;
SpriteY = 200;
executedAmm = 0;

function onCreate()
   precacheImage('ready')
   precacheImage('set')
   precacheImage('go')
   
   precacheSound('intro1')
   precacheSound('intro2')
   precacheSound('intro3')
   precacheSound('introGo')
   
   makeLuaSprite('ready', 'ready', SpriteX, SpriteY);
   setObjectCamera('ready', 'camother');
   
   makeLuaSprite('set', 'set', SpriteX, SpriteY);
   setObjectCamera('set', 'camother');
   
   makeLuaSprite('go', 'go', SpriteX, SpriteY);
   setObjectCamera('go', 'camother');
end

function onEvent(name, value1, value2)
    if name == 'StartCountdown' and executedAmm == 0 then
	executedAmm = (getProperty(executedAmm) + 2);
	
    elseif name == 'StartCountdown' and executedAmm == 2 then
	setProperty('ready.alpha', 1);
	executedAmm = (getProperty(executedAmm) + 1);
	addLuaSprite('ready', true);
	doTweenAlpha('noReady', 'ready', 0, 0.50, "quartOut");
	
	elseif name == 'StartCountdown' and executedAmm == 3 then
	setProperty('set.alpha', 1);
	executedAmm = (getProperty(executedAmm) + 1);
	addLuaSprite('set', true);
	doTweenAlpha('noSet', 'set', 0, 0.50, "quartOut");
	
	elseif name == 'StartCountdown' and executedAmm == 4 then
	setProperty('go.alpha', 1);
	executedAmm = 0;
	addLuaSprite('go', true);
	doTweenAlpha('noGo', 'go', 0, 0.50, "quartOut");
	end
end
	  