package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import flixel.graphics.FlxGraphic;
import PauseSubState2.ShakyText;
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
import WeekData;

using StringTools;

class StoryMenuState extends MusicBeatState
{	
	var camGame = new FlxCamera();

	public var blackishGrayThing:FlxSprite;
	public var whiteThing:FlxSprite;
	public var redThing:FlxSprite;
	public var weekBG:FlxSprite;
	public var difficultySprite:FlxSprite;

	public var weekCharacters:FlxTypedGroup<MenuCharacter>;
	public var radish = new FlxRuntimeShader(Paths.getTextFromFile('shaders/glitchShader2.frag', false));

 	var weekText:ShakyText;
	var trackText:FlxText;
	var weekDescription:FlxText;
	var bestScore:FlxText;

	public static var lerpedBestScore:Int = 0;
	private static var defaultBestScore:Int = 0;

	var loadedWeeks:Array<WeekData> = [];
	public static var weekCompleted:Map<String, Bool> = new Map<String, Bool>();

	var selectingDifficulty:Bool = false;
	var curDifficulty:Int = 1;

	private static var curWeek:Int = 0;
	private static var lastDifficultyName:String = '';

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!weekCompleted.exists(leWeek.weekBefore) || !weekCompleted.get(leWeek.weekBefore)));
	}

	public function fixTextSize(text:FlxText, sprite:FlxSprite, ?mult:Float = 0)
	{
    	var ratio:Float = (sprite.width + mult) / text.textField.width;
    	var originalOrigin:FlxPoint = FlxPoint.get(text.origin.x, text.origin.y);
    	text.centerOrigin();
    	text.scale.set(ratio, ratio);
    	text.updateHitbox();
    	text.offset.set(originalOrigin.x, originalOrigin.y);
    	text.updateHitbox();
	}

	override function create(){
		FlxG.cameras.reset(camGame);
		FlxCamera.defaultCameras = [camGame];
		camGame.setFilters([new ShaderFilter(radish)]);

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);

		if(curWeek >= WeekData.weeksList.length) curWeek = 0;
		for (i in 0...WeekData.weeksList.length){
			var weekFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);

			if(!isLocked || !weekFile.hiddenUntilUnlocked)
			{
				loadedWeeks.push(weekFile);
				WeekData.setDirectoryFromWeek(weekFile);
			}
		}
		WeekData.setDirectoryFromWeek(loadedWeeks[0]);

		weekBG = new FlxSprite(0, 0);
		weekCharacters = new FlxTypedGroup<MenuCharacter>();

		redThing = new FlxSprite(FlxG.width+50, FlxG.height-350).makeGraphic(FlxG.width, 400, 0xFfac0001);
		difficultySprite = new FlxSprite(0, 0);
		blackishGrayThing = new FlxSprite(FlxG.width+425, 0).makeGraphic(655, FlxG.height+150, 0xFF19181a);
		whiteThing = new FlxSprite(-25, -350).makeGraphic(650, 280, 0xFFe8d8c0);

		weekText = new ShakyText(0, -480, 0, WeekData.getWeekFileName().toUpperCase(), 100, Paths.font('Futura.otf'), 0xFF19181a, 0xFFac0001, 5);
		trackText = new FlxText(-400, 0, 0, 'Tracks', 40);
		weekDescription = new FlxText(-400, FlxG.height-50, 0, '...', 35);
		bestScore = new FlxText(-300, 0, 0, 'N/A', 40);

		trackText.alignment = CENTER;
		trackText.font = Paths.font('Futura.otf');
		trackText.color = 0xFFe9a642;

		weekDescription.alignment = CENTER;
		weekDescription.font = Paths.font('Futura.otf');
		weekDescription.color = 0xFFe8d8c0;

		bestScore.alignment = CENTER;
		bestScore.font = Paths.font('Futura.otf');
		bestScore.color = 0xFF19181a;

		weekBG.scrollFactor.set(0, 0);
		redThing.scrollFactor.set(0, 0);
		blackishGrayThing.scrollFactor.set(0, 0);
		whiteThing.scrollFactor.set(0, 0);
		weekText.scrollFactor.set(0, 0);
		trackText.scrollFactor.set(0, 0);
		weekDescription.scrollFactor.set(0, 0);
		difficultySprite.scrollFactor.set(0, 0);
		bestScore.scrollFactor.set(0, 0);

		blackishGrayThing.angle = -3;
		whiteThing.angle = -3;
		weekText.angle = -3;
		trackText.angle = -3;
		weekDescription.angle = -3;

		difficultySprite.visible = false;
		bestScore.visible = false;

		var charArray:Array<String> = loadedWeeks[0].weekCharacters;
		for (char in 0...3)
		{
			var weekCharacterThing:MenuCharacter = new MenuCharacter((FlxG.width * 0.25) * (1 + char) - 150, charArray[char]);
			weekCharacterThing.y += 30;
			weekCharacters.add(weekCharacterThing);
		}

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		if(lastDifficultyName == '')
			lastDifficultyName = CoolUtil.defaultDifficulty;
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		add(weekBG);
		add(weekCharacters);

		add(redThing);
		add(difficultySprite);
		add(blackishGrayThing);
		add(whiteThing);
		add(weekText);
		add(trackText);
		add(weekDescription);
		add(bestScore);

		FlxTween.tween(blackishGrayThing, {x: -15}, 0.4, {ease: FlxEase.expoIn, onComplete: function(posi:FlxTween){
			FlxTween.tween(blackishGrayThing, {"scale.x": 2}, 0.2, {ease: FlxEase.elasticOut, type: BACKWARD});
			FlxTween.tween(whiteThing, {y: -45}, 0.3, {ease: FlxEase.smoothStepInOut, onComplete: function(poru:FlxTween){
				changeWeek(0);
				FlxTween.tween(redThing, {x: 0}, 0.15, {ease: FlxEase.smoothStepInOut});
			}});
		}});
		super.create();
	}

	function changeDifficulty(who:Int = 0)
	{
		curDifficulty += who;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length-1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var currentImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(CoolUtil.difficulties[curDifficulty]));
		difficultySprite.loadGraphic(currentImage);
		FlxTween.tween(difficultySprite, {x: redThing.x+redThing.width/2-difficultySprite.width/2, y: redThing.y+difficultySprite.height}, 0.15, {ease: FlxEase.elasticOut, onComplete: function(posi:FlxTween){
			FlxTween.tween(bestScore, {x: redThing.x+redThing.width/2-bestScore.width/2, y: difficultySprite.y+difficultySprite.height+20}, 0.15, {ease: FlxEase.elasticOut});
		}});
		lastDifficultyName = Paths.formatToSongPath(CoolUtil.difficulties[curDifficulty]);

		#if !switch
			defaultBestScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end
	}

	function changeWeek(who:Int = 0){
		curWeek += who;

		if (curWeek >= loadedWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = loadedWeeks.length - 1;

		var leWeek:WeekData = loadedWeeks[curWeek];
		WeekData.setDirectoryFromWeek(leWeek);
		PlayState.storyWeek = curWeek;

		weekText.text = WeekData.getWeekFileName().toUpperCase();
		if (weekText.textField.width > whiteThing.width-100){
			fixTextSize(weekText, whiteThing, -100);
			fixTextSize(weekText.shakyText, whiteThing, -99);
		}

		var stringThing:Array<String> = [];
		for (i in 0...leWeek.songs.length) 
			stringThing.push(leWeek.songs[i][0]);
		trackText.text = 'TRACKS\n\n';
		for (i in 0...stringThing.length)
			trackText.text += stringThing[i].toUpperCase() + '\n';
		weekDescription.text = leWeek.storyName.toUpperCase();
		weekBG.loadGraphic(Paths.image('menubackgrounds/menu_' + leWeek.weekBackground));

		var weekArray:Array<String> = loadedWeeks[curWeek].weekCharacters;
		for (i in 0...weekCharacters.length) {
			weekCharacters.members[i].changeCharacter(weekArray[i]);
		}

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
				CoolUtil.difficulties = diffs;

			if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
				curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
			else
				curDifficulty = 0;
			var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
			if(newPos > -1)
				curDifficulty = newPos;
		}

		#if !switch
			defaultBestScore = Highscore.getWeekScore(loadedWeeks[curWeek].fileName, curDifficulty);
		#end

		FlxTween.tween(weekText, {x: whiteThing.x+whiteThing.width/2-weekText.width/2, y: whiteThing.y+whiteThing.height/2-weekText.height/2}, 0.2, {ease: FlxEase.elasticOut});
		FlxTween.tween(trackText, {x: blackishGrayThing.x+blackishGrayThing.width/2-trackText.width/2, y: whiteThing.y+whiteThing.height+20}, 0.15, {ease: FlxEase.elasticOut});
		FlxTween.tween(weekDescription, {x: blackishGrayThing.x+blackishGrayThing.width/2-weekDescription.width/2, y: (FlxG.height-weekDescription.height)-5}, 0.15, {ease: FlxEase.elasticOut});
	}

	var no_flavor:Bool = false;
	function selectWeek(){
		if (no_flavor == false)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			var bf:MenuCharacter = weekCharacters.members[1];
			if(bf.character != '' && bf.hasConfirmAnimation) weekCharacters.members[1].animation.play('confirm');
			no_flavor = true;
		}
		// We can't use Dynamic Array .copy() because that crashes HTML5, here's a workaround.
		
		var songArray:Array<String> = [];
		var leWeek:Array<Dynamic> = loadedWeeks[curWeek].songs;
		for (i in 0...leWeek.length) 
			songArray.push(leWeek[i][0]);

		// Nevermind that's stupid lmao

		PlayState.storyPlaylist = songArray;
		PlayState.isStoryMode = true;

		var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
		if(diffic == null) diffic = '';

		PlayState.storyDifficulty = curDifficulty;
		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
		PlayState.campaignScore = 0;
		PlayState.campaignMisses = 0;
		
		FlxTween.tween(weekBG, {y: -100-weekBG.height}, 1, {ease: FlxEase.elasticOut});
		FlxTween.tween(redThing, {y: FlxG.height+50+redThing.height}, 0.3, {ease: FlxEase.elasticOut});
		FlxTween.tween(difficultySprite, {y: FlxG.height+50+redThing.height}, 0.3, {ease: FlxEase.elasticOut});
		FlxTween.tween(bestScore, {y: FlxG.height+50+redThing.height}, 0.3, {ease: FlxEase.elasticOut, onComplete: function(posi:FlxTween){
			LoadingState.loadAndSwitchState(new PlayState(), true);
			FreeplayState.destroyFreeplayVocals();
		}});
	}

	override function update(elapsed:Float){
		radish.setFloat('iTime', Sys.cpuTime());

		lerpedBestScore = Math.floor(FlxMath.lerp(lerpedBestScore, defaultBestScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if(Math.abs(defaultBestScore - lerpedBestScore) < 10) lerpedBestScore = defaultBestScore;

		bestScore.text = 'PERSONAL BEST:\n'+lerpedBestScore+'\n';

		if (!selectingDifficulty){
			if (controls.UI_UP_P)
				changeWeek(-1);
			else if (controls.UI_DOWN_P)
				changeWeek(1);
		}else if (!no_flavor){
			if (controls.UI_LEFT_P)
				changeDifficulty(-1);
			else if (controls.UI_RIGHT_P)
				changeDifficulty(1);
		}

		if (controls.ACCEPT){
			if (!selectingDifficulty)
			{
				if (!weekIsLocked(loadedWeeks[curWeek].fileName)){
					FlxTween.tween(blackishGrayThing, {x: -FlxG.width}, 0.25, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(whiteThing, {y: -350}, 0.25, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(trackText, {y: -350}, 0.25, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(weekDescription, {y: -350}, 0.25, {ease: FlxEase.smootherStepInOut});
					FlxTween.tween(weekText, {y: -350}, 0.25, {ease: FlxEase.smootherStepInOut, onComplete: function(frtie:FlxTween){
						selectingDifficulty = true;
						difficultySprite.visible = true;
						bestScore.visible = true;
						changeDifficulty(0);
					}});
				}else{
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			}else{
				selectWeek();
			}
		}
		if (FlxG.keys.justPressed.ESCAPE){
			if (!selectingDifficulty){
				FlxG.sound.play(Paths.sound('cancelMenu'));
				no_flavor = true;
				MusicBeatState.switchState(new TitleState(true));
			}else{
				FlxTween.tween(blackishGrayThing, {x: -15}, 0.4, {ease: FlxEase.smoothStepInOut, onComplete: function(posi:FlxTween){
					FlxTween.tween(whiteThing, {y: -45}, 0.3, {ease: FlxEase.smoothStepInOut, onComplete: function(repu:FlxTween){
						changeWeek(0);
						selectingDifficulty = false;
						FlxTween.tween(bestScore, {x: -400}, 0.3, {ease: FlxEase.expoIn});
						FlxTween.tween(difficultySprite, {x: -400}, 0.3, {ease: FlxEase.expoIn, onComplete: function(psst:FlxTween){
							difficultySprite.visible = false;
							bestScore.visible = false;
						}});
					}});
				}});
			}
		}
		super.update(elapsed);
	}
}