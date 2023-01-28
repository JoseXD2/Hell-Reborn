--script made by ms funky and time shit is made(stolen) by kevin kuntz
function onCreatePost()
    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
    setProperty('scoreTxt.visible', false)
    setProperty('timeBar.visible', false)
    setProperty('timeBarBG.visible', false)
    setProperty('timeTxt.visible', false)

    quickLuaText('score', 'SCORE', 0, 20, 520, 60, 'sonic2.ttf')
    setTextColor('score', 'fcfc00')
    quickLuaText('scoreColon', ':', 0, getProperty('score.x') + 160, getProperty('score.y'), 60, 'sonic2.ttf')
    quickLuaText('score2', '', 0, getProperty('score.x') + 200, getProperty('score.y'), 60, 'sonic2.ttf')

    setObjectOrder('score', 1)
    setObjectOrder('scoreColon', 2)
    setObjectOrder('score2', 3)

    setObjectCamera('score', 'other')
    setObjectCamera('scoreColon', 'other')
    setObjectCamera('score2', 'other')

    quickLuaText('time', 'TIME', 0, 20, getProperty('score.y') + 50, 60, 'sonic2.ttf')
    setTextColor('time', 'fcfc00')
    quickLuaText('timeColon', ':', 0, getProperty('score.x') + 160, getProperty('score.y') + 50, 60, 'sonic2.ttf')
    quickLuaText('time2', '00:00', 0, getProperty('score.x') + 200, getProperty('score.y') + 50, 60, 'sonic2.ttf')

    setObjectOrder('time', 4)
    setObjectOrder('timeColon', 5)
    setObjectOrder('time2', 6)

    setObjectCamera('time', 'other')
    setObjectCamera('timeColon', 'other')
    setObjectCamera('time2', 'other')

    quickLuaText('combo', 'COMBO', 0, 20, getProperty('time.y') + 50, 60, 'sonic2.ttf')
    setTextColor('combo', 'fcfc00')
    quickLuaText('comboColon', ':', 0, getProperty('score.x') + 160, getProperty('time.y') + 50, 60, 'sonic2.ttf')
    quickLuaText('combo2', '', 0, getProperty('score.x') + 200, getProperty('time.y') + 50, 60, 'sonic2.ttf')

    setObjectOrder('combo', 7)
    setObjectOrder('comboColon', 8)
    setObjectOrder('combo2', 9)

    setObjectCamera('combo', 'other')
    setObjectCamera('comboColon', 'other')
    setObjectCamera('combo2', 'other')
end

function onUpdate()
    setTextString('score2', getProperty('songScore'))

    setTextString('combo2', getProperty('combo'))

    if curStep > 0 then
        setTextString('time2', milliToHuman(math.floor(getPropertyFromClass('Conductor', 'songPosition') - noteOffset)))
    end
end

function quickLuaSprite(tag, image, x, y)
    makeLuaSprite(tag, image, x, y);
	addLuaSprite(tag);
end

function quickLuaText(tag, text, width, x, y, size, font)
    makeLuaText(tag, text, width, x, y);
    setTextSize(tag, size)
    setTextFont(tag, font)
	addLuaText(tag);
end

function milliToHuman(milliseconds) -- https://forums.mudlet.org/viewtopic.php?t=3258
	local totalseconds = math.floor(milliseconds / 1000)
	local seconds = totalseconds % 60
	local minutes = math.floor(totalseconds / 60)
	minutes = minutes % 60
	return string.format("%02d:%02d", minutes, seconds)  
end