package tstool.utils;

import firetongue.FireTongue;
import firetongue.FireTongue.Case;
import firetongue.FireTongue.Framework;

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
	public function initialize(lang:String, ?callback:Void->Void= null){
		this.init(lang, callback, false, false, folder);
	}
}