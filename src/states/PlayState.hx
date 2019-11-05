package states;

import zero.utilities.Vec2;
import js.Cookie;
import objects.Background;
import objects.Sky;
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
import particles.Poofs;
import particles.Confetti;

class PlayState extends Container {

	public static var instance:PlayState;

	public var player:objects.Player;
	public var stack:objects.Stack;
	public var instructions:BitmapText;
	public var score:BitmapText;
	public var score_amt(default, set):Int = 0;
	public var fader:Sprite;
	public var poofs:Poofs;
	public var confetti:Confetti;
	public var sky:Sky;
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
		addChild(sky = new Sky());
		addChild(stack = new objects.Stack());
		addChild(poofs = new Poofs());
		addChild(player = new objects.Player());
		addChild(fader = Background.make_dark());
		addChild(score = new BitmapText('0', {
			font: 'Oduda',
			align: CENTER
		}));
		addChild(confetti = new Confetti());
		addChild(get_instructions());
		fader.to(1, { alpha: 0 });
		score.scale.set(0);
		score.rotation = -0.1;
		score.to(2, { rotation: 0.1, yoyo: true, repeat: -1, ease:Sine.easeInOut });
		score.anchor.set(0.5);
		score.position.set(App.i.renderer.width/2, 128);
	}

	function get_instructions():BitmapText {
		instructions = new BitmapText('Tap anywhere to begin!', {
			font: 'MainText',
			tint: 0x0858c1,
		});
		instructions.anchor.set(0.5);
		var resize = (?_) -> instructions.position.set(App.i.renderer.width/2, App.i.renderer.height - 128);
		resize();
		resize.register_listener('resize');
		instructions.scale.set(0);
		instructions.scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut, delay: 0.5 });
		return instructions;
	}

	public function begin() {
		score.scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut });
		instructions.scale.to(0.5, { x: 0, y: 0, ease: Back.easeIn });
	}

	public function resize(?_:{width:Float, height:Float}) {
		score.x = App.i.renderer.width/2;
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
		Timer.get(1, () -> {
			score.scale.to(0.5, { x: 2, y: 2, ease: Elastic.easeOut });
			for (i in 0...8) {
				var v:Vec2 = [1200];
				v.angle = i * 360/8;
				poofs.fire({
					position: [App.i.renderer.width/2 + 16, App.i.renderer.height * 0.3],
					velocity: v,
					timer: 1
				});
			}
		});
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
				on_tap: () -> reload()
			});
			retry.position.set(App.i.renderer.width/2, App.i.renderer.height - 128);
			retry.scale.set(0);
			retry.scale.to(0.5, { x: 1, y: 1, ease: Elastic.easeOut });
			addChild(retry);
			addChild(new objects.Info(App.i.renderer.width/2, App.i.renderer.height * 0.6));
		});
	}

	function reload() {
		//Browser.document.location.reload();
		App.i.stage.removeChildren();
		App.i.stage.addChild(new PlayState());
	}

}