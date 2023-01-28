package;

import Achievements;
import editors.MasterEditorMenu;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxRuntimeShader;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;

class MainMenuSubState extends MusicBeatSubstate {
    public static var bg:FlxSprite;
	public var options:Array<String> = ['StoryMode', 'FreePlay', 'Options', 'Extras'];
	public static var curOption:Int = 0;
	var optionGroup:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var sheddar:FlxRuntimeShader = new FlxRuntimeShader(Paths.getTextFromFile('shaders/glitchShader2.frag', false));

	private var camAchievement:FlxCamera;
    override public function create(){
        bg = new FlxSprite().loadGraphic(Paths.image('menuBG'));
        bg.alpha = 0;
        add(bg);
		FlxTween.tween(bg, {alpha: 1}, 0.3);
		FlxG.camera.setFilters([new ShaderFilter(sheddar)]);

        for (i in 0...options.length){
			var option:FlxSprite = new FlxSprite().loadGraphic(Paths.image('MainMenu/Buttons/' + options[i]));
            option.scale.set(0.5, 0.5);
            option.updateHitbox();
            option.x = FlxG.width+10+option.width;
            option.ID = i;
            FlxTween.tween(option, {x: (option.width + 10) * Math.abs(i - curOption)}, 0.5, {ease: FlxEase.quadInOut});
			FlxTween.tween(option, {y: (FlxG.height - option.height) / 2}, ((i+1)/10), {ease: FlxEase.quadInOut});
			optionGroup.add(option);
        }

        add(optionGroup);
		changeSelection();

		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;
		FlxG.cameras.add(camAchievement);
    }
    override function update(elapsed:Float){
		sheddar.setFloat('iTime', Sys.cpuTime() * elapsed);
		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
            TitleState.closedMenuState();
			FlxTween.tween(bg, {alpha: 0}, 0.3);
			close();
		}
		if (controls.UI_LEFT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeSelection(1);
		}

		if (controls.UI_RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'));
			changeSelection(-1);
		}
		if (controls.ACCEPT)
		{
            switch(options[curOption]){
				case 'StoryMode':
					MusicBeatState.switchState(new StoryMenuState());
				case 'FreePlay':
					MusicBeatState.switchState(new FreeplayState());
				case 'Options':
					MusicBeatState.switchState(new options.OptionsState());
				case 'Extras':
					LoadingState.loadAndSwitchState(new GalleryState());
            }
        }
		#if desktop
		if (FlxG.keys.anyJustPressed(ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'))))
				MusicBeatState.switchState(new MasterEditorMenu());
		#end
    }

    function changeSelection(who:Int = 0){
        curOption += who;
		if (curOption >= optionGroup.length)
			curOption = 0;
		if (curOption < 0)
			curOption = optionGroup.length - 1;
		optionGroup.forEach(function(spr:FlxSprite)
		{  
			FlxTween.tween(spr, {x: (spr.width + 10) * Math.abs(spr.ID - curOption), alpha: (spr.ID == curOption ? 1 : 0.35)}, 0.5, {ease: FlxEase.quadInOut});
        });
    }
}