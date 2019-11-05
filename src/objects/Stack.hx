package objects;

import zero.utilities.Vec2;
import pixi.core.sprites.Sprite;
import com.greensock.easing.Linear;
import states.PlayState;
import pixi.core.display.DisplayObject;
import com.greensock.easing.Elastic;
import zero.utilities.Color;
import pixi.core.graphics.Graphics;
import zero.utilities.Timer;
import com.greensock.easing.Quad;
import pixi.core.display.Container;

class Stack extends Container {

	public var top_item:StackItem;
	public var incoming_direction:IncomingDirection = LEFT;
	var items:Array<StackItem> = [];
	var state:StackState = SOLID;
	var top_pos:Float;
	var item_tween:TweenMax;
	var scale_tween:TweenMax;
	var has_moved = false;

	public function new() {
		super();
		add_floor();
		add_items();
		var resize = (?_) -> x = App.i.renderer.width/2;
		resize.register_listener('resize');
		resize();
		y = App.i.get_midscreen();
		top_pos = 0;
	}

	function add_floor() {
		var floor = Sprite.fromImage('images/floor_0.png');
		floor.anchor.set(0.5, 0);
		floor.position.set(0, -244);
		floor.alpha = 0.5;
		var resize = (?_) -> {
			floor.scale.set(App.i.renderer.width/128, 10);
		}
		resize.register_listener('resize');
		resize();
		addChild(floor);
	}

	function add_items() {
		for (i in 0...32) items.push(addChild(new StackItem()));
	}

	public function move() {
		if (!has_moved) return;
		PlayState.instance.sky.move();
		this.to(0.5, { y: y + StackItem.item_height, ease: Quad.easeOut });
	}

	public function move_top_item() {
		has_moved = true;
		var item = items.pop();
		items.unshift(item);
		setChildIndex(item, children.length - 1);
		top_pos -= StackItem.item_height;
		item.position.set(get_item_x(incoming_direction), top_pos - 32);
		item.scale.set(0.75, 0.75);
		item.scale.x = 0.75;
		item.scale.y = 0.75;
		trace('${item.scale.x}');
		var time = 5.get_random_gaussian(1, 2);
		item.rotation = incoming_direction == LEFT ? -0.1 : 0.1;
		var rotation_target = incoming_direction == LEFT ? 0.1 : -0.1;
		item_tween = item.to(time, { x: get_item_x(get_opposite_d()), y: item.y + 32, rotation: rotation_target, ease: Linear.easeNone });
		scale_tween = item.scale.to(time, { x: 1.25, y: 1.25, ease: Linear.easeNone });
		incoming_direction = get_opposite_d();
		top_item = item;
	}

	function get_item_x(d:IncomingDirection):Float {
		var out = App.i.renderer.width/2;
		out += StackItem.item_width;
		out *= (d == LEFT ? -1 : 1);
		return out;
	}

	function get_opposite_d():IncomingDirection {
		return incoming_direction == LEFT ? RIGHT : LEFT;
	}

	public function is_solid():Bool {
		if (!has_moved) return true;
		var solid = top_item.x.abs() < StackItem.item_width/2;
		if (top_item.x.abs() < 16) shoot_confetti();
		return solid;
	}

	function shoot_confetti() {
		PlayState.instance.score_amt += 9;
		for (i in 0...16) {
			var v:Vec2 = [20.get_random(-20), -(3000.get_random(1600))];
			PlayState.instance.confetti.fire({
				position: [App.i.renderer.width.get_random(), App.i.renderer.height.get_random()],
				velocity: v,
				timer: 0.25,
			});
		}
		Timer.get(0.4, () -> {
			for (i in 0...48) {
				var v:Vec2 = [400.get_random(200)];
				v.angle = 135.get_random_gaussian(45);
				PlayState.instance.confetti.fire({
					position: [App.i.renderer.width.get_random(), App.i.renderer.height.get_random(-512)],
					velocity: v,
					timer: 1.5,
				});
			}
		});
	}

	public function cancel_tween() {
		if (item_tween != null) item_tween.kill();
		if (scale_tween != null) scale_tween.kill();
		var i = 0.01;
		var a = children.copy();
		a.reverse();
		var i = 0;
		for (child in a) if (i++ < 10) Timer.get(i++ * 0.05, () -> {
			if (child != top_item && items.indexOf(cast child) >= 0) {
				child.scale.set(1.04);
				child.scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut });
			}
		});
		if (has_moved) PlayState.instance.score_amt++;
		move_top_item();
	}

}

enum StackState {
	SOLID;
	MOVING;
}

enum IncomingDirection {
	LEFT;
	RIGHT;
}