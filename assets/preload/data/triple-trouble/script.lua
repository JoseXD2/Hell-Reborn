function onCreate()
    local font = "arial.TTF"
    local size = {"150", "50"} -- o primeiro valor é o size text da musica, e o segundo o credito / the first value is the song`s size text, the second one is the credits

    local song = songName
    local credit = "Finch, Madhayter." -- mude isso para max funny / change here the credits

    makeLuaText('song',song,screenWidth,0,screenHeight/2.4);
    setTextSize('song', size[1]);
    setTextAlignment('song','center');
    setObjectCamera('song', 'other')
    setTextFont("song", font)
    addLuaText('song');

    makeLuaText('credit',credit,screenWidth,0,screenHeight/1.7);
    setTextSize('credit', size[2]);
    setTextAlignment('credit','center');
    setObjectCamera('credit', 'other')
    setTextFont("credit", font)
    addLuaText('credit');

    makeLuaSprite('bartop','',-200,-100)
    makeGraphic('bartop',2000,100,'000000')
    addLuaSprite('bartop',false)
    setScrollFactor('bartop',0,0)
    setObjectCamera('bartop','hud')
    
    makeLuaSprite('barbot','',-200, 720)
    makeGraphic('barbot',2000,100,'000000')
    addLuaSprite('barbot',false)
    setScrollFactor('barbot',0,0)
    setObjectCamera('barbot','hud')
    
    doTweenAlpha('aqui meu discord se vc quiser q eu programe pro seu mod', 'song', 0, 0.001, 'linear')
    doTweenAlpha('L`Étranger#9279', 'credit', 0, 0.001, 'linear')
end

local ceninha 

function onUpdate()
    if ceninha then
        doTweenY("bartop", "bartop", -30, 5, "circOut")
        doTweenY("barbot", "barbot", 650, 5, "circOut")

        for i= 0,7 do
            noteTweenAlpha('nota'.. i, i, 0, 0.2, "linear")
        end

        doTweenAlpha("cringe", "healthBar", 0, 0.2, "linear")
        doTweenAlpha("cringe2", "healthBarBG", 0, 0.2, "linear")
        doTweenAlpha("cringe3", "iconP1", 0, 0.2, "linear")
        doTweenAlpha("cringe4", "iconP2", 0, 0.2, "linear")
        doTweenAlpha("cringe5", "scoreTxt", 0, 0.2, "linear")
        setProperty("timeBarBG.visible", false)
        setProperty("timeBar.visible", false)
        setProperty("timeTxt.visible", false)
    end

    if ceninha == false then
        doTweenY("bartop", "bartop", -100, 5, "circOut")
        doTweenY("barbot", "barbot", 720, 5, "circOut")

        for i= 0,7 do
            noteTweenAlpha('nota'.. i, i, 1, 0.2, "linear")
        end

        doTweenAlpha("cringe", "healthBar", 1, 0.2, "linear")
        doTweenAlpha("cringe2", "healthBarBG", 1, 0.2, "linear")
        doTweenAlpha("cringe3", "iconP1", 1, 0.2, "linear")
        doTweenAlpha("cringe4", "iconP2", 1, 0.2, "linear")
        doTweenAlpha("cringe5", "scoreTxt", 1, 0.2, "linear")
        setProperty("timeBarBG.visible", true)
        setProperty("timeBar.visible", true)
        setProperty("timeTxt.visible", true)
    end
end

function onSongStart()
    runTimer("ave2", 4.4) -- mude isso de acordo com a duração da musica / adjust to your song time
    runTimer("ave", 0.4)

    ceninha = true

    doTweenAlpha('aqui meu discord se vc quiser q eu programe pro seu mod', 'song', 1, 0.4, 'linear')
end

function onTimerCompleted(tag, loop, loopsLeft)
    if tag == "ave" then
        doTweenAlpha('L`Étranger#9279', 'credit', 1, 0.4, 'linear')
    end

    if tag == "ave2" then
        doTweenAlpha('aqui meu discord se vc quiser q eu programe pro seu mod', 'song', 0, 0.4, 'linear')
        doTweenAlpha('L`Étranger#9279', 'credit', 0, 0.4, 'linear')

        
        setProperty("timeBarBG.visible", true)
        setProperty("timeBar.visible", true)
        setProperty("timeTxt.visible", true)

        ceninha = false
    end
end
