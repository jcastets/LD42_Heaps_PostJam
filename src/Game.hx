import hxd.Event;
import h2d.Interactive;
import h2d.Layers;
import h2d.Sprite;
import h2d.Bitmap;

class Game extends Sprite {

    var monster : Monster;
    var layers : Layers;

    public function new(?parent) {
        super(parent);

        layers = new Layers(parent);
        initWorld();
        initMonster();
    }

    function initWorld() {

        //floor
        var floor = new Bitmap(hxd.Res.textures.bg_game.toTile());
        layers.add(floor, 0);

        var interaction = new Interactive(floor.getSize().width, floor.getSize().height, floor);
        interaction.onClick = floorClicked;
        
        //side trees
        layers.add(new Bitmap(hxd.Res.textures.fg_forest.toTile()), 100);
    }

    function initMonster() {
        monster = new Monster(this);
        layers.add(monster, 50);
        monster.x = Main.getInstance().s2d.width * 0.5;
        monster.y = Main.getInstance().s2d.height * 0.5;
    }

    public function update(dt:Float) {
        monster.update(dt);
    }

    function floorClicked (event : Event) {
        monster.swipeAt(event.relX, event.relY);
    }
}