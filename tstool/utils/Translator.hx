package tstool.utils;

import firetongue.FireTongue;
//import firetongue.FireTongue.Case;
//import firetongue.FireTongue.Framework;
import haxe.PosInfos;
using string.StringUtils;

/**
 * ...
 * @author bb
 */
class Translator extends FireTongue 
{
	
	var folder:String;
	
	public function new(?folder:String="assets/locales/") 
	{
		super();
		this.folder = folder;
		
	}
	public function initialize(lang:String, ?callback:Void->Void = null, ?pos:PosInfos){
		#if debug
		trace('CALLED FROM ${pos.className} ${pos.methodName} ${pos.fileName} ${pos.lineNumber}');
		#end
		this.init(lang, callback, false, false, folder);
	}
	public function translate(fullClassName: String, txt:String, ?suffix:String="", ?context="data"):String
	{
        //#if debug
		//trace('tstool.utils.Translator::translate::fullClassName ${fullClassName}');
		//trace('tstool.utils.Translator::translate::txt ${txt}');
		//trace('tstool.utils.Translator::translate::suffix ${suffix}');
		//trace('tstool.utils.Translator::translate::context ${context}');
		//#end
		var tString = switch (context)
		{
			//case "data" : "$" + this._name + "_" + suffix;
			case "data" : "$" + fullClassName + "_" + suffix;
			case "headers" : "$" + txt + "." + suffix.removeWhite();
			case _ : "$" + txt + "_" + suffix;
		}
		//var t = MainApp.translator.get(tString, context);
		var t =  get(tString, context);
		var s = if (t.indexOf("$") == 0 || StringTools.trim(t) == "")
		{
			//couldn't translate
			if (context == "headers")
			{
				//then show the suffix
				suffix;
			}
			else
			{
				//or show the original string not translated
				txt;
			}
		}
		else {
			//could translate
			t;
		}
		#if debug
		if (Main.DEBUG || Main.DEBUG_LEVEL == 0)
			return s;
		else
			return StringTools.trim(t) == "" ? context == "headers"? suffix: txt : t;
		#else
		return s;
		#end

	}
	public function getPreferedQookLang():String
	{
		return switch(this.locale)
		{
			case "de-DE": "de";
			case "en-GB": "de";
			case _: "fr";
		}
	}
	
}