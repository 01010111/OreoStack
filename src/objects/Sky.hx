package objects;

import pixi.core.graphics.Graphics;
import com.greensock.easing.Quad;
import pixi.core.sprites.Sprite;
import pixi.core.display.Container;

class Sky extends Container {

	var moon_x:Float;
	var moon_y:Float;

	public function new() {
		super();
		moon_x = App.i.renderer.width/4;
		moon_y = -128;
		for(i in 0...32) add_star(App.i.renderer.width.get_random(), -(App.i.renderer.height * 2).get_random_gaussian(0) + 128, 32.get_random_gaussian(8, 4).to_int());
		add_moon(moon_x, moon_y);
		alpha = 0.1;
	}

	function add_moon(x:Float, y:Float) {
		var moon = Sprite.fromImage('images/moon.png');
		moon.scale.set(0.4);
		moon.anchor.set(0.5);
		moon.position.set(x, y);
		addChild(moon);
	}

	function add_star(x:Float, y:Float, size:Int) {
		if ((x - moon_x).abs() < 64 && (y - moon_y).abs() < 64) return;
		var star = Sprite.fromImage('images/star.png');
		var time = 3.get_random_gaussian(1, 2);
		star.anchor.set(0.5);
		star.scale.set(0);
		star.alpha = 0;
		star.position.set(x, y);
		star.to(time, { alpha: 1, ease: Quad.easeIn, repeat: -1, yoyo: true });
		star.scale.to(time, { x: size/32, y: size/32, ease: Quad.easeIn, repeat: -1, yoyo: true });
		addChild(star);
	}

	public function move() {
		this.to(0.5, { y: y + StackItem.item_height * 0.25, alpha: alpha + 0.05, ease: Quad.easeOut });
	}

}