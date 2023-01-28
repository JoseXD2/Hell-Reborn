function onCreate()
	--Iterate over all notes
	makeAnimatedLuaSprite('glitchload','hitStatic',-250,-150)
	addAnimationByPrefix('glitchload','staticanim','staticANIMATION',24,true)
	objectPlayAnimation('glitchload','staticanim',false)
	setScrollFactor('glitchload', 0, 0);
	scaleObject('glitchload', 1.25, 1.25);
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is an Instakill Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'staticNote' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'staticNotes'); --Change texture
			setPropertyFromGroup('unspawnNotes', i, 'hitHealth', '0'); --Default value is: health gained on hit
			setPropertyFromGroup('unspawnNotes', i, 'missHealth', '0.35'); --Default value is: health lost on miss
			setPropertyFromGroup('unspawnNotes', i, 'hitCausesMiss', false);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', false); --Miss has no penalties
			end
		end
	end
	--debugPrint('Script started!')
end