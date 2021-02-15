package tstool.utils;

/**
 * ...
 * @author bb
 */
class ExpReg 
{

	static public inline var ALL:String = "^[\\s\\S]+$";
	static public inline var DATE_REG:String = "^(([0-3]?[0-9]{1}.(0|1)?[0-9]{1}.20(1|2)[0-9]{1})|([0-3]?[0-9]{1}/(0|1)?[0-9]{1}/20(1|2)[0-9]{1}))$";
	static public inline var OTO_REG:String = "^(A|B)\\.[0-9]{3}\\.[0-9]{3}\\.[0-9]{3}(\\.[0-9X])?$";
	static public inline var CONTRACTOR_EREG:String = "^3\\d{7}$";
	static public inline var MISIDN_LOCAL:String = "^(07\\d{8})|((0)[0-9]{2}\\s{0,1}[0-9]{3}\\s{0,1}[0-9]{4})$";
	static public inline var MISIDN_INTL:String = "^(41\\d{9})|(41\\s{0,1}[0-9]{2}\\s{0,1}[0-9]{3}\\s{0,1}[0-9]{4})$";
	static public inline var MISIDN_UNIVERAL:String = "^(41\\d{9})|(07\\d{8})$";
	static public inline var EMAIL:String = "[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+\\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
}