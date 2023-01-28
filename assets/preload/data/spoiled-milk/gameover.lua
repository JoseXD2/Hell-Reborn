function onCreate()
	setPropertyFromClass('GameOverSubstate', 'characterName', 'sunk'); --Character json file for the death animation
	setPropertyFromClass('GameOverSubstate', 'loopSoundName', 'uronblast'); --put in mods/music/
	setPropertyFromClass('GameOverSubstate', 'endSoundName', 'gameOverEnd'); --put in mods/music/
end