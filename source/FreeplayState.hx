package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState {
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;

	private static var curSelected:Int = 0;

	var curDifficulty:Int = -1;

	private static var lastDifficultyName:String = '';

	var Bg:FlxSprite;
	var black1:FlxSprite;

	public var middleSprite:FlxSprite;

	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongs:FlxTypedGroup<FlxText>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite;
	var intendedColor:Int;
	var colorTween:FlxTween;

	var difficultyText:FlxText;
	var kiwi:FlxTextFormatMarkerPair = new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFffdf02), "<_X_>");

	override function create() {
		// Paths.clearStoredMemory();
		// Paths.clearUnusedMemory();

		persistentUpdate = true;
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		for (i in 0...WeekData.weeksList.length) {
			if (weekIsLocked(WeekData.weeksList[i]))
				continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length) {
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs) {
				var colors:Array<Int> = song[2];
				if (colors == null || colors.length < 3) {
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();

		/*//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//
			var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
			for (i in 0...initSonglist.length)
			{
				if(initSonglist[i] != null && initSonglist[i].length > 0) {
					var songArray:Array<String> = initSonglist[i].split(":");
					addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
				}
		}*/

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);
		bg.screenCenter();

		// Bg = new FlxSprite();
		// Bg.frames = Paths.getSparrowAtlas('FreeplayBG');

		// Bg.antialiasing = ClientPrefs.globalAntialiasing;
		// Bg.animation.addByPrefix('idle', 'idle', 24);
		// Bg.animation.play('idle');
		// Bg.scale.set(0.65, 0.65);
		// Bg.updateHitbox();
		// Bg.screenCenter();
		// add(Bg);

		middleSprite = new FlxSprite(0, FlxG.height - 300).makeGraphic(FlxG.width, 300, 0xFFe8d8c0);
		middleSprite.scrollFactor.set(0, 0);
		add(middleSprite);

		difficultyText = new FlxText(0, FlxG.height-200, 0, '< NORMAL >', 60);
		difficultyText.font = Paths.font("Futura.otf");
		difficultyText.color = 0xFF19181a;
		add(difficultyText);

		scoreText = new FlxText(FlxG.width-330, FlxG.height-150, 0, "", 20);
		scoreText.setFormat(Paths.font("Futura.otf"), 55, 0xFF19181a, CENTER);
		add(scoreText);

		black1 = new FlxSprite(-20, -40).makeGraphic(610, FlxG.height + 100, 0xFF19181a);
		black1.scrollFactor.set(0, 0);
		black1.angle = -3;
		add(black1);

		grpSongs = new FlxTypedGroup<FlxText>();
		add(grpSongs);

		for (i in 0...songs.length) {
			var songText:FlxText = new FlxText(0, (70 * i) + 30, 0, songs[i].songName.toUpperCase(), 80);
			songText.font = Paths.font('Futura.otf');
			songText.color = 0xFFe8d8c0;
			songText.angle = -3;
			songText.ID = i;

			if (songText.width > black1.width-50){
				songText.setGraphicSize(Std.int(black1.width-50), Std.int(songText.height));
				songText.updateHitbox();
			}
			grpSongs.add(songText);

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.x = 870;
			icon.y = 150;
			icon.setGraphicSize(Std.int(icon.width * 1.5));
			// icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}
		WeekData.setDirectoryFromWeek();

		FlxG.camera.zoom = 3;
		// FlxG.camera.angle = 25;
		FlxTween.tween(FlxG.camera, {zoom: 1}, 1.5, {ease: FlxEase.expoInOut});
		// FlxTween.tween(FlxG.camera, {angle: 0}, 1, {ease: FlxEase.quartOut});

		if (curSelected >= songs.length)
			curSelected = 0;
		bg.color = songs[curSelected].color;
		intendedColor = bg.color;

		if (lastDifficultyName == '') {
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));

		changeSelection();
		changeDiff();

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));
			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;
			FlxG.stage.addChild(texFel);
			// scoreText.textField.htmlText = md;
			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("vcr.ttf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int) {
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}

	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
		{
			if (songCharacters == null)
				songCharacters = ['bf'];
			var num:Int = 0;
			for (song in songs)
			{
				addSong(song, weekNum, songCharacters[num]);
				this.songs[this.songs.length-1].color = weekColor;
				if (songCharacters.length != 1)
					num++;
			}
	}*/
	var instPlaying:Int = -1;

	public static var vocals:FlxSound = null;

	var holdTime:Float = 0;

	override function update(elapsed:Float) {
		if (FlxG.sound.music.volume < 0.7) {
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if (ratingSplit.length < 2) { // No decimals, add an empty space
			ratingSplit.push('');
		}

		while (ratingSplit[1].length < 2) { // Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if (FlxG.keys.pressed.SHIFT)
			shiftMult = 3;

		if (songs.length > 1) {
			if (upP) {
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP) {
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if (controls.UI_DOWN || controls.UI_UP) {
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if (holdTime > 0.5 && checkNewHold - checkLastHold > 0) {
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if (FlxG.mouse.wheel != 0) {
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP)
			changeDiff();

		if (controls.BACK) {
			persistentUpdate = false;
			if (colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());

			// if (optionShit[curSelected] != null )
			// {
			FlxTween.tween(FlxG.camera, {zoom: 5}, 1.5, {ease: FlxEase.expoInOut});
			// FlxTween.tween(bg, {angle: 45}, 1, {ease: FlxEase.quartIn});
			// }
		}

		if (ctrl) {
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		} else if (space) {
			if (instPlaying != curSelected) {
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		} else if (accepted) {

			for (ioii in grpSongs.members)
				FlxTween.tween(ioii, {alpha: 0}, 0.2, {ease: FlxEase.smoothStepInOut});
			for (icon in 0...iconArray.length)
				FlxTween.tween(iconArray[icon], {alpha: 0}, 0.2, {ease: FlxEase.smoothStepInOut});
			
			FlxTween.tween(black1, {"scale.x": 3.3, "scale.y": 2, x: 180}, 0.3, {ease: FlxEase.expoIn, onComplete: function(t:FlxTween){
				persistentUpdate = false;
				var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
				var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
				/*#if MODS_ALLOWED
					if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
					#else
					if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					#end
						poop = songLowercase;
						curDifficulty = 1;
						trace('Couldnt find file');
				}*/
				trace(poop);

				PlayState.SONG = Song.loadFromJson(poop, songLowercase);
				PlayState.isStoryMode = false;
				PlayState.storyDifficulty = curDifficulty;

				trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
				if (colorTween != null) {
					colorTween.cancel();
				}

				if (FlxG.keys.pressed.SHIFT) {
					LoadingState.loadAndSwitchState(new ChartingState());
				} else {
					LoadingState.loadAndSwitchState(new PlayState());
				}

				FlxG.sound.music.volume = 0;

				destroyFreeplayVocals();
			}});
		} else if (controls.RESET) {
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if (vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0) {
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficulties.length - 1;
		if (curDifficulty >= CoolUtil.difficulties.length)
			curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		PlayState.storyDifficulty = curDifficulty;
		if (change == 1)
			difficultyText.applyMarkup('< '+CoolUtil.difficultyString().toUpperCase()+' <_X_>><_X_>', [kiwi]);
		if (change == -1)
			difficultyText.applyMarkup('<_X_><<_X_> '+CoolUtil.difficultyString().toUpperCase()+' >', [kiwi]);

		new FlxTimer().start(0.13, function(tmr:FlxTimer) {
			difficultyText.applyMarkup('< '+CoolUtil.difficultyString().toUpperCase()+' >', [kiwi]);
		});

		difficultyText.x = (FlxG.width-330)-difficultyText.width/2;
		
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true) {
		if (playSound)
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		var newColor:Int = songs[curSelected].color;
		if (newColor != intendedColor) {
			if (colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		for (i in 0...iconArray.length) {
			iconArray[i].alpha = 0;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members) {
			FlxTween.tween(item, {y: (70*item.ID)-(70*curSelected)+15}, 0.2, {ease: FlxEase.smoothStepInOut});
			if (item.ID == curSelected)
				item.color = 0xFFffdf02;
			else
				item.color = 0xFFe8d8c0;
		}

		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (diffStr != null)
			diffStr = diffStr.trim(); // Fuck you HTML5

		if (diffStr != null && diffStr.length > 0) {
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0) {
				if (diffs[i] != null) {
					diffs[i] = diffs[i].trim();
					if (diffs[i].length < 1)
						diffs.remove(diffs[i]);
				}
				--i;
			}

			if (diffs.length > 0 && diffs[0].length > 0) {
				CoolUtil.difficulties = diffs;
			}
		}

		if (CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty)) {
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		} else {
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		// trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if (newPos > -1) {
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		scoreText.y = difficultyText.y+difficultyText.height+5;
		scoreText.x = (FlxG.width-330)-scoreText.width/2;

		if (scoreText.width > middleSprite.width/2-20)
			scoreText.setGraphicSize(Std.int(middleSprite.width/2-20));
		else
			scoreText.scale.set(1, 1);

		for (i in 0...iconArray.length)
		{
			var icon:HealthIcon = iconArray[i];
			icon.x = 870-icon.width/2;
			icon.y = 150+icon.height/2;
		}
	}
}

class SongMetadata {
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";

	public function new(song:String, week:Int, songCharacter:String, color:Int) {
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Paths.currentModDirectory;
		if (this.folder == null)
			this.folder = '';
	}
}