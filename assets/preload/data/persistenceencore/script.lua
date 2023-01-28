
function opponentNoteHit()
    cameraShake('game', 0.01, 0.05);
    if mustHitSection == false then
        health = getProperty('health')
        if getProperty('health') > 0.21 then
            --setProperty('health', health- 0.02);
        end
    end
end

