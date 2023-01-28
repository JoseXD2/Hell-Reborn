function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
	    if  getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'flashbang' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'flashbang');
			setPropertyFromGroup('unspawnNotes', i, 'noteSplashDisabled', true);

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') == true then
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			else
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true);
			end
		end
	end
end

function goodNoteHit(id, noteData, noteType, isSustainNote)
	if noteType == 'flashbang' then
		cameraFlash('game', '0xFFFFFF', 5, true)
		playSound('flashbang', 55)
	end
end