package objects;

import pixi.extras.BitmapText;
import pixi.core.text.Text;
import zero.utilities.Color;
import pixi.core.graphics.Graphics;

class Button extends Graphics {

	static var button_width:Float = 512;
	static var button_height:Float = 96;

	public function new(options:ButtonOptions) {
		super();

		beginFill(options.color.to_hex_24());
		drawRoundedRect(-button_width/2, -button_height/2, button_width, button_height, button_height/2);
		endFill();

		var text = new BitmapText(options.text, {
			font: 'MainText',
			tint: options.text_color.to_hex_24(),
		});
		text.anchor.set(0.55);
		addChild(text);

		interactive = true;
		buttonMode = true;
		on('pointertap', () -> options.on_tap());
	}

}

typedef ButtonOptions = {
	color: Color,
	text_color: Color,
	text:String,
	on_tap:Void -> Void,
}