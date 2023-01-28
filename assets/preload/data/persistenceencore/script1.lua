local timeStuff = {
    timeA = 0,
    timeB = 0
}

local startTime = false
local oldTxtX
local oldTxtY
function onCreatePost()
    oldTxtX = getProperty('timeTxt.x')
    oldTxtY = getProperty('timeTxt.y')
end
function onSongStart() startTime = true end
 
local function lerp(a, b, ratio)
    return a + ratio * (b - a)
end
local function boundTo(value, min, max)
    return math.max(min, math.min(max, value));
end

function onUpdatePost(elapsed)
    if startTime then
        if getPropertyFromClass('Conductor', 'songPosition') > 46500  then
            timeStuff.timeA = lerp(timeStuff.timeA, (getPropertyFromClass('Conductor', 'songPosition') - (timeBarType == 'Time Elapsed' and 46500 or 0))/1000, elapsed*2)
        else
            timeStuff.timeA = timeBarType == 'Time Elapsed' and getPropertyFromClass('Conductor', 'songPosition')/1000 or (getPropertyFromClass('Conductor', 'songPosition')+(songLength-46500))/1000 
        end
        if timeBarType == 'Song Name' then
            timeStuff.timeB = 'Song: '..songName..' - '..difficultyName
        else
            if timeBarType == 'Time Elapsed' then
                timeStuff.timeB = 'Time: '.. formatTime(math.floor(timeStuff.timeA))
            else
                timeStuff.timeB = 'Time: '.. formatTime(math.floor((songLength-(timeStuff.timeA*1000))/1000))
            end
            if getPropertyFromClass('Conductor', 'songPosition') >= 46000 and getPropertyFromClass('Conductor', 'songPosition') < 49000 then
                setProperty('timeTxt.x', lerp(getProperty('timeTxt.x'), (screenWidth/2-getProperty('timeTxt.width')/2), elapsed*2))
                setProperty('timeTxt.y', lerp(getProperty('timeTxt.y'), (screenHeight/2-getProperty('timeTxt.height')/2), elapsed*2))
                setProperty('timeTxt.size', lerp(getProperty('timeTxt.size'), 100, elapsed*2))
            else
                setProperty('timeTxt.x', lerp(getProperty('timeTxt.x'), oldTxtX, elapsed*2))
                setProperty('timeTxt.y', lerp(getProperty('timeTxt.y'), oldTxtY, elapsed*2))
                setProperty('timeTxt.size', lerp(getProperty('timeTxt.size'), 40, elapsed*2))
            end
        end
        setProperty('timeTxt.text', timeStuff.timeB)
    end
end

function formatTime(seconds)
    seconds = math.floor(seconds)
    local minutes = math.floor(seconds / 60)
    local secondsString = tostring(seconds%60)
    if #secondsString < 2 then secondsString = '0'..secondsString end
    return string.format('%d:%s', minutes, secondsString)
end
