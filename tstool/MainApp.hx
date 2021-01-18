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
	static inline var lang:String = "en-GB";
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
		//save = new FlxSave();
		//var couldBind = save.bind(config.cookie);
		//var agent = Agent.cretaDummyAgent();
		if (Cookie.exists(config.cookie))
		{
			//trace("COOKIE EXISTS");
			//trace(Cookie.get(config.cookie));
			var d = new Unserializer(Cookie.get(config.cookie));
			agent = d.unserialize();
			//trace(a);
		}
		else{
			#if debug
			agent = Agent.cretaDummyAgent();
			#else
			agent = null;
			#end
			//trace("COOKIE NOT EXISTS");
			//s = new Serializer();
			//s.serialize(agent);
			//Cookie.set(config.cookie, s.toString(), 86400 * 15, config.scriptName);
		}
		//trace("tstool.MainApp::MainApp::couldBind ", couldBind  );
		//trace("tstool.MainApp::MainApp::save", save.data.user );
		translator = new Translator();
		location = Browser.location;
		debug = location.origin.indexOf("qook.test.salt.ch") > -1;
		//trace("tstool.MainApp::MainApp::location.origin", location.origin, debug );
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
		//trace("tstool.MainApp::flush");
		s = new Serializer();
		if (agent.mainLanguage == null ||agent.mainLanguage == "" || Main.LANGS.indexOf(agent.mainLanguage) == -1)
		{
			agent.mainLanguage = lang;
		}
		s.serialize(agent);
		Cookie.set(config.cookie, s.toString(), 86400 * 15, config.scriptName);
	}
	function get_location():Location 
	{
		return location;
	}
	
	
	
	
}