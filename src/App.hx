import pixi.core.display.Container;
import util.UpdateManager;
import util.ResizeManager;
import zero.utilities.SyncedSin;
import zero.utilities.ECS;
import zero.utilities.Timer;
import webfont.WebFontLoader;
import pixi.loaders.Loader;
import js.Browser;

class App extends pixi.core.Application {

	public static var i:App;

	// Add assets here
	static var fonts:Array<String> = [];
	static var assets:Array<String> = [
		'images/oreo_0.png',
		'images/oreo_1.png',
		'images/oreo_2.png',
		'images/marshmallow_0.png',
		'images/bg.png',
		'images/score.fnt',
		'images/text.fnt',
	];

	static var initial_obj:Class<Container> = states.PlayState;

	static function main() {
		// Load fonts, then load assets, then start new app
		var load_assets = () -> {
			var loader = new Loader();
			loader.add(assets.remove_duplicates());
			loader.on('complete', () -> new App());
			loader.load();
		}
		fonts.length == 0 ? load_assets() : WebFontLoader.load({
			custom: { families: fonts, urls: ['include/fonts.css'] },
			active: load_assets,
			inactive: () -> trace('uh oh'),
			timeout: 1000,
			fontloading: (family, fvd) -> trace(family)
		});
	}

	public function new() {
		// Create new Application with options
		i = this;
		super({
			resolution: 2,
			width: Browser.document.documentElement.clientWidth,
			height: Browser.document.documentElement.clientHeight,
			backgroundColor: 0x000000,
			antialias: true,
			roundPixels: true,
			clearBeforeRender: true,
			forceFXAA: true,
			powerPreference: 'high-performance',
			autoResize: true,
			legacy: false,
			transparent: false
		});
		// Add view to body
		Browser.document.body.appendChild(view);
		// Resize Handler
		Browser.window.addEventListener('resize', () -> 'resize'.dispatch({ width: Browser.document.documentElement.clientWidth, height: Browser.document.documentElement.clientHeight }));
		var resize = (?_) -> renderer.resize(_.width, _.height);
		resize.register_listener('resize');
		// Update Handler
		Browser.window.requestAnimationFrame(util.UpdateManager.update);
		var update = (?dt) -> {
			Timer.update(dt);
			ECS.tick(dt);
			SyncedSin.update(dt);
		}
		update.register_listener('update');
		// Create and add initial object
		if (initial_obj != null) stage.addChild(Type.createInstance(initial_obj, []));
	}

	public function get_midscreen():Float {
		return renderer.height * 0.6;
	}

}
