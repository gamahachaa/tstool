package tstool.process;
import Main;
import flixel.FlxG;
import flixel.math.FlxPoint;
//import openfl.events.FocusEvent;
import tstool.layout.BIGUIInputTfCore;
//import tstool.layout.SaltColor;
//import lime.utils.Assets;
//import openfl.text.TextField;
//import openfl.text.TextFieldType;
//import openfl.text.TextFormat;
import tstool.salt.SOTickets;
//import tstool.utils.Csv;
import tstool.utils.Mail;
import tstool.utils.SwiftMailWrapper;
/**
 * ...
 * @author bb
 */
class ActionMail extends Action
{
	var memoDefault:String;
	var mail:Mail;
	var ticket:SOTickets;
	//var tf:TextField;
	var hasFocus:Bool;
	var memoTxtArea:tstool.layout.BIGUIInputTfCore;
	var resolved:Bool;
	var verfifyContctNumber:String;
	public function new(ticket: SOTickets, ?resolved:Bool=false)
	{
		super();
		this.ticket = ticket;
		this.resolved = resolved;
		//mail = new Mail(ticket, this);
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

		hasFocus = false;
		verfifyContctNumber = translate("verifiyContactDetails", "UI1", "meta");
		//trace(verfifyContctNumber);
		memoDefault = translate("describeIssue", "UI1", "meta");
		memoTxtArea = new BIGUIInputTfCore(750, 50, memoDefault, [bottom, left]);
		memoTxtArea.inputtextfield.text = "CONTACT: " + Main.customer.contract.mobile + " ";
		
		//_detailTxt += verfifyContctNumber + prepareHistory();
		_detailTxt = verfifyContctNumber + _detailTxt + prepareHistory();
		//details.textField.html = true;
		//_detailTxt += "FAUCK";
		mail = new Mail(ticket, this, resolved);
		
		super.create();
		//this.details.text = verfifyContctNumber + "\n" + this._detailTxt;
		this.question.text += "\n" + ticket.desc;
		this.details.textField.htmlText = _detailTxt;
		
		memoTxtArea.addToParent(this);
	}
	override function positionThis(?offSet:FlxPoint)
	{
		super.positionThis();
		var r = this.question.boundingRect;
		//r.height = r.height  + _padding;
		var p = this.memoTxtArea.positionMe(r, _padding);
		positionBottom(p);
		positionButtons(p);
		

	}
	override public function setStyle()
	{
		super.setStyle();
		memoTxtArea.setStyle();
	}
	
	function onMailError(parameter0:Dynamic):Void
	{
		closeSubState();
	}

	function onMailSuccess(data:Result):Void
	{
		closeSubState();
		Main.track.setCase(this.ticket);
		Main.track.setVerb("submitted");
		
		switch data.status {
			case "success" : super.onClick();
			case "failed" : openSubState(new DataView(Main.THEME.bg, this._name, '\nFailed to create the ticket !!!\n\nPlease do a print screen of this and send it to qook@salt.ch\n+${data.error} (${data.additional}). Also make note of the steps and raise the same S.O. ${ticket.number} ticket manually '));
		}
	}

	function onMailStatus(parameter0:Int):Void
	{
		closeSubState();
		if (parameter0 != 200) openSubState(new DataView(Main.THEME.bg, this._name, '\n\nhttp status $parameter0, \n\nCould not create the ticket !!!\nPlease do a print screen of this and send it to qook@salt.ch'));
	}
	override public function onClick()
	{
		var txt = memoTxtArea.getInputedText();
		var content = memoTxtArea.getInputedText().split(" ");
		if (content.length < 3)
		{
			memoTxtArea.blink(true);
		}
		else{
			memoTxtArea.inputtextfield.visible = false;
			#if debug
			trace(txt);
			mail.send( txt );
			#else
			openSubState(new TicketSendSub(Main.THEME.bg));
			
			mail.successSignal.addOnce(onMailSuccess);
			mail.send( txt );
			#end
		}
	}
	function prepareHistory()
	{
		var hist = Main.HISTORY.history;
		var t = "\n\nSummrary :\n";
		for ( i in hist )
		{
			t += i.processTitle + " :: " + i.iteractionTitle + (i.values==null? "": i.values.toString()) + "\n" ;
		}
		#if debug
		//trace(t);
		#end
		return t;
	}
	/*
	function prepareCycleTime()
	{
		var lang = Main.user.mainLanguage == null ? "EN" : Main.user.mainLanguage.split("-")[1];
		//var data = Assets.getText("assets/data/20200402_CycleTimeExpectedNextWeek_BB.csv");
		var csv:Csv = new Csv(Assets.getText("assets/data/20200402_CycleTimeExpectedNextWeek_BB.csv"), ";", false);
		var cycleTime = csv.dict.exists(this.ticket.queue) ? csv.dict.get(this.ticket.queue).get(lang) : "";
		return cycleTime ;
	}*/
	override public function destroy()
    {
		super.destroy();
		this.mail = null;
	}
	override public function update(elapsed)
	{
		super.update(elapsed);
		if (FlxG.keys.justReleased.BACKSPACE)
		{
			memoTxtArea.clearText();
		}
	
	}
	
}