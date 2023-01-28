function onCreate()

     makeLuaSprite('theSky','Blue Sphere',-200,-200)
	 addLuaSprite('theSky',false) 
     setLuaSpriteScrollFactor('theSky', 0.2, 0.2);

end


function onCreatePost()

    addVCREffect('camgame')
    addVCREffect('camhud', false)
    addChromaticAbberationEffect( 'camhud',0.005)
    addChromaticAbberationEffect( 'camgame',0.005)
    addScanLineEffect( 'camgame',0.5)
    addScanLineEffect( 'camhud',0.5)
    addBloomEffect( 'camgame',0.5)
    addBloomEffect( 'camhud',0.5)
    addScanLineEffect( 'gf',0.5)

end