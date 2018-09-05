import h2d.Anim;
import h2d.Bitmap;
import h2d.Sprite;

class Monster extends Sprite {

    var blink : Anim;

    public function new(?parent) {
        super(parent);
        //new Bitmap(hxd.Res.textures.ground_tentacles.toTile().center(), this);
        var t = hxd.Res.textures.eye_anim.toTile().center().gridFlatten(200);
        t = t.map(function(v) return v.center());
        blink = new Anim([t[0], t[1], t[2], t[3], t[4], t[3], t[2], t[1]], 16, this);
        
    }

}