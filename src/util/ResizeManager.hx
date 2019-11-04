package util;

import pixi.core.display.Container;

class ResizeManager {
	public static function add(fn:?Dynamic -> Void) fn.register_listener('resize');
	public static function remove(fn:?Dynamic -> Void) fn.deregister_listener('resize');
}