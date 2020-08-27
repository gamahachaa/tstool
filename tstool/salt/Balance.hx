package tstool.salt;

/**
 * ...
 * @author bb
 */
class Balance 
{
	public var current:String;
	public var overdue:String;
	public var overdueDate:String;

	public function new(?vtiBalance:String="0.00 CHF", ?vtiOverdue:String="0.00 CHF", ?vtiOverdueDate:String= "") 
	{
		current=vtiBalance;
		overdue=vtiOverdue;
		overdueDate=vtiOverdueDate;
	}
	
}