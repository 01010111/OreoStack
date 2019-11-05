package objects;

import pixi.core.textures.Texture;
import states.PlayState;
import zero.utilities.Timer;
import objects.Stack.IncomingDirection;
import com.greensock.easing.Back;
import com.greensock.easing.Elastic;
import pixi.core.sprites.Sprite;
import zero.utilities.Vec2;
import js.Browser;
import pixi.core.graphics.Graphics;
import states.PlayState.instance as STATE;

class Player extends Graphics {

	var velocity:Vec2 = [0, 0];
	var acceleration:Vec2 = [0, 2400];
	var sprite:Sprite;
	var fall_dir:IncomingDirection;
	var first_jump:Bool = true;
	var state(default, set):PlayerState = LANDED;
	function set_state(v:PlayerState) {
		trace(v);
		switch v {
			case LANDED:
				scale.to(0.4, { x: 1, y: 1, ease: Elastic.easeOut });
				for (i in 0...4) {
					var v = Vec2.get(500);
					v.angle = 45 + i * 360/4;
					PlayState.instance.poofs.fire({
						position: [x, y] + v.copy() * 0.1 + [0, 48],
						timer: 0.5,
						velocity: v * [1, 0.25],
					});
				}
			case JUMPING:
			case KNOCKED:
				velocity.x = fall_dir == LEFT ? -200 : 200;
				velocity.y = -800;
				this.to(1.5, { rotation: fall_dir == LEFT ? -1 : 1 });
				scale.to(1.5, { x: 2, y: 2 });
				Timer.get(2, () -> PlayState.instance.end());
				sprite.texture = Texture.fromImage('images/marshmallow_1.png');
			case FALLING:
				sprite.texture = Texture.fromImage('images/marshmallow_1.png');
				Timer.get(2, () -> PlayState.instance.end());
		}
		return state = v;
	}

	public function new() {
		super();
		register_events();

		sprite = Sprite.fromImage('images/marshmallow_0.png');
		sprite.anchor.set(0.5);
		addChild(sprite);

		resize.register_listener('resize');
		position.set(App.i.renderer.width/2, App.i.get_midscreen());
	}

	function resize(?_) {
		x = App.i.renderer.width/2;
	}

	function register_events() {
		update.register_listener('update');
		Browser.window.addEventListener('pointerdown', (e) -> jump());
		Browser.window.addEventListener('pointerup', (e) -> fall());
	}

	function update(?dt:Float) {
		velocity += acceleration * dt;
		position.set(x + velocity.x * dt, y + velocity.y * dt);
		switch state {
			case LANDED: 
				position.y = App.i.get_midscreen();
				velocity.y = 0;
				check_incoming();
			case JUMPING: if (velocity.y > 0 && y >= App.i.get_midscreen()) land();
			case KNOCKED:
			case FALLING:
		}
	}

	function jump() {
		if (state != LANDED) return;
		if (first_jump) do_first_jump();
		velocity.y -= 1280;
		state = JUMPING;
		STATE.stack.move();
		scale.to(0.4, { x: 0.75, y: 1.25, ease: Back.easeOut, onComplete: () -> {
			scale.to(0.5, { x: 0.9, y: 1.1 });
		}});
	}

	function do_first_jump() {
		first_jump = false;
		PlayState.instance.begin();
	}

	function fall() {
		if (velocity.y < 0) velocity.y = 0;
	}

	function land() {
		switch state {
			case LANDED:
				bounds();
				check_incoming();
			case JUMPING:
				check_stack();
			case KNOCKED: return;
			case FALLING: return;
		}
	}

	function bounds() {
		position.y = App.i.get_midscreen();
		velocity.y = velocity.y.min(0);		
	}

	function check_stack() {
		if (!STATE.stack.is_solid()) return state = FALLING;
		STATE.stack.cancel_tween();
		return state = LANDED;
	}

	function check_incoming() {
		if (STATE.stack.top_item == null) return;
		var d = (STATE.stack.top_item.x).abs();
		var min_d = 32 + StackItem.item_width/2;
		if (d > min_d) return;
		fall_dir = STATE.stack.incoming_direction;
		state = KNOCKED;
	}

}

enum PlayerState {
	LANDED;		// when the player is standing on the stack
	JUMPING;	// when the player is mid air above the stack
	KNOCKED;	// when the next stack item knocks the player off the stack
	FALLING;	// when the player falls on a bad stack
}