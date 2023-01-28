keybind = ''
keyToPressed = { 'V', 'B', 'N' }

function onEvent(tag, v1, v2)
    if tag == 'quick_time_event' then
        dur = 0
        if v1 == '' then
            dur = 3
        else
            dur = tonumber(v1)
        end
        makeQuickTime(dur)
        getRandomKey()
    end
end

function makeQuickTime(duration)
    makeLuaSprite('circle', 'quick', getRandomFloat(500, 600), 300)
    setObjectCamera('circle', 'hud')
    scaleObject('circle', 0.3, 0.3)
    doTweenAlpha('circleA', 'circle', 0.5, 0.2)
    setProperty('circle.alpha', 0)
    addLuaSprite('circle')

    makeLuaSprite('circleToClick', 'circle', getProperty('circle.x') - 50, getProperty('circle.y') - 50)
    setObjectCamera('circleToClick', 'hud')
    doTweenX('circleToClickSX', 'circleToClick.scale', 0.25, duration)
    doTweenY('circleToClickSY', 'circleToClick.scale', 0.25, duration)
    scaleObject('circleToClick', 0.5, 0.5)
    setProperty('circleToClick.alpha', 0)
    doTweenAlpha('circleToClickA', 'circleToClick', 0.5, 0.2)
    addLuaSprite('circleToClick')

    makeLuaText('text', keybind, 0, getProperty('circle.x') + 35, getProperty('circle.y') + 25)
    setObjectOrder('text', getObjectOrder('circle') + 1)
    setObjectCamera('text', 'hud')
    setTextSize('text', 120)
    setProperty('text.alpha', 0)
    doTweenAlpha('textA', 'text', 1, 0.2)
    addLuaText('text')

    makeLuaText('amongus', '', 0, getProperty('circle.x'), getProperty('circle.y') - 45)
    setObjectOrder('amongus', getObjectOrder('circle') + 2)
    setObjectCamera('amongus', 'hud')
    setTextSize('amongus', 30)
    setProperty('amongus.alpha', 0)
    doTweenAlpha('amongusA', 'amongus', 1, 0.2)
    setTextColor('amongus', '22ff00')
    addLuaText('amongus')
end

function getRandomKey()
    funny = getRandomInt(0, #keyToPressed)

    keybind = keyToPressed[funny]

    setTextString('text', keybind)
end

successClick = false

function onTweenCompleted(tag)
    if tag == 'circleToClickSX' and not successClick then
        doTweenAlpha('circleToClickA', 'circleToClick', 0, 0.2)
        doTweenAlpha('textA', 'text', 0, 0.2)
        doTweenAlpha('circleA', 'circle', 0, 0.2)

        circleFailed()
    end

    if tag == 'circleToClickSX' and successClick then
        runTimer('successDies', 0.2)
    end

    if tag == 'circleToClickA' then
        scaleObject('circleToClick', 0.5, 0.5)
    end

    if tag == 'amongusDies' then
        setTextString('amongus', '')
        setProperty('amongus.alpha', 1)
    end
end

function circleFailed()
    setHealth(getHealth() - 0.2)
    setTextString('amongus', 'Failed!')
    setTextColor('amongus', 'ff0011')
    runTimer('amongusDies', 2)
end

function onUpdate()
    if keyboardJustPressed(keybind) and getProperty('circleToClick.scale.x') < 0.3 and getProperty('circleToClick.scale.x') > 0.25 and not botPlay then
        successClick = true
        doTweenAlpha('circleToClickA', 'circleToClick', 0, 0.2)
        doTweenAlpha('textA', 'text', 0, 0.2)
        doTweenAlpha('circleA', 'circle', 0, 0.2)
        setTextString('amongus', 'Completed!')
        runTimer('amongusDies', 2)
    end

    if getProperty('circleToClick.scale.x') < 0.3 and getProperty('circleToClick.scale.x') > 0.25 and not successClick and botPlay then
        successClick = true
        doTweenAlpha('circleToClickA', 'circleToClick', 0, 0.2)
        doTweenAlpha('textA', 'text', 0, 0.2)
        doTweenAlpha('circleA', 'circle', 0, 0.2)
        setTextString('amongus', 'Completed!')
        runTimer('amongusDies', 2)
    end
end

function onTimerCompleted(tag)
    if tag == 'amongusDies' then
        doTweenAlpha('amongusDies', 'amongus', 0, 0.2)
    end

    if tag == 'successDies' then
        successClick = false
    end
end