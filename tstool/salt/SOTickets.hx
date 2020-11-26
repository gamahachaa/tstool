package tstool.salt;

/**
 * ...
 * @author bb
 */
class SOTickets 
{
	public var domain(get, null):String;
	public var number(get, null):String;
	public var queue(get, null):String;
	public var desc(get, null):String;
	public var email(get, null):String;
	/*
	///
public static var FIX_111:SOTickets = new SOTickets('FIX','1.1.1','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 1.Eligibility','fiber.tech.qtool@salt.ch');
public static var FIX_112:SOTickets = new SOTickets('FIX','1.1.2','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 2.Missing Address','fiber.tech.qtool@salt.ch');
public static var FIX_113:SOTickets = new SOTickets('FIX','1.1.3','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 3.Contact Information / ID','fiber.tech.qtool@salt.ch');
public static var FIX_114:SOTickets = new SOTickets('FIX','1.1.4','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 4.Cannot finalize order / payment','fiber.tech.qtool@salt.ch');
public static var FIX_311:SOTickets = new SOTickets('FIX','3.1.1','FIBER_NON_TECH_SO','3.Billing 1.Discount 1.Missing discount','fiber.tech.qtool@salt.ch');
public static var FIX_411:SOTickets = new SOTickets('FIX','4.1.1','FIBER_NON_TECH_SO','4.Order 1.Order Process 1.New order  / Validation email issue','fiber.tech.qtool@salt.ch');
public static var FIX_412:SOTickets = new SOTickets('FIX','4.1.2','FIBER_NON_TECH_SO','4.Order 1.Order Process 2.Payment not arrived > 5days','fiber.tech.qtool@salt.ch');
public static var FIX_414:SOTickets = new SOTickets('FIX','4.1.4','FIBER_DELEGATE_BACKOFFICE_SO','4.Order 1.Order Process 4.OTO Given by customer','fiber.tech.qtool@salt.ch');
public static var FIX_413:SOTickets = new SOTickets('FIX','4.1.3','FIBER_PLUGINUSE_SO','4.Order 1.Order Process 3.Plug in Use info','fiber.tech.qtool@salt.ch');
public static var FIX_421:SOTickets = new SOTickets('FIX','4.2.1','FIBER_LOGISTICS_SO','4.Order 2.Logistics 1.Equipement delivery','fiber.tech.qtool@salt.ch');
public static var FIX_511:SOTickets = new SOTickets('FIX','5.1.1','FIBER_WRONG_OTO_SO','5.Technical 1.Optical connection / OTO 1.Wrong OTO connected','fiber.tech.qtool@salt.ch');
public static var FIX_521:SOTickets = new SOTickets('FIX','5.2.1','FIBER_TECH_SO','5.Technical 2.Modem - Router 1.Modem connection','fiber.tech.qtool@salt.ch');
public static var FIX_211:SOTickets = new SOTickets('FIX','2.1.1','FIBER_NON_TECH_SO','2.Admin 1.Account Management 1.Contacts changes','fiber.tech.qtool@salt.ch');
public static var FIX_212:SOTickets = new SOTickets('FIX','2.1.2','FIBER_NON_TECH_SO','2.Admin 1.Account Management 2.Services Change','fiber.tech.qtool@salt.ch');
public static var FIX_415:SOTickets = new SOTickets('FIX','4.1.5','FIBER_ACTIVATION_CHECK_SO','4.Order 1.Order Process 5.Order not completed - Switch date','fiber.tech.qtool@salt.ch');
public static var FIX_213:SOTickets = new SOTickets('FIX','2.1.3','FIBER_NON_TECH_SO','2.Admin 1.Account Management 3.Fiber My Account','fiber.tech.qtool@salt.ch');
public static var FIX_214:SOTickets = new SOTickets('FIX','2.1.4','FIBER_OPTION_DEACTIVATION_SO','2.Admin 1.Account Management 4.TV Options - Deactivation','fiber.tech.qtool@salt.ch');
public static var FIX_416:SOTickets = new SOTickets('FIX','4.1.6','FIBER_DELEGATE_BACKOFFICE_SO','4.Order 1.Order Process 6.Order Status check request','fiber.tech.qtool@salt.ch');
public static var FIX_215:SOTickets = new SOTickets('FIX','2.1.5','FIBER_WINBACK_SO','2.Admin 1.Account Management 5.Termination (Chrun)','fiber.tech.qtool@salt.ch');
public static var FIX_531:SOTickets = new SOTickets('FIX','5.3.1','FIBER_LOW_PRIO_TECH_SO','5.Technical 3.Voip Telephony 1.Voip Calls','fiber.tech.qtool@salt.ch');
public static var FIX_321:SOTickets = new SOTickets('FIX','3.2.1','FIBER_FINANCIAL_SO','3.Billing 2.Compensation 1.*Request for Compensation','fiber.tech.qtool@salt.ch');
public static var FIX_331:SOTickets = new SOTickets('FIX','3.3.1','B2C_SA_MAS_SO','3.Billing 3.Bill method & delivery 1.*Bill Copy','fiber.tech.qtool@salt.ch');
public static var FIX_332:SOTickets = new SOTickets('FIX','3.3.2','B2C_SA_EXPERT_SO','3.Billing 3.Bill method & delivery 2.Direct Debit Issue','fiber.tech.qtool@salt.ch');
public static var FIX_333:SOTickets = new SOTickets('FIX','3.3.3','FIBER_EMAIL_SO','3.Billing 3.Bill method & delivery 3.*Account Statement','fiber.tech.qtool@salt.ch');
public static var FIX_341:SOTickets = new SOTickets('FIX','3.4.1','FS_PAYMENT_SEARCH_SO','3.Billing 4.Collection 1.Payment search (fibre)','fiber.tech.qtool@salt.ch');
public static var FIX_217:SOTickets = new SOTickets('FIX','2.1.7','FIBER_EMAIL_SO','2.Admin 1.Account Management 7.Contract Correction','fiber.tech.qtool@salt.ch');
//public static var FIX_611:SOTickets = new SOTickets('FIX','6.1.1','FIBER_EXECUTIVE_SO','6.Poor Service Provided 1.Executive Case 1.*Management Board Case','fiber.tech.qtool@salt.ch');
public static var FIX_551:SOTickets = new SOTickets('FIX','5.5.1','FIBER_RETURNED_MATERIAL_SO','5.Technical 5.Equipement 1.Salt Box Return to SST','fiber.tech.qtool@salt.ch');
public static var FIX_522:SOTickets = new SOTickets('FIX','5.2.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 2.Problème de Wifi / Wlan','fiber.tech.qtool@salt.ch');
public static var FIX_218:SOTickets = new SOTickets('FIX','2.1.8','FIBER_NON_TECH_SO','2.Admin 1.Account Management 8.Add / Reactivate TV Services','fiber.tech.qtool@salt.ch');
public static var FIX_523:SOTickets = new SOTickets('FIX','5.2.3','FIBER_TECH_SO','5.Technical 2.Modem - Router 3.Box Swap Request (under condition)','fiber.tech.qtool@salt.ch');
public static var FIX_524:SOTickets = new SOTickets('FIX','5.2.4','FIBER_TECH_SO','5.Technical 2.Modem - Router 4.WWW LED OFF','fiber.tech.qtool@salt.ch');
public static var FIX_525:SOTickets = new SOTickets('FIX','5.2.5','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 5.Internet check et Speed test','fiber.tech.qtool@salt.ch');
public static var FIX_342:SOTickets = new SOTickets('FIX','3.4.2','FS_PAYMENT_SEARCH_SO','3.Billing 4.Collection 2.Payment reimbursement (fibre)','fiber.tech.qtool@salt.ch');
public static var FIX_216:SOTickets = new SOTickets('FIX','2.1.6','FIBER_MOVE_SO','2.Admin 1.Account Management 6.Move','fiber.tech.qtool@salt.ch');
public static var FIX_526:SOTickets = new SOTickets('FIX','5.2.6','FIBER_PARTS_REQUEST_SO','5.Technical 2.Modem - Router 6.New Fibre Cable request (send by post)','fiber.tech.qtool@salt.ch');
public static var FIX_541:SOTickets = new SOTickets('FIX','5.4.1','FIBER_LOW_PRIO_TECH_SO','5.Technical 4.TV and Video Services 1.Salt TV problem','fiber.tech.qtool@salt.ch');
public static var FIX_221:SOTickets = new SOTickets('FIX','2.2.1','B2C_SA_MAS_SO','2.Admin 2.Missing Document 1.Contract Copy','fiber.tech.qtool@salt.ch');
public static var FIX_532:SOTickets = new SOTickets('FIX','5.3.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 3.Voip Telephony 2.VTI Voice Service','fiber.tech.qtool@salt.ch');
public static var FIX_542:SOTickets = new SOTickets('FIX','5.4.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 4.TV and Video Services 2.Salt VOD problem','fiber.tech.qtool@salt.ch');
public static var FIX_222:SOTickets = new SOTickets('FIX','2.2.2','B2C_SA_MAS_SO','2.Admin 2.Missing Document 2.Warranty Copy','fiber.tech.qtool@salt.ch');
public static var FIX_533:SOTickets = new SOTickets('FIX','5.3.3','FIBER_VOIP_MOVE_SO','5.Technical 3.Voip Telephony 3.VOIP Transfer (Move)','fiber.tech.qtool@salt.ch');
public static var FIX_2110:SOTickets = new SOTickets('FIX','2.1.10','FIBER_PERSONAL_SERVICE_SO','2.Admin 1.Account Management 10.Fiber Personal Service (Only for Backoffice)','fiber.tech.qtool@salt.ch');
public static var FIX_151:SOTickets = new SOTickets('FIX','1.5.1','NW_OPS_SERVICE_DESK_SO','10.Escalation (Only for Backoffice) 5.Technical (Escalation to SD Only) 1.Escalation - Voip Calls - Backoffice to SD','fiber.tech.qtool@salt.ch');
public static var FIX_2111:SOTickets = new SOTickets('FIX','2.1.11','FS_CREDICT_CHECK_SO','2.Admin 1.Account Management 11.Credit Limit','fiber.tech.qtool@salt.ch');
public static var FIX_125:SOTickets = new SOTickets('FIX','1.2.5','FIBER_LOW_PRIO_TECH_SO','10.Escalation (Only for Backoffice) 2.Admin (Backoffice Internal only) 5.Termination - TECH Reason (only Backoffice)','fiber.tech.qtool@salt.ch');
public static var FIX_2112:SOTickets = new SOTickets('FIX','2.1.12','FS_CREDICT_CHECK_SO','2.Admin 1.Account Management 12.Credit Check','fiber.tech.qtool@salt.ch');
public static var FIX_334:SOTickets = new SOTickets('FIX','3.3.4','FIBER_NON_TECH_SO','3.Billing 3.Bill method & delivery 4.Payment method change','fiber.tech.qtool@salt.ch');
public static var FIX_335:SOTickets = new SOTickets('FIX','3.3.5','FIBER_NON_TECH_SO','3.Billing 3.Bill method & delivery 5.Bill delivery method','fiber.tech.qtool@salt.ch');
public static var FIX_611:SOTickets = new SOTickets('FIX','6.1.1','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.OTO 1.Wrong OTO','fiber.tech.qtool@salt.ch');
public static var FIX_612:SOTickets = new SOTickets('FIX','6.1.2','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.OTO 2.Plug in Use','fiber.tech.qtool@salt.ch');
public static var FIX_613:SOTickets = new SOTickets('FIX','6.1.3','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.OTO 3.Delegate','fiber.tech.qtool@salt.ch');
public static var FIX_621:SOTickets = new SOTickets('FIX','6.2.1','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 2.Order 1.Order Status check','fiber.tech.qtool@salt.ch');
public static var FIX_622:SOTickets = new SOTickets('FIX','6.2.2','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 2.Order 2.Move (eligible address)','fiber.tech.qtool@salt.ch');
public static var FIX_623:SOTickets = new SOTickets('FIX','6.2.3','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 2.Order 3.Chrun (Termination)','fiber.tech.qtool@salt.ch');
public static var FIX_322:SOTickets = new SOTickets('FIX','3.2.2','FIBER_WELCOME_OFFER_SO','3.Billing 2.Compensation 2.*Welcome Offer','fiber.tech.qtool@salt.ch');
public static var FIX_527:SOTickets = new SOTickets('FIX','5.2.7','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 7. IP Option Management','fiber.tech.qtool@salt.ch');
public static var FIX_2113:SOTickets = new SOTickets('FIX','2.1.13','B2C_SA_MAS_SO','2.Admin 1.Account Management 13*.Death','fiber.tech.qtool@salt.ch');
public static var FIX_2114:SOTickets = new SOTickets('FIX','2.1.14','B2C_SA_MAS_SO','2.Admin 1.Account Management 14*.Guardianship','fiber.tech.qtool@salt.ch');
public static var FIX_343:SOTickets = new SOTickets('FIX','3.4.3','FS_PAYMENT_SEARCH_SO','3.Billing 4.Collection 3.Payment transfer from ID XXX to ID XXX (Fiber)','fiber.tech.qtool@salt.ch');
public static var FIX_351:SOTickets = new SOTickets('FIX','3.5.1','FIBER_FINANCIAL_SO','3.Billing 5.Bill & charging content 1.Contestation of content','fiber.tech.qtool@salt.ch');
public static var FIX_2115:SOTickets = new SOTickets('FIX','2.1.15','B2C_SA_EXPERT_SO','2.Admin 1.Account Management 15.*Recall collection Agency','fiber.tech.qtool@salt.ch');
*/
public static var FIX_111:SOTickets = new SOTickets('FIX','1.1.1','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 1.Eligibility','fiber.tech.qtool@salt.ch');
public static var FIX_112:SOTickets = new SOTickets('FIX','1.1.2','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 2.Missing Address','fiber.tech.qtool@salt.ch');
public static var FIX_113:SOTickets = new SOTickets('FIX','1.1.3','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 3.Contact Information / ID','fiber.tech.qtool@salt.ch');
public static var FIX_114:SOTickets = new SOTickets('FIX','1.1.4','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 4.Cannot finalize order / payment','fiber.tech.qtool@salt.ch');
public static var FIX_351:SOTickets = new SOTickets('FIX','3.5.1','FIBER_MISSING_DISCOUNT_SO','3.Billing 5.Discount (NOT for compensation) 1.Missing discount','fiber.tech.qtool@salt.ch');
public static var FIX_413:SOTickets = new SOTickets('FIX','4.1.3','FIBER_DELEGATE_BACKOFFICE_SO','4.Order 1.Order Process 3.OTO Given by customer','fiber.tech.qtool@salt.ch');
public static var FIX_412:SOTickets = new SOTickets('FIX','4.1.2','FIBER_PLUGINUSE_SO','4.Order 1.Order Process 2.Plug in Use info','fiber.tech.qtool@salt.ch');
public static var FIX_421:SOTickets = new SOTickets('FIX','4.2.1','FIBER_LOGISTICS_SO','4.Order 2.Logistics 1.Equipement delivery','fiber.tech.qtool@salt.ch');
public static var FIX_511:SOTickets = new SOTickets('FIX','5.1.1','FIBER_WRONG_OTO_SO','5.Technical 1.Optical connection / OTO 1.Wrong OTO connected','fiber.tech.qtool@salt.ch');
public static var FIX_521:SOTickets = new SOTickets('FIX','5.2.1','FIBER_TECH_SO','5.Technical 2.Modem - Router 1.Modem connection','fiber.tech.qtool@salt.ch');
public static var FIX_211:SOTickets = new SOTickets('FIX','2.1.1','FIBER_NON_TECH_SO','2.Admin 1.Account Management 1.Contacts changes','fiber.tech.qtool@salt.ch');
public static var FIX_414:SOTickets = new SOTickets('FIX','4.1.4','FIBER_ACTIVATION_CHECK_SO','4.Order 1.Order Process 4.Order not completed - Switch date','fiber.tech.qtool@salt.ch');
public static var FIX_2199:SOTickets = new SOTickets('FIX','2.1.99','FIBER_NON_TECH_SO','2.Admin 1.Account Management 99.Fiber My Account','fiber.tech.qtool@salt.ch');
public static var FIX_415:SOTickets = new SOTickets('FIX','4.1.5','FIBER_ACTIVATION_CHECK_SO','4.Order 1.Order Process 5.Order Status check request','fiber.tech.qtool@salt.ch');
public static var FIX_212:SOTickets = new SOTickets('FIX','2.1.2','FIBER_WINBACK_SO','2.Admin 1.Account Management 2.Termination (Chrun)','fiber.tech.qtool@salt.ch');
public static var FIX_531:SOTickets = new SOTickets('FIX','5.3.1','FIBER_LOW_PRIO_TECH_SO','5.Technical 3.Voip Telephony 1.Voip Calls','fiber.tech.qtool@salt.ch');
public static var FIX_311:SOTickets = new SOTickets('FIX','3.1.1','FIBER_FINANCIAL_SO','3.Billing 1.Compensation 1.*Request for Compensation','fiber.tech.qtool@salt.ch');
public static var FIX_321:SOTickets = new SOTickets('FIX','3.2.1','B2C_SA_MAS_SO','3.Billing 2.Bill method & delivery 1.*Bill Copy','fiber.tech.qtool@salt.ch');
public static var FIX_322:SOTickets = new SOTickets('FIX','3.2.2','B2C_SA_EXPERT_SO','3.Billing 2.Bill method & delivery 2.Direct Debit Issue','fiber.tech.qtool@salt.ch');
public static var FIX_323:SOTickets = new SOTickets('FIX','3.2.3','FIBER_EMAIL_SO','3.Billing 2.Bill method & delivery 3.*Account Statement','fiber.tech.qtool@salt.ch');
public static var FIX_331:SOTickets = new SOTickets('FIX','3.3.1','FS_PAYMENT_SEARCH_SO','3.Billing 3.Finance 1.Payment search (fibre)','fiber.tech.qtool@salt.ch');
public static var FIX_213:SOTickets = new SOTickets('FIX','2.1.3','B2C_SA_MAS_SO','2.Admin 1.Account Management 3.Contract Correction (Language)','fiber.tech.qtool@salt.ch');
public static var FIX_551:SOTickets = new SOTickets('FIX','5.5.1','FIBER_RETURNED_MATERIAL_SO','5.Technical 5.Equipement 1.Salt Box Return to SST','fiber.tech.qtool@salt.ch');
public static var FIX_522:SOTickets = new SOTickets('FIX','5.2.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 2.Problème de Wifi / Wlan','fiber.tech.qtool@salt.ch');
public static var FIX_215:SOTickets = new SOTickets('FIX','2.1.5','FIBER_NON_TECH_SO','2.Admin 1.Account Management 5.Add / Reactivate TV Services','fiber.tech.qtool@salt.ch');
public static var FIX_523:SOTickets = new SOTickets('FIX','5.2.3','FIBER_TECH_SO','5.Technical 2.Modem - Router 3.Box Swap Request (under condition)','fiber.tech.qtool@salt.ch');
public static var FIX_524:SOTickets = new SOTickets('FIX','5.2.4','FIBER_TECH_SO','5.Technical 2.Modem - Router 4.WWW LED OFF','fiber.tech.qtool@salt.ch');
public static var FIX_525:SOTickets = new SOTickets('FIX','5.2.5','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 5.Internet check et Speed test','fiber.tech.qtool@salt.ch');
public static var FIX_332:SOTickets = new SOTickets('FIX','3.3.2','FS_PAYMENT_SEARCH_SO','3.Billing 3.Finance 2.Payment reimbursement (fibre)','fiber.tech.qtool@salt.ch');
public static var FIX_712:SOTickets = new SOTickets('FIX','7.1.2','FIBER_PARTS_REQUEST_SO','7.Escalation (Only for Backoffice) 1.Technical (Escalation to SD Only) 2.New Fibre Cable request (send by post)','fiber.tech.qtool@salt.ch');
public static var FIX_541:SOTickets = new SOTickets('FIX','5.4.1','FIBER_LOW_PRIO_TECH_SO','5.Technical 4.TV and Video Services 1.Salt TV problem','fiber.tech.qtool@salt.ch');
public static var FIX_221:SOTickets = new SOTickets('FIX','2.2.1','B2C_SA_MAS_SO','2.Admin 2.Document (Contract / Warranty) 1.Contract Copy','fiber.tech.qtool@salt.ch');
public static var FIX_532:SOTickets = new SOTickets('FIX','5.3.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 3.Voip Telephony 2.VTI Voice Service','fiber.tech.qtool@salt.ch');
public static var FIX_542:SOTickets = new SOTickets('FIX','5.4.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 4.TV and Video Services 2.Salt VOD problem','fiber.tech.qtool@salt.ch');
public static var FIX_222:SOTickets = new SOTickets('FIX','2.2.2','B2C_SA_MAS_SO','2.Admin 2.Document (Contract / Warranty) 2.Warranty Copy','fiber.tech.qtool@salt.ch');
public static var FIX_533:SOTickets = new SOTickets('FIX','5.3.3','FIBER_VOIP_MOVE_SO','5.Technical 3.Voip Telephony 3.VOIP Transfer (Move)','fiber.tech.qtool@salt.ch');
public static var FIX_731:SOTickets = new SOTickets('FIX','7.3.1','FIBER_PERSONAL_SERVICE_SO','7.Escalation (Only for Backoffice) 3.Premium Service 1.Fiber Personal Service (Only for Backoffice)','fiber.tech.qtool@salt.ch');
public static var FIX_711:SOTickets = new SOTickets('FIX','7.1.1','NW_OPS_SERVICE_DESK_SO','7.Escalation (Only for Backoffice) 1.Technical (Escalation to SD Only) 1.Escalation - Voip Calls - Backoffice to SD','fiber.tech.qtool@salt.ch');
public static var FIX_342:SOTickets = new SOTickets('FIX','3.4.2','FS_CREDICT_CHECK_SO','3.Billing 4.Collection 2.Credit Limit','fiber.tech.qtool@salt.ch');
public static var FIX_641:SOTickets = new SOTickets('FIX','6.4.1','FIBER_TECH_ESCA_SO','6.Recaller 4.Winback 1.Termination - TECH Reason (only Backoffice)','fiber.tech.qtool@salt.ch');
public static var FIX_722:SOTickets = new SOTickets('FIX','7.2.2','FS_CREDICT_CHECK_SO','7.Escalation (Only for Backoffice) 2.Change Owner (Fibre) 2.Credit Check','fiber.tech.qtool@salt.ch');
public static var FIX_612:SOTickets = new SOTickets('FIX','6.1.2','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.Activation 2.Plug in Use (Recaller)','fiber.tech.qtool@salt.ch');
public static var FIX_621:SOTickets = new SOTickets('FIX','6.2.1','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 2.Order 1.Order Status check','fiber.tech.qtool@salt.ch');
public static var FIX_622:SOTickets = new SOTickets('FIX','6.2.2','FIBER_TERMINATION_ESCA_SO','6.Recaller 2.Order 2.Move (eligible address)','fiber.tech.qtool@salt.ch');
public static var FIX_623:SOTickets = new SOTickets('FIX','6.2.3','FIBER_TERMINATION_ESCA_SO','6.Recaller 2.Order 3.Chrun (Termination)','fiber.tech.qtool@salt.ch');
public static var FIX_312:SOTickets = new SOTickets('FIX','3.1.2','FIBER_WELCOME_OFFER_SO','3.Billing 1.Compensation 2.*Welcome Offer','fiber.tech.qtool@salt.ch');
public static var FIX_526:SOTickets = new SOTickets('FIX','5.2.6','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 6.IP Option Management','fiber.tech.qtool@salt.ch');
public static var FIX_216:SOTickets = new SOTickets('FIX','2.1.6','B2C_SA_MAS_SO','2.Admin 1.Account Management 6.Death','fiber.tech.qtool@salt.ch');
public static var FIX_217:SOTickets = new SOTickets('FIX','2.1.7','B2C_SA_MAS_SO','2.Admin 1.Account Management 7.Guardianship','fiber.tech.qtool@salt.ch');
public static var FIX_333:SOTickets = new SOTickets('FIX','3.3.3','FS_PAYMENT_SEARCH_SO','3.Billing 3.Finance 3.Payment transfer from ID XXX to ID XXX (Fiber)','fiber.tech.qtool@salt.ch');
public static var FIX_343:SOTickets = new SOTickets('FIX','3.4.3','B2C_SA_EXPERT_SO','3.Billing 4.Collection 3.Recall collection Agency','fiber.tech.qtool@salt.ch');
public static var FIX_341:SOTickets = new SOTickets('FIX','3.4.1','FS_FIBER_PAY_ARRANGEMENT_SO','3.Billing 4.Collection 1.Payment delay request (1 month)','fiber.tech.qtool@salt.ch');
public static var FIX_561:SOTickets = new SOTickets('FIX','5.6.1','FIBER_TECH_SO','5.Technical 6.Wifi Repeater 1.Wifi Repeater - Problem','fiber.tech.qtool@salt.ch');
public static var FIX_613:SOTickets = new SOTickets('FIX','6.1.3','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.Activation 3.Delegate (Recaller)','fiber.tech.qtool@salt.ch');
public static var FIX_611:SOTickets = new SOTickets('FIX','6.1.1','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.Activation 1.Wrong OTO (Recaller)','fiber.tech.qtool@salt.ch');
public static var FIX_631:SOTickets = new SOTickets('FIX','6.3.1','FIBER_TECH_ESCA_SO','6.Recaller 3.Technical 1.Technical Issue (Recaller)','fiber.tech.qtool@salt.ch');
public static var FIX_324:SOTickets = new SOTickets('FIX','3.2.4','FIBER_NON_TECH_SO','3.Billing 2.Bill method & delivery 4.Changement mode paiment ou reception','fiber.tech.qtool@salt.ch');
public static var FIX_411:SOTickets = new SOTickets('FIX','4.1.1','FIBER_ACTIVATION_CHECK_SO','4.Order 1.Order Process 1.Wrong Address','fiber.tech.qtool@salt.ch');
public static var FIX_313:SOTickets = new SOTickets('FIX','3.1.3','FIBER_REMINDER_FEE_SO','3.Billing 1.Compensation 3.Entschädigung für Mahnkosten','fiber.tech.qtool@salt.ch');
public static var FIX_424:SOTickets = new SOTickets('FIX','4.2.4','FIBER_ACCESSORIES_SO','4.Order 2.Logistics 4.Fiber Accessory Delivery Issue','fiber.tech.qtool@salt.ch');

//
//public static var MOBILE_511:SOTickets = new SOTickets('MOBILE','5.1.1','B2C_FINANCIAL_COMPLAINT_SO','5.Escalation 1.Compensation 1.Request for Compensation','fiber.tech.qtool@salt.ch');
public static var MOBILE_511:SOTickets = new SOTickets('MOBILE','5.1.1','B2C_FINANCIAL_COMPLAINT_SO','5.*Escalation 1.*Compensation 1.*Request for Compensation','fiber.tech.qtool@salt.ch');


	public function new(domain:String,number:String,queue:String,desc:String,email:String) 
	{
		this.email = email;
		this.desc = desc;
		this.queue = queue;
		this.number = number;
		this.domain = domain;
	}
	//////////////////// GETTERS ///////////////////////////
	function get_domain():String 
	{
		return domain;
	}
	
	function get_number():String 
	{
		return number;
	}
	
	function get_queue():String 
	{
		return queue;
	}
	
	function get_desc():String 
	{
		return desc;
	}
	
	function get_email():String 
	{
		return email;
	}
}