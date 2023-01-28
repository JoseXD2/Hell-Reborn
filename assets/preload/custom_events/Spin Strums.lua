-- Event notes hooks
function onEvent(name, value1, value2)
	if name == "Spin Strums" then
		noteTweenAngle('opp1', 0, 360, value1, 'circIn');
		noteTweenAngle('opp2', 1, 360, value1, 'circIn');
		noteTweenAngle('opp3', 2, 360, value1, 'circIn');
		noteTweenAngle('opp4', 3, 360, value1, 'circIn');
		noteTweenAngle('plr1', 4, 360, value1, 'circIn');
		noteTweenAngle('plr2', 5, 360, value1, 'circIn');
		noteTweenAngle('plr3', 6, 360, value1, 'circIn');
		noteTweenAngle('plr4', 7, 360, value1, 'circIn');
	end
end