function onEvent(n, v1, v2)
    if n == 'textPopUp' then
        makeLuaText('textPopUp', v1, 0, 0)
        setTextSize('TextPopUp', 20)
        setObjectCamera('textPopUp', 'other')
        screenCenter('textPopUp', 'X')
        setProperty('textPopUp.y', -getProperty('textPopUp.height')-5)
        setTextFont('textPopUp', 'futura.otf')
        setTextColor('textPopUp', v2 or 'ffffff')
        setTextSize('textPopUp', 30)
        addLuaText('textPopUp', true)
        doTweenY('textPopUpTween', 'textPopUp', (screenHeight-getProperty('textPopUp.height'))/2, 0.4, 'elasticOut')
    end
end

function onTweenCompleted(t)
    if t == 'textPopUpTween' then
        doTweenAlpha('textPopUpTweenAlpha', 'textPopUp', 0, 'quintInOut')
    elseif t == 'textPopUpTweenAlpha' then
        removeLuaText('textPopUp')
    end
end