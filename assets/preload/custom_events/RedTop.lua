function onEvent(n, o, t)
   t = tonumber(t) or 1
   if n == 'RedTop' then
      if o == 'true' then
          setProperty('redGradThing', true)
          setProperty('redGradSpeed', t)
      else
          setProperty('redGradThing', false)
      end
   end
end