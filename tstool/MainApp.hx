package tstool;

import date.WorldTimeAPI;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
import haxe.Json;
import haxe.Timer;
import lime.utils.Assets;
import tstool.utils.XapiTracker;
import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import js.Cookie;
import openfl.display.Sprite;
import js.html.Location;
import tstool.layout.History;
import tstool.layout.Login;
import tstool.salt.SaltAgent;
import tstool.salt.Customer;
import tstool.utils.Translator;
import tstool.utils.VersionTracker;


/**
 * ...
 * @author bb
 */
typedef Config =
{
	var ?libFolder:String;
	var cookie:String;
	var scriptName:String;
}

class MainApp extends Sprite
{
	public static inline var LIB_FOLDER = "/commonlibs/";
	static inline var DEFAULT_COOKIE = "tstool";
	static inline var SCRIPT_NAME:String = "nointernet"; //historical

	static var debug:Bool;
	public static var DEBUG_EMAIL_ARRAY:Array<String>;

	static var xapiHelper:XapiTracker;

	static public var location:Location;

	static var versionTracker:VersionTracker;
	static public var translator:Translator;
	static var stack:History;
	static var cust:Customer;
	public static var agent:SaltAgent;
	static var s:Serializer;
	public static var ASSETS_VERSION:String;

	public static var config:Config;

	public static var idleTimer:Timer = new Timer(1000);
	#if debug
	static public var VERSION_TIMER_DURATION:Float = 60;
	#else
	static public var VERSION_TIMER_DURATION:Float = 300;
	#end
	static public var VERSION_TIMER_value:Float = VERSION_TIMER_DURATION;
	static public var WORD_TIME:WorldTimeAPI = new WorldTimeAPI();
	public static var LANGS:Array<String> = ["fr-FR", "de-DE", "en-GB", "it-IT"];
	public static var INTRO_PIC:String = "intro/favicon.png";

	public function new()
	{
		super();

		idleTimer.run = onTimer;
		
		location = Browser.location;
		prepareConfig();
		FlxAssets.FONT_DEFAULT =  "Consolas";


		stack = History.STACK;

		if (Cookie.exists(config.cookie))
		{

			var d = new Unserializer(Cookie.get(config.cookie));
			agent = d.unserialize();
		}
		else
		{
			agent = null;
		}

		translator = new Translator();

		xapiHelper = new XapiTracker( location.origin + config.libFolder);

        versionTracker = new VersionTracker( location.origin + config.libFolder, config.scriptName);
		if (ASSETS_VERSION != "-1")
		{
			versionTracker.addAssetsVersion(ASSETS_VERSION);
		}
		cust = new Customer();
		//agent= new Agent();
		translator.initialize("fr-FR",function(){});

	}
	/**
	 * 11.04.2023 14:32
	 * externalising in assets the config
	 */
	function prepareConfig()
	{
		var isTest = location.origin.indexOf("qook.test.salt.ch") > -1;
		var cfg = Json.parse(Assets.getText("assets/data/dev_config.json"));
		ASSETS_VERSION = cfg.assetsVersion ?? "-1";
		var c:Dynamic = isTest ? cfg.test : cfg.prod;
		debug = c.debug ?? isTest;
		DEBUG_EMAIL_ARRAY = cast(c.debug_mail) ?? ["qook@salt.ch"];
		INTRO_PIC = c.intro_pic ?? INTRO_PIC;
		config = {
			   libFolder: c.libfolder?? "/commonlibs/" ,
			   cookie: c.cookie ?? "tstoolcookie",
			   scriptName: c.scriptName ?? "tstool",
		}
	}
	function initScreen()
	{
		if (Browser.navigator.userAgent.indexOf("Firefox") == -1)
		{
			//Browser.window.alert("" + Browser.navigator.userAgent);
			addChild(new FlxGame(1400, 880, tstool.layout.Sorry, 1, 30, 30, true, true));
		}
		else
		{
			addChild(new FlxGame(1400, 880, Login, 1, 30, 30, true, true));
		}
	}
	static function onTimer()
	{
		if (VERSION_TIMER_value < 0)
		{
			Main.VERSION_TRACKER.scriptChangedSignal.addOnce(onNewVersion);
			Main.VERSION_TRACKER.request();
		}
		else
		{
			VERSION_TIMER_value--;

		}
	}
	public static function onNewVersion(needsUpdate:Bool):Void
	{
		#if debug
		//trace("MainApp::onNewVersion::needsUpdate", needsUpdate );
		#end
		if (needsUpdate)
		{
			Browser.location.reload(true);
		}
		else{
			//idleTimer.start(VERSION_TIMER_DURATION);
			VERSION_TIMER_value = VERSION_TIMER_DURATION;
		}
	}
	public static function flush()
	{
		s = new Serializer();
		agent.mainLanguage = FIND_LANG(agent.mainLanguage);
		s.serialize(agent);
		Cookie.set(config.cookie, s.toString(), 86400 * 15, config.scriptName);
	}
	public static function clearCookie()
	{
		Cookie.remove(config.cookie, config.scriptName);
		Browser.location.reload(true);
	}
	static public function setUpSystemDefault(?block:Bool = false )
	{
		FlxG.sound.soundTrayEnabled = false;
		FlxG.mouse.useSystemCursor = block;
		FlxG.keys.preventDefaultKeys = block ? [FlxKey.BACKSPACE, FlxKey.TAB] : [FlxKey.TAB];
	}
	static function FIND_LANG(?lang:String="")
	{
		return  LANGS[LANGS.indexOf(lang)>-1 ? LANGS.indexOf(lang): 0];
	}
	function get_location():Location
	{
		return location;
	}
	

}