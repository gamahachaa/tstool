package tstool.salt;

/**
 * ...
 * @author bb
 */
class SOTickets extends SuperOffice
{


	public static var FIX_111:SOTickets = new SOTickets('FIX','1.1.1','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 1.Eligibility','fiber.tech.qtool@salt.ch');
	public static var FIX_112:SOTickets = new SOTickets('FIX','1.1.2','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 2.Missing Address','fiber.tech.qtool@salt.ch');
	public static var FIX_113:SOTickets = new SOTickets('FIX','1.1.3','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 3.Contact Information / ID','fiber.tech.qtool@salt.ch');
	public static var FIX_114:SOTickets = new SOTickets('FIX','1.1.4','FIBER_SALES_FEEDBACK_SO','1.Sales (Telesales) 1.eShop 4.Cannot finalize order / payment','fiber.tech.qtool@salt.ch');
	public static var FIX_211:SOTickets = new SOTickets('FIX','2.1.1','FIBER_NON_TECH_SO','2.Admin 1.Account Management 1.Contacts changes','fiber.tech.qtool@salt.ch');
	public static var FIX_212:SOTickets = new SOTickets('FIX','2.1.2','FIBER_TERMINATION_SO','2.Admin 1.Account Management 2.Termination','fiber.tech.qtool@salt.ch');
	public static var FIX_213:SOTickets = new SOTickets('FIX','2.1.3','FIBER_MOVE_SO','2.Admin 1.Account Management 3.Move','fiber.tech.qtool@salt.ch');
	public static var FIX_215:SOTickets = new SOTickets('FIX','2.1.5','FIBER_OPTION_DEACTIVATION_SO','2.Admin 1.Account Management 5.Add / Reactivate TV Services','fiber.tech.qtool@salt.ch');
	public static var FIX_216:SOTickets = new SOTickets('FIX','2.1.6','B2C_SA_MAS_SO','2.Admin 1.Account Management 6.Death','fiber.tech.qtool@salt.ch');
	public static var FIX_221:SOTickets = new SOTickets('FIX','2.2.1','B2C_SA_MAS_SO','2.Admin 2.Document (Contract / Warranty) 1.Paper contract copy','fiber.tech.qtool@salt.ch');
	public static var FIX_222:SOTickets = new SOTickets('FIX','2.2.2','B2C_SA_MAS_SO','2.Admin 2.Document (Contract / Warranty) 2.Warranty Copy','fiber.tech.qtool@salt.ch');
	public static var FIX_241:SOTickets = new SOTickets('FIX','2.4.1','FIBER_TERMINATION_ESCA_SO','2.Admin 4.Gigabox (FWA) - Account Management 1.Gigabox (FWA) - Termination / Cancellation','fiber.tech.qtool@salt.ch');
	public static var FIX_313:SOTickets = new SOTickets('FIX', '3.1.3', 'FIBER_REMINDER_FEE_SO', '3.Billing 1.Compensation 3.Compensation for reminder costs', 'fiber.tech.qtool@salt.ch');
	public static var FIX_311:SOTickets = new SOTickets('FIX','3.1.1','FIBER_FINANCIAL_SO','3.Billing 1.Compensation 1.*Request for Compensation','fiber.tech.qtool@salt.ch');
	public static var FIX_324:SOTickets = new SOTickets('FIX','3.2.4','FIBER_NON_TECH_SO','3.Billing 2.Bill method & delivery 4.Changement mode paiment ou reception','fiber.tech.qtool@salt.ch');
	public static var FIX_341:SOTickets = new SOTickets('FIX','3.4.1','FS_FIBER_PAY_ARRANGEMENT_SO','3.Billing 4.Collection 1.Payment delay request (1 month)','fiber.tech.qtool@salt.ch');
	public static var FIX_351:SOTickets = new SOTickets('FIX','3.5.1','FIBER_MISSING_DISCOUNT_SO','3.Billing 5.Discount (NOT for compensation) 1.Missing discount','fiber.tech.qtool@salt.ch');
	public static var FIX_411:SOTickets = new SOTickets('FIX','4.1.1','FIBER_NON_TECH_SO','4.Order 1.Order Process 1.New order  / Validation email issue','fiber.tech.qtool@salt.ch');
	public static var FIX_412:SOTickets = new SOTickets('FIX','4.1.2','FIBER_PLUGINUSE_SO','4.Order 1.Order Process 2.Plug in Use info','fiber.tech.qtool@salt.ch');
	public static var FIX_413:SOTickets = new SOTickets('FIX', '4.1.3', 'FIBER_PARTS_REQUEST_SO', '4.Order 1.Order Process 3.Fibre Cable request (addtional / new / longuer)', 'fiber.tech.qtool@salt.ch');
	public static var FIX_415:SOTickets = new SOTickets('FIX','4.1.5','FIBER_ACTIVATION_CHECK_SO','4.Order 1.Order Process 5.Order Status check request','fiber.tech.qtool@salt.ch');
	public static var FIX_416:SOTickets = new SOTickets('FIX','4.1.6','FWA_TECH_SO','4.Order 1.Order Process 6.Gigabox - (FWA) Order','fiber.tech.qtool@salt.ch');
	public static var FIX_414:SOTickets = new SOTickets('FIX','4.1.4','FIBER_ACTIVATION_CHECK_SO','4.Order 1.Order Process 4.Order not completed - Switch date','fiber.tech.qtool@salt.ch');
	public static var FIX_421:SOTickets = new SOTickets('FIX','4.2.1','FIBER_LOGISTICS_SO','4.Order 2.Logistics 1.Equipement delivery','fiber.tech.qtool@salt.ch');
	public static var FIX_422:SOTickets = new SOTickets('FIX','4.2.2','FIBER_LOGISTICS_SO','4.Order 2.Logistics 2.Salt TV Remote request','fiber.tech.qtool@salt.ch');
	public static var FIX_5101:SOTickets = new SOTickets('FIX','5.10.1','FIBER_TECH_SO','5.Technical 10.Gigabox (FWA) 1.CPE 4G / 5G Antenna','fiber.tech.qtool@salt.ch');
	public static var FIX_5102:SOTickets = new SOTickets('FIX','5.10.2','FIBER_TECH_SO','5.Technical 10.Gigabox (FWA) 2.FWA - AX3 Router','fiber.tech.qtool@salt.ch');
	public static var FIX_511:SOTickets = new SOTickets('FIX','5.1.1','FIBER_WRONG_OTO_SO','5.Technical 1.Optical connection / OTO 1.Wrong OTO connected','fiber.tech.qtool@salt.ch');
	public static var FIX_521:SOTickets = new SOTickets('FIX','5.2.1','FIBER_TECH_SO','5.Technical 2.Modem - Router 1.Modem connection','fiber.tech.qtool@salt.ch');
	public static var FIX_522:SOTickets = new SOTickets('FIX','5.2.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 2.Problème de Wifi / Wlan','fiber.tech.qtool@salt.ch');
	public static var FIX_523:SOTickets = new SOTickets('FIX', '5.2.3', 'FIBER_TECH_SO', '5.Technical 2.Modem - Router 3.Box Swap Request (under condition)', 'fiber.tech.qtool@salt.ch');
	public static var FIX_525:SOTickets = new SOTickets('FIX','5.2.5','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 5.Internet check et Speed test','fiber.tech.qtool@salt.ch');
	public static var FIX_332:SOTickets = new SOTickets('FIX', '3.3.2', 'FS_PAYMENT_SEARCH_SO', '3.Billing 3.Finance 2.Payment reimbursement (fibre)', 'fiber.tech.qtool@salt.ch');

	public static var FIX_526:SOTickets = new SOTickets('FIX','5.2.6','FIBER_LOW_PRIO_TECH_SO','5.Technical 2.Modem - Router 6.IP Option Management','fiber.tech.qtool@salt.ch');
	public static var FIX_532:SOTickets = new SOTickets('FIX','5.3.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 3.Voip Telephony 2.VTI Voice Service','fiber.tech.qtool@salt.ch');
	public static var FIX_533:SOTickets = new SOTickets('FIX','5.3.3','FIBER_VOIP_MOVE_SO','5.Technical 3.Voip Telephony 3.VOIP Transfer (Move)','fiber.tech.qtool@salt.ch');
	public static var FIX_541:SOTickets = new SOTickets('FIX','5.4.1','FIBER_LOW_PRIO_TECH_SO','5.Technical 4.TV and Video Services 1.Salt TV problem','fiber.tech.qtool@salt.ch');
	public static var FIX_542:SOTickets = new SOTickets('FIX','5.4.2','FIBER_LOW_PRIO_TECH_SO','5.Technical 4.TV and Video Services 2.Salt VOD problem','fiber.tech.qtool@salt.ch');
	public static var FIX_562:SOTickets = new SOTickets('FIX','5.6.2','FIBER_3LEVEL_SUPPORT_SO','5.Technical 6.Wifi Repeater 2.Firmware update for Wifi Repeater','fiber.tech.qtool@salt.ch');
	public static var FIX_611:SOTickets = new SOTickets('FIX','6.1.1','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.OTO 1.Wrong OTO','fiber.tech.qtool@salt.ch');
	public static var FIX_612:SOTickets = new SOTickets('FIX','6.1.2','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.Activation 2.Plug in Use (Recaller)','fiber.tech.qtool@salt.ch');
	public static var FIX_613:SOTickets = new SOTickets('FIX','6.1.3','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 1.OTO 3.Delegate','fiber.tech.qtool@salt.ch');
	public static var FIX_621:SOTickets = new SOTickets('FIX','6.2.1','FIBER_CALLBACK_BACKOFFICE_SO','6.Recaller 2.Order 1.Order Status check','fiber.tech.qtool@salt.ch');
	public static var FIX_622:SOTickets = new SOTickets('FIX','6.2.2','FIBER_TERMINATION_ESCA_SO','6.Recaller 2.Order 2.Move (eligible address)','fiber.tech.qtool@salt.ch');
	public static var FIX_623:SOTickets = new SOTickets('FIX','6.2.3','FIBER_TERMINATION_ESCA_SO','6.Recaller 2.Order 3.Chrun (Termination)','fiber.tech.qtool@salt.ch');
	public static var FIX_631:SOTickets = new SOTickets('FIX','6.3.1','FIBER_TECH_ESCA_SO','6.Recaller 3.Technical 1.Technical Issue (Recaller)','fiber.tech.qtool@salt.ch');
	//public static var FIX_641:SOTickets = new SOTickets('FIX','6.4.1','FIBER_WINBACK_SO','6.Recaller 4.Winback 1.Termination - TECH Reason (only Backoffice)','fiber.tech.qtool@salt.ch');
	public static var FIX_641_NONTECH:SOTickets = new SOTickets('FIX','6.4.1','FIBER_WINBACK_SO','6.Recaller 4.Winback 1.Termination - TECH Reason (only Backoffice)','fiber.tech.qtool@salt.ch');
	public static var FIX_641_NONTECH_PROMO:SOTickets = new SOTickets('FIX','6.4.1','FIBER_WINBACK_SO','PROMO 6.Recaller 4.Winback 1.Termination - TECH Reason (only Backoffice)','fiber.tech.qtool@salt.ch');
	public static var FIX_641_TECH:SOTickets = new SOTickets('FIX','6.4.1','FIBER_WINBACK_TECH_SO','6.Recaller 4.Winback 1.Termination - TECH Reason (only Backoffice)','fiber.tech.qtool@salt.ch');
	public static var FIX_711:SOTickets = new SOTickets('FIX','7.1.1','NW_OPS_SERVICE_DESK_SO','7.Escalation (Only for Backoffice) 1.Technical (Escalation to SD Only) 1.Escalation - Voip Calls - Backoffice to SD','fiber.tech.qtool@salt.ch');
	public static var FIX_712:SOTickets = new SOTickets('FIX','7.1.2','FIBER_PARTS_REQUEST_SO','NEVER EVER REOPEN. 7.Escalation 1.Technical 2.New Fibre Cable request','fiber.tech.qtool@salt.ch');
	public static var FIX_713:SOTickets = new SOTickets('FIX','7.1.3','NW_OPS_SERVICE_DESK_SO','7.Escalation (Only for Backoffice) 1.Technical (Escalation to SD Only) 3.CPE 4G / 5G Antenna -Escalate to SD (BO agent only!)','fiber.tech.qtool@salt.ch');
	public static var FIX_722:SOTickets = new SOTickets('FIX','7.2.2','FS_CREDICT_CHECK_SO','7.Escalation (Only for Backoffice) 2.Change Owner (Fibre) 2.Credit Check','fiber.tech.qtool@salt.ch');
	public static var FIX_731:SOTickets = new SOTickets('FIX','7.3.1','FIBER_PERSONAL_SERVICE_SO','7.Escalation (Only for Backoffice) 3.Premium Service 1.Fiber Personal Service (Only for Backoffice)','fiber.tech.qtool@salt.ch');

	// SAGEM
	public static var FIX_999:SOTickets = new SOTickets('FIX','9.9.9','FIBER_TECH_SGBX_SO','Special queue','fiber.tech.qtool@salt.ch');

	/**
	public static var MOBILE_111:SOTickets = new SOTickets('MOBILE','1.1.1','B2C_SA_MAS_SO','1.Admin 1.Account Management 1.Abusiv Anrufe','mobile.qtool@salt.ch');
	public static var MOBILE_1112:SOTickets = new SOTickets('MOBILE','1.1.12','B2C_SA_EXPERT_SO','1.Admin 1.Account Management 12.Wangiri Calls','mobile.qtool@salt.ch');
	public static var MOBILE_112:SOTickets = new SOTickets('MOBILE','1.1.2','B2C_SA_MAS_SO','1.Admin 1.Account Management 2.SMS Spam','mobile.qtool@salt.ch');
	public static var MOBILE_114:SOTickets = new SOTickets('MOBILE','1.1.4','B2C_SA_EXPERT_SO','1.Admin 1.Account Management 4.Recall collection Agency','mobile.qtool@salt.ch');
	public static var MOBILE_115:SOTickets = new SOTickets('MOBILE','1.1.5','B2C_CHANGE_OWNER_SO','1.Admin 1.Account Management 5.Change Owner (only reassignment)','mobile.qtool@salt.ch');
	public static var MOBILE_116:SOTickets = new SOTickets('MOBILE','1.1.6','B2C_SA_MAS_SO','1.Admin 1.Account Management 6.Guardianship','mobile.qtool@salt.ch');
	public static var MOBILE_117:SOTickets = new SOTickets('MOBILE','1.1.7','B2C_SA_MAS_SO','1.Admin 1.Account Management 7.Death','mobile.qtool@salt.ch');
	public static var MOBILE_119:SOTickets = new SOTickets('MOBILE','1.1.9','B2C_SA_EXPERT_SO','1.Admin 1.Account Management 9.Wangiri Calls','mobile.qtool@salt.ch');
	public static var MOBILE_131:SOTickets = new SOTickets('MOBILE','1.3.1','B2C_SA_EXPERT_SO','1.Admin 3.Subscription Management 1.Gold and Platinum Number Request','mobile.qtool@salt.ch');
	public static var MOBILE_132:SOTickets = new SOTickets('MOBILE','1.3.2','B2C_SA_TICKET_SO','1.Admin 3.Logistics 2.Issue with Repair','mobile.qtool@salt.ch');
	public static var MOBILE_211:SOTickets = new SOTickets('MOBILE','2.1.1','B2C_SA_MAS_SO','2.Billing 1.Bill & charging content 1.Contestation of premium SMS/MMS','mobile.qtool@salt.ch');
	public static var MOBILE_212:SOTickets = new SOTickets('MOBILE','2.1.2','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 2.Data','mobile.qtool@salt.ch');
	public static var MOBILE_213:SOTickets = new SOTickets('MOBILE','2.1.3','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 3.Messages (SMS/MMS)','mobile.qtool@salt.ch');
	public static var MOBILE_214:SOTickets = new SOTickets('MOBILE','2.1.4','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 4.Roaming','mobile.qtool@salt.ch');
	public static var MOBILE_216:SOTickets = new SOTickets('MOBILE','2.1.6','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 6.Discount / Special Offer','mobile.qtool@salt.ch');
	public static var MOBILE_221:SOTickets = new SOTickets('MOBILE','2.2.1','B2C_SA_TICKET_SO','2.Billing 2.Bill method & delivery 1.Bill not received Paynet','mobile.qtool@salt.ch');
	public static var MOBILE_222:SOTickets = new SOTickets('MOBILE','2.2.2','B2C_SA_MAS_SO','2.Billing 2.Bill method & delivery 2.Bill Copy by Post','mobile.qtool@salt.ch');
	public static var MOBILE_223:SOTickets = new SOTickets('MOBILE','2.2.3','B2C_SA_EXPERT_SO','2.Billing 2.Bill method & delivery 3.Extrait de compte','mobile.qtool@salt.ch');
	public static var MOBILE_231:SOTickets = new SOTickets('MOBILE','2.3.1','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 1.Amount recharged not credited','mobile.qtool@salt.ch');
	public static var MOBILE_232:SOTickets = new SOTickets('MOBILE','2.3.2','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 2.Cannot recharge','mobile.qtool@salt.ch');
	public static var MOBILE_233:SOTickets = new SOTickets('MOBILE','2.3.3','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 3.Recharge bonus','mobile.qtool@salt.ch');
	public static var MOBILE_234:SOTickets = new SOTickets('MOBILE','2.3.4','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 4.Recurring recharge','mobile.qtool@salt.ch');
	public static var MOBILE_251:SOTickets = new SOTickets('MOBILE','2.5.1','B2C_SA_NOT_PROMISE_SO','2.Billing 5.Payment Arrangement 1.Payment arrangement','mobile.qtool@salt.ch');
	public static var MOBILE_3101:SOTickets = new SOTickets('MOBILE','3.10.1','B2C_SA_TECH_SO','3.Technical 10.Modem 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_311:SOTickets = new SOTickets('MOBILE','3.1.1','B2C_SA_TECH_SO','3.Technical 1.Network Coverage 1.No coverage','mobile.qtool@salt.ch');
	public static var MOBILE_3111:SOTickets = new SOTickets('MOBILE','3.11.1','B2C_SA_EXPERT_SO','3.Technical 11.Femto 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_312:SOTickets = new SOTickets('MOBILE','3.1.2','B2C_SA_TECH_SO','3.Technical 1.Network Coverage 2.No coverage','mobile.qtool@salt.ch');
	public static var MOBILE_3121:SOTickets = new SOTickets('MOBILE','3.12.1','B2C_SA_TECH_SO','3.Technical 12.Self Care 1.My Account','mobile.qtool@salt.ch');
	public static var MOBILE_3123:SOTickets = new SOTickets('MOBILE','3.12.3','B2C_SA_TICKET_SO','3.Technical 12.Self Care 3.Salt Mobile App (for iPhone and Android)','mobile.qtool@salt.ch');
	public static var MOBILE_3124:SOTickets = new SOTickets('MOBILE','3.12.4','B2C_SA_TICKET_SO','3.Technical 12.Self Care 4.Mobile Self Service (#121, #123)','mobile.qtool@salt.ch');
	public static var MOBILE_321:SOTickets = new SOTickets('MOBILE','3.2.1','B2C_SA_TECH_SO','3.Technical 2.Calls 1.Quality','mobile.qtool@salt.ch');
	public static var MOBILE_322:SOTickets = new SOTickets('MOBILE','3.2.2','B2C_SA_TECH_SO','3.Technical 2.Calls 2.Cannot make / receive call','mobile.qtool@salt.ch');
	public static var MOBILE_323:SOTickets = new SOTickets('MOBILE','3.2.3','B2C_SA_TECH_SO','3.Technical 2.Calls 3.Missed / white calls','mobile.qtool@salt.ch');
	public static var MOBILE_324:SOTickets = new SOTickets('MOBILE','3.2.4','B2C_SA_TECH_SO','3.Technical 2.Calls 4.Dropped calls','mobile.qtool@salt.ch');
	public static var MOBILE_325:SOTickets = new SOTickets('MOBILE','3.2.5','B2C_SA_TECH_SO','3.Technical 2.Calls 5.Value added Calls','mobile.qtool@salt.ch');
	public static var MOBILE_331:SOTickets = new SOTickets('MOBILE','3.3.1','B2C_SA_TECH_SO','3.Technical 3.SMS/MMS 1.Cannot send & receive','mobile.qtool@salt.ch');
	public static var MOBILE_332:SOTickets = new SOTickets('MOBILE','3.3.2','B2C_SA_TECH_SO','3.Technical 3.SMS/MMS 2.Send & Receive multiple time','mobile.qtool@salt.ch');
	public static var MOBILE_333:SOTickets = new SOTickets('MOBILE','3.3.3','B2C_SA_TECH_SO','3.Technical 3.SMS/MMS 3.Value added services','mobile.qtool@salt.ch');
	public static var MOBILE_341:SOTickets = new SOTickets('MOBILE','3.4.1','B2C_SA_TECH_SO','3.Technical 4.Data 1.No / intermittent connection','mobile.qtool@salt.ch');
	public static var MOBILE_342:SOTickets = new SOTickets('MOBILE','3.4.2','B2C_SA_TECH_SO','3.Technical 4.Data 2.Speed','mobile.qtool@salt.ch');
	public static var MOBILE_351:SOTickets = new SOTickets('MOBILE','3.5.1','B2C_SA_TECH_SO','3.Technical 5.Device 1.Broken or defective','mobile.qtool@salt.ch');
	public static var MOBILE_352:SOTickets = new SOTickets('MOBILE','3.5.2','B2C_SA_TECH_SO','3.Technical 5.Device 2.Configuration','mobile.qtool@salt.ch');
	public static var MOBILE_361:SOTickets = new SOTickets('MOBILE','3.6.1','B2C_SA_TICKET_SO','3.Technical 6.Multimedia services 1.Ringback tones','mobile.qtool@salt.ch');
	public static var MOBILE_362:SOTickets = new SOTickets('MOBILE','3.6.2','B2C_SA_TICKET_SO','3.Technical 6.Multimedia services 2.Salt Cinema','mobile.qtool@salt.ch');
	public static var MOBILE_364:SOTickets = new SOTickets('MOBILE','3.6.4','B2C_SA_TECH_SO','3.Technical 6.Multimedia services 4.Zattoo TV','mobile.qtool@salt.ch');
	public static var MOBILE_381:SOTickets = new SOTickets('MOBILE','3.8.1','B2C_MNP_SO','3.Technical 8.Mobile Number Portability (MNP) 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_391:SOTickets = new SOTickets('MOBILE','3.9.1','B2C_SA_TECH_SO','3.Technical 9.Wifi Calling 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_412:SOTickets = new SOTickets('MOBILE','4.1.2','B2C_SA_COMPLAINT_SO','4.Poor Service Provided 1.Salt 2.Direct Channels (OC)','mobile.qtool@salt.ch');
	public static var MOBILE_422:SOTickets = new SOTickets('MOBILE','4.2.2','B2C_SA_COMPLAINT_SO','4.Poor Service Provided 2.Indirect  & Partners 2.Partners','mobile.qtool@salt.ch');
	public static var MOBILE_441:SOTickets = new SOTickets('MOBILE', '4.4.1', 'B2C_SA_COMPLAINT_SO', '4.Poor Service Provided 4.Email 1.Complaint', 'mobile.qtool@salt.ch');
	*/
	public static var MOBILE_111:SOTickets = new SOTickets('MOBILE','1.1.1','B2C_SA_MAS_SO','1.Admin 1.Account Management 1.Abusiv Anrufe','mobile.qtool@salt.ch');
	public static var MOBILE_1110:SOTickets = new SOTickets('MOBILE','1.1.10','B2C_SA_TECH_SO','1.Admin 1.Account Management 10.Spoofing','mobile.qtool@salt.ch');
	public static var MOBILE_1112:SOTickets = new SOTickets('MOBILE','1.1.12','B2C_SA_EXPERT_SO','1.Admin 1.Account Management 12.Wangiri Calls','mobile.qtool@salt.ch');
	public static var MOBILE_1113:SOTickets = new SOTickets('MOBILE','1.1.13','B2C_SA_TECH_SO','1.Admin 1.Account Management 13.Spoofing','mobile.qtool@salt.ch');
	public static var MOBILE_112:SOTickets = new SOTickets('MOBILE','1.1.2','B2C_SA_MAS_SO','1.Admin 1.Account Management 2.SMS Spam','mobile.qtool@salt.ch');
	public static var MOBILE_113:SOTickets = new SOTickets('MOBILE','1.1.3','FS_CREDICT_CHECK_SO','1.Admin 1.Account Management 3.Credit Check','mobile.qtool@salt.ch');
	public static var MOBILE_114:SOTickets = new SOTickets('MOBILE','1.1.4','B2C_SA_EXPERT_SO','1.Admin 1.Account Management 4.Recall collection Agency','mobile.qtool@salt.ch');
	public static var MOBILE_115:SOTickets = new SOTickets('MOBILE','1.1.5','B2C_CHANGE_OWNER_SO','1.Admin 1.Account Management 5.Change Owner (only reassignment)','mobile.qtool@salt.ch');
	public static var MOBILE_116:SOTickets = new SOTickets('MOBILE','1.1.6','B2C_SA_MAS_SO','1.Admin 1.Account Management 6.Guardianship','mobile.qtool@salt.ch');
	public static var MOBILE_117:SOTickets = new SOTickets('MOBILE','1.1.7','B2C_SA_MAS_SO','1.Admin 1.Account Management 7.Death','mobile.qtool@salt.ch');
	public static var MOBILE_118:SOTickets = new SOTickets('MOBILE','1.1.8','FS_CREDICT_CHECK_SO','1.Admin 1.Account Management 8.Credit Limit','mobile.qtool@salt.ch');
	public static var MOBILE_119:SOTickets = new SOTickets('MOBILE','1.1.9','B2C_SA_EXPERT_SO','1.Admin 1.Account Management 9.Wangiri Calls','mobile.qtool@salt.ch');
	public static var MOBILE_121:SOTickets = new SOTickets('MOBILE','1.2.1','B2C_SA_TECH_SO','1.Admin 2.My Account 1.Cannot create account','mobile.qtool@salt.ch');
	public static var MOBILE_122:SOTickets = new SOTickets('MOBILE','1.2.2','B2C_SA_TECH_SO','1.Admin 2.My Account 2.Cannot login','mobile.qtool@salt.ch');
	public static var MOBILE_123:SOTickets = new SOTickets('MOBILE','1.2.3','B2C_SA_TECH_SO','1.Admin 2.My Account 3.Content issue','mobile.qtool@salt.ch');
	public static var MOBILE_131:SOTickets = new SOTickets('MOBILE','1.3.1','B2C_SA_TICKET_SO','1.Admin 3.Logistics 1.Issue with Shipment','mobile.qtool@salt.ch');
	public static var MOBILE_132:SOTickets = new SOTickets('MOBILE','1.3.2','B2C_SA_TICKET_SO','1.Admin 3.Logistics 2.Issue with Repair','mobile.qtool@salt.ch');
	public static var MOBILE_133:SOTickets = new SOTickets('MOBILE','1.3.3','B2B_SA_TECH_SO','1.Admin 3.Self Care 3.Salt Mobile App (for iPhone and Android)','mobile.qtool@salt.ch');
	public static var MOBILE_134:SOTickets = new SOTickets('MOBILE','1.3.4','B2B_SA_TECH_SO','1.Admin 3.Self Care 4.Mobile Self Service (#121, #123)','mobile.qtool@salt.ch');
	public static var MOBILE_211:SOTickets = new SOTickets('MOBILE','2.1.1','B2C_SA_MAS_SO','2.Billing 1.Bill & charging content 1.Contestation of premium SMS/MMS','mobile.qtool@salt.ch');
	public static var MOBILE_212:SOTickets = new SOTickets('MOBILE','2.1.2','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 2.Data','mobile.qtool@salt.ch');
	public static var MOBILE_213:SOTickets = new SOTickets('MOBILE','2.1.3','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 3.Messages (SMS/MMS)','mobile.qtool@salt.ch');
	public static var MOBILE_214:SOTickets = new SOTickets('MOBILE','2.1.4','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 4.Roaming','mobile.qtool@salt.ch');
	public static var MOBILE_216:SOTickets = new SOTickets('MOBILE','2.1.6','B2C_SA_TICKET_SO','2.Billing 1.Bill & charging content 6.Discount / Special Offer','mobile.qtool@salt.ch');
	public static var MOBILE_221:SOTickets = new SOTickets('MOBILE','2.2.1','B2C_SA_TICKET_SO','2.Billing 2.Bill method & delivery 1.Bill not received Paynet','mobile.qtool@salt.ch');
	public static var MOBILE_222:SOTickets = new SOTickets('MOBILE','2.2.2','B2C_SA_TICKET_SO','2.Billing 2.Bill method & delivery 2.Bill not received Email','mobile.qtool@salt.ch');
	public static var MOBILE_223:SOTickets = new SOTickets('MOBILE','2.2.3','B2C_SA_EXPERT_SO','2.Billing 2.Bill method & delivery 3.Extrait de compte','mobile.qtool@salt.ch');
	public static var MOBILE_231:SOTickets = new SOTickets('MOBILE','2.3.1','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 1.Amount recharged not credited','mobile.qtool@salt.ch');
	public static var MOBILE_232:SOTickets = new SOTickets('MOBILE','2.3.2','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 2.Cannot recharge','mobile.qtool@salt.ch');
	public static var MOBILE_233:SOTickets = new SOTickets('MOBILE','2.3.3','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 3.Recharge bonus','mobile.qtool@salt.ch');
	public static var MOBILE_234:SOTickets = new SOTickets('MOBILE','2.3.4','B2C_SA_TICKET_SO','2.Billing 3.Recharge (for PrePay) 4.Recurring recharge','mobile.qtool@salt.ch');
	public static var MOBILE_241:SOTickets = new SOTickets('MOBILE','2.4.1','FS_PAYMENT_SEARCH_SO','2.Billing 4.Collection 1.Payment search','mobile.qtool@salt.ch');
	public static var MOBILE_242:SOTickets = new SOTickets('MOBILE','2.4.2','FS_PAYMENT_SEARCH_SO','2.Billing 4.Collection 2.Payment transfer from ID XXX to ID XXX','mobile.qtool@salt.ch');
	public static var MOBILE_243:SOTickets = new SOTickets('MOBILE','2.4.3','FS_PAYMENT_REIMBURSEMENT_SO','2.Billing 4.Collection 3.Payment reimbursement','mobile.qtool@salt.ch');
	public static var MOBILE_251:SOTickets = new SOTickets('MOBILE','2.5.1','B2C_SA_NOT_PROMISE_SO','2.Billing 5.Payment Arrangement 1.Payment arrangement','mobile.qtool@salt.ch');
	
	public static var MOBILE_3101:SOTickets = new SOTickets('MOBILE','3.10.1','B2C_SA_TECH_SO','3.Technical 10.Modem 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_311:SOTickets = new SOTickets('MOBILE','3.1.1','B2C_SA_TECH_SO','3.Technical 1.Network Coverage 1.No coverage','mobile.qtool@salt.ch');
	public static var MOBILE_3111:SOTickets = new SOTickets('MOBILE','3.11.1','B2C_SA_EXPERT_SO','3.Technical 11.Femto 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_312:SOTickets = new SOTickets('MOBILE','3.1.2','B2C_SA_TECH_SO','3.Technical 1.Network Coverage 2.No coverage','mobile.qtool@salt.ch');
	public static var MOBILE_3121:SOTickets = new SOTickets('MOBILE','3.12.1','B2C_SA_TECH_SO','3.Technical 12.Self Care 1.My Account','mobile.qtool@salt.ch');
	//public static var MOBILE_3123:SOTickets = new SOTickets('MOBILE','3.12.3','B2C_SA_TICKET_SO','3.Technical 12.Self Care 3.Salt Mobile App (for iPhone and Android)','mobile.qtool@salt.ch');
	//public static var MOBILE_3124:SOTickets = new SOTickets('MOBILE','3.12.4','B2C_SA_TICKET_SO','3.Technical 12.Self Care 4.Mobile Self Service (#121, #123)','mobile.qtool@salt.ch');
	public static var MOBILE_321:SOTickets = new SOTickets('MOBILE','3.2.1','B2C_SA_TECH_SO','3.Technical 2.Calls 1.Quality','mobile.qtool@salt.ch');
	public static var MOBILE_321_BLACKCELLS:SOTickets = new SOTickets('MOBILE','3.2.1','B2C_SA_TECH_SO','3.Technical 2.Calls 1.Quality - BLACKCELL','mobile.qtool@salt.ch');
	public static var MOBILE_322:SOTickets = new SOTickets('MOBILE','3.2.2','B2C_SA_TECH_SO','3.Technical 2.Calls 2.Cannot make / receive call','mobile.qtool@salt.ch');
	public static var MOBILE_322_BLACKCELLS:SOTickets = new SOTickets('MOBILE','3.2.2','B2C_SA_TECH_SO','3.Technical 2.Calls 2.Cannot make / receive call - BLACKCELL','mobile.qtool@salt.ch');
	public static var MOBILE_322_ESCA:SOTickets = new SOTickets('MOBILE','3.2.2','B2C_SA_TECH_ESCA_SO','3.Technical 2.Calls 2.Cannot make / receive call','mobile.qtool@salt.ch');
	public static var MOBILE_323:SOTickets = new SOTickets('MOBILE','3.2.3','B2C_SA_TECH_SO','3.Technical 2.Calls 3.Missed / white calls','mobile.qtool@salt.ch');
	public static var MOBILE_323_BLACKCELLS:SOTickets = new SOTickets('MOBILE','3.2.3','B2C_SA_TECH_SO','3.Technical 2.Calls 3.Missed / white calls - BLACKCELL','mobile.qtool@salt.ch');
	public static var MOBILE_324:SOTickets = new SOTickets('MOBILE','3.2.4','B2C_SA_TECH_SO','3.Technical 2.Calls 4.Dropped calls','mobile.qtool@salt.ch');
	public static var MOBILE_324_BLACKCELLS:SOTickets = new SOTickets('MOBILE','3.2.4','B2C_SA_TECH_SO','3.Technical 2.Calls 4.Dropped calls  - BLACKCELL','mobile.qtool@salt.ch');
	public static var MOBILE_325:SOTickets = new SOTickets('MOBILE','3.2.5','B2C_SA_TECH_SO','3.Technical 2.Calls 5.Value added Calls','mobile.qtool@salt.ch');
	public static var MOBILE_331:SOTickets = new SOTickets('MOBILE','3.3.1','B2C_SA_TECH_SO','3.Technical 3.SMS/MMS 1.Cannot send & receive','mobile.qtool@salt.ch');
	public static var MOBILE_332:SOTickets = new SOTickets('MOBILE','3.3.2','B2C_SA_TECH_SO','3.Technical 3.SMS/MMS 2.Send & Receive multiple time','mobile.qtool@salt.ch');
	public static var MOBILE_333:SOTickets = new SOTickets('MOBILE','3.3.3','B2C_SA_TECH_SO','3.Technical 3.SMS/MMS 3.Value added services','mobile.qtool@salt.ch');
	public static var MOBILE_341:SOTickets = new SOTickets('MOBILE','3.4.1','B2C_SA_TECH_SO','3.Technical 4.Data 1.No / intermittent connection','mobile.qtool@salt.ch');
	public static var MOBILE_341_ESCA:SOTickets = new SOTickets('MOBILE','3.4.1','B2C_SA_TECH_ESCA_SO','3.Technical 4.Data 1.No / intermittent connection','mobile.qtool@salt.ch');
	public static var MOBILE_342:SOTickets = new SOTickets('MOBILE','3.4.2','B2C_SA_TECH_SO','3.Technical 4.Data 2.Speed','mobile.qtool@salt.ch');
	public static var MOBILE_351:SOTickets = new SOTickets('MOBILE','3.5.1','B2C_SA_TECH_SO','3.Technical 5.Device 1.Broken or defective','mobile.qtool@salt.ch');
	public static var MOBILE_352:SOTickets = new SOTickets('MOBILE','3.5.2','B2C_SA_TECH_SO','3.Technical 5.Device 2.Configuration','mobile.qtool@salt.ch');
	//public static var MOBILE_361:SOTickets = new SOTickets('MOBILE','3.6.1','B2C_SA_TICKET_SO','3.Technical 6.Multimedia services 1.Ringback tones','mobile.qtool@salt.ch');
	//public static var MOBILE_362:SOTickets = new SOTickets('MOBILE','3.6.2','B2C_SA_TICKET_SO','3.Technical 6.Multimedia services 2.Salt Cinema','mobile.qtool@salt.ch');
	public static var MOBILE_364:SOTickets = new SOTickets('MOBILE','3.6.4','B2C_SA_TECH_SO','3.Technical 6.Multimedia services 4.Zattoo TV','mobile.qtool@salt.ch');
	public static var MOBILE_381:SOTickets = new SOTickets('MOBILE','3.8.1','B2C_MNP_SO','3.Technical 8.Mobile Number Portability (MNP) 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_391:SOTickets = new SOTickets('MOBILE','3.9.1','B2C_SA_TECH_SO','3.Technical 9.Wifi Calling 1.Troubleshooting','mobile.qtool@salt.ch');
	public static var MOBILE_392:SOTickets = new SOTickets('MOBILE','3.9.2','B2B_SA_TECH_SO','3.Technical 9.BlackBerry 2.Blackberry Enterprise Services','mobile.qtool@salt.ch');
	
	public static var MOBILE_411:SOTickets = new SOTickets('MOBILE','4.1.1','LS_REPAIR_COMPLAIN_SO','4.Poor Service Provided 1.Salt 1.Logistic repair','mobile.qtool@salt.ch');
	public static var MOBILE_412:SOTickets = new SOTickets('MOBILE','4.1.2','B2C_SA_COMPLAINT_SO','4.Poor Service Provided 1.Salt 2.Direct Channels (OC)','mobile.qtool@salt.ch');
	public static var MOBILE_413:SOTickets = new SOTickets('MOBILE','4.1.3','B2B_SA_NONTECH_SO','4.Poor Service Provided 1.Salt 3.Online','mobile.qtool@salt.ch');
	public static var MOBILE_422:SOTickets = new SOTickets('MOBILE','4.2.2','B2C_SA_COMPLAINT_SO','4.Poor Service Provided 2.Indirect  & Partners 2.Partners','mobile.qtool@salt.ch');
	public static var MOBILE_441:SOTickets = new SOTickets('MOBILE','4.4.1','B2C_SA_COMPLAINT_SO','4.Poor Service Provided 4.Email 1.Complaint','mobile.qtool@salt.ch');
	//public static var MOBILE_511:SOTickets = new SOTickets('MOBILE','5.1.1','B2C_FINANCIAL_COMPLAINT_SO','5.Escalation 1.Compensation 1.Request for Compensation','mobile.qtool@salt.ch');
	public static var MOBILE_511_ACCEPT:SOTickets = new SOTickets('MOBILE','5.1.1','B2C_FINANCIAL_BILLSHOCK_SO','5.Escalation 1.Compensation 1.Request for Compensation','mobile.qtool@salt.ch');
	public static var MOBILE_511_REFUSES:SOTickets = new SOTickets('MOBILE','5.1.1','B2C_SA_COMPLAINT_SO',' REFUSES 5.Escalation 1.Compensation 1.Request for Compensation','mobile.qtool@salt.ch');
	public static var MOBILE_511:SOTickets = new SOTickets('MOBILE','5.1.1','B2C_FINANCIAL_COMPLAINT_SO','5.Escalation 1.Compensation 1.Request for Compensation','mobile.qtool@salt.ch');
	public static var MOBILE_521:SOTickets = new SOTickets('MOBILE','5.2.1','LIDL_REGISTRATION_SO','5.Escalation 2.Registration 1.ID Check - Escalation to Care','mobile.qtool@salt.ch');
	public static var MOBILE_611:SOTickets = new SOTickets('MOBILE','6.1.1','IDCHECK_FAILED_SO','6.Ordering 1.Prepay Order 1.Prepay ID Check Failed','mobile.qtool@salt.ch');
	public static var MOBILE_621:SOTickets = new SOTickets('MOBILE','6.2.1','IDCHECK_FAILED_SO','6.Ordering 2.Postpay Order 1.Postpay ID Check Failed','mobile.qtool@salt.ch');
	public static var MOBILE_911:SOTickets = new SOTickets('MOBILE','9.1.1','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 1.New Activation','mobile.qtool@salt.ch');
	public static var MOBILE_912:SOTickets = new SOTickets('MOBILE','9.1.2','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 2.Retention','mobile.qtool@salt.ch');
	public static var MOBILE_913:SOTickets = new SOTickets('MOBILE','9.1.3','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 3.MNP','mobile.qtool@salt.ch');
	public static var MOBILE_914:SOTickets = new SOTickets('MOBILE','9.1.4','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 4.Multisurf','mobile.qtool@salt.ch');
	public static var MOBILE_915:SOTickets = new SOTickets('MOBILE','9.1.5','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 5.Logistics','mobile.qtool@salt.ch');
	public static var MOBILE_916:SOTickets = new SOTickets('MOBILE','9.1.6','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 6.Other','mobile.qtool@salt.ch');
	public static var MOBILE_917:SOTickets = new SOTickets('MOBILE','9.1.7','CS_SALES_SUPPORT_SO','9.Sales 1.Salt Store 7.Product Price','mobile.qtool@salt.ch');
	public static var MOBILE_921:SOTickets = new SOTickets('MOBILE','9.2.1','CS_SALES_SUPPORT_SO','9.Sales 2.Indirect Channel 1.New Activation','mobile.qtool@salt.ch');
	public static var MOBILE_922:SOTickets = new SOTickets('MOBILE','9.2.2','CS_SALES_SUPPORT_SO','9.Sales 2.Indirect Channel 2.Retention','mobile.qtool@salt.ch');
	public static var MOBILE_923:SOTickets = new SOTickets('MOBILE','9.2.3','CS_SALES_SUPPORT_SO','9.Sales 2.Indirect Channel 3.MNP','mobile.qtool@salt.ch');
	public static var MOBILE_924:SOTickets = new SOTickets('MOBILE','9.2.4','CS_SALES_SUPPORT_SO','9.Sales 2.Indirect Channel 4.Multisurf','mobile.qtool@salt.ch');
	public static var MOBILE_925:SOTickets = new SOTickets('MOBILE','9.2.5','CS_SALES_SUPPORT_SO','9.Sales 2.Indirect Channel 5.Other','mobile.qtool@salt.ch');
	public static var MOBILE_927:SOTickets = new SOTickets('MOBILE','9.2.7','CS_SALES_SUPPORT_SO','9.Sales 2.Indirect Channel 7.Product Price','mobile.qtool@salt.ch');
	public static var MOBILE_931:SOTickets = new SOTickets('MOBILE','9.3.1','OS_FRONT_SO','9.Sales 3.Online Sales & Telesales 1.Login (MyAccount)','mobile.qtool@salt.ch');
	public static var MOBILE_933:SOTickets = new SOTickets('MOBILE','9.3.3','OS_FRONT_SO','9.Sales 3.Online Sales & Telesales 3.Retention','mobile.qtool@salt.ch');
	public static var MOBILE_934:SOTickets = new SOTickets('MOBILE','9.3.4','OS_FRONT_SO','9.Sales 3.Online Sales & Telesales 4.MNP','mobile.qtool@salt.ch');
	public static var MOBILE_935:SOTickets = new SOTickets('MOBILE','9.3.5','OS_FRONT_SO','9.Sales 3.Online Sales & Telesales 5.Multisurf','mobile.qtool@salt.ch');
	public static var MOBILE_937:SOTickets = new SOTickets('MOBILE','9.3.7','ERF_WAIVING_BATCH','9.Sales 3.Online Sales & Telesales 7.Early Retention campaigns','mobile.qtool@salt.ch');
	public static var MOBILE_941:SOTickets = new SOTickets('MOBILE','9.4.1','OS_FRONT_SO','9.Sales 4.Telesales 1.New Activation','mobile.qtool@salt.ch');
	public static var MOBILE_942:SOTickets = new SOTickets('MOBILE','9.4.2','OS_FRONT_SO','9.Sales 4.Telesales 2.Retention','mobile.qtool@salt.ch');
	public static var MOBILE_944:SOTickets = new SOTickets('MOBILE','9.4.4','OS_FRONT_SO','9.Sales 4.Telesales 4.Multisurf','mobile.qtool@salt.ch');
	public static var MOBILE_945:SOTickets = new SOTickets('MOBILE','9.4.5','OS_FRONT_SO','9.Sales 4.Telesales 5.Other','mobile.qtool@salt.ch');
	public static var MOBILE_951:SOTickets = new SOTickets('MOBILE','9.5.1','OS_BACKOFFICE_2_SO','9.Sales 5.Salt ID Check 1.Salt Prepay ID Check Failed','mobile.qtool@salt.ch');
	public static var MOBILE_952:SOTickets = new SOTickets('MOBILE','9.5.2','OS_BACKOFFICE_2_SO','9.Sales 5.Salt ID Check 2.Salt Postpay ID Check Failed','mobile.qtool@salt.ch');

	/**
	 * @todo correct queue
	 */
	public static var MOBILE_531:SOTickets = new SOTickets('MOBILE','5.3.1','ESC_SM_SO','5.*Escalation 3.*Care Channel 1.REF Defect','mobile.qtool@salt.ch');
	public static var MOBILE_531_ESCA:SOTickets = new SOTickets('MOBILE','5.3.1','B2C_SA_TECH_ESCA_SO','5.*Escalation 3.*Care Channel 1.REF Defect 600','mobile.qtool@salt.ch');

}