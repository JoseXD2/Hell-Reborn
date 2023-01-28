

function onGameOver()
    setProperty('health', -500);
    math.randomseed(os.clock()/4.0)
    local num = math.random(1,4)
    local name = tostring(num)
    playSound(name, 1, 'deathquote')
end