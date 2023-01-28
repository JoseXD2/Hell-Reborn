// A psych lua hitgraph made by Cherry ported into haxe
package;

import flash.display.Sprite;
import flash.display.Graphics;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;

class GraphData {
    public var x:Float;
    public var y:Float;
    public var width:Int;
    public var height:Int;
    public var graphics:Graphics;

    public function new(X:Float, Y:Float, width:Int, height:Int, graphics:Graphics){
        this.x = X;
        this.y = Y;
        this.width = width;
        this.height = height;
        this.graphics = graphics;
    }
} // didn't want to use typedefs

class HitGraph extends Sprite {
    var graphData:GraphData;
    public function new(x:Float, y:Float, width:Int, height:Int){
        super();
        graphData = new GraphData(x, y, width, height, graphics);
        drawGraphContent();
    }
    private function drawGraphContent(){
        graphData.graphics.clear();

        // HG BG
        FlUtil.quickBeginFill(graphData.graphics, 0x53000000);
        graphData.graphics.drawRect(0, 0, graphData.width, graphData.height);
        graphData.graphics.endFill();

        //HG Bottom Line
        FlUtil.quickBeginFill(graphData.graphics, 0x53b00fff);
        graphData.graphics.drawRect(0, graphData.height-2, graphData.width, 2);
        graphData.graphics.endFill();

        //HG Middle Line
        FlUtil.quickBeginFill(graphData.graphics, 0x53b00fff);
        graphData.graphics.drawRect(0, graphData.height/2+0.75, graphData.width, 1.5);
        graphData.graphics.endFill();

        //HG Top Line
        FlUtil.quickBeginFill(graphData.graphics, 0x53b00fff);
        graphData.graphics.drawRect(0, 0, graphData.width, 2);
        graphData.graphics.endFill();

        // Note Squares
        var noteShit:Array<Note.NoteUtil> = PlayState.instance.notesMS;
        if (noteShit.length > 0){
            for (i in 0...noteShit.length-1){
                if (Std.isOfType(noteShit[i].noteStrumTime, Float) && !noteShit[i].noteIsSustain){
                    var noteXPos:Float = (noteShit[i].noteStrumTime/PlayState.instance.songLength)*(graphData.width);
                    var noteYPos:Float = graphData.height/2-1+(
                        (noteShit[i].noteMS/Conductor.safeZoneOffset)*(graphData.height/2-20)
                    );
                    var noteColor:FlxColor = 0xFFffffff;
                    switch(noteShit[i].noteRating){
                        case 'sick':
                            noteColor = 0xFF33FFA1;
                        case 'good':
                            noteColor = 0xFF7DFF00;
                        case 'bad':
                            noteColor = 0xFFFFB700;
                        case 'shit':
                            noteColor = 0xFFFF4E33;
                        case 'miss':
                            noteColor = 0xFFff0000;
                        case 'unknown':
                            noteColor = 0xFFffffff;
                    }
                    FlUtil.quickBeginFill(graphData.graphics, noteColor);
                    graphData.graphics.drawRect(noteXPos, noteYPos, 5, 5);
                    graphData.graphics.endFill();
                }
            }
        }
    }
    public function toFlFlxSprite():FlFlxSprite{
        return FlUtil.toFlFlxSprite(graphData, this);
    }
}

class HitGraph2 extends Sprite {
    public var graphData:GraphData;
    public function new(x:Float, y:Float, width:Int, height:Int){
        super();
        graphData = new GraphData(x, y, width, height, graphics);
        drawGraphContent();
    }
    private function drawGraphContent(){
        graphData.graphics.clear();
        
        // HG BG
        FlUtil.quickBeginFill(graphData.graphics, 0x53000000);
        graphData.graphics.drawRect(0, 0, graphData.width, graphData.height);
        graphData.graphics.endFill();

        // StrumLines
        for (strum in 0...4){
            FlUtil.quickBeginFill(graphData.graphics, 0x53b00fff);
            graphData.graphics.drawRect(0, (height/5)*(strum+1), graphData.width, 1);
            graphData.graphics.endFill();
        }

        // Note Squares
        var noteShit:Array<Note.NoteUtil> = PlayState.instance.notesMS;
        if (noteShit.length > 0){
            for (i in 0...noteShit.length-1){
                var noteXPos:Float = (noteShit[i].noteStrumTime/PlayState.instance.songLength)*(graphData.width);
                var noteYPos:Float = Math.min(Math.max((height/5)*(noteShit[i].noteData+1), 0), height);
                var noteColor:FlxColor = 0xFFffffff;
                switch(noteShit[i].noteRating){
                    case 'sick':
                        noteColor = 0xFF33FFA1;
                    case 'good':
                        noteColor = 0xFF7DFF00;
                    case 'bad':
                        noteColor = 0xFFFFB700;
                    case 'shit':
                        noteColor = 0xFFFF4E33;
                    case 'miss':
                        noteColor = 0xFFff0000;
                    case 'unknown':
                        noteColor = 0xFFffffff;
                }
                FlUtil.quickBeginFill(graphData.graphics, noteColor);
                if (!noteShit[i].noteIsSustain){
                    FlUtil.d2AngledRect(graphData.graphics, noteXPos, noteYPos-3.75, 7.5, 7.5);
                }else{
                    graphData.graphics.drawRect(noteXPos, noteYPos-0.75, 5, 1.25);
                }
                graphData.graphics.endFill();
            }
        }
    }
    public function toFlFlxSprite():FlFlxSprite{
        return FlUtil.toFlFlxSprite(graphData, this);
    }
}

class ResultScreen extends MusicBeatSubstate {
    public static var force:Bool = false;

    public function new(){
        var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0x53000000);
        var hitGraph1:FlFlxSprite = new HitGraph(FlxG.width-1010, 100, 1000, 189).toFlFlxSprite();
        hitGraph1.scrollFactor.set();

        var hitGraph2:FlFlxSprite = new HitGraph2(FlxG.width-1010, 310, 1000, 189).toFlFlxSprite();
        hitGraph2.scrollFactor.set();

        var noteShit:Array<Note.NoteUtil> = PlayState.instance.notesMS;
        var maxNotes:Array<Float> = [];
        for (i in 0...noteShit.length){
            if (!noteShit[i].noteIsSustain)
                maxNotes.push(i);
        }

        var sicksBar:OutlinedCherryBar = new OutlinedCherryBar(20, 100, 200, 28, 8, maxNotes.length, 0xFF33FFA1, 0xFF200020, 'SICKS');
        sicksBar.curAmount = PlayState.instance.sicks;

        var goodsBar:OutlinedCherryBar = new OutlinedCherryBar(20, 138, 200, 28, 8, maxNotes.length, 0xFF7DFF00, 0xFF200020, 'GOODS');
        goodsBar.curAmount = PlayState.instance.goods;

        var badsBar:OutlinedCherryBar = new OutlinedCherryBar(20, 176, 200, 28, 8, maxNotes.length, 0xFFFFB700, 0xFF200020, 'BADS');
        badsBar.curAmount = PlayState.instance.bads;

        var shitsBar:OutlinedCherryBar = new OutlinedCherryBar(20, 214, 200, 28, 8, maxNotes.length, 0xFFFF4E33, 0xFF200020, 'SHITS');
        shitsBar.curAmount = PlayState.instance.shits;

        var missesBar:OutlinedCherryBar = new OutlinedCherryBar(20, 252, 200, 28, 8, maxNotes.length, 0xFFFF0000, 0xFF200020, 'MISSES');
        missesBar.curAmount = PlayState.instance.songMisses;

        var bestCombo = PlayState.instance.bestCombo;
        var comboBar:OutlinedCherryBar = new OutlinedCherryBar(FlxG.width-1010, 510, 992, 25, 8, maxNotes.length, 0xFF7700fc, 0xFF200020, 'COMBO');
        comboBar.extraText = ' - ($bestCombo/'+maxNotes.length+')';
        comboBar.curAmount = bestCombo;

        var scoreBar:OutlinedCherryBar = new OutlinedCherryBar(FlxG.width-1010, 545, 992, 25, 8, maxNotes.length*350, 0xFF857cff, 0xFF200020, 'SCORE');
        scoreBar.extraText = ' - ('+PlayState.instance.songScore+'/'+maxNotes.length*350+')';
        scoreBar.curAmount = PlayState.instance.songScore;

        var healthBar:OutlinedCherryBar = new OutlinedCherryBar(FlxG.width-1010, 580, 992, 25, 8, 2, PlayState.instance.healthBar1.color, 0xFF200020, 'HEALTH');
        healthBar.curAmount = PlayState.instance.health;

        var lateText:FlxText = new FlxText(hitGraph1.x, hitGraph1.y-18, 0, 'LATE: '+Math.floor(Conductor.safeZoneOffset), 14);
        lateText.setFormat(Paths.font("vcr.ttf"), 14, 0x60b00fff, CENTER, FlxTextBorderStyle.OUTLINE, 0x80200020);

        var middleText:FlxText = new FlxText(hitGraph1.x-30, hitGraph1.y+hitGraph1.height/2-8, 0, '0MS', 14);
        middleText.setFormat(Paths.font("vcr.ttf"), 14, 0x60b00fff, CENTER, FlxTextBorderStyle.OUTLINE, 0x80200020);

        var earlyText:FlxText = new FlxText(hitGraph1.x, hitGraph1.y+hitGraph1.height, 0, 'EARLY: '+ Math.floor(-Conductor.safeZoneOffset), 14);
        earlyText.setFormat(Paths.font("vcr.ttf"), 14, 0x60b00fff, CENTER, FlxTextBorderStyle.OUTLINE, 0x80200020);

        var paRatio:FlxText = new FlxText(hitGraph1.x+hitGraph1.width, hitGraph1.y-18, 0, 'PA: '+Math.floor(PlayState.instance.sicks/PlayState.instance.goods), 14);
        paRatio.x -= paRatio.width;
        paRatio.setFormat(Paths.font("vcr.ttf"), 14, 0x60b00fff, CENTER, FlxTextBorderStyle.OUTLINE, 0x80200020);

        var bbColor:FlxColor = 0xFFffffff;
        switch(PlayState.instance.ratingFC){
            case 'SFC':
                bbColor = 0xFF33ffa1;
            case 'GFC':
                bbColor = 0xFF4dff69;
            case 'FC':
                bbColor = 0xFFa0ff53;
            case 'SDCB':
                bbColor = 0xFF7DFF00;
            case 'Clear':
                bbColor = 0xFFd1d102;
        }

        var noteHitsBar:OutlinedCherryBar = new OutlinedCherryBar(20, 461, 200, 28, 8, 100, bbColor, 0xFF200020, PlayState.instance.ratingFC);
        noteHitsBar.curAmount = PlayState.instance.ratingPercent*100;

        var songDisplayGraphic = new FlxSprite(20, 310).makeGraphic(208, 189, 0xFF200020);
        var songName:FlxText = new FlxText(songDisplayGraphic.getMidpoint().x+7, songDisplayGraphic.y, 0, PlayState.SONG.song.toUpperCase()+'\n'+CoolUtil.difficulties[PlayState.storyDifficulty].toUpperCase()+'\n', 18);
        songName.x -= songName.width/2;
        songName.setFormat(Paths.font("vcr.ttf"), 18, 0x60b00fff, CENTER, FlxTextBorderStyle.OUTLINE, 0x80200020);
        if (songName.width > songDisplayGraphic.width-5){
            songName.setGraphicSize(Std.int(songDisplayGraphic.width-5), Std.int(songName.height));
            songName.updateHitbox();
        }

        var judgementShit:FlxText = new FlxText(22.5, songDisplayGraphic.getMidpoint().y, 0, 'SICKS: '+PlayState.instance.sicks+'\nGOODS: '+PlayState.instance.goods+'\nBADS: '+PlayState.instance.bads+'\nSHITS: '+PlayState.instance.shits+'\nMISSES: '+PlayState.instance.songMisses+'\n', 17);
        judgementShit.y = songDisplayGraphic.y+songDisplayGraphic.height/2-judgementShit.height/2+40;
        judgementShit.setFormat(Paths.font("vcr.ttf"), 17, 0xFF200020, LEFT, FlxTextBorderStyle.OUTLINE, 0xFFffffff);

        //shit is so fucking messed up -(judgementShit, songName)
        super();
        add(bg);
        add(hitGraph1);
        add(hitGraph2);

        add(sicksBar);
        add(goodsBar);
        add(badsBar);
        add(shitsBar);
        add(missesBar);

        add(comboBar);
        add(scoreBar);
        add(healthBar);

        add(lateText);
        add(middleText);
        add(earlyText);
        add(paRatio);

        add(songDisplayGraphic);
        add(songName);
        add(judgementShit);
        add(noteHitsBar);
        
        cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
    }
   override function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.ENTER){
            close();
            force = true;
            PlayState.instance.endSong();
        }
   }
}

class FlFlxSprite extends FlxSprite { // didnt want to repeat the proccess over and over again
    public var flashSprite:Sprite;
    public function new(x:Float, y:Float, width:Int, height:Int, flSprite:Sprite){
        super(x, y);
        flashSprite = flSprite;
        makeGraphic(width, height, 0x00000000, true);
        pixels.draw(flSprite);
    }
}

class FlUtil {
    public static function quickBeginFill(flashGFX:Graphics, color:FlxColor, lineTrans:Bool = true){
        flashGFX.lineStyle(1, color.to24Bit(), lineTrans ? 0 : color.alphaFloat);
        flashGFX.beginFill(color.to24Bit(), color.alphaFloat);
    }
    public static function toFlFlxSprite(graphData:GraphData, sprite:Sprite){
        var piss:FlFlxSprite =  new FlFlxSprite(graphData.x, graphData.y, graphData.width, graphData.height, sprite);
        return piss;
    }
    public static function d2AngledRect(flashGFX:Graphics, x:Float, y:Float, width:Float, height:Float){
        flashGFX.moveTo(x, y+height/2);
        flashGFX.lineTo(x+width/2, y+height);
        flashGFX.lineTo(x+width, y+height/2);
        flashGFX.lineTo(x+height/2, y);
    }
}

class OutlinedCherryBar extends FlxSprite { // yay my cherry bar class
    private var displayColor:FlxSprite;
    private var textShit:FlxText;

    private var lerpedValue:Float = 0;
    private var barData:Map<String, Float>;

    private var percent(get, never):Float;
    private var txt:String;

    public var curAmount:Float;
    public var extraText:String = '';
    
    public function new(x:Float, y:Float, maxWidth:Int, height:Int, depth:Float, maxAmount:Float = 1, colourIn:FlxColor, colourOut:FlxColor, text:String){
        super(x, y);
        makeGraphic(maxWidth+Std.int(depth), height+Std.int(depth), colourOut, true);

        displayColor = new FlxSprite(x+depth/2, y+depth/2).makeGraphic(1, height, colourIn, true);

        textShit = new FlxText(x+depth, y+depth, 0, text+': 0%'+extraText, 14);
        textShit.setFormat(Paths.font("vcr.ttf"), 14, colourOut, CENTER, FlxTextBorderStyle.OUTLINE, colourIn);
        textShit.x = x+(width-depth)/2-textShit.width/2;
        textShit.y = y+(height+depth)/2-textShit.height/2;

        barData = ["x" => x, "y" => y, "width" => maxWidth, "height" => height, "depth" => depth, "max" => maxAmount];
        txt = text;
    }
    override function update(elapsed:Float){
        super.update(elapsed);

        if (lerpedValue != curAmount)
            lerpedValue = flixel.math.FlxMath.lerp(lerpedValue, Math.min(curAmount, barData.get("max")), elapsed*3.75);
        var valuePercent:Float = 0;
        if ((lerpedValue/barData.get("max")) >= 0.9999 && barData.get("max") == curAmount)
            valuePercent = 1;
        else
            valuePercent = (lerpedValue/barData.get("max"));
        if (Math.isNaN(valuePercent)) valuePercent = 0;

        displayColor.setGraphicSize(Std.int(barData.get("width")*valuePercent), Std.int(barData.get("height")));
        displayColor.updateHitbox();
        displayColor.x = barData.get("x")+barData.get("depth")/2;


        var piss:String = Format.float(valuePercent*100, 2);
        textShit.text = '$txt: $piss%$extraText';
        textShit.x = x+(width-barData.get("depth"))/2-textShit.width/2;
        textShit.y = y+height/2-textShit.height/2;
    }
    override function draw(){
        super.draw();
        displayColor.draw();
        displayColor.cameras = cameras;
        displayColor.scrollFactor = scrollFactor;

        textShit.draw();
        textShit.cameras = cameras;
        textShit.scrollFactor = scrollFactor;
    }
    public function get_percent():Float{
        return (curAmount/barData.get("max"))*100;
    }
}

class Format { // i made this cause i wanted to errr do something like string.format('%.2f', float) in haxe
    public static function float(string:Dynamic, floatNum:Int = 1){
        var pissArray:Array<String> = Std.string(string).split('.');
        var piss:String = Std.string(string).substr(pissArray[0].length).substr(1, floatNum);
        if (pissArray[1] == null){ 
            var heeha:String = '';
            for (i in 0...floatNum)
                heeha += '0';
            piss = Std.string(string).substr(pissArray[0].length)+heeha; 
        }
        return pissArray[0]+'.'+piss;
    }
}