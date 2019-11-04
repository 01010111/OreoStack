package objects;

import pixi.core.sprites.Sprite;
import zero.utilities.Color;
import pixi.core.graphics.Graphics;

class StackItem extends Graphics {

	public static var item_width(default, never) = 256;
	public static var item_height(default, never) = 64;
	public var played:Bool = false;

	static var i = 0;

	public function new() {
		super();

		/*beginFill(0x5C4B42);
		drawRect(-item_width/2, 0, item_width, item_height);
		endFill();
		beginFill(0xFFFFFF);
		drawRect(-item_width/2, item_height/3, item_width, item_height/3);
		endFill();*/

		var sprite = Sprite.fromImage('images/oreo_${i++ % 3}.png');
		sprite.anchor.set(0.5, 0.1);
		addChild(sprite);

		var resize = (?_) -> if (!played) position.set(-App.i.renderer.width);
		resize.register_listener('resize');
		resize();
	}

}