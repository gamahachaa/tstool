package tstool.utils;

import haxe.Http;

/**
 * ...
 * @author bb
 */
class CsvFetcher extends Http 
{

	public function new() 
	{
		super(MainApp.config.libFolder +  "csvreader/index.php");
		//super(url);
		
	}
	
}