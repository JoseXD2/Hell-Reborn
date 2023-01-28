local zooming = false
local zoom = 0
function onEvent(name,value1,value2)
    if name == "Set Cam Zoom" then
		local easing = 'sineInOut'
		local easingStart = 0
		local easingEnd = 0
		local duration = 0

		local easings = {'quart','quint','sine','linear','bounce','back','circ','cube','elastic','expo','quad','smoothStep'}

		local textStringStart = 0
		local textStringLast = 0
		textStringStart,textStringLast = string.find(value2,value2)
		if string.find(value2,',',0,true) ~= nil then
			easingStart,easingEnd = string.find(value2,',',textStringStart,true)
			easing = string.sub(value2,easingEnd + 1)
			if string.sub(value2,0,easingStart - 1) ~= string.sub(value2,textStringLast - 1,textStringLast) then
				duration = string.sub(value2,0,easingStart - 1)
			else
				duration = 1 /getProperty('cameraSpeed')
			end
		else
			for easingsLength = 1,#easings do
				if string.find(string.lower(value2),easings[easingsLength],0,true) ~= nil then
					easing = value2
				else
					easing = 'sineInOut'
				end
			end
			if tonumber(value2) == nil then
				duration = 0.8
			else
				duration = tonumber(value2)
			end
		end
		if string.match(value1,'cur') == 'cur' and string.find(value1,',',0,true) ~= nil then
			local comma1 = 0
			local comma2 = 0
			comma1,comma2 = string.find(value1,',',0,true)
			if zoom == 0 then
				zoom = getProperty('defaultCamZoom') + string.sub(value1,comma2 + 1)
			else
				zoom = zoom + string.sub(value1,comma2 + 1)
			end
		else
			zoom = value1
		end
		if value2 ~= '' then
			doTweenZoom('camz','camGame',zoom,duration,easing)
		else
			setProperty('defaultCamZoom',zoom)
		end
		zooming = true
	end
end
function onBeatHit()
	if curBeat % 4 == 0 and getProperty('camZooming') == true and zooming == true then
		setProperty('camGame.zoom',getProperty('camGame.zoom') - 0.015)
	end
end
function onTweenCompleted(name)
	if name == 'camz' then
		setProperty("defaultCamZoom",getProperty('camGame.zoom'))
		zoom = 0
		zooming = false
	end
end