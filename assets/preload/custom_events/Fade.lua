   function mysplit (inputstr, sep)
    if sep == nil then
        sep = "%s";
    end
    local t={};
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str);
    end
    return t;
end



function onEvent(name, v1, v2)
-- test stuff 





    if name == 'Fade' then
        local tableee=mysplit(v1,", "); -- Splits value1 into a table
        v1 = tonumber(v1)

        local tableee2=mysplit(v2,", "); -- Splits value1 into a table
        v2 = tonumber(v2)

        if tableee[1] == 'test' then
            
        end


        if tableee[1] == 'myhex' then
            Soup = tableee[3]
        end

        if tableee[1] == 'random' then
          Soup  = getRandomInt(000000, 999999) -- might give a color that doesn't exist (aka not visible)
        end

        if tableee[1] == 'none' then
            Soup = 'Why would you even use this if its none?'
        end

        if tableee[1] == nil then
           Soup = '000000'
        end

        if tableee[1] == 'black' then
            Soup = '000000'
        end
    
        if tableee[1] == 'white' then
            Soup = 'ffffff'
        end
    
        if tableee[1] == 'red' then
            Soup = 'FF0000'
        end
    
        if tableee[1] == 'green' then
            Soup = '008000'
        end
    
        if tableee[1] == 'yellow' then
            Soup = 'ffff00'
        end
    
        if tableee[1] == 'purple' then
            Soup = '8102ea'
        end
    
        if tableee[1] == 'orange' then
            Soup = 'ffa500'
        end

        if tableee[1] == 'blue' then
            flash = '0000ff'
            flush = true
        end




-- table 2 fades from a color to another ex: red to black

if tableee[2] == 'random' then
    flash  = getRandomInt(000000, 999999) -- might give a color that doesn't exist (aka not visible)
    flush = true
  end

  if tableee[2] == 'myhex' then
   if Soup == tableee[3] then
    flash = tableee[4]
   
else
    flash = tableee[3]
end
    flush = true
end

        if tableee[2] == 'black' then
            flash = '000000'
            flush = true
        end
    
        if tableee[2] == 'white' then
            flash = 'ffffff'
            flush = true
        end
    
        if tableee[2] == 'red' then
            flash = 'FF0000'
            flush = true
        end
    
        if tableee[2] == 'green' then
            flash = '008000'
            flush = true
        end
    
        if tableee[2] == 'yellow' then
            flash = 'ffff00'
            flush = true
        end
    
        if tableee[2] == 'purple' then
            flash = '8102ea'
            flush = true
        end
    
        if tableee[2] == 'orange' then
            flash = 'ffa500'
            flush = true
        end
    
        if tableee[2] == 'blue' then
            flash = '0000ff'
            flush = true
        end
        

        
        pikumiku = 1
        if flush == true then
            makeLuaSprite('beans2', '', -200, -200)
            setObjectCamera('beans2', 'other')
            setScrollFactor('beans2', 0, 0)
            setProperty('beans2.alpha', 0)
            addLuaSprite('beans2',true)
            makeGraphic('beans2', 4000, 4000, flash)
            doTweenAlpha('FadeIN', 'beans2', pikumiku, 1, 'linear');
        end
if tableee2[1] == 'IN' then
    makeLuaSprite('beans', '', -200, -200)
    setObjectCamera('beans', 'other')
    setScrollFactor('beans', 0, 0)
    setProperty('beans.alpha', 0)
    addLuaSprite('beans',true)
    makeGraphic('beans', 4000, 4000, Soup)

    doTweenAlpha('FadeIn', 'beans', pikumiku, 1, 'linear');
end
if tableee2[1] == 'OUT' then
    doTweenAlpha('FadeOut', 'beans', pikumiku-1, 3, 'linear');
       if flush == true then
        doTweenAlpha('FadeOUT', 'beans2', pikumiku-1, 3, 'linear');
       end
   end
   if tableee2[2] == 'COLORED' then
   makeLuaSprite('beans3', '', -200, -200)
   setObjectCamera('beans3', 'other')
   setScrollFactor('beans3', 0, 0)
   addLuaSprite('beans3',true)
   makeGraphic('beans3', 4000, 4000, flash)
   setObjectOrder('beans3', getObjectOrder('beans')-1)
   doTweenAlpha('FadeOUT2', 'beans3', pikumiku-1, 3.2, 'linear');
  end
end
end
