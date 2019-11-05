package objects;

import zero.utilities.Vec2;
import com.greensock.easing.Elastic;
import zero.utilities.Color;
import pixi.extras.BitmapText;
import pixi.core.graphics.Graphics;

class Info extends Graphics {

	var padding:Float = 64;

	static var info_table:Array<String> = [
		'Did you know that if you stacked every Oreo cookie ever eaten, they would reach the moon ten times over?',
		'Landing on an Oreo perfectly will get you 10 points instead of one!',
		'You can tap to jump, but did you know you can hold your finger down to jump higher?',
		'The Oreo cookie celebrated its hundredth birthday in 2012!',
		'You would need about 250 million Oreo cookies placed side by side to go around the moon!'
	].shuffle();

	public function new(x:Float, y:Float) {
		super();
		var info = info_table.pop();
		info_table.unshift(info);
		trace(info);
		var text = get_text(info, App.i.renderer.width - (padding * 2));
		text.anchor.set(0.5);
		text.y -= 4;
		text.scale.set((App.i.renderer.width - padding * 4) / (App.i.renderer.width - padding * 2));
		beginFill(Color.PICO_8_BLUE.to_hex_24());
		var size:Vec2 = [App.i.renderer.width - padding * 2, text.height + padding * 2];
		drawRoundedRect(-size.x/2, -size.y/2, size.x, size.y, 16);
		endFill();
		addChild(text);
		scale.set(0);
		scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut, delay: 0.25 });
		position.set(x, y);
	}

	function get_text(text:String, max_width:Float):BitmapText {
		var style = { font: 'MainText' };
		var out = new BitmapText('', style);
		var test = new BitmapText('', style);
		for (word in text.split(' ')) {
			test.text += '$word ';
			if (test.width > max_width) {
				out.text += '\n$word ';
				test.text = out.text;
			} else {
				out.text = test.text;
			}
		}
		return out;
	}

}