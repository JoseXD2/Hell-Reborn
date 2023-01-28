function onEvent(n,v,b)
	if n == 'Stage Switch' then
		addLuaScript('stages/'..v,true)
		setObjectOrder('gfGroup',getObjectOrder('dadGroup'))
	end


end

