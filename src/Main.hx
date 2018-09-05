
import format.png.Data;

class Main extends hxd.App {
    
    static var instance : Main;
    var game : Game;
    
    override function init() {
        hxd.Stage.getInstance().resize(1280, 720);
        instance = this;
        s2d.setFixedSize(1920, 1080);
        game = new Game(s2d);
    }

    public var time(default, null):Float = 0;

    override function update(dt:Float) {
        game.update(dt);
        time += dt;
    }

    static function main() {
        hxd.Res.initLocal();
        new Main();
    }

    public static inline function getInstance() {
        return instance;
    }
}