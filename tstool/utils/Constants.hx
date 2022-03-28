package tstool.utils;
import tstool.utils.DateToolsBB.Opennings;

/**
 * ...
 * @author bb
 */
class Constants 
{
	public static inline var ONE_MONTH_MILLI:Float = 2629743000;
	public static inline var ONE_DAY_MILLI:Float = 86400000;
	public static inline var FIBER_WINBACK_OPEN_UTC:Int = 7;//7
	public static inline var FIBER_WINBACK_OPEN_UTC_FLOAT:Float= 6.0;//7
	public static inline var FIBER_WINBACK_CLOSE_UTC:Int = 17; // 17 excluded
	public static inline var FIBER_WINBACK_CLOSE_UTC_FLOAT:Float = 15.30; //
	public static var FIBER_WINBACK_UTC_RANGES:Array<Opennings> = [ {open: 7, close:10.5}, {open: 11, close:15} ];// 15.30; //
	
	public static inline var FIBER_WINBACK_DAYS_OPENED_RANGE:String = "1,2,3,4,5"; //monday friday
	public static inline var FIBER_WINBACK_BANK_HOLIDAYS:String = "2021-12-24,2021-12-31"; //monday friday
	/**
	 * tests
	 */
	public static inline var TEST_CONTRACTOR:String = "30001047";
	public static inline var TEST_VOIP:String = "41212180513";
	public static inline var TEST_MSISDN:String = "41787878814";
	public static inline var TEST_OTO:String = "A.123.456.789.X";
	public static inline var TEST_APT_ID:String = "2a";
	public static inline var TEST_APT_FLOOR_NB:String = "2";
	public static inline var TEST_APT_FORMER:String = "Bellucci Monica";
	/**
	 * products
	 */
		public static inline var CUST_DATA_PRODUCT:String = "PRODUCTS";
	public static inline var CUST_DATA_PRODUCT_BOX:String = "BOX";
	public static inline var CUST_DATA_PRODUCT_BOX_SAGEM:String = "Sagem";
	public static inline var CUST_DATA_PRODUCT_BOX_ARCADYAN:String = "Arcadyan";
	public static inline var CUST_DATA_PRODUCT_BOX_FWA:String = "Gigabox";
	/**
	 * customer
	 */
	 	public static inline var STORAGE_CONTRACTOR:String = "CONTRACTOR";
	public static inline var STORAGE_VOIP:String = "VOIP";
	public static inline var STORAGE_OWNER:String = "OWNER";
	public static inline var STORAGE_CONTACT:String = "CONTACT";
	

}