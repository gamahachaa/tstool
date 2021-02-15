package tstool.salt;
using tstool.utils.StringUtils;
import tstool.process.Process;
import tstool.utils.Mail;

/**
 * ...
 * @author bb
 */
enum TemplateStyle {
	SMS;
	EMAIL;
	BOTH;
}
class TemplateMail extends Mail 
{
	var soTemplate:SOTemplate;
	var _currentProcess:Process;

	public function new( soTemplate:SOTemplate, currentProcess:Process) 
	{
		super();
		this._currentProcess = currentProcess;
		this.soTemplate = soTemplate;
		setReciepients(soTemplate.email);
		//setTemplateSubject();
	}
	
	public function setTemplateSubject( style: TemplateStyle, msisdn:String, email:String) 
	{
		var _queue = soTemplate.queue + "_"; // Nico change 25.03.2020
		var _mailSubject = soTemplate.domain + "-" + soTemplate.number + " " + soTemplate.desc;
		var msisdnLocalised = msisdn.indexOf("07") == 0 ? msisdn : msisdn.intlToLocalMSISDN();
		#if debug
		var s = '[${msisdnLocalised}][$_queue][${MainApp.agent.twoCharsLang()}][${Std.string(style)}][$email][$msisdnLocalised][${soTemplate.number}] ${_mailSubject}' ;
		#else
		var s = '[${Main.customer.iri}][$_queue][${MainApp.agent.twoCharsLang()}][${Std.string(style)}][$email][$msisdnLocalised][${soTemplate.number}] ${_mailSubject}' ;
		#end
		//var s = '[${Main.customer.iri}][$_queue][${MainApp.agent.twoCharsLang()}][${Std.string(style)}][$email][$msisdnLocalised][${soTemplate.number}] ${_mailSubject}' ;
		setSubject(s);
	}
	override function setBody(memo:String) 
	{
		var mailBody = memo;
		mailBody += Main.customer.buildCustomerBody( memo.indexOf( Main.customer.contract.mobile ) >-1);
		mailBody += Main.HISTORY.buildHistoryEmailBody(MainApp.agent.mainLanguage, _currentProcess, false);
		mailBody += MainApp.agent.buildEmailBody( Main.HISTORY.getFirst().start, Main.HISTORY.getLast().start);
		super.setBody(mailBody);
	}
	
}