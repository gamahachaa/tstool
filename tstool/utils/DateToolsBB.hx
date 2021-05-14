package tstool.utils;

/**
 * ...
 * @author bb
 */
class DateToolsBB 
{
	static var SUMMER:Date = new Date(2021, 2, 28, 0, 0, 0);
	public static function delta(a:Date, b:Date)
	{
		return a.getTime() - b.getTime();
	}
	public static function deltaDatePositive(a:Date, b:Date)
	{	
		return Date.fromTime(Std.int(Math.abs(a.getTime() - b.getTime())));
	}
	public static function isBefore(date:Date, comparedTo:Date)
	{
		return delta(date, comparedTo) < 0;
	}
	public static function isAfter(date:Date, comparedTo:Date)
	{
		return delta(date, comparedTo) > 0;
	}
	public static function isSame(date:Date, comparedTo:Date)
	{
		return delta(date, comparedTo) == 0;
	}
	public static function isWithinHours(start:Int, stopExcluded:Int, ?date:Date)
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
		
		return (start <= date.getHours() + (date.getMinutes()/100) &&  date.getHours() + (date.getMinutes()/100)< stopExcluded) ;
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
	public static function isWithinDays(start:Int, stopExcluded:Int, ?date:Date)
	{

		if (date == null) date = Date.now();
		return (start <= date.getDay() && date.getDay() < stopExcluded) ;
	}
	public static function isWithinDaysArray(days:Array<Int>, ?date:Date)
	{
		if (date == null) date = Date.now();
		return (days.contains(date.getDay())) ;
	}
	public static function isWithinDaysString(days:String, ?date:Date)
	{
		if (date == null) date = Date.now();
		return (days.indexOf(Std.string(date.getDay())) > -1) ;
	}
	public static function isSummerTime(date:Date)
	{
		return isAfter(date, SUMMER);
	}
}