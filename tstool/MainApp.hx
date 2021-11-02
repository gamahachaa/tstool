package tstool;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxAssets;
//import flixel.text.FlxText.FlxTextFormat;
//import flixel.text.FlxText.FlxTextFormatMarkerPair;
//import flixel.util.FlxColor;
import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import js.Cookie;
import openfl.display.Sprite;
import js.html.Location;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;
import tstool.layout.History;
import tstool.layout.Login;
import tstool.layout.SaltColor;
import tstool.layout.Sorry;
import tstool.salt.Agent;
import tstool.salt.Customer;
import tstool.utils.Translator;
import tstool.utils.VersionTracker;
import tstool.utils.XapiTracker;

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
	//static inline var lang:String = "en-GB";
	static inline var LIB_FOLDER = "../trouble/php/";
	static inline var DEFAULT_COOKIE = "tstool";
	static inline var SCRIPT_NAME:String = "nointernet"; //historical

	static var debug:Bool;
	static var xapiTracker:XapiTracker;
	//public static var save:FlxSave = new FlxSave();
	static public var location:Location;
	//var TEST = "teststring";

	static var versionTracker:VersionTracker;
	static public var translator:Translator;
	static var stack:History;
	static var cust:Customer;
	public static var agent:Agent;
	static var s:Serializer;

	public static var config:Config;

	public function new(?cfg:Config)
	{
		super();
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
			libFolder : cfg.libFolder == null || cfg.libFolder == "" ? location.pathname + LIB_FOLDER : cfg.libFolder,
			cookie : cfg.cookie == null ? DEFAULT_COOKIE : cfg.cookie,
			scriptName : cfg.scriptName == null ? SCRIPT_NAME : cfg.scriptName
		};
		//stack = new History();
		//trace("tstool.MainApp::MainApp::config.cookie (name)", config.cookie );
		stack = History.STACK;

		if (Cookie.exists(config.cookie))
		{
			//trace("COOKIE EXISTS");
			#if debug
			trace("tstool.MainApp::MainApp::", "COOKIE EXISTS" );
			#end
			//trace(Cookie.get(config.cookie));
			var d = new Unserializer(Cookie.get(config.cookie));
			agent = d.unserialize();
			
			
			#if debug
			trace("REMOVED TS tool GROUPS");
			trace("tstool.MainApp::MainApp::agent.isMember(Customer Operations - Training)", agent.isMember("Customer Operations - Training") );
			#end
			//trace(a);
		}
		else
		{
			#if debug
			trace("tstool.MainApp::MainApp::", "COOKIE NOT EXISTS" );
			#end
			#if debug
			//agent = Agent.cretaDummyAgent();
			#else
			agent = null;
			#end
		}

		translator = new Translator();
		#if debug
		versionTracker = new VersionTracker( location.origin + config.libFolder, config.scriptName, true);
		#else
		versionTracker = new VersionTracker( location.origin + config.libFolder, config.scriptName);
		#end
		xapiTracker =  new XapiTracker(location.origin +  config.libFolder);
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