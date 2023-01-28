function onEvent(name, value1, value2)
  if name == 'gay' then
    local angleshit = 2;
    local anglevar = 2;

    function onBeatHit()
        if curBeat % 2 == 0 then
            angleshit = anglevar;
        else
            angleshit = -anglevar;
        end
           setProperty('camHUD.angle',angleshit*3)
           setProperty('camGame.angle',angleshit*3)
           doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0.002, 'circOut')
           doTweenX('tuin', 'camHUD', -angleshit*8, crochet*0.001, 'linear')
           doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0.002, 'circOut')
           doTweenX('ttrn', 'camGame', -angleshit*8, crochet*0.001, 'linear')
           runTimer('wait', value2);
        end
    end
end

function onTimerCompleted(tag, loops, loopsleft)
    setProperty('camHUD.angle',angleshit*0)
    setProperty('camGame.angle',angleshit*0)
    doTweenAngle('turn', 'camHUD', angleshit, stepCrochet*0., 'circOut')
    doTweenX('tuin', 'camHUD', -angleshit*0, crochet*0, 'linear')
    doTweenAngle('tt', 'camGame', angleshit, stepCrochet*0, 'circOut')
    doTweenX('ttrn', 'camGame', -angleshit*0, crochet*0, 'linear')
end