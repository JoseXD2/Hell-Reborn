--i said i wouldnt use lua but i forgot how to make this shit in haxe lmao
local angleshit = 2;
local anglevar = 2;
function onEvent(name, value1, value2)
    function onUpdate()
        songPos = getSongPosition()
          local currentBeat = (songPos/1000)*(bpm/200)

        currentBeat = (songPos / 1000) * (bpm / 140)
        if value1 == "on" then
            doTweenAngle('healthtilt', 'healthBar', 5, 1, linear)
            doTweenAngle('icon1tilt', 'iconP1', 5, 1, linear)
            doTweenAngle('icon2tilt', 'iconP2', 5, 1, linear)
            if getProperty('health') == 0.1 then
                doTweenY('iconP1y', 'iconP1', 1580, 1, circInOut)
                doTweenY('iconP2y', 'iconP2', 770, 1, circInOut)
            elseif getProperty('health') == 0.2 then
                doTweenY('iconP1y2', 'iconP1', 1480, 1, circInOut)
                doTweenY('iconP2y2', 'iconP2', 760, 1, circInOut)
            elseif getProperty('health') == 0.3 then
                doTweenY('iconP1y3', 'iconP1', 1380, 1, circInOut)
                doTweenY('iconP2y3', 'iconP2', 750, 1, circInOut)
            elseif getProperty('health') == 0.4 then
                doTweenY('iconP1y4', 'iconP1', 1280, 1, circInOut)
                doTweenY('iconP2y4', 'iconP2', 740, 1, circInOut)
            elseif getProperty('health') == 0.5 then
                doTweenY('iconP1y5', 'iconP1', 1180, 1, circInOut)
                doTweenY('iconP2y5', 'iconP2', 730, 1, circInOut)
            elseif getProperty('health') == 0.6 then
                doTweenY('iconP1y6', 'iconP1', 1080, 1, circInOut)
                doTweenY('iconP2y6', 'iconP2', 720, 1, circInOut)
            elseif getProperty('health') == 0.7 then
                doTweenY('iconP1y7', 'iconP1', 980, 1, circInOut)
                doTweenY('iconP2y7', 'iconP2', 710, 1, circInOut)
            elseif getProperty('health') == 0.8 then
                doTweenY('iconP1y8', 'iconP1', 880, 1, circInOut)
                doTweenY('iconP2y8', 'iconP2', 700, 1, circInOut)
            elseif getProperty('health') == 0.9 then
                doTweenY('iconP1y9', 'iconP1', 780, 1, circInOut)
                doTweenY('iconP2y9', 'iconP2', 690, 1, circInOut)
            elseif getProperty('health') == 1 then
                doTweenY('iconP1y10', 'iconP1', 680, 1, circInOut)
                doTweenY('iconP2y10', 'iconP2', 670, 1, circInOut)
            elseif getProperty('health') == 1.1 then
                doTweenY('iconP1y11', 'iconP1', 670, 1, circInOut)
                doTweenY('iconP2y11', 'iconP2', 660, 1, circInOut)
            elseif getProperty('health') == 1.2 then
                doTweenY('iconP1y12', 'iconP1', 660, 1, circInOut)
                doTweenY('iconP2y12', 'iconP2', 650, 1, circInOut)
            elseif getProperty('health') == 1.3 then
                doTweenY('iconP1y13', 'iconP1', 650, 1, circInOut)
                doTweenY('iconP2y13', 'iconP2', 640, 1, circInOut)
            elseif getProperty('health') == 1.4 then
                doTweenY('iconP1y14', 'iconP1', 640, 1, circInOut)
                doTweenY('iconP2y14', 'iconP2', 630, 1, circInOut)
            elseif getProperty('health') == 1.5 then
                doTweenY('iconP1y15', 'iconP1', 630, 1, circInOut)
                doTweenY('iconP2y15', 'iconP2', 620, 1, circInOut)
            elseif getProperty('health') == 1.6 then
                doTweenY('iconP1y16', 'iconP1', 620, 1, circInOut)
                doTweenY('iconP2y16', 'iconP2', 610, 1, circInOut)
            elseif getProperty('health') == 1.7 then
                doTweenY('iconP1y17', 'iconP1', 610, 1, circInOut)
                doTweenY('iconP2y17', 'iconP2', 600, 1, circInOut)
            elseif getProperty('health') == 1.8 then
                doTweenY('iconP1y18', 'iconP1', 600, 1, circInOut)
                doTweenY('iconP2y18', 'iconP2', 590, 1, circInOut)
            elseif getProperty('health') == 1.9 then
                doTweenY('iconP1y19', 'iconP1', 590, 1, circInOut)
                doTweenY('iconP2y19', 'iconP2', 580, 1, circInOut)
            elseif getProperty('health') == 2 then
                doTweenY('iconP1y20', 'iconP1', 580, 1, circInOut)
                doTweenY('iconP2y20', 'iconP2', 570, 1, circInOut)
            end
            setProperty('health', getProperty('health') - value2 / 100)
        end
        if value1 == "off" then
            doTweenAngle('healthtilt', 'healthBar', 0, 1, linear)
            doTweenAngle('icon1tilt', 'iconP1', 0, 1, linear)
            doTweenAngle('icon2tilt', 'iconP2', 0, 1, linear)
            doTweenY('iconP1y', 'iconP1', 570, 1, circInOut)
            doTweenY('iconP2y', 'iconP2', 570, 1, circInOut)
        end
    end
end