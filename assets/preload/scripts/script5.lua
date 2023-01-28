-- cam follow script by stilic
-- please credit me if you use it
-- VARIABLES THAT YOU CAN CHANGE YOUSELF
camFollowOffset = 25
camFollowMovement = {gf = true, dad = true, bf = true}

-- INTERNAL STUFF
local lastMustHit

local function nativeFollow(IsDad)
    if getProperty('gf.active') ~= 'gf.active' and gfSection then
        local camPos, camOffset = getProperty('gf.cameraPosition'),
                                  getProperty('girlfriendCameraOffset')
        setProperty('camFollow.x', getMidpointX('gf') + camPos[1] + camOffset[1])
        setProperty('camFollow.y', getMidpointY('gf') + camPos[2] + camOffset[2])
    else
        runHaxeCode('PlayState.instance.moveCamera(' .. tostring(IsDad) .. ');')
    end
end

local function follow(isDad, dir)
    if (gfSection and not camFollowMovement.gf) or
        (isDad and not camFollowMovement.dad) or
        (not isDad and not camFollowMovement.bf) then return end

    nativeFollow(isDad)

    local x, y = getProperty('camFollow.x'), getProperty('camFollow.y')
    if dir == 0 then
        triggerEvent('Camera Follow Pos', x - camFollowOffset, y)
    elseif dir == 3 then
        triggerEvent('Camera Follow Pos', x + camFollowOffset, y)
    elseif dir == 2 then
        triggerEvent('Camera Follow Pos', x, y - camFollowOffset)
    elseif dir == 1 then
        triggerEvent('Camera Follow Pos', x, y + camFollowOffset)
    end
end

function onCreatePost() lastMustHit = mustHitSection end

function onSectionHit()
    if lastMustHit ~= mustHitSection then
        lastMustHit = mustHitSection
        if camFollowMovement.gf or camFollowMovement.dad or camFollowMovement.bf then
            triggerEvent('Camera Follow Pos', '', '')
            nativeFollow(not mustHitSection)
        end
    end
end

function goodNoteHit(id, direction, noteType, isSustainNote)
    if mustHitSection then follow(false, direction) end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
    if not mustHitSection then follow(true, direction) end
end
