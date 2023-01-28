function onCreatePost()
   	setPropertyFromClass('GameOverSubstate', 'deathSoundName', '');
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', '');
   	setPropertyFromClass('GameOverSubstate', 'endSoundName', '');
end

function onGameOverStart()
	startVideo('Game over BF Variation 1')
end

function onStartCountdown()
	if inGameOver then
		restartSong(true)
		return Function_Stop;
	end
	return Function_Continue;
end