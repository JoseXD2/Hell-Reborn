package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import hscript.Parser;
import PauseSubState2;
import hscript.Interp;
import sys.FileSystem;
import editors.ChartingState;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	public static var haxeInterp = null;
	public var variables:Map<String, Dynamic> = new Map();
	public static var instance:MainMenuState;
	var hscriptIsRunning:Bool = false;

	public var items:Map<String, Dynamic> = [];
	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'StoryMode',
		'FreePlay',
		'Options',
		'Extras'
	];

	var magenta:FlxSprite;
	var selectArrow:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

	var allDirPath:Dynamic;

	public function initHaxeInterpM(){
		if(haxeInterp == null)
		{
			haxeInterp = new Interp();
			haxeInterp.variables.set('FlxG', FlxG);
			haxeInterp.variables.set('Std', Std);
			haxeInterp.variables.set('FlxSprite', FlxSprite);
			haxeInterp.variables.set('FlxCamera', FlxCamera);
			haxeInterp.variables.set('FlxTween', FlxTween);
			haxeInterp.variables.set('FlxEase', FlxEase);
			haxeInterp.variables.set('MusicBeatState', MusicBeatState);
			haxeInterp.variables.set('game', MainMenuState.instance);
			haxeInterp.variables.set('OptionsState', options.OptionsState);
			haxeInterp.variables.set('Paths', Paths);
			haxeInterp.variables.set('PauseSubState2', PauseSubState2);
			haxeInterp.variables.set('Conductor', Conductor);
			haxeInterp.variables.set('ClientPrefs', ClientPrefs);
			haxeInterp.variables.set('addLibrary', function(libName:String, ?libPackage:String = ''){
				initHaxeInterpM();
				try {
					var str:String = '';
					if(libPackage.length > 0)
						str = libPackage + '.';

					haxeInterp.variables.set(libName, Type.resolveClass(str + libName));
				}
			});
			#if !flash
			haxeInterp.variables.set('ShaderFilter', openfl.filters.ShaderFilter);
			#end
			haxeInterp.variables.set('StringTools', StringTools);
			haxeInterp.variables.set('setVar', function(name:String, value:Dynamic)
			{
				MainMenuState.instance.variables.set(name, value);
			});
			haxeInterp.variables.set('getVar', function(name:String)
			{
				if(!MainMenuState.instance.variables.exists(name)) return null;
				return MainMenuState.instance.variables.get(name);
			});
		}
	}
	public function runHaxeCodeFromStr(str:String){
		initHaxeInterpM();
		try {
			var myFunction:Dynamic = haxeInterp.expr(new Parser().parseString(str));
			myFunction();
		}
		catch (e:Dynamic) {
			switch(e)
			{
				case 'Null Function Pointer', 'SReturn':
					//nothing
				default:
					trace(e);
			}
		}
	}
	
	public function newItem(tag:String, item:Dynamic) {items[tag] = item; return true;}
	public function getObject(tag:String) { return items[tag]; }
	public function addItem(tag:String) {add(getObject(tag)); return true;}

	public function newSprite(tag:String, path:String, x:Float, y:Float) { newItem(tag, new FlxSprite(x, y).loadGraphic(Paths.image(path)));}
	public function newText(tag:String, text:String, width:Float, x:Float, y:Float, ?size:Int = 8) { newItem(tag, new FlxText(x, y, width, text, size));}

	function getField(object:Dynamic, fieldString:String, ?i:Int = 0):Dynamic
	{
    	var splittedField:Array<String> = fieldString.split('.');
    	var returnThis;
    	if (i != splittedField.length-1){
    	    returnThis = getField(Reflect.getProperty(object, splittedField[i]), fieldString, i+1);
		}else{
    	    returnThis = Reflect.getProperty(object, splittedField[i]);
		}
		return returnThis;
	}

	function setProperty(fullObject:String, value:Dynamic){
    	var splittedString:Array<String> = fullObject.split('.');
    	var object:String = splittedString[0];
    	var field:String = splittedString[splittedString.length-1];

    	if (splittedString.length > 1){
    	    var fieldLoop:String = fullObject.substr(object.length).substr(1, -field.length-2);
    	    Reflect.setProperty(getField(getObject(object), fieldLoop), field, value);
    	}else{
    	    Reflect.setProperty(getObject(object), field, value);
    	}
    	return true;
	}

	function getProperty(me:String){
	    var splittedString:Array<String> = me.split('.');
	    var object:String = splittedString[0];
	    var field:String = splittedString[splittedString.length-1];
	    var returnedProperty:Dynamic;

	    if (splittedString.length > 1){
	        var fieldLoop:String = me.substr(object.length).substr(1, -field.length-2);
	        returnedProperty = Reflect.getProperty(getField(getObject(object), fieldLoop), field);
	    }else{
	        returnedProperty = Reflect.getProperty(getObject(object), field);
	    }
	    return returnedProperty;
	}

	override function create()
	{

		instance = this;

		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		// FlxG.stage.window.onDropFile.add((songPath:String) -> {
		// 	songPath = StringTools.replace(songPath, '\\', '/');
		// 	FlxG.sound.music.fadeOut(0.7, 0, function(tween){
		// 		FlxG.sound.music.stop();
		// 		var soundFile = openfl.media.Sound.fromFile(songPath);
		// 		FlxG.sound.playMusic(soundFile, 0.8, true);
		// 		FlxG.sound.music.fadeIn(1, 0, 0.7);
		// 	});
		// });
		

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = ClientPrefs.globalAntialiasing;
		magenta.color = 0xFFfd719b;
		add(magenta);

		trace('seperator!');
    	newSprite('test', 'Bottom', 500, 0);
		addItem('test');
    	setProperty('test.velocity.x', 300);
		
		trace(getProperty('test.velocity.x'));
        selectArrow = new FlxSprite(0, 0);
		selectArrow.frames = ui_tex;
		selectArrow.animation.addByPrefix('idle', "arrow left");
		selectArrow.animation.play('idle');
		selectArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(selectArrow);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			// var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(/*0, (i * 140)  + offset*/);
			menuItem.loadGraphic(Paths.image('MainMenu/Buttons/' + optionShit[i]));
			menuItem.scale.set(0.5, 0.5);
			menuItem.screenCenter();
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
		}


		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
		for (i in 0...FileSystem.readDirectory("mods/MainMenuState").length){
			allDirPath = 'MainMenuState/' + FileSystem.readDirectory("mods/MainMenuState")[i];
			runHaxeCodeFromStr(Paths.getTextFromFile(allDirPath, false));
			if (StringTools.contains(Paths.getTextFromFile(allDirPath, false), 'create()'))
				runHaxeCodeFromStr('if (create != null) { create();}');
		}
		hscriptIsRunning = true;
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));
				if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);
				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];
							switch (daChoice)
							{
								case 'StoryMode':
									MusicBeatState.switchState(new StoryMenuState());
								case 'FreePlay':
									MusicBeatState.switchState(new FreeplayState());
								case 'Options':
									MusicBeatState.switchState(new options.OptionsState());
								case 'Extras':
									LoadingState.loadAndSwitchState(new GalleryState());
							}
						});
					}
				});
			}
			if (FlxG.keys.justPressed.NINE)
                MusicBeatState.switchState(new Test());
			
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
		if (hscriptIsRunning)
			if (StringTools.contains(Paths.getTextFromFile(allDirPath, false), 'update()'))
				runHaxeCodeFromStr('if (update != null) { update(); }\n');
			menuItems.forEach(function(spr:FlxSprite){
				if (curSelected == spr.ID){
					spr.scale.set(FlxMath.lerp(spr.scale.x, 1, elapsed*2.7), FlxMath.lerp(spr.scale.y, 1, elapsed*2.7));
					spr.x = FlxMath.lerp(spr.x, FlxG.width/2-spr.width/2, elapsed*2.7);
					spr.y = FlxMath.lerp(spr.y, FlxG.height/2-spr.height/2, elapsed*2.7);
					spr.alpha = FlxMath.lerp(spr.alpha, 1, elapsed*2.7);
				}else{
					spr.scale.set(FlxMath.lerp(spr.scale.x, 0.5, elapsed*2.7), FlxMath.lerp(spr.scale.y, 0.5, elapsed*2.7));
					spr.x = FlxMath.lerp(spr.x, ((FlxG.width/2-spr.width/2)-(spr.ID-curSelected)*spr.width), elapsed*2.7);
					spr.y = FlxMath.lerp(spr.y, (FlxG.height/2-spr.height/2)-50, elapsed*2.7);
					spr.alpha = FlxMath.lerp(spr.alpha, 0.5, elapsed*2.7);
				}
			});
	}

	function changeItem(huh:Int = 0)
	{
		var lastSelected = curSelected;
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
				// selectArrow.x = 450;
			    // FlxTween.tween(selectArrow, {y: spr.y}, 0.2, {ease: FlxEase.smoothStepInOut});
				// FlxTween.tween(spr, {x: 50}, 0.2, {ease: FlxEase.smoothStepInOut});
			}else{
				// if (spr.ID == lastSelected)
					// FlxTween.tween(spr, {x: 0}, 0.2, {ease: FlxEase.smoothStepInOut});
			}
		});
	}
	override function destroy(){
		haxeInterp = null;
		super.destroy();
	}
}
