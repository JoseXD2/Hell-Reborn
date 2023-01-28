function onCreate()
	-- background shit
    makeAnimatedLuaSprite('Sky', 'YCR/staticBACKGROUND2', -2400, -10);
    makeLuaSprite('Sky2', 'YCR/Sky', -1800, -10);
    makeLuaSprite('FarBack', 'YCR/Further Back Trees', -1800, -10);
    makeLuaSprite('Back', 'YCR/Back Trees', -1800, -10);
    makeLuaSprite('Floor', 'YCR/Grass And Trees', -1800, -10);
    makeLuaSprite('bushes', 'YCR/Front Bushes', -2300, -10);
    luaSpritePlayAnimation('Sky', 'static');
    luaSpriteAddAnimationByPrefix('Sky', 'static', 'menuSTATICNEW instance ', 24, true);

    makeLuaSprite('Sunset Floor', 'YCR/Sunset Hill Floor', -2300, -700);
    makeLuaSprite('Sunset Back', 'YCR/Sunset Hill Back', -3000, -2600);
    setProperty('Sunset Floor.visible', false);
    setProperty('Sunset Back.visible', false);

    makeLuaSprite('Hill Floor', 'YCR/Green Hill Floor', -2300, -1850);
    makeLuaSprite('Hill Back', 'YCR/Green Hill Back', -3000, -4000);
    setProperty('Hill Floor.visible', false);
    setProperty('Hill Back.visible', false);
    makeLuaSprite('Angel', 'YCR/Angel Island', -1500, -650);
    setProperty('Angel.visible', false);

    makeLuaSprite('black vig', 'blackvignette', 0, 0);
    setObjectCamera('black vig', 'hud')
    screenCenter('black vig', 'X')


    addLuaSprite('Sky2', false);
    addLuaSprite('FarBack', false);
    addLuaSprite('Sky', false);
    addLuaSprite('FarBack', false);
    addLuaSprite('Back', false);
    addLuaSprite('Floor', false);
    addLuaSprite('bushes', true);
    addLuaSprite('Sunset Back', false);
    addLuaSprite('Sunset Floor', false);
    addLuaSprite('Hill Back', false);
    addLuaSprite('Hill Floor', false);
    addLuaSprite('Angel', false);
    addLuaSprite('black vig', false);
    scaleObject('Back', 2, 2);
    scaleObject('Floor', 2, 2);
    scaleObject('bushes', 2, 2);
    scaleObject('Sky', 4, 4);
    scaleObject('Angel', 1.7, 1.7);
    scaleObject('FarBack', 2, 2);
    scaleObject('Sunset Floor', 2.5, 2.5);
    scaleObject('Sunset Back', 4, 4);
	scaleObject('Hill Floor', 2.5, 2.5);
    scaleObject('Hill Back', 4, 4);
end

function onEvent(name,value1,value2)
    if name == 'Spawn' then
        
        if value1 == 'Pixel 1' then
            setProperty('Sunset Floor.visible', true);
            setProperty('Sunset Back.visible', true);
            setProperty('bushes.visible', false);
        end
        if value1 == 'Pixel 2' then
            setProperty('Hill Floor.visible', true);
            setProperty('Hill Back.visible', true);
        end
        if value1 == 'Pixel 3' then
            setProperty('Angel.visible', true);
        end
        if value1 == 'Normal' then
            setProperty('Sunset Floor.visible', false);
            setProperty('Hill Floor.visible', false);
            setProperty('Hill Back.visible', false);
            setProperty('Sunset Back.visible', false);
            setProperty('Angel.visible', false);
            setProperty('bushes.visible', true);
        end
    end
end