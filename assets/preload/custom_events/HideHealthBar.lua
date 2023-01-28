function onEvent(name, value1, value2)
    if name == 'HideHealthBar' then
        if value1 == 'true' then
        setProperty('healthBar.alpha', tonumber(0))
        setProperty('iconP1.alpha', tonumber(0))
        setProperty('iconP2.alpha', tonumber(0))
        elseif value1 == 'false' then
        setProperty('healthBar.alpha', tonumber(1))
        setProperty('iconP1.alpha', tonumber(1))
        setProperty('iconP2.alpha', tonumber(1))
            end
        end
    end