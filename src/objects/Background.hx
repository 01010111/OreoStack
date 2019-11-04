package objects;

import pixi.core.sprites.Sprite;

class Background
{

	public static function make() {
		var sprite = Sprite.fromImage('images/bg.png');
		var resize = (?_:{width:Float, height:Float}) -> {
			sprite.scale.set(_.width/256, _.height/256);
		}
		resize({ width: App.i.renderer.width, height: App.i.renderer.height });
		resize.register_listener('resize');
		return sprite;
	}

}