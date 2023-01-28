package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

class Test extends MusicBeatState {
   public var player:Player = new Player(0, FlxG.height-200);
   public var gameObjects:FlxTypedGroup<GameObject> = new FlxTypedGroup<GameObject>();
   override function create() {
        super.create();
        var bg:FlxSprite = new FlxSprite();
        bg.frames = Paths.getSparrowAtlas('game/Green_Hill_Zone');
        bg.animation.addByPrefix('bgloop', 'green hill zone bg_', 24, true);
        bg.animation.play('bgloop');
        bg.setGraphicSize(FlxG.width, FlxG.height);
        add(bg);
        
        add(gameObjects);

        var wall:GameObject = new GameObject(0, FlxG.height-100, FlxObject.FLOOR);
        wall.makeGraphic(FlxG.width, 100, 0xFFffffff);
        gameObjects.add(wall);

        var platform:GameObject = new GameObject(0, FlxG.height-300, FlxObject.FLOOR);
        platform.makeGraphic(300, 100, 0xFFffffff);
        gameObjects.add(platform);

        player.y = player.height+100;
        add(player);
   }
   override function update(elapsed:Float){
        super.update(elapsed);
        FlxG.collide(player, gameObjects);
        player.updateMovements(elapsed);
   }
}

class Player extends FlxSprite {
    public var isJumping:Bool = false;
    public var spinDashTime:Float = 0;
    public var spinDashReset:Bool = false;
    public var gravity:Float = 1300;

    private var pressedSpace:Bool = false;

    public function new(X:Float, Y:Float){
        super(X, Y);
        frames = Paths.getSparrowAtlas('game/Intro_Sonic');
        animation.addByPrefix('idle', 'Idling', 24, false);
        animation.addByPrefix('jump', 'Jumping', 24, true);
        animation.addByPrefix('walk', 'Walking', 24, true);
        animation.addByPrefix('run', 'Running', 24, true);
        animation.play('idle');
    }
   public function updateMovements(elapsed:Float) {
        acceleration.y = 180;
        maxVelocity.y = 180;

        if (!FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.LEFT)
            velocity.x = 0;

        if (FlxG.keys.justPressed.SPACE && isTouching(FlxObject.FLOOR)){
            acceleration.y = 0;
            velocity.y = -gravity/1.1;
            playAnimation('jump');
        }

        if (FlxG.keys.justReleased.X)
            spinDashReset = true;

        if (spinDashReset){
            spinDashTime = Math.max(spinDashTime-elapsed, 0);
            if (spinDashTime <= 0){
                playAnimation('idle');
                spinDashReset = false;
            }else{
                playAnimation('run');
                velocity.x = (facing == LEFT ? -600 : 600);
            }
        }

        if (FlxG.keys.justPressed.RIGHT){ facing = RIGHT; velocity.x = 100; };
        if (FlxG.keys.justPressed.LEFT){ facing = LEFT; velocity.x = -100; };

        if (FlxG.keys.pressed.X)
            spinDashTime = Math.min(spinDashTime+elapsed, 3);
        else{
            if (FlxG.keys.pressed.RIGHT){
                velocity.x = Math.min(velocity.x+5, 580);
            }
            if (FlxG.keys.pressed.LEFT){
                velocity.x = Math.max(velocity.x-5, -580);
            }
            if (isTouching(FlxObject.FLOOR)){
                if (velocity.x > 380 || velocity.x < -380 && (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT))
                    playAnimation('run');
                else if (velocity.x != 0)
                    playAnimation('walk', true);
                if (spinDashReset && FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
                    spinDashTime = 0;
            }
        }
        
        if (FlxG.keys.justReleased.RIGHT || FlxG.keys.justReleased.LEFT)
            playAnimation('idle');
        flipX = (facing == LEFT ? true : false);
   }
   public function playAnimation(anim:String, forceToPlay:Bool = false, force:Bool = false, ignoreAnims:Bool = true){
        if (!ignoreAnims) if (!animation.curAnim.finished) return;
        var forcedToRepeat:Bool = (force ? true : ((animation.curAnim.name != anim) ? true : false));
        if (forcedToRepeat)
            animation.play(anim, forceToPlay);
   }
}

class GameObject extends FlxSprite {
    public function new(X:Float, Y:Float, type){
        super(X, Y);
        immovable = true;
        facing = type;
    }
}