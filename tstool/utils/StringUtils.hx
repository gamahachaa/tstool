package tstool.utils;
/**
 * ...
 * @author bb
 */
class StringUtils 
{
	static public function intlToLocalMSISDN(s:String):String
	{
		return "0" + s.substr(2);
	}
}