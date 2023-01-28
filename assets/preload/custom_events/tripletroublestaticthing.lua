function onEvent(name, value1, value2)
    if name == 'tripletroublestaticthing' then
            
        makeAnimatedLuaSprite('daP3Static', 'Phase3Static', -144, -82)
        addAnimationByPrefix('daP3Static', 'P3Static', 'Phase3Static instance 1', 24, false)
        objectPlayAnimation('daP3Static', 'P3Static', false)
        scaleObject('daP3Static', 3.8, 3.8);
        setObjectCamera('daP3Static', 'other');
        setProperty('daP3Static.alpha', 0.5)
        addLuaSprite('daP3Static', true);
        runTimer('wait', value2);
        

    end


    function onTimerCompleted(tag, loops, loopsleft)
        if tag == 'wait' then
            doTweenAlpha('no', 'image', 0, 1, 'linear');
        end
    end


    function onTimerCompleted(tag, loops, loopsLeft) --when the imposter is sus
        if tag == 'no' then
            removeLuaSprite('daP3Static', false);
        end    
    
    end
end