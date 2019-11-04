package objects;

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
	var items:Array<StackItem> = [];
	var state:StackState = SOLID;
	public var incoming_direction:IncomingDirection = LEFT;
	var top_pos:Float;
	var item_tween:TweenMax;
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
		var floor = Sprite.fromImage('images/floor.png');
		floor.scale.set(App.i.renderer.width/128, App.i.renderer.height/2/128);
		floor.position.set(-App.i.renderer.width/2, -48);
		/*var floor = new Graphics();
		floor.beginFill(0x47C9F3);
		floor.drawRect(-App.i.renderer.width, -128, App.i.renderer.width * 2, App.i.renderer.height);
		floor.endFill();*/
		addChild(floor);
	}

	function add_items() {		
		for (i in 0...10) items.push(addChild(new StackItem()));
	}

	public function move() {
		if (!has_moved) return;
		this.to(0.5, { y: y + StackItem.item_height, ease: Quad.easeOut });
	}

	public function move_top_item() {
		has_moved = true;
		var item = items.pop();
		items.unshift(item);
		setChildIndex(item, children.length - 1);
		top_pos -= StackItem.item_height;
		item.position.set(get_item_x(incoming_direction), top_pos);
		var time = 5.get_random_gaussian(1, 2);
		item.rotation = incoming_direction == LEFT ? -0.1 : 0.1;
		var rotation_target = incoming_direction == LEFT ? 0.1 : -0.1;
		item_tween = item.to(time, { x: get_item_x(get_opposite_d()), rotation: rotation_target, ease: Linear.easeNone });
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
		return (top_item.x).abs() < StackItem.item_width/2;
		return switch state {
			case SOLID: true;
			case MOVING: (top_item.x - App.i.renderer.width/2).abs() < StackItem.item_width/2;
		}
	}

	public function cancel_tween() {
		if (item_tween != null) item_tween.kill();
		var i = 0.01;
		var a = children.copy();
		a.reverse();
		for (child in a) Timer.get(i++ * 0.05, () -> {
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