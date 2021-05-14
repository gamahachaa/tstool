package tstool.salt;

/**
 * ...
 * @author bb
 */
class SOTemplate extends SuperOffice
{
	//4.Salt Fiber/3.Salt Fiber Technical/9.Smart Repeater/01.Smart Extender commercial Links
	
	#if debug
	public static var FIX_381 :SOTemplate =  new SOTemplate("FIX","319","","","TSToolTemplateNotif@salt.ch");
	public static var FIX_334 :SOTemplate =  new SOTemplate("FIX","246","","","TSToolTemplateNotif@salt.ch");
	public static var FIX_552:SOTemplate =  new SOTemplate("FIX","334","FIBER_EMAIL_SO","4.Salt Fiber/12.Selfservice/Trick-Speed Home","TSToolTemplateNotif@salt.ch");
	public static var FIX_566:SOTemplate =  new SOTemplate("FIX","338","FIBER_EMAIL_SO","4.Salt Fiber/3.Salt Fiber Technical/9.Smart Repeater/01.Smart Extender commercial Links","TSToolTemplateNotif@salt.ch");
	public static var MOBILE_APN:SOTemplate =  new SOTemplate("MOBILE","345","MOBILE_EMAIL_SO","Internet problem connexion ","TSToolTemplateNotif@salt.ch");
	public static var MOBILE_DATA_UPSELL:SOTemplate =  new SOTemplate("MOBILE","346","MOBILE_EMAIL_SO","Upsell","TSToolTemplateNotif@salt.ch");	
	#else
		public static var FIX_381 :SOTemplate =  new SOTemplate("FIX","381","","","TSToolTemplateNotif@salt.ch");
	public static var FIX_334 :SOTemplate =  new SOTemplate("FIX","334","FIBER_EMAIL_SO","","TSToolTemplateNotif@salt.ch");
	public static var FIX_552 :SOTemplate =  new SOTemplate("FIX","552","FIBER_EMAIL_SO","4.Salt Fiber/12.Selfservice/Trick-Speed Home","TSToolTemplateNotif@salt.ch");
	public static var FIX_566 :SOTemplate =  new SOTemplate("FIX", "566", "FIBER_EMAIL_SO", "4.Salt Fiber/3.Salt Fiber Technical/9.Smart Repeater/01.Smart Extender commercial Links", "TSToolTemplateNotif@salt.ch");
	public static var MOBILE_APN:SOTemplate =  new SOTemplate("MOBILE","577","MOBILE_EMAIL_SO","Internet problem connexion ","TSToolTemplateNotif@salt.ch");
	public static var MOBILE_DATA_UPSELL:SOTemplate =  new SOTemplate("MOBILE","576","MOBILE_EMAIL_SO","Upsell","TSToolTemplateNotif@salt.ch");
	#end
}