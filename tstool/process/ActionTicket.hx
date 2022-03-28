package tstool.process;
import Main;
import haxe.Exception;
import js.Browser;
import lime.utils.Assets;
import tstool.layout.UI;
import tstool.utils.SwiftMailWrapper.Result;
import tstool.salt.TicketMail;
import tstool.salt.SOTickets;
import xapi.Activity;
import xapi.Verb;
//import xapi.activities.Definition;

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
		try
		{
			super();

			this.ticket = ticket;
			/**
			 * @todo FIX out of main classes
			 */
			#if fiber
			this.resolved = resolved;
			var fut = Assets.getText("assets/data/ipv4_fut.txt");
			var fut_start:Float = new Date(2022, 1, 17, 0, 0, 0).getTime();

			if (fut.indexOf(Main.customer.contract.contractorID) >-1 && Date.now().getTime()>fut_start)
			{
				//this.ticket.desc = "MIGipV6 " + this.ticket.desc;

				this.ticket.queue = "FIBER_IP_MIGRATION_SO";
			}
			#end
			mail = new TicketMail(this.ticket, this, resolved);
		}
		catch (e:Exception)
		{
			trace(e);
		}

	}
	override public function create()
	{

		try
		{

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
		catch (e:Exception)
		{
			trace(e);
		}
	}

	function onMailError(parameter0:Dynamic):Void
	{
		
		closeSubState();
	}

	function onMailSuccess(data:Result):Void
	{
		
		closeSubState();
		//#if debug
		Main.trackH.setVerb(Verb.submitted);
		Main.trackH.setContext(
			null, 
			Browser.location.protocol + Browser.location.hostname + Browser.location.pathname,
			"trouble", 
			MainApp.translator.locale, 
			null
			);
         
		cast(Main.trackH.object, Activity).definition.extensions.set("https://cs.salt.ch", this.ticket.toString() );

		//#else
		//Main.track.setCase(this.ticket);
		//Main.track.setVerb("submitted");
		//#end

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
			
			openSubState(new TicketSendSub());
			mail.successSignal.addOnce(onMailSuccess);
			mail.build( buildMemo(memoTxt, defaultMemo) );
			mail.send();
		}
	}
	inline function buildMemo(memo:String, defautlTxt:String)
	{
		
		var m = StringTools.trim(memo) ;
		if (m == "")
			m = "<p><strong>MEMO:</strong><br/>No memo written by agent</p>";
		else
			m = "<p><strong>MEMO:</strong><br/>"+ StringTools.replace(memo,"\n","<br/>") + "</p>";
		return m;
	}

	override public function destroy()
	{
		super.destroy();
		this.mail = null;
	}

}