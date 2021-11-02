package tstool.utils;

import firetongue.FireTongue;
import firetongue.FireTongue.Case;
import firetongue.FireTongue.Framework;
import haxe.PosInfos;

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
}