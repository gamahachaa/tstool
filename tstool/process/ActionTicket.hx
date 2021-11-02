package tstool.process;
import Main;
import tstool.layout.UI;
import tstool.utils.SwiftMailWrapper.Result;
import tstool.salt.TicketMail;
import tstool.salt.SOTickets;

/**
 * ...
 * @author bb
 */
class ActionTicket extends ActionMemo
{
	var mail:TicketMail;
	var ticket:SOTickets;
	var resolved:Bool;

	
	public function new(ticket: SOTickets, ?resolved:Bool=false)
	{
		super();
		this.ticket = ticket;
		this.resolved = resolved;
		mail = new TicketMail(this.ticket, this, resolved);
		
		#if debug
		//trace(ticket);
		#end
	
	}
	override public function create()
	{
		
		/*///// Cycle time //////
		var eta = translate("cycleTime", "UI1", "meta");
		eta = StringTools.replace(eta, "<X>", prepareCycleTime());
		////////////////////////*/
		
		//_detailTxt = verfifyContctNumber + _detailTxt;
		
		super.create();
		if (Main.customer.contract.mobile != "" || Main.customer.contract.getEmails() != [])
		{
			defaultMemo = "CONTACT:";
			if (Main.customer.contract.mobile != "")
				defaultMemo += " " + Main.customer.contract.mobile;		
			if (Main.customer.contract.getEmails() != [])
				defaultMemo += " " + Main.customer.contract.getEmails().join(" ");
		}
		
		memoTxtArea.inputtextfield.text = defaultMemo;
		
		//this.question.text += "\n" + ticket.desc;
		details.autoSize = true;
		this.details.textField.htmlText = _detailTxt;
	}
	

	
	function onMailError(parameter0:Dynamic):Void
	{
		#if debug
		trace("tstool.process.ActionMail::onMailError::onMailError", parameter0 );
		#end
		closeSubState();
	}

	function onMailSuccess(data:Result):Void
	{
		#if debug
		trace("tstool.process.ActionMail::onMailSuccess::data", data );
		#end
		closeSubState();
		Main.track.setCase(this.ticket);
		Main.track.setVerb("submitted");
		//Main.track.
		
		switch data.status {
			case "success" : super.onClick();
			case "failed" : openSubState(new DataView(UI.THEME.bg, this._name, '\nFailed to create the ticket !!!\n\nPlease do a print screen of this and send it to qook@salt.ch\n+${data.error} (${data.additional}). Also make note of the steps and raise the same S.O. ${ticket.number} ticket manually '));
		}
	}

	function onMailStatus(parameter0:Int):Void
	{
		closeSubState();
		if (parameter0 != 200) openSubState(new DataView(UI.THEME.bg, this._name, '\n\nhttp status $parameter0, \n\nCould not create the ticket !!!\nPlease do a print screen of this and send it to qook@salt.ch'));
	}
	override public function onClick()
	{
		
		if (validate())
		{
			//var txt = memoTxtArea.getInputedText();
			memoTxtArea.show(false);
			#if debug
			trace("tstool.process.ActionMail::onClick");
			#end
			openSubState(new TicketSendSub());
			mail.successSignal.addOnce(onMailSuccess);
			mail.build( buildMemo(memoTxt, defaultMemo) );
			mail.send();
		}
	}
	inline function buildMemo(memo:String, defautlTxt:String)
	{
		return "<p><strong>MEMO:</strong><br/>"+ (StringTools.trim(memo) == ""? "No memo written by agent" : memo) + "</p>";
	}
	
	override public function destroy()
    {
		super.destroy();
		this.mail = null;
	}
	
}