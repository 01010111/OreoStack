package util;

import js.lib.Date;
import js.Browser;

class Cookie {

	static var map:Map<String, String> = [];

	public static function get(key:String):String return map.exists(key) ? map[key] : '';
	public static function set(key:String, value:String) map.set(key, value);
	public static function load() for (cookie in Browser.document.cookie.split(';')) map.set(cookie.split('=')[0], cookie.split('=')[1]);
	
	public static function save(exp_days:Int) {
		var d = new Date().getTime() + exp_days * 24 * 60 * 60 * 1000;
		map.set('expires', d.string());
		var cookie = '';
		for (key => value in map) cookie += '$key=$value;';
		Browser.document.cookie = cookie;
	}

}