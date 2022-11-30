package tstool.process;
import Main;
import haxe.Exception;
import js.Browser;
import lime.utils.AssetType;
import lime.utils.Assets;
import tstool.layout.UI;
import tstool.salt.SuperOffice;
import tstool.utils.SwiftMailWrapper.Result;
import tstool.salt.TicketMail;
import tstool.salt.SOTickets;
import xapi.Activity;
import xapi.Verb;
//import xapi.activities.Definition;
using StringTools;

/**
 * ...
 * @author bb
 */
class ActionTicket extends ActionMemo
{
	var mail:TicketMail;
	var ticket:SuperOffice;
	var resolved:Bool;

	public function new(ticket: SOTickets, ?resolved:Bool=false)
	{
		try
		{
			super();
            
			//this.ticket = ticket;
            var description = ticket.desc;
			var a:String = "";
			for (i in Assets.list(AssetType.TEXT))
			{
				if (i.indexOf(Main.TMP_FILTER_ASSET_PATH) >-1)
				{
					a =  Assets.getText(i);

					if ( a.indexOf( Main.customer.iri ) >-1)
					{
						description += " | " + i.replace(Main.TMP_FILTER_ASSET_PATH,"").replace(".txt","");
					}
				}
			}
            this.ticket = ticket.cloneWithNewAttributes([descs => description]);
			mail = new TicketMail(cast this.ticket, this, resolved);
		}
		catch (e:Exception)
		{
			trace(e);
		}

	}
	//function renameticket(s:String, ticket:SOTickets)
	//{
		//ticket.desc += ' $s ${this.ticket.desc}';
	//}
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
			//trace(e);
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
		cast(Main.trackH.object, Activity).definition.extensions.set("https://cs.salt.ch", this.ticket.toString() );
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
			mail.successSignal.addOnce(onMailSuccess);
			openSubState(new TicketSendSub());

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