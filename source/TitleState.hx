package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.display.BlendMode;
import openfl.filters.ShaderFilter;

class TitleState extends MusicBeatState {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var initialized:Bool = false;
	public static var hasStarted:Bool = false;
	public static var introHasFinished:Bool = false;
	var switchToMainMenu:Bool = false;

	static var sheddar:FlxRuntimeShader = new FlxRuntimeShader(Paths.getTextFromFile('shaders/glitchShader2.frag', false));
	var markups:Array<FlxTextFormatMarkerPair> = [];
	var textArray:Array<String> = [];
	var step:Int = -1;

	var leText:FlxText;
	var red:FlxSprite;

	public static var bg:FlxSprite;
	public static var logo:FlxSprite;
    public static var logoWidth:Float;
    public static var logoHeight:Float;

	var particleGroup:FlxTypedGroup<TTest> = new FlxTypedGroup<TTest>();
	var particleTimer:FlxTimer;

    public function new(switchToMainMenu:Bool = false){
        super();
		this.switchToMainMenu = switchToMainMenu;
	}

	override public function create() {
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();
		FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();

		Highscore.load();

		super.create();
		bg = new FlxSprite();
		bg.frames = Paths.getSparrowAtlas('staticBACKGROUND2');
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.animation.addByPrefix('bump', 'menuSTATICNEW instance', 24);
		bg.animation.play('bump');
		bg.alpha = 0;
        add(bg);

		red = new FlxSprite(-500, -100).makeGraphic(500, FlxG.height * 2, 0xFFac0001);
		red.angle = -3;

		logo = new FlxSprite();
		logo.frames = Paths.getSparrowAtlas('logoBumpin');
		logo.antialiasing = ClientPrefs.globalAntialiasing;
		logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		logo.animation.play('bump');
        logo.updateHitbox();
		logo.screenCenter();
		logo.alpha = 0;
        logoWidth = logo.width;
		logoHeight = logo.height;

		particleTimer = new FlxTimer().start(0.4, function(t:FlxTimer) {
			particleGroup.add(new TTest(0, FlxG.random.float(0, FlxG.height), 150, 250, 30, 0xFFac0001, 0.5));
			t.reset(0.1);
		});
		add(particleGroup);

		leText = new FlxText(5, 5, 0, '', 50);
		leText.font = Paths.font('futura.otf');
		leText.color = 0xFFe8d8c0;
		leText.alignment = 'center';
		leText.angle = -3;

		var colors:Map<String, FlxColor> = [
			   "RED" => 0xFFac0001, "WHITE" => 0xFFe8d8c0,
			"YELLOW" => 0xFFffdf02, "BLACK" => 0xFF19181a
		];
		var modes:Map<String, Array<Bool>> = [
			"BOLD:" => [true, false],
			"BOLD:ITALIC" => [true, true],
			"ITALIC:" => [false, true],
			"" => [false, false]
		];
		for (color => colorvalue in colors) {
			for (mode => boolshit in modes) {
				var f:FlxTextFormat = new FlxTextFormat(colorvalue, boolshit[0], boolshit[1]);
				var fBig:FlxTextFormat = new FlxTextFormat(colorvalue, boolshit[0], boolshit[1]);
				@:privateAccess f.format.size = 30;
				markups.push(new FlxTextFormatMarkerPair(fBig, '<${mode}TITLE:$color>'));
				markups.push(new FlxTextFormatMarkerPair(f, '<${mode}$color>'));
			}
		}
		FlxG.camera.setFilters([new ShaderFilter(sheddar)]);
		textArray = Paths.getTextFromFile('data/startText.txt', false).split('|-|-|-|');

		if (!initialized)
			new FlxTimer().start(8, function(t:FlxTimer) {
				if (!initialized)
				    onStart();
			});
		else
			onEndIntro();
		if (FlxG.sound.music == null){
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			FlxG.sound.music.fadeIn(6, 0, 1);
		}
		if (FlxG.save.data.flashing == null && !FlashingState.leftState) {
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new FlashingState());
		}
		if (switchToMainMenu)
		{
			onEndIntro();
			openSubState(new MainMenuSubState());
			add(logo);
		}
	}

	var alreadyUsed:Array<Int> = [];

	private function getRandomFromArray():Int {
		var a:Int = FlxG.random.int(0, textArray.length - 1);
		if (alreadyUsed.contains(a))
			return getRandomFromArray();
		alreadyUsed.push(a);
		return a;
	}

	var sstep:Float = 0;

	override public function update(elapsed:Float) {
		super.update(elapsed);
		sheddar.setFloat('iTime', Sys.cpuTime() * elapsed);

		if (hasStarted && !introHasFinished) {
			if (alreadyUsed.length != textArray.length && FlxG.sound.music.time < 24200) {
				sstep += 0.5;
				if ((sstep % 120) == 0) {
					leText.applyMarkup(textArray[getRandomFromArray()], markups);
					leText.x = leText.x = (red.width - leText.width) / 2 - 15;
				}
			} else {
				sstep += 0.5;
				if ((sstep % 60) == 0)
					leText.applyMarkup('<ITALIC:TITLE:YELLOW>Hell Reborn<ITALIC:TITLE:YELLOW>', markups);
				if (FlxG.sound.music.time >= 24850 && !introHasFinished)
					onEndIntro();
			}
		}
		if (!introHasFinished && hasStarted)
			leText.x = (red.width - leText.width) / 2 - 15;
		if (FlxG.keys.justPressed.ENTER)
			if (!introHasFinished)
				onEndIntro();
			else
				openSubState(new MainMenuSubState());
	}

	override public function openSubState(substate:FlxSubState) {
		FlxTween.cancelTweensOf(logo);
		FlxTween.tween(logo, {
			x: 0,
			y: 0,
			"scale.x": 0.4,
			"scale.y": 0.4
		}, 0.3, {
			ease: FlxEase.smoothStepInOut,
			onUpdate: function(t:FlxTween) {
				logo.updateHitbox();
			}
		});
        FlxTween.tween(bg, {alpha: 0}, 0.3);
		FlxTween.tween(logo, {alpha: 0}, 0.3);
		super.openSubState(substate);
	}

	public function onStart() {
		FlxTween.tween(red, {x: -10}, 0.3, {ease: FlxEase.elasticOut});
		FlxTween.tween(red.scale, {x: 1.2}, 0.4, {
			ease: FlxEase.elasticOut,
			type: BACKWARD,
		});
		add(red);
		add(leText);
		hasStarted = true;
	}

	public function onEndIntro() {
		initialized = true;
		introHasFinished = true;
		if (FlxG.sound.music.time < 24850)
			FlxG.sound.music.time = 24850;
		FlxTween.tween(red, {x: -600}, 0.3, {ease: FlxEase.elasticIn});
		FlxTween.tween(leText, {x: -500}, 0.3, {ease: FlxEase.elasticIn});
		particleTimer.cancel();

		add(logo);
		FlxTween.tween(bg, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepInOut});
		FlxTween.tween(logo, {alpha: 1}, 0.5, {ease: FlxEase.smoothStepInOut});
		FlxTween.tween(logo, {y: logo.y - 50}, 1.0, {
			ease: FlxEase.quadInOut,
			onComplete: function(t:FlxTween)
			{
				FlxTween.tween(logo, {y: logo.y + 50}, 1.0, {ease: FlxEase.quadInOut, type: PINGPONG});
			}
		});
	}

	public static function closedMenuState() {
		FlxTween.tween(logo, {x: (FlxG.width - logoWidth) / 2, y: (FlxG.height - logoHeight) / 2}, 0.3, {ease: FlxEase.smoothStepInOut});
		FlxTween.tween(logo.scale, {x: 1, y: 1}, 0.3, {
			ease: FlxEase.smoothStepInOut,
			onUpdate: function(t:FlxTween)
			{
				logo.updateHitbox();
			},
            onComplete: function(t:FlxTween){
				FlxTween.tween(logo, {y: logo.y - 50}, 1.0, {
					ease: FlxEase.quadInOut,
					onComplete: function(t:FlxTween)
					{
						FlxTween.tween(logo, {y: logo.y + 50}, 1.0, {ease: FlxEase.quadInOut, type: PINGPONG});
					}
				});
			}
		});
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		FlxTween.tween(logo, {alpha: 1}, 0.3);
		FlxG.camera.setFilters([new ShaderFilter(sheddar)]);
	}
}

class TTest extends FlxSprite {
	public var duration:Float = 1;
	public var curWidth:Float;

	private var lifespan:Float = 0;
	private var _x:Float = 0;
	private var goal:Float;

	public function new(X:Float = 0, Y:Float = 0, minWidth:Int = 35, maxWidth:Int = 150, _height:Int = 50, _color:FlxColor = 0xFFffffff, duration:Float = 1,
			?goal:Float) {
		super(X, Y);
		this.duration = duration;
		makeGraphic(FlxG.random.int(minWidth, maxWidth), _height, _color);
		this.curWidth = width;
		this._x = X;
		this.goal = (goal == null ? FlxG.width : goal);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		lifespan = Math.min(lifespan + elapsed, duration);
		var scale:Float = Math.max(lifespan, 0) / duration;
		if (lifespan < duration) {
			x = _x + (goal - _x) * scale;
			setGraphicSize(Std.int(curWidth + (0 - curWidth) * scale), Std.int(height));
			updateHitbox();
		} else {
			kill();
		}
	}
}