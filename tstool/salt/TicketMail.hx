package tstool.salt;

import tstool.layout.History.Interactions;
import tstool.layout.History.Snapshot;
import tstool.process.Process;
import tstool.utils.Mail;

/**
 * ...
 * @author bb
 */
class TicketMail extends Mail 
{
	var _ticket:SOTickets;
	var _currentProcess(default, set):Process;
	var resolved:Bool;
	public function new(ticket:SOTickets, currentProcess:Process, ?resolved:Bool=false) 
	{
		super();
		this._ticket = ticket;
		this.resolved = resolved;
		this._currentProcess = currentProcess;
		setReciepients(_ticket.email);
		setTicketSubject();
	}
	/**
	 * called by embeder
	 * @param	body
	 */
	override function setBody(memo:String) 
	{
		var mailBody = memo;
		mailBody += Main.customer.buildCustomerBody( memo.indexOf( Main.customer.contract.mobile ) >-1);
		mailBody += Main.HISTORY.buildHistoryEmailBody(MainApp.agent.mainLanguage, _currentProcess);
		mailBody += MainApp.agent.buildTSEmailBody( Main.HISTORY.getFirst().start, Main.HISTORY.getLast().start);
		super.setBody(mailBody);
	}
	function setTicketSubject()
	{
		var isResolved = resolved?"[RESOLVED]":"";	
		var _queue =_ticket.queue + "_"; // Nico change 25.03.2020
		var _mailSubject = _ticket.domain + "-" + _ticket.number + " " + _ticket.desc;
		
		var s = '[${Main.customer.iri}][$_queue][${MainApp.agent.sAMAccountName}]$isResolved $_mailSubject' ;
		setSubject(s);
	}
	
	function set__currentProcess(value:Process):Process 
	{
		return _currentProcess = value;
	}
	
}
