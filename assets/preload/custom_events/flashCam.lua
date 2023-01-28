function onCreatePost()
   --luaDebugMode = true
   addHaxeLibrary("flixel.FlxG", "FlxCamera")
   addHaxeLibrary("flash.geom", "Point")
   addHaxeLibrary("flash.geom", "Matrix")

end

function onEvent(event, value1, value2)
   if event == "flashCam" then
      flash(tonumber(value1), "camHUD", true)
   end
end

-- duration : Duration FlashSprite to Fade out
-- camToFlash : Camera to Flash
-- hideCam : hide Targeted Camera then Fade In 
function flash(_duration, _camToFlash , _hideCam)
 
   local sprCam = "camOther"
   local dur = (_duration == nil and 0.8 or _duration)
   
   local camToFlash = (_camToFlash == nil and "camHUD" or _camToFlash)
   
   local hideCam = (_hideCam and 1 or 0)
   runHaxeCode([[
         var duration = ]]..dur..[[;
         var cam = game.]]..camToFlash..[[;

         var cameraCopySprite = new FlxSprite(0, 0);
         cameraCopySprite.makeGraphic(1280, 720, 0, true);
         cameraCopySprite.cameras = [game.]]..sprCam..[[];
         game.add(cameraCopySprite);
   
         if (FlxG.renderBlit) {
            cameraCopySprite.pixels.copyPixels(cam.buffer, cam.buffer.rect, new Point());
         } else {
            cameraCopySprite.pixels.draw(cam.canvas);    
         }
         
         if (]]..hideCam..[[ == 1){
            cam.alpha = 0.5;
            FlxTween.tween(cam, {alpha: 1}, duration);
         }
         FlxTween.tween(cameraCopySprite, {alpha: 0}, duration, {
            onComplete: function(twn)
            {
               game.remove(cameraCopySprite);
            }
         });
       
      ]])
end