package tstool.utils;

//import firetongue.CSV;
import firetongue.format.CSV;

/**
 * ...
 * @author bb
 */
class Csv extends CSV 
{
	public var dict(get, null):Map<String,Map<String, String>>;

	public function new(input:String, delimeter:String=',', quoted:Bool=true) 
	{
		super(input, delimeter, quoted);
		dict = new Map<String,Map<String, String>>();
		csvToDict();	
	}
	
	function get_dict():Map<String, Map<String, String>> 
	{
		return dict;
	}
	
	function csvToDict() 
	{
		for ( i in this.grid)
		{
			if (i[0] == null || i[0]  == "" ) continue;
			else{
				dict.set( i[0], [ this.fields[1] => i[1], this.fields[2] => i[2] , this.fields[3] => i[3], this.fields[4] => i[4]] );
			}
		}
	}
	
}