package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;

typedef Art = {
    name:String,
    creator:String
}
class GalleryState extends MusicBeatState {
    public static var artArray:Array<Art> = [
        {name: 'Bf-1', creator: 'PuffyBunnyTail'},
        {name: 'Bf-2', creator: 'Tipo Random'},
        {name: 'Bf But Real', creator: 'BIGV'},
        {name: 'Confronting Yourself Moment', creator: 'Mr Game'},
        {name: 'Gutted', creator: 'Jakua P'},
        {name: 'Lord X-1', creator: 'FlareBlin'},
        {name: 'Lord X-2', creator: 'Le Guy'},
        {name: 'Lord X-3', creator: 'Unknown'},
        {name: 'Old Gf', creator: 'PuffyBunnyTail'},
        {name: 'Road Trip', creator: 'Dvl37'},
        {name: 'TooMuch', creator: 'NateM7X'}
    ];
    var curArt:Int = 0;

    var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuBG'));
    var artDisplay:FlxSprite = new FlxSprite();
    var creatorText:FlxText = new FlxText(0, 0, 0, '', 25);
    var infoText:FlxText = new FlxText(0, 0, 0, '', 30);
    override function create(){
        super.create();
        creatorText.font = Paths.font('futura.otf');
        creatorText.screenCenter(X);
        infoText.font = Paths.font('futura.otf');
        infoText.screenCenter(X);
        add(bg);
        add(artDisplay);
        add(creatorText);
        add(infoText);
        changeArt(0);
    }
    override function update(elapsed:Float){
        if (controls.UI_LEFT_P)
            changeArt(-1);
        if (controls.UI_RIGHT_P)
            changeArt(1);
        if (controls.BACK){
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new TitleState(true));
        }
        super.update(elapsed);
    }
    function changeArt(who:Int = 0){
        curArt += who;
        if (curArt >= artArray.length)
            curArt = 0;
        if (curArt < 0)
            curArt = artArray.length - 1;
        artDisplay.loadGraphic(Paths.image('ArtGallery/Art-${curArt+1}'));
        artDisplay.screenCenter();
        FlxTween.tween(artDisplay, {x: FlxG.width-artDisplay.width}, 0.3, {ease: FlxEase.elasticOut, type: BACKWARD, onComplete: function(t){
            artDisplay.screenCenter(); // to avoid spamming shit and stuff like that
        }});

        creatorText.text = artArray[curArt].creator;
        creatorText.screenCenter(X);
        FlxTween.tween(creatorText, {x: FlxG.width-creatorText.width}, 0.3, {ease: FlxEase.elasticOut, type: BACKWARD, onComplete: function(t){
            creatorText.screenCenter(X); 
        }});
        creatorText.y = artDisplay.y+artDisplay.height+1;

        infoText.text = artArray[curArt].name;
        infoText.screenCenter(X);
        FlxTween.tween(infoText, {x: FlxG.width-infoText.width}, 0.3, {ease: FlxEase.elasticOut, type: BACKWARD, onComplete: function(t){
            infoText.screenCenter(X); 
        }});
        infoText.y = artDisplay.y-infoText.height-1;
    }
}