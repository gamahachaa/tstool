package tstool.utils;

/**
 * ...
 * @author bb
 */
class ExpReg 
{

	static public inline var ALL:String = "^[\\s\\S]+$";
	static public inline var DATE_REG_START_END:String = "^(([0-3]?[0-9]{1}.(0|1)?[0-9]{1}.20(1|2)[0-9]{1})|([0-3]?[0-9]{1}/(0|1)?[0-9]{1}/20(1|2)[0-9]{1}))$";
	static public inline var DATE_REG:String = "(([0-3]?[0-9]{1}.(0|1)?[0-9]{1}.20(1|2)[0-9]{1})|([0-3]?[0-9]{1}/(0|1)?[0-9]{1}/20(1|2)[0-9]{1}))";
	static public inline var TIME:String = "[012]?\\d(h\\s?|:|\\s)+[012]?\\d(m|')?";
	static public inline var DATE_TIME:String = DATE_REG + "\\s" + TIME;
	
	static public inline var OTO_REG:String = "^(A|B)\\.[0-9]{3}\\.[0-9]{3}\\.[0-9]{3}(\\.[0-9X])?$";
	static public inline var CONTRACTOR_EREG:String = "^3\\d{7}$";
	//static public inline var MISIDN_LOCAL:String = "^(07\\d{8})|((0)[0-9]{2}\\s{0,1}[0-9]{3}\\s{0,1}[0-9]{4})$";
	static public inline var MISIDN_LOCAL:String = "(^07\\d{8}$)|(^0\\d{2}\\s?\\d{3}\\s?(\\d{4}|\\d{2}\\s?\\d{2})$)";
	static public inline var MISIDN_INTL:String = "(^41\\d{9}$)|(^41\\s{0,1}\\d{2}\\s{0,1}\\d{3}\\s{0,1}\\d{4}$)";
	static public inline var MISIDN_UNIVERAL:String = MISIDN_LOCAL + "|" + MISIDN_INTL;
	static public inline var EMAIL:String = "[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
	static public inline var ZIP:String = "^[1-9]{1}\\d{3}$";
	static public inline var CITY:String = "^\\w+[a-z 0-9.éàèüöäâêô!ï()\\/\\-']+$";
	static public inline var ADRESS_NUMBER:String = "^\\d+\\w?$";
	static public inline var STREET:String = "^.{2,}$";
	static public inline var INTL_NUMBER:String = "(\\(0\\))?\\d{4,14}";
	static public inline var INTL_CODE:String = "^(00|\\+)(9[976]\\d|8[987530]\\d|6[987]\\d|5[90]\\d|42\\d|3[875]\\d|2[98654321]\\d|9[8543210]|8[6421]|6[6543210]|5[87654321]|4[987654310]|3[9643210]|2[70]|7|1)$";
	static public inline var COUNTRY_LOOSE:String = "^\\w+[a-zéàèüöäâêô!ï &]+$";
	static public inline var NUMBEB_ONLY:String = "^\\d+$";
	static public inline var NAME_MINIMAL:String = "^\\w{2,}$";
	static public inline var BOX_SERIAL:String = "^(SFAA|GFAB)?[0-9]{8}$";
	
	
}