

function onCreate()
    local toughness = checkDifficulty()

    makeLuaSprite('bgThing', 'songBG', -500, 250)
    scaleObject('bgThing', 0.35, 0.43)
    setObjectCamera('bgThing', 'hud')
    addLuaSprite('bgThing', true)
    setScrollFactor('bgThing', 0, 0)
    setProperty('bgThing.alpha', tonumber(0.7))


    makeLuaText('songText', "".. songName.." - ".. toughness, 400, getProperty('bgThing.x') + 180, 320)
    setObjectCamera("songText", 'hud');
    setTextColor('songText', '0xffffff')
    setTextSize('songText', 30);
    addLuaText("songText");
    setTextFont('songText', "vcr.ttf")
    setTextAlignment('songText', 'left')
    

    makeLuaText('beforeSongText', "Song by Wrath!", 300, getProperty('bgThing.x') + 100 - 40, 260)
    setObjectCamera("beforeSongText", 'hud');
    setTextColor('beforeSongText', '0xffffff')
    setTextSize('beforeSongText', 25);
    addLuaText("beforeSongText");
    setTextFont('beforeSongText', "vcr.ttf")
    setTextAlignment('beforeSongText', 'left')


    setObjectOrder('beforeSongText', 3)
    setObjectOrder('songText', 3)
    setObjectOrder('bgThing', 2)

    setProperty('healthBar.alpha', tonumber(0))
    setProperty('iconP1.alpha', tonumber(0))
    setProperty('iconP2.alpha', tonumber(0))
end

function onCreatePost()
    doTweenX('bgThingMoveIn', 'bgThing', -50, 0.6, 'linear')
    doTweenX('bgThingText', 'songText', 70, 0.6, 'linear')  -- might need to mess with these for longer names
    doTweenX('bgThingTextBleb', 'beforeSongText', 20, 0.6, 'linear')  -- might need to mess with these for longer names
    runTimer('moveOut', 3.7, 1)
end

local allowCountdown = false
function onStartCountdown()
    -- Block the first countdown and start a timer of 0.8 seconds to play the dialogue
    if not allowCountdown and isStoryMode and not seenCutscene then
        setProperty('inCutscene', true);
        runTimer('startDialogue', 0.8);
        allowCountdown = true;
        return Function_Stop;
    end
    return Function_Continue;
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'startDialogue' then -- Timer completed, play dialogue
        startDialogue('dialogue', 'breakfast');
    end
    if tag == 'moveOut' then
        doTweenX('bgThingLeave', 'bgThing', -700, 0.6, 'linear')
        doTweenX('bgThingLeaveText', 'songText', -500, 0.6, 'linear')  -- might need to mess with these for longer names
        doTweenX('bgThingLeavePreText', 'beforeSongText', -400, 0.6, 'linear') -- might need to mess with these for longer names
    end
end

-- Dialogue (When a dialogue is finished, it calls startCountdown again)
function onNextDialogue(count)
    -- triggered when the next dialogue line starts, 'line' starts with 1
end

function onSkipDialogue(count)
    -- triggered when you press Enter and skip a dialogue line that was still being typed, dialogue line starts with 1
end

function onTweenCompleted(tag)
    if tag == 'bgThingLeave' then
        removeLuaSprite('bgThing', true)
        removeLuaText('songText', true)
        removeLuaText('beforeSongText', true)
    end
end

function checkDifficulty()
    -- not needed really, but cool
    if difficulty == 2 then
        return 'HARD';
    elseif difficulty == 1 then
        return 'NORMAL';
    else
        return 'EASY';
    end
end
