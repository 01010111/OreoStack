package util;

import js.Browser;
import zero.utilities.Timer;

class UpdateManager {
	static var last = 0.0;
	public static function add(fn:?Dynamic -> Void) fn.register_listener('update');
	public static function remove(fn:?Dynamic -> Void) fn.deregister_listener('update');
	public static function update(time:Float) {
		'update'.dispatch(get_dt(time));
		Browser.window.requestAnimationFrame(update);
	}
	static function get_dt(time:Float):Float {
		var out = (time - last) / 1000;
		last = time;
		return out;
	}
}