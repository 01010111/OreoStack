package particles;

import zero.utilities.Timer;
import pixi.core.display.Container;
import pixi.core.textures.Texture;
import zero.utilities.Vec2;
import pixi.core.sprites.Sprite;

class Poofs extends Container {
	var i:Int;
	function make():Poof {
		var p = new Poof();
		addChild(p);
		return p;
	}
	function get():Poof {
		children.shuffle();
		for (child in children) if (!child.visible) return cast child;
		return make();
	}
	public function fire(options:FireOptions) {
		get().fire(options);
	}
}

class Poof extends Sprite {

	var velocity:Vec2 = [];
	var acceleration:Vec2 = [];
	static var poof_no = 0;

	public function new() {
		super(Texture.fromImage('images/poof_${poof_no++ % 6}.png'));
		pivot.set(32, 32);
		visible = false;
		update.register_listener('update');
	}

	public function fire(options:FireOptions) {
		visible = true;
		alpha = 0.5;
		if (options.velocity == null) options.velocity = [0, 0];
		if (options.acceleration == null) options.acceleration = [0, 0];
		position.set(options.position.x, options.position.y);
		velocity.copy_from(options.velocity);
		acceleration.copy_from(options.acceleration);
		options.velocity.put();
		options.acceleration.put();
		Timer.get(options.timer, () -> this.to(0.2, {alpha: 0, onComplete: () -> visible = false }));
	}

	function update(?_) {
		if (!visible) return;
		x += velocity.x * _;
		y += velocity.y * _;
		velocity.length *= 0.9;
	}

}

typedef FireOptions = {
	?velocity:Vec2,
	?acceleration:Vec2,
	position:Vec2,
	timer:Float,
}