package tstool.utils;

/**
 * ...
 * @author bb
 */
typedef Opennings = {
	var open:Float;
	var close:Float;
}
class DateToolsBB 
{
	static var SUMMER:Date = new Date(2021, 2, 28, 0, 0, 0);
	static var SUMMER_TIMES:Map<Int,Date> = [
		2021 => new Date(2021, 2, 28, 0, 0, 0), 
		2022 => new Date(2022, 2, 27, 0, 0, 0),
		2023 => new Date(2023, 2, 26, 0, 0, 0),
		2024 => new Date(2024, 2, 31, 0, 0, 0)
		];
	static var WINTER_TIMES:Map<Int,Date> = [
		2021 => new Date(2021, 9, 31, 0, 0, 0), 
		2022 => new Date(2022, 9, 30, 0, 0, 0),
		2023 => new Date(2023, 9, 29, 0, 0, 0),
		2024 => new Date(2024, 9, 27, 0, 0, 0)
		];
	/**
	 * 
	 * @param	a
	 * @param	b
	 */
	public static function delta(a:Date, b:Date)
	{
		return a.getTime() - b.getTime();
	}
	/**
	 * 
	 * @param	a
	 * @param	b
	 */
	public static function deltaDatePositive(a:Date, b:Date)
	{	
		return Date.fromTime(Std.int(Math.abs(a.getTime() - b.getTime())));
	}
	/**
	 * 
	 * @param	date
	 * @param	comparedTo
	 */
	public static function isBefore(date:Date, comparedTo:Date)
	{
		return delta(date, comparedTo) < 0;
	}
	/**
	 * 
	 * @param	date
	 * @param	comparedTo
	 */
	public static function isAfter(date:Date, comparedTo:Date)
	{
		return delta(date, comparedTo) > 0;
	}
	/**
	 * 
	 * @param	date
	 * @param	comparedTo
	 */
	public static function isSame(date:Date, comparedTo:Date)
	{
		return delta(date, comparedTo) == 0;
	}
	
	
	
	
	/**
	 * 
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinHours(start:Int, stopExcluded:Int, ?date:Date)
	{
		
		if (date == null) date = Date.now();
		return (start <= date.getHours() &&  date.getHours() < stopExcluded) ;
	}
	/**
	 * 
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinUTCHours(start:Int, stopExcluded:Int, ?date:Date)
	{
		
		if (date == null) date = Date.now();
		return (start <= date.getHours() &&  date.getHours() < stopExcluded) ;
	}
	/**
	 * use minutes as float not scaled to 100 exp 17h30 = 17.3
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinHoursMinutes(start:Float, stopExcluded:Float, ?date:Date)
	{
		if (date == null) date = Date.now();
		var hoursMin:Float = date.getHours() + (date.getMinutes() / 100);
		//#if debug
		//trace("tstool.utils.DateToolsBB::isWithinHoursMinutes::start", start );
		//trace("tstool.utils.DateToolsBB::isWithinHoursMinutes::stopExcluded", stopExcluded );
		//trace("tstool.utils.DateToolsBB::isWithinHoursMinutes::hoursMin", hoursMin );
		//trace("tstool.utils.DateToolsBB::isWithinHoursMinutes::(start <= hoursMin) && (hoursMin < stopExcluded)", (start <= hoursMin) && (hoursMin < stopExcluded) );
		//
		//#end
		return ( start <= hoursMin && hoursMin < stopExcluded);
	}
	/**
	 * 
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinUTCHoursMinutes(start:Float, stopExcluded:Float, ?date:Date)
	{
		if (date == null) date = Date.now();
		var hoursMin:Float = date.getUTCHours() + (date.getUTCMinutes() / 100);
		#if debug
		//trace("tstool.utils.DateToolsBB::isWithinUTCHoursMinutes::start", start );
		//trace("tstool.utils.DateToolsBB::isWithinUTCHoursMinutes::stopExcluded", stopExcluded );
		//trace("tstool.utils.DateToolsBB::isWithinUTCHoursMinutes::hoursMin", hoursMin );
		//trace("tstool.utils.DateToolsBB::isWithinUTCHoursMinutes::(start <= hoursMin) && (hoursMin < stopExcluded)", (start <= hoursMin) && (hoursMin < stopExcluded) );
		
		#end
		return ( start <= hoursMin && hoursMin < stopExcluded);
	}
	/**
	 * use hour:minutes
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinHoursMinutesString(start:String, stopExcluded:String, ?date:Date)
	{
		if (date == null) date = Date.now();
				
		return (start <= Std.string(date.getHours()) + ":" + Std.string((date.getMinutes())) &&  Std.string(date.getHours()) + ":" + Std.string((date.getMinutes()))< stopExcluded) ;
	}
	/**
	 * 
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinUTCHoursMinutesString(start:String, stopExcluded:String, ?date:Date)
	{
		if (date == null) date = Date.now();
				
		return (start <= Std.string(date.getUTCHours()) + ":" + Std.string((date.getUTCMinutes())) &&  Std.string(date.getUTCHours()) + ":" + Std.string((date.getUTCMinutes()))< stopExcluded) ;
	}
	/**
	 * 
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinDays(start:Int, stopExcluded:Int, ?date:Date)
	{

		if (date == null) date = Date.now();
		return (start <= date.getDay() && date.getDay() < stopExcluded) ;
	}
	/**
	 * 
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isWithinUTCDays(start:Int, stopExcluded:Int, ?date:Date)
	{

		if (date == null) date = Date.now();
		return (start <= date.getUTCDay() && date.getUTCDay() < stopExcluded) ;
	}
	/**
	 * 
	 * @param	days
	 * @param	date
	 */
	public static function isWithinDaysArray(days:Array<Int>, ?date:Date)
	{
		if (date == null) date = Date.now();
		return (days.contains(date.getDay())) ;
	}
	/**
	 * 
	 * @param	days
	 * @param	date
	 */
	public static function isWithinUTCDaysArray(days:Array<Int>, ?date:Date)
	{
		if (date == null) date = Date.now();
		return (days.contains(date.getUTCDay())) ;
	}
	/**
	 * 
	 * @param	days
	 * @param	date
	 */
	public static function isWithinDaysString(days:String, ?date:Date)
	{
		if (date == null) date = Date.now();
		return (days.indexOf(Std.string(date.getDay())) > -1) ;
	}
	/**
	 * 
	 * @param	days
	 * @param	date
	 */
	public static function isBankHolidayString(days:String, ?date:Date)
	{
		if (date == null) date = Date.now();
		var s = '${date.getFullYear()}-${date.getMonth()+1}-${date.getDate()}';
		#if debug
		trace("tstool.utils.DateToolsBB::isBankHolidayString::s", s );
		#end
		return (days.indexOf(s)  > -1) ;
	}
	/**
	 * 
	 * @param	days
	 * @param	date
	 */
	public static function isWithinUTCDaysString(days:String, ?date:Date)
	{
		if (date == null) date = Date.now();
		return (days.indexOf(Std.string(date.getUTCDay())) > -1) ;
	}
	
	/**
	 * 
	 * @param	days
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isDayTimeFloatInRange(days:String, start:Float, stopExcluded:Float, ?date:Date)
	{
		if (date == null) date = Date.now();
		return isWithinDaysString(days, date) && isWithinHoursMinutes(start, stopExcluded, date);
	}
	/**
	 * 
	 * @param	days
	 * @param	start
	 * @param	stopExcluded
	 * @param	date
	 */
	public static function isUTCDayTimeFloatInRange(days:String, start:Float, stopExcluded:Float, ?date:Date)
	{
		if (date == null) date = Date.now();
		#if debug
		//trace("tstool.utils.DateToolsBB::isUTCDayTimeFloatInRange::isWithinUTCDaysString(days, date)", isWithinUTCDaysString(days, date) );
		//trace("tstool.utils.DateToolsBB::isUTCDayTimeFloatInRange::isWithinUTCHoursMinutes(start, stopExcluded, date)", isWithinUTCHoursMinutes(start, stopExcluded, date) );
		#end
		return isWithinUTCDaysString(days, date) && isWithinUTCHoursMinutes(start, stopExcluded, date);
	}
	public static function isUTCDayTimeFloatInRanges(days:String, ranges:Array<Opennings>, ?date:Date):Bool
	{
		if (date == null) date = Date.now();
		if ( isWithinUTCDaysString(days, date))
		{
			 for (i in ranges)
			 {
				 #if debug
				 //trace("tstool.utils.DateToolsBB::isUTCDayTimeFloatInRanges::i", i );
				 #end
				 if (isWithinUTCHoursMinutes(i.open, i.close, date))
				 {
					 return true;
				 }
			 }
		}
		return false;
	}
	 /**
	  * 
	  * @param	date
	  */
	public static function isSummerTime(date:Date)
	{
		var year = date.getUTCFullYear();
		return isAfter(date, SUMMER_TIMES.get(year)) && isBefore(date, WINTER_TIMES.get(year));
	}
	public static function getSeasonDelta(?date:Date=null):Int
	{
		if (date == null) date = Date.now();
		 return isSummerTime(date) ? 2:1;
	}
	/**
	 * 
	 * @param	d
	 * @return
	 */
	public static function TO_ISO_DATE(d:Date):String
	{
		return Std.string(d.getFullYear()) +"-" + ZERO_LEAD( d.getMonth()) + "-" + ZERO_LEAD(d.getDate()) + "T" + ZERO_LEAD(d.getHours()) + ":" + ZERO_LEAD(d.getMinutes()) + ":" + ZERO_LEAD(d.getSeconds()) + "Z";
	}
		/**
		 * 
		 * @param	d
		 * @return
		 */
	public static function TO_UTC_ISO_DATE(d:Date):String
	{
		return Std.string(d.getUTCFullYear()) +"-" + ZERO_LEAD( d.getUTCMonth()) + "-" + ZERO_LEAD(d.getUTCDate()) + "T" + ZERO_LEAD(d.getUTCHours()) + ":" + ZERO_LEAD(d.getUTCMinutes()) + ":" + ZERO_LEAD(d.getUTCSeconds()) + "Z";
	}
	/**
	 * 
	 * @param	i
	 * @return
	 */
	inline public static function ZERO_LEAD(i:Int):String
	{
		return (i < 10?"0" :"" )+Std.string(i);
	}
	/**
	 * 
	 * @param	f
	 * @return
	 */
	inline static public function prepareHourFromFloat(f:Float):String
	{
		var s = Std.string(f);
		var o ="";
		if (s.indexOf(".")>-1)
		{
			  o = s.split(".").join("h");
		}
		else{
			o = s + "h0";
		}
		return o + "0";
	}
}