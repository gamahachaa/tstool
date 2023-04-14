package tstool.utils;

import haxe.Http;
import haxe.Json;
import js.Browser;
import flixel.util.FlxSignal.FlxTypedSignal;
import js.html.HTMLCollection;
import version.Params;
/**
 * ...
 * @author bb
 */
class VersionTracker extends Http
{
	var reg:EReg;
	var scriptFileVersion:String;
	//static inline var SCRIPT_NAME:String = "nointernet";
	var scriptStart:String;
	public var scriptChangedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public function new(url:String, ?script:String="")
	{
		super(url +  "version/index.php");
		//trace(url);
		//trace(script);
		this.addParameter(Params.SCRIPT_FILE, script);
		scriptStart = script;
		scriptChangedSignal = new FlxTypedSignal<Bool->Void>();
		this.async = true;
		this.onData = ondata;
		this.onError = onerror;
		this.onStatus = onstatus;
		#if debug
		//reg = ~/^\.\/scriptStart(\d{8}_\d{6}).js$/;
		if (Browser.location.origin.indexOf("qook.test.salt.ch") > -1)
		{
			//trace('^./${scriptStart}_(\\d{8}_\\d{6}).min.js$');
			reg = new EReg('^\\.\\/${scriptStart}_(\\d{8}_\\d{6}).min.js$', "g");
		}
		else
		{
			//trace('^./${scriptStart}_(\\d{8}_\\d{6}).js$');
			reg = new EReg('^\\.\\/${scriptStart}_(\\d{8}_\\d{6}).js$', "g");
		}
		#elseif DEMO
		reg = new EReg('^\\.\\/${scriptStart}_.js$', "g");
		#else
		//reg = ~/^\.\/scriptStart(\d{8}_\d{6}).min.js$/;
		reg = new EReg('^\\.\\/${scriptStart}_(\\d{8}_\\d{6}).min.js$', "g");
		//trace('^\\.\\/${scriptStart}_(\\d{8}_\\d{6}).min.js$');
		#end
		var scripts:HTMLCollection = Browser.document.getElementsByTagName("script");
		//trace(scripts.length);
		for (i in 0...scripts.length)
		{
			if (scripts[i].attributes.getNamedItem('src') != null
					&& scripts[i].attributes.getNamedItem('src').nodeValue.indexOf("./"+scriptStart+"_") == 0)
			{
				scriptFileVersion = scripts[i].attributes.getNamedItem('src').nodeValue;
				break;
			}

		}

		//scriptFileVersion = Browser.document.getElementsByTagName("script")[0].attributes.getNamedItem('src').nodeValue;
		if (reg.match(scriptFileVersion))
		{
			Main.VERSION = reg.matched(1);
		}
		else
		{
			trace(scriptFileVersion + " JS Script doesn't match version format ");
			Main.VERSION = "0";
		}
	}
	public function setDebug(debug:Bool)
	{
		this.addParameter(Params.DEBUG, Std.string(debug));
	}
	public function addAssetsVersion(version:String)
	{
		this.addParameter(Params.ASSETS_VERSION, version);
	}

	/**
	 * @TODO skip when no file found and debug mode
	 * @param	data
	 */
	private function ondata(data:String)
	{
		if (data.indexOf("{") >-1 && data.indexOf("}") >-1)
		{
			var j = Json.parse(data);
			var scriptVersion = j.scriptVersion ?? "-1";
			var assetsVersion = j.assetsVersion ?? "-1";
			if (scriptVersion > Main.VERSION || assetsVersion > MainApp.ASSETS_VERSION)
			{
				#if debug
				trace('update SCRIPT : ${Main.VERSION} to $scriptVersion or ASSETS ${MainApp.ASSETS_VERSION} to $assetsVersion');
				#end
				scriptChangedSignal.dispatch(true);
			}
			else
			{
				#if debug
				trace('current version SCRIPT : ${Main.VERSION} is aligned with $scriptVersion or ASSETS ${MainApp.ASSETS_VERSION} s aligned with $assetsVersion or debugging ');

				#end
				scriptChangedSignal.dispatch(false);
			}

		}
		else
		{
			// LEGACY
			checkScriptVersion(data);
		}

	}

	function get_scriptChangedSignal():FlxTypedSignal<Bool->Void>
	{
		return scriptChangedSignal;
	}
	function onerror(n:String)
	{
		#if debug
		trace(n);
		#end
	}
	function onstatus(n:Int)
	{
		#if debug
		trace(n);
		#end
	}

	function checkScriptVersion(data:String):Void
	{
		if (Main.DEBUG)
		{
			trace('version ${Main.VERSION} vs $data');
		}
		//Main.VERSION = reg.matched(1);

		if (data > Main.VERSION)
		{
			#if debug
			trace('update ${Main.VERSION} to $data');
			#end
			scriptChangedSignal.dispatch(true);
		}
		else
		{
			#if debug
			trace('current version ${Main.VERSION} is aligned with $data or debugging ');

			#end
			scriptChangedSignal.dispatch(false);
		}
	}
}