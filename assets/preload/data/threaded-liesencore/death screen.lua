function onCreate()
	setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx')
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'gameOver')
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd')
end

function onGameOverStart()
    makeLuaSprite('bg')
    makeGraphic('bg', screenWidth, screenHeight, '000000')
    setObjectCamera('bg', 'game')
    setScrollFactor('bg', 0, 0)
    addLuaSprite('bg', true)

    makeAnimatedLuaSprite('boyfriend_dead', 'characters/Threaded Die')
    screenCenter('boyfriend_dead', 'X')
    setProperty('boyfriend_dead.y', screenHeight-getProperty('boyfriend_dead.height')+150)
    setObjectCamera('boyfriend_dead', 'game')
    setScrollFactor('boyfriend_dead', 0, 0)
    addLuaSprite('boyfriend_dead', true)
    scaleObject('boyfriend_dead', 0.6, 0.6, false)
    
    addAnimationByPrefix('boyfriend_dead', 'sperm_cell', 'Death', 24, false)
    playAnim('boyfriend_dead', 'sperm_cell')

    doTweenX('beeboo', 'boyfriend_dead.scale', 1, 3.8, 'quintInOut')
    doTweenY('beeboo2', 'boyfriend_dead.scale', 1, 3.8, 'quintInOut')
    doTweenY('beeboo3', 'boyfriend_dead', screenHeight-getProperty('boyfriend_dead.height'), 3.8, 'quintInOut')
end

function onGameOverConfirm(t)
    if t then
       playAnim('boyfriend_dead', 'sperm_cell', false, true, 42) 
       doTweenX('beeboo', 'boyfriend_dead.scale', 0.6, 0.4, 'smoothStepInOut')
       doTweenY('beeboo2', 'boyfriend_dead.scale', 0.6, 0.4, 'smoothStepInOut')
       doTweenY('beeboo3', 'boyfriend_dead', screenHeight-getProperty('boyfriend_dead.height')+150, 0.4, 'smoothStepInOut')
    end
end