package tstool.salt;

/**
 * ...
 * @author bb
 */
class SOTemplate extends SuperOffice
{
	//4.Salt Fiber/3.Salt Fiber Technical/9.Smart Repeater/01.Smart Extender commercial Links
	#if debug
	public static var FIX_552:SOTemplate =  new SOTemplate("FIX","334","FIBER_EMAIL_SO","4.Salt Fiber/12.Selfservice/Trick-Speed Home","TSToolTemplateNotif-sit@salt.ch");
	public static var FIX_566:SOTemplate =  new SOTemplate("FIX","338","FIBER_EMAIL_SO","4.Salt Fiber/3.Salt Fiber Technical/9.Smart Repeater/01.Smart Extender commercial Links","TSToolTemplateNotif-sit@salt.ch");
	
	#else
	public static var FIX_552 :SOTemplate =  new SOTemplate("FIX","552","FIBER_EMAIL_SO","4.Salt Fiber/12.Selfservice/Trick-Speed Home","TSToolTemplateNotif@salt.ch");
	public static var FIX_566 :SOTemplate =  new SOTemplate("FIX","566","FIBER_EMAIL_SO","4.Salt Fiber/3.Salt Fiber Technical/9.Smart Repeater/01.Smart Extender commercial Links","TSToolTemplateNotif@salt.ch");
	#end
}