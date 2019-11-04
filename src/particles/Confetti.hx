package particles;

import zero.utilities.Timer;
import zero.utilities.Vec2;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import particles.Poofs.FireOptions;

class Confetti extends Container {
	function make():ConfettiPiece {
		var p = new ConfettiPiece();
		addChild(p);
		return p;
	}
	function get():ConfettiPiece {
		children.shuffle();
		for (child in children) if (!child.visible) return cast child;
		return make();
	}
	public function fire(options:FireOptions) {
		get().fire(options);
	}
}

class ConfettiPiece extends Graphics {
	var colors = [0xa864fd, 0x29cdff, 0x78ff44, 0xff718d, 0xfdff6a, 0xffffff];
	var velocity:Vec2;
	public function new() {
		super();
		beginFill(colors.get_random());
		drawCircle(0, 0, 8);
		endFill();
		visible = false;
		update.register_listener('update');
	}
	public function fire(options:FireOptions) {
		trace('confetti!');
		visible = true;
		alpha = 0;
		this.to(options.timer * 0.5, { alpha: 1, onComplete: () -> {
			Timer.get(options.timer * 0.5, () -> this.to(0.5, { alpha: 0, onComplete: () -> visible = false }));
		}});
		position.set(options.position.x, options.position.y);
		velocity = options.velocity;
	}
	function update(?dt:Float) {
		if (!visible) return;
		x += velocity.x * dt;
		y += velocity.y * dt;
		velocity.y += 500 * dt;
	}
}