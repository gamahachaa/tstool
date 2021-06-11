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
	static inline public function removeWhite(s:String):String
	{
		return s.split(" ").join("");
	}
	static inline public function phonSpaces(s:String):String
	{
		var t = s.split("");
		 t.insert(8, " ");
			t.insert(6, " ");
			t.insert(3, " ");
		return t.join("");
	}
}