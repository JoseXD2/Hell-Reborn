-- Base Detect
local defaultVert = false
local defaultHori = false
local Vertical = false -- True is downscroll, false is upscroll
local Horizontal = false -- True is middlescroll, false is sidescroll
local updateLabels = false
local chartingMode
local autoSwapHorizontal
function onCreatePost()
	chartingMode = getPropertyFromClass('PlayState', 'chartingMode')
	Vertical = downscroll
	defaultVert = Vertical
	Horizontal = middlescroll
	defaultHori = Horizontal
	if chartingMode then
		updateLabels = true
		-- Label's to see Defaults
		makeLuaText('defaultslabel', "   Default's: " .. (defaultVert and "Downscroll" or "Upscroll") .. " and " .. (defaultHori and "Middlescroll" or "Sidescroll"),x, y, 340);
		setProperty('defaultslabel.pos.x', getProperty('Vert.pos.x'));
		setProperty('defaultslabel.pos.y', getProperty('Vert.pos.y'));
		setTextSize('defaultslabel', 24);
		setProperty('defaultslabel' ..'.borderColor', getColorFromHex('000000'));
		setProperty('defaultslabel' ..'.borderSize', 1.2);
		addLuaText('defaultslabel');
		-- Cool, shitty title
		makeLuaText('titlingthisshit', '    Current Scrolltypes', x, y, 370);
		setProperty('titlingthisshit.pos.x', getProperty('Vert.pos.x'));
		setProperty('titlingthisshit.pos.y', getProperty('Vert.pos.y'));
		setTextSize('titlingthisshit', 34);
		setProperty('titlingthisshit' ..'.borderColor', getColorFromHex('000000'));
		setProperty('titlingthisshit' ..'.borderSize', 1.2);
		addLuaText('titlingthisshit');
		-- Vertical Label
		makeLuaText('Vert', (Vertical and "on" or "off"), x, y, 400);
		setProperty('Vert.scale.x', getProperty('scoreTxt.scale.x'));
		setProperty('Vert.scale.y', getProperty('scoreTxt.scale.y'));
		setTextSize('Vert', 48);
		setProperty('Vert' ..'.borderColor', getColorFromHex('000000'));
		setProperty('Vert' ..'.borderSize', 1.2);
		addLuaText('Vert');
		-- Horizontal Label
		makeLuaText('Hori', (Horizontal and "on" or "off"), x, y, 450);
		setProperty('Hori.pos.x', getProperty('Vert.pos.x'))
		setProperty('Hori.pos.y', getProperty('Vert.pos.y'))
		setProperty('Hori.scale.x', getProperty('scoreTxt.scale.x'))
		setProperty('Hori.scale.y', getProperty('scoreTxt.scale.y'))
		setTextSize('Hori', 48);
		setProperty('Hori' ..'.borderColor', getColorFromHex('000000'));
		setProperty('Hori' ..'.borderSize', 1.2);
		addLuaText('Hori');
		-- Section Label
		makeLuaText('sectionCheck', tostring(sectionCheck), x, y, 500);
		setProperty('sectionCheck.pos.x', getProperty('Hori.pos.x'))
		setProperty('sectionCheck.pos.y', getProperty('Hori.pos.y'))
		setProperty('sectionCheck.scale.x', getProperty('scoreTxt.scale.x'))
		setProperty('sectionCheck.scale.y', getProperty('scoreTxt.scale.y'))
		setTextSize('sectionCheck', 48);
		setProperty('sectionCheck' ..'.borderColor', getColorFromHex('000000'));
		setProperty('sectionCheck' ..'.borderSize', 1.2);
	end
end

function onUpdate()
	if (updateLabels) then
		setProperty('Vert.text', '  Downscroll: ' .. (Vertical and "On" or "Off"))
		setProperty('Hori.text', '  Middlescroll: ' .. (Horizontal and "On" or "Off"))
		setProperty('sectionCheck.text', '  Section: ' .. (gfSection and 'Dancer' or mustHitSection and "Player" or "Opponent"))
	end
	if botPlay then
		if getPropertyFromClass("flixel.FlxG","keys.justPressed.LEFT") then
			triggerEvent('Change Scrolltype', '', 'off')
		elseif getPropertyFromClass("flixel.FlxG", "keys.justPressed.DOWN") then
			triggerEvent('Change Scrolltype', 'on', '')
		elseif getPropertyFromClass("flixel.FlxG", "keys.justPressed.UP") then
			triggerEvent('Change Scrolltype', 'off', '')
		elseif getPropertyFromClass("flixel.FlxG", "keys.justPressed.RIGHT") then
			triggerEvent('Change Scrolltype', '', 'on')
		end
	end
end

function onUpdatePost(elapsed)
	if autoSwapHorizontal == true then
		if mustHitSection == false then
			triggerEvent('Change Scrolltype', '', 'off')
		elseif mustHitSection == true then
			triggerEvent('Change Scrolltype', '', 'on')
		end
	else
		-- Leave Blank
	end
end

function onEvent(name, value1, value2)
	if name == 'Change Scrolltype' then
		-- Vertical Scrolltypes
		if value1 == 'off' or value1 == 'on' then -- Switch to Upscroll
			Vertical = (value1 == "on")
		elseif value1 == 'swap' then -- Swap between Up and Downscroll
			Vertical = not Vertical
		elseif value1 == 'default' then -- Switch Back to Default Scrolltype
			Vertical = defaultVert
		end

		-- Horizontal Scrolltypes
		if value2 == 'off' or value2 == 'on' then -- Switch to Upscroll
			Horizontal = (value2 == "on")
		elseif value2 == 'swap' then -- Swap between Up and Downscroll
			Horizontal = not Horizontal
		elseif value2 == 'default' then -- Switch Back to Default Scrolltype
			Horizontal = defaultHori
		end

		-- Weird Shit but it's cool - Doesn't work properly sadly
		if value2 == 'unfunny' then
			autoSwapHorizontal = true
			if chartingMode then
				addLuaText('sectionCheck');
			end
		elseif value2 == 'funny' then
			autoSwapHorizontal = false
			if chartingMode then
				removeLuaText('sectionCheck', false);
			end
		end



		-- Up and Downscroll
		for i = 0, 7 do
			if downscroll then
				noteTweenDirection('scrollDir' .. i, i, (Vertical and 90 or -90), 1, 'elasticOut')
				-- doTweenY('healthBarMove', 'healthBar', (Vertical and 75 or 650), 0.5, 'elasticIn')
				-- doTweenY('timeBarBGmove', 'timeBar', (Vertical and 688 or 31), 0.5, 'elasticIn')
				setProperty('healthBar.y', (Vertical and 75 or 650))
				setProperty('timeBar.y', (Vertical and 688 or 31))
				setProperty('iconP1.y', getProperty('healthBar.y') - 75)
				setProperty('iconP2.y', getProperty('healthBar.y') - 75)
				setProperty('scoreTxt.y', getProperty('healthBar.y') + 25)
				setProperty('timeTxt.y', getProperty('timeBar.y') - 12)
				if Vertical == false then
					noteTweenY('moveNoteY' .. i, i, 50, 1, 'elasticOut')
				else
					noteTweenY('moveNoteY' .. i, i, 570, 1, 'elasticOut')
				end
			else
				noteTweenDirection('scrollDir' .. i, i, (Vertical and -90 or 90), 1, 'elasticOut')
				if Vertical == false then
					noteTweenY('moveNoteY' .. i, i, 50, 1, 'elasticOut')
				else
					noteTweenY('moveNoteY' .. i, i, 500, 1, 'elasticOut')
				end
			end
		end


		-- Side and Middlescroll
		if Horizontal then
			noteTweenX('moveNoteX0', 0, 92, 0.5, 'elasticIn');
			noteTweenX('moveNoteX1', 1, 204, 0.5, 'elasticIn');
			noteTweenX('moveNoteX2', 2, 956, 0.5, 'elasticIn');
			noteTweenX('moveNoteX3', 3, 1068, 0.5, 'elasticIn');
			
			noteTweenX('moveNoteX4', 4, 416, 0.5, 'elasticIn');
			noteTweenX('moveNoteX5', 5, 528, 0.5, 'elasticIn');
			noteTweenX('moveNoteX6', 6, 640, 0.5, 'elasticIn');
			noteTweenX('moveNoteX7', 7, 752, 0.5, 'elasticIn');
			
			for i = 0, 3 do
				noteTweenAlpha('alphaNote' .. i, i, 0.5, 1, 'elasticIn')
			end
		else
			noteTweenX('moveNoteX0', 0, 92, 0.5, 'elasticIn');
			noteTweenX('moveNoteX1', 1, 204, 0.5, 'elasticIn');
			noteTweenX('moveNoteX2', 2, 316, 0.5, 'elasticIn');
			noteTweenX('moveNoteX3', 3, 428, 0.5, 'elasticIn');
			
			noteTweenX('moveNoteX4', 4, 732, 0.5, 'elasticIn');
			noteTweenX('moveNoteX5', 5, 844, 0.5, 'elasticIn');
			noteTweenX('moveNoteX6', 6, 956, 0.5, 'elasticIn');
			noteTweenX('moveNoteX7', 7, 1068, 0.5, 'elasticIn');
		
			for i = 0, 3 do
				noteTweenAlpha('alphaNote' .. i, i, 1, 1, 'elasticIn')
			end
		end
	end
end

function onEndSong()
	for i = 0,7 do
		cancelTween('scrollDir' .. i)
		cancelTween('moveNoteY' .. i)
		cancelTween('moveNoteX' .. i)
		cancelTween('alphaNote' .. i)
	end
	return Function_Continue
end

function onGameOver()
	for i = 0,7 do
		cancelTween('scrollDir' .. i)
		cancelTween('moveNoteY' .. i)
		cancelTween('moveNoteX' .. i)
		cancelTween('alphaNote' .. i)
	end
	return Function_Continue
end


-- Made by ImaginationSuperHero52806#2485 and JasonTheOne111#1000
-- Cleaned up and fixed by Superpowers#3887
-- Heatlthbar now moves by The Shade Lord#9206