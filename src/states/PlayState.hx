package states;

import js.Cookie;
import objects.Background;
import pixi.core.sprites.Sprite;
import js.Browser;
import js.html.Document;
import zero.utilities.Color;
import zero.utilities.Timer;
import com.greensock.easing.Back;
import com.greensock.easing.Sine;
import com.greensock.easing.Elastic;
import pixi.extras.BitmapText;
import pixi.core.display.Container;

class PlayState extends Container {

	public static var instance:PlayState;

	public var player:objects.Player;
	public var stack:objects.Stack;
	public var score:BitmapText;
	public var score_amt(default, set):Int = 0;
	public var fader:Sprite;
	function set_score_amt(n:Int):Int {
		score.text = '$n';
		score.scale.set(1.5);
		score.scale.to(0.75, { x: 1, y: 1, ease: Elastic.easeOut });
		return score_amt = n;
	}

	public function new() {
		instance = this;
		super();
		scale.set(0.5);
		resize.register_listener('resize');
		addChild(objects.Background.make());
		addChild(stack = new objects.Stack());
		addChild(player = new objects.Player());
		addChild(fader = Background.make());
		addChild(score = new BitmapText('0', {
			font: 'Oduda',
			align: CENTER
		}));
		fader.to(1, { alpha: 0 });
		score.scale.set(0);
		score.rotation = -0.1;
		score.to(2, { rotation: 0.1, yoyo: true, repeat: -1, ease:Sine.easeInOut });
		score.anchor.set(0.5);
		score.position.set(App.i.renderer.width/2, 128);
	}

	public function resize(?_:{width:Float, height:Float}) {
		
	}

	public function end() {
		var hi = Cookie.get('top').parseInt();
		if (hi == null) hi = 0;
		if (score_amt > hi) {
			hi = score_amt;
			Cookie.set('top', score_amt.string(), 365 * 10 * 24 * 60 * 60);
		}
		trace('hi score: $hi');
		fader.to(5, { alpha: 0.75 });
		score.to(1, { y: App.i.renderer.height * 0.3, ease: Back.easeOut });
		score.scale.to(0.5, { x: 1.5, y: 1.5, ease: Elastic.easeOut, delay: 1.25 });
		Timer.get(1.75, () -> {
			var hi = new BitmapText('Hi Score: $hi', {
				font: 'MainText',
				tint: 0xFFFFFF,
			});
			hi.anchor.set(0.5);
			hi.position.set(App.i.renderer.width/2, App.i.renderer.height - 224);
			hi.scale.set(0);
			hi.scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut, delay: 0.25 });
			addChild(hi);
			var retry = new objects.Button({
				color: [1,1,1,1],
				text_color: Color.PICO_8_BLUE,
				text: 'RETRY',
				on_tap: () -> Browser.document.location.reload()
			});
			retry.position.set(App.i.renderer.width/2, App.i.renderer.height - 128);
			retry.scale.set(0);
			retry.scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut });
			addChild(retry);
		});
	}

}