function onCreate()
	--Iterate over all notes
	for i = 0, getProperty('unspawnNotes.length')-1 do
		--Check if the note is a Husk Note
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Husk Note' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'HUSKNOTE_assets'); --Change texture

			if getPropertyFromGroup('unspawnNotes', i, 'mustPress') then --Doesn't let Dad/Opponent notes get ignored
				setPropertyFromGroup('unspawnNotes', i, 'ignoreNote', true); --Miss has no penalties
			end
		end
	end
	--debugPrint('Script started!')
end

local poisonStacks = 0;
local poisonDuration = 0;
function goodNoteHit(id, direction, noteType, isSustainNote)
	if noteType == 'Husk Note' then
		if direction == 0 then
			poisonDuration = 9;
			poisonStacks = poisonStacks + 0.05;
		end
		if direction == 1 then
			poisonDuration = 11;
			poisonStacks = poisonStacks + 0.12;
		end
		if direction == 2 then
			poisonDuration = 13;
			poisonStacks = poisonStacks + 0.22;
		end
		if direction == 3 then
			poisonDuration = 25;
			poisonStacks = poisonStacks + 0.35;
		end
	end
end

function onStepHit()
	if poisonDuration ~= 0 then
		poisonStacks = poisonStacks - 0.03;
		poisonDuration = poisonDuration - 1;
		setProperty('health', getProperty('health') - poisonStacks);
	end
end