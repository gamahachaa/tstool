package tstool;

import flixel.system.FlxAssets;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import haxe.Serializer;
import haxe.Unserializer;
import js.Browser;
import js.Cookie;
import openfl.display.Sprite;
import js.html.Location;
import tstool.layout.History;
import tstool.layout.SaltColor;
import tstool.salt.Agent;
import tstool.salt.Customer;
import tstool.utils.Translator;
import tstool.utils.VersionTracker;
import tstool.utils.XapiTracker;

/**
 * ...
 * @author bb
 */
typedef Config = {
	var ?libFolder:String;
	var cookie:String;
	var scriptName:String;
}

class MainApp extends Sprite 
{
	//static inline var lang:String = "en-GB";
	static inline var LIB_FOLDER = "../trouble/";
	static inline var DEFAULT_COOKIE = "tstool";
	static inline var SCRIPT_NAME:String = "nointernet"; //historical
	
	static var debug:Bool;
	static var xapiTracker:XapiTracker;
	//public static var save:FlxSave = new FlxSave();
	static var location:Location;
	//var TEST = "teststring";
	
	static var versionTracker:VersionTracker;
	static var translator:Translator;
	static var stack:History;
	static var cust:Customer;
	public static var agent:Agent;
	static var s:Serializer;
	
	static var config:Config;
	
	public function new(?cfg:Config) 
	{
		super();
		
		location = Browser.location;
		debug = location.origin.indexOf("qook.test.salt.ch") > -1;
		FlxAssets.FONT_DEFAULT =  "Consolas";
		config = 
		{
			libFolder : cfg.libFolder == null || cfg.libFolder == "" ? LIB_FOLDER : cfg.libFolder,
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
			trace("tstool.MainApp::MainApp::agent.isMember(Customer Operations - Training)", agent.isMember("Customer Operations - Training") );
			#end
			//trace(a);
		}
		else{
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
		versionTracker = new VersionTracker( location.origin + location.pathname +  "php/version/index.php", config.scriptName);
		xapiTracker =  new XapiTracker(location.origin + location.pathname + config.libFolder);
		cust = new Customer();
		//agent= new Agent();
		translator.initialize("fr-FR",
					function(){
					#if debug
					//trace(tongue.get("$flow.nointernet.vti.CheckContractorVTI_UI1", "meta"));
					#end
				});
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
	static function FIND_LANG(?lang:String="")
	{
		return  Main.LANGS[Main.LANGS.indexOf(lang)>-1 ? Main.LANGS.indexOf(lang): 0];
	}
	function get_location():Location 
	{
		return location;
	}
	
	
	
	
}