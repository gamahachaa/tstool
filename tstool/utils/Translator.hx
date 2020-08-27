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
	var indexFile:String;
	var folder:String;
	
	public function new(indexFile:String, ?folder:String="assets/locales/") 
	{
		super();
		this.folder = folder;
		this.indexFile = indexFile;
	}
	public function initialize(lang:String, ?callback:Void->Void= null){
		this.init(lang, callback, false, false, folder, indexFile);
	}
}