import h2d.*;
import h2d.col.*;

enum AttackKind {
    Tentacle;
    Spit;
    Burp;
}

@:allow(Monster)
class Attack extends Sprite {
    public var kind(default, null) : AttackKind;
    public var available(get, never) : Bool;

    var cooldown : Float;
    var duration : Float;

    override function new(?parent, kind, duration) {
        super(parent);
        visible = false;
        this.kind = kind;
        this.duration = duration;
        init();
    }

    function init() {}
    function update(dt : Float) {
        if(cooldown > 0.) {
            cooldown -= dt / 60;
        }
    }
    
    function use(x : Float, y : Float) {
        this.x = x;
        this.y = y;
        cooldown = duration;
        visible = true;
    }

    function get_available() {
        return cooldown <= 0;
    }
}

@:allow(Monster)
class Tentacle extends Attack {
    
    var swipe : Anim;

    override function init() {
        var t = hxd.Res.textures.tentacle_swipe.toTile().gridFlatten(180, -90, -90);
        swipe = new Anim(t, 12, this);
        swipe.loop = false;
        swipe.onAnimEnd = function () {
            cooldown = 1;
        }
    }

    override function update(dt : Float) {
        super.update(dt);
       
    }

    override function use(x : Float, y : Float) {
        super.use(x, y);
        swipe.currentFrame = 0;
    }
}

class Monster extends Sprite {

    static inline var MAX_TENTACLES = 3;
    
    var eyeBlink : Anim;
    var eyeStand : Anim;
    var eyeAffraid : Anim;

    var mouthStand : Anim;
    var mouthEat : Anim;
    var mouthSpit : Anim;

    var eye : Sprite;
    var mouth : Sprite;

    var attacks : Array<Attack>;

    public function new(?parent) {
        super(parent);
        
        new Bitmap(hxd.Res.textures.ground_tentacles.toTile().center(), this);

        initMouth();
        initEye();
        initAttacks();
    }

    function initEye() {
        eye = new Sprite(this);

        new Bitmap(hxd.Res.textures.monster_eye.toTile().center(), eye);
        new Bitmap(hxd.Res.textures.monster_eye_iris.toTile().center(), eye);
        var reflect = new Bitmap(hxd.Res.textures.monaster_eye_reflect.toTile().center(), eye);
        reflect.x -= 24;
        reflect.y -= 10;

        var t = hxd.Res.textures.eye_anim.toTile().center().gridFlatten(200, -100, -100);
        eyeBlink = new Anim([t[0], t[1], t[2], t[3], t[4], t[3], t[2], t[1]], 12, eye);
        eyeStand = new Anim([t[0]], eye);
        eyeAffraid = new Anim([t[5], t[6], t[7], t[6]], 12, eye);
        //eyeBlink.visible = false;
        eyeStand.visible = false;
        eyeAffraid.visible = false;

        eye.y = -60;
    }

    function initMouth() {
        mouth = new Sprite(this);
        
        var t = hxd.Res.textures.mouth_anim.toTile().center().gridFlatten(200, -100, -100);
        
        mouthStand = new Anim([t[0]], mouth);
        mouthEat = new Anim([for (i in 0...10) t[i]], 12, mouth);
        mouthSpit = new Anim([for (i in 8...14) t[i]], 12, mouth);

        //mouthStand.visible = false;
        mouthEat.visible = false;
        mouthSpit.visible = false;

        mouth.y = 70;
    }

    function initAttacks() {
        attacks = [];
        attacks.push(new Tentacle(this, Tentacle, 1.));
    }

    public function swipeAt(x: Float, y : Float) {
        for(attack in attacks) {
            if(attack.kind != Tentacle) {
                continue;
            }

            if(!attack.available) {
                continue;
            }

            attack.use(x - this.x ,y - this.y);
            break;
        }
    }

    public function update(dt : Float) {
        for(attack in attacks) {
            attack.update(dt);
        }
    }
}