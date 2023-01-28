package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import haxe.Timer;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

using StringTools;
//crash handler stuff
#if CRASH_HANDLER
import Discord.DiscordClient;
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
#end


class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	var framerate:Int = 60; // How many frames per second the game should run at.
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var fpsVar:FPSText;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
		{
			init();
		}
		else
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
	
		ClientPrefs.loadDefaultKeys();
		var game:FlxGame = new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen);
		addChild(game);

		#if !mobile
			Lib.current.stage.align = "tl";
			Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
			fpsVar = new FPSText();
			addChild(fpsVar);
			fpsVar.visible = ClientPrefs.showFPS;
		#end

		#if html5
		FlxG.autoPause = false;
		FlxG.mouse.visible = false;
		#end
		
		#if CRASH_HANDLER
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
		#end
	}

	// Code was entirely made by sqirra-rng for their fnf engine named "Izzy Engine", big props to them!!!
	// very cool person for real they don't get enough credit for their work
	#if CRASH_HANDLER
	function onCrash(e:UncaughtErrorEvent):Void
	{
		var errMsg:String = "";
		var path:String;
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();

		dateNow = dateNow.replace(" ", "_");
		dateNow = dateNow.replace(":", "'");

		path = "./crash/" + "PsychEngine_" + dateNow + ".txt";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += "\nUncaught Error: " + e.error + "\nPlease report this error to the GitHub page: https://github.com/ShadowMario/FNF-PsychEngine\n\n> Crash Handler written by: sqirra-rng";

		if (!FileSystem.exists("./crash/"))
			FileSystem.createDirectory("./crash/");

		File.saveContent(path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));

		Application.current.window.alert(errMsg, "Error!");
		DiscordClient.shutdown();
		Sys.exit(1);
	}
	#end
}

class FPSText extends TextField {
	public var fps:Int = 0;
	public var curFPS:Float = 0;
	private var currentTime:Float = 0;
	private var cacheCount:Float = 0;
	private var times:Array<Float> = [];

	public var memoryType:String = 'KB';
	private var memoryType2:String = 'KB';
	private var memoryThing:Int = 0;
	private var memoryNew:Float = 0;
	public function new(X:Float = 10, Y:Float = 3)
	{
		super();
		this.x = X;
		this.y = Y;
		selectable = false;
		autoSize = LEFT;
		defaultTextFormat = new TextFormat(Paths.font("futura.otf"), 16, 0xFFFFFF);
		addEventListener(Event.ENTER_FRAME, function(p){
			updateFPS(Lib.getTimer()-currentTime);
		});
	}
	public function updateFPS(el:Float){
		// fps

		currentTime += el;
		times.push(currentTime);
		while (times[0] < currentTime - 1000)
			times.shift();

		var currentCount = times.length;
		fps = Math.round((currentCount+cacheCount)/2);
		if (currentCount != cacheCount)
			curFPS = Math.min(fps, ClientPrefs.framerate);

		// memory

		var memory:Float = System.totalMemory / 1024 / 1024 * 1000;
		for (i => v in ['KB', 'MB', 'GB', 'TB'])
		{
			if (memory > Math.pow(1000, i))
			{
				memoryType = v;
				memoryThing = i;
			}
		}

		textColor = 0xFFFFFFFF;
		if (memory/1000 > 3000 || curFPS <= ClientPrefs.framerate / 2)
			textColor = 0xFFFF0000;

		memory /= Math.pow(1000, memoryThing);
		memory = Math.round(memory * 100) / 100;
		if (memory > memoryNew)
		{
			memoryNew = memory;
			memoryType2 = memoryType;
		}
		text = 'FPS: $curFPS' + '\nMEMORY USAGE: $memory$memoryType / $memoryNew$memoryType2';

		cacheCount = currentCount;
	}
}