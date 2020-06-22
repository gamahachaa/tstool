package tstool.utils;

import haxe.Http;
import js.Browser;
import flixel.util.FlxSignal.FlxTypedSignal;
/**
 * ...
 * @author bb
 */
class VersionTracker extends Http
{
	var reg:EReg;
	var scriptFileVersion:String;
	public var scriptChangedSignal(get, null):FlxTypedSignal<Bool->Void>;
	public function new(url:String)
	{
		super(url);
		scriptChangedSignal = new FlxTypedSignal<Bool->Void>();
		this.async = true;
		this.onData = ondata;
		this.onError = onerror;
		this.onStatus = onstatus;
		reg = ~/^\.\/nointernet_(\d{8}_\d{6}).js$/;
		scriptFileVersion = Browser.document.getElementsByTagName("script")[0].attributes.getNamedItem('src').nodeValue;
		if (reg.match(scriptFileVersion))
		{
			Main.VERSION = reg.matched(1);
		}
		else
		{
			trace(scriptFileVersion + " JS Script doesn't match version format ");
		}
	}
	
	

	private function ondata(data:String)
	{

		//Main.VERSION = reg.matched(1);
		if (data > Main.VERSION)
		{
			#if debug
			trace('update ${Main.VERSION} to $data');
			#end
			scriptChangedSignal.dispatch(true);
			//trace('update ${Main.VERSION} to $data');
			//Browser.alert(tongue.get("$needUpdate_UI1", "meta"));
			//Browser.location.reload(true);
			//Browser.window.history.go(0);
		}
		else
		{
			#if debug
			trace('current version ${Main.VERSION} is aligned with $data');
			#end
			scriptChangedSignal.dispatch(false);
			//trace('current version ${Main.VERSION} is aligned with $data');
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
}

//static public function CHECK_NEW_VERSION()
//{
//
//var versionTracker = new Http(LOCATION.origin + LOCATION.pathname+ "php/version/index.php");
//scriptFileVersion = Browser.document.getElementsByTagName("script")[0].attributes.getNamedItem('src').nodeValue;
//#if debug
//trace(scriptFileVersion);
//trace(reg.match(scriptFileVersion));
//#end
//versionTracker.async = true;
//versionTracker.onData = function(data:String)
//{
//if (reg.match(scriptFileVersion))
//{
//VERSION = reg.matched(1);
//if (data > VERSION)
//{
//#if debug
//trace('update $VERSION to $data');
//#end
//Browser.alert(tongue.get("$needUpdate_UI1", "meta"));
//Browser.location.reload(true);
////Browser.window.history.go(0);
//}
//else
//{
//#if debug
//trace('current version $VERSION is aligned with $data');
//#end
//}
//}
//else
//{
//trace(scriptFileVersion + " JS Script doesn't match version format ");
//}
//
//};
//versionTracker.request();
//}