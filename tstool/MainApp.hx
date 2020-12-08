package tstool;

import flixel.system.FlxAssets;
import flixel.text.FlxText.FlxTextFormat;
import flixel.text.FlxText.FlxTextFormatMarkerPair;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import js.Browser;
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
	static inline var LIB_FOLDER = "../trouble/";
	static inline var DEFAULT_COOKIE = "tstool";
	static inline var SCRIPT_NAME:String = "nointernet"; //historical
	
	var debug:Bool;
	var xapiTracker:XapiTracker;
	var save:FlxSave;
	var location:Location;
	//var TEST = "teststring";
	
	var versionTracker:VersionTracker;
	var translator:Translator;
	var stack:History;
	var cust:Customer;
	var agent:Agent;
	
	public var config(get, null):Config;
	
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
		stack = History.STACK;
		save = new FlxSave();
		save.bind(config.cookie);
		translator = new Translator();
		location = Browser.location;
		debug = location.origin.indexOf("qook.test.salt.ch") > -1;
		versionTracker = new VersionTracker( location.origin + location.pathname +  "php/version/index.php", config.scriptName);
		xapiTracker =  new XapiTracker(location.origin + location.pathname + config.libFolder);
		cust = new Customer();
		agent= new Agent();
		translator.initialize("fr-FR",
					function(){
					#if debug
					//trace(tongue.get("$flow.nointernet.vti.CheckContractorVTI_UI1", "meta"));
					#end
				});
	}
	
	function get_save():FlxSave 
	{
		return save;
	}
	
	function get_location():Location 
	{
		return location;
	}
	
	function get_config():Config 
	{
		return config;
	}
	
}