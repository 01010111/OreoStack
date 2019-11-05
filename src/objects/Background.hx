package objects;

import pixi.core.sprites.Sprite;

class Background
{

	public static function make() {
		var sprite = Sprite.fromImage('images/floor.png');
		var resize = (?_) -> {
			trace('hi');
			sprite.scale.set(App.i.renderer.width/128, App.i.renderer.height/128);
		}
		resize();
		resize.register_listener('resize');
		return sprite;
	}

	public static function make_dark() {
		var sprite = Sprite.fromImage('images/bg.png');
		var resize = (?_) -> {
			sprite.scale.set(App.i.renderer.width/256, App.i.renderer.height/256);
		}
		resize();
		resize.register_listener('resize');
		return sprite;
	}

}