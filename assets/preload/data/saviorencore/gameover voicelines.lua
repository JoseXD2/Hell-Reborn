function onGameOver()
    setProperty('health', -500);
    math.randomseed(os.clock()/4.0)
    local num = math.random(12,14)
    local name = tostring(num)
    playSound(name, 1, 'deathquote')
end