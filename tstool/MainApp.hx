package tstool;

import date.WorldTimeAPI;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
import flixel.util.FlxTimer;
import haxe.Timer;
import tstool.utils.XapiTracker;

import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import js.Cookie;
import openfl.display.Sprite;
import js.html.Location;
import tstool.layout.History;
import tstool.layout.Login;

import tstool.salt.Agent;
import tstool.salt.Customer;
import tstool.utils.Translator;
import tstool.utils.VersionTracker;

//import tstool.utils.XapiHelper;

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

	static var xapiHelper:XapiTracker;

	static public var location:Location;

	static var versionTracker:VersionTracker;
	static public var translator:Translator;
	static var stack:History;
	static var cust:Customer;
	public static var agent:Agent;
	static var s:Serializer;

	public static var config:Config;

	public static var idleTimer:Timer = new Timer(1000);
	static public var VERSION_TIMER_DURATION:Float = 300;
	static public var VERSION_TIMER_value:Float = VERSION_TIMER_DURATION;
	static public var WORD_TIME:WorldTimeAPI = new WorldTimeAPI();

	public function new(?cfg:Config)
	{
		super();

		idleTimer.run = onTimer;
		/*
		 * scale
		 *
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addEventListener (Event.RESIZE, resizeDisplay);
		*/
		location = Browser.location;
		debug = location.origin.indexOf("qook.test.salt.ch") > -1;
		FlxAssets.FONT_DEFAULT =  "Consolas";
		config =
		{
			libFolder : cfg.libFolder == null || cfg.libFolder == "" ? LIB_FOLDER : cfg.libFolder,
			cookie : cfg.cookie == null ? DEFAULT_COOKIE : cfg.cookie,
			scriptName : cfg.scriptName == null ? SCRIPT_NAME : cfg.scriptName
		};

		stack = History.STACK;

		if (Cookie.exists(config.cookie))
		{

			var d = new Unserializer(Cookie.get(config.cookie));
			agent = d.unserialize();
		}
		else
		{
			#if debug
			//trace("tstool.MainApp::MainApp::", "COOKIE NOT EXISTS" );
			#end
			#if debug
			//agent = Agent.cretaDummyAgent();
			#else
			agent = null;
			#end
		}

		translator = new Translator();
		//xapiHelper = new XapiHelper( location.origin +  config.libFolder);
		xapiHelper = new XapiTracker( location.origin +  config.libFolder);
		//xapiHelper.setActor(new Agent( MainApp.agent.iri, MainApp.agent.sAMAccountName));
		#if debug
		

		//xapiTracker =  new XapiTracker( location.origin +  config.libFolder);
		//

		#else
		
		//xapiTracker =  new XapiTracker( location.origin +  "/trouble/php/");
		#end
        versionTracker = new VersionTracker( location.origin + config.libFolder, config.scriptName, true);
		cust = new Customer();
		//agent= new Agent();
		translator.initialize("fr-FR",
							  function()
		{
			/**
			 * @todo Set a language message
			 */
			#if debug
			//trace(tongue.get("$flow.nointernet.vti.CheckContractorVTI_UI1", "meta"));
			#end
		});

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
			#if debug
			//trace("tstool.MainApp::onTimer::MainApp.VERSION_TIMER_value", VERSION_TIMER_value );
			#end
		}
		else
		{
			VERSION_TIMER_value--;

		}
		#if debug
		//trace(MainApp.VERSION_TIMER_value);
		#end
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
		return  Main.LANGS[Main.LANGS.indexOf(lang)>-1 ? Main.LANGS.indexOf(lang): 0];
	}
	function get_location():Location
	{
		return location;
	}
	/*
	 * scale
	function resizeDisplay(e:Event):Void
	{
		var width = stage.stageWidth;
		var height = stage.stageHeight;

		// Resize the main content area
		this.width = width;
		this.height = height;
	}
	*/

}