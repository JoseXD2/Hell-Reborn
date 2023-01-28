function onCreate()
	-- background shit
    makeLuaSprite('Sky', 'Angel Island/Sky', -1800, -10);
    makeLuaSprite('FarBack', 'Angel Island/Further Back Trees', -1800, -10);
	makeLuaSprite('Back', 'Angel Island/Back Trees', -1800, -10);
	makeLuaSprite('Floor', 'Angel Island/Grass And Trees', -1800, -10);
	makeLuaSprite('bushes', 'Angel Island/Front Bushes', -1800, -10);
    makeLuaSprite('ASky', 'Angel Island/Alive Sky', -1800, -10);
    makeLuaSprite('AFarBack', 'Angel Island/Alive FBT', -1800, -10);
    makeLuaSprite('ABack', 'Angel Island/Alive BT', -1800, -10);
    makeLuaSprite('AFloor', 'Angel Island/Alive GAT', -1800, -10);
    makeLuaSprite('Abushes', 'Angel Island/Alive FB', -1800, -10);

    addLuaSprite('Sky', false);
    addLuaSprite('FarBack', false);
    addLuaSprite('Back', false);
    addLuaSprite('Floor', false);
    addLuaSprite('bushes', true);
    addLuaSprite('ASky', false);
    addLuaSprite('AFarBack', false);
    addLuaSprite('ABack', false);
    addLuaSprite('AFloor', false);
    addLuaSprite('Abushes', true);
    scaleObject('Back', 2, 2);
    scaleObject('Floor', 2, 2);
    scaleObject('bushes', 2, 2);
    scaleObject('Sky', 2, 2);
    scaleObject('FarBack', 2, 2);
    scaleObject('ABack', 2, 2);
    scaleObject('AFloor', 2, 2);
    scaleObject('Abushes', 2, 2);
    scaleObject('ASky', 2, 2);
    scaleObject('AFarBack', 2, 2);
end

function onEvent(name,value1,value2)
    if name == 'Spawn' then
        if value1 == 'dead' then
            setProperty('ABack.visible', false);
            setProperty('AFloor.visible', false);
            setProperty('ABushes.visible', false);
            setProperty('AFarBack.visible', false);
            setProperty('ASky.visible', false);
        end
        if value1 == 'alive' then
            setProperty('ABack.visible', true);
            setProperty('AFloor.visible', true);
            setProperty('ABushes.visible', true);
            setProperty('AFarBack.visible', true);
            setProperty('ASky.visible', true);
        end
    end
end