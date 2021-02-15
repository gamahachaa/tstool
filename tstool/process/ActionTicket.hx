package tstool.process;
import Main;
import flixel.FlxG;
import flixel.math.FlxPoint;
import tstool.salt.TicketMail;
import tstool.layout.ScriptView;
import tstool.layout.UI;
import tstool.layout.BIGUIInputTfCore;
import tstool.salt.SOTickets;
//import tstool.utils.Mail;
import tstool.utils.SwiftMailWrapper;
/**
 * ...
 * @author bb
 */
class ActionTicket extends Action
{
	var memoDefault:String;
	var mail:TicketMail;
	var ticket:SOTickets;
	//var tf:TextField;
	var hasFocus:Bool;
	var memoTxtArea:tstool.layout.BIGUIInputTfCore;
	var resolved:Bool;
	var verfifyContctNumber:String;
	var scriptView:tstool.layout.ScriptView;
	var defaultMemo:String;
	
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

		hasFocus = false;
		verfifyContctNumber = translate("verifiyContactDetails", "UI1", "meta");
		
		memoDefault = translate("describeIssue", "UI1", "meta");
		memoTxtArea = new BIGUIInputTfCore(750, 50, memoDefault, [bottom, left]);
		defaultMemo = "CONTACT: " + Main.customer.contract.mobile + " ";
		memoTxtArea.inputtextfield.text = defaultMemo;
		
		
		_detailTxt = verfifyContctNumber + _detailTxt;
		
		super.create();
		scriptView = new ScriptView(Main.HISTORY.prepareListHistory());
		scriptView.signal.add(sbStateListener);
		this.question.text += "\n" + ticket.desc;
		details.autoSize = true;
		this.details.textField.htmlText = _detailTxt;
		memoTxtArea.addToParent(this);
		ui.script.visible = true;
	}
	
	function sbStateListener():Void 
	{
		memoTxtArea.show();
	}
	override function positionThis(?offSet:FlxPoint)
	{
		super.positionThis();
		var p = this.memoTxtArea.positionMe(this.question.boundingRect, _padding);
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
		
		if (!validate())
		{
			memoTxtArea.blink(true);
		}
		else{
			var txt = memoTxtArea.getInputedText();
			memoTxtArea.show(false);
			#if debug
			trace("tstool.process.ActionMail::onClick");
			openSubState(new TicketSendSub(UI.THEME.bg));
			mail.successSignal.addOnce(onMailSuccess);
			mail.build( buildMemo(txt, defaultMemo) );
			mail.send();
			
			#else
			openSubState(new TicketSendSub(UI.THEME.bg));
			mail.successSignal.addOnce(onMailSuccess);
			mail.build( buildMemo(txt, defaultMemo) );
			mail.send();
			#end
		}
	}
	inline function buildMemo(memo:String, defautlTxt:String)
	{
		return "<p><strong>MEMO:</strong><br/>"+ (StringTools.trim(memo) == ""? "No memo written by agent" : memo) + "</p>";
	}
	function validate()
	{
		return memoTxtArea.getInputedText().split(" ").length >= 3 ;
	}
	
	override function listener(s:String):Void 
	{
		switch (s){
			case "en-GB" : switchLang("en-GB");
			case "it-IT" : switchLang("it-IT");
			case "de-DE" : switchLang("de-DE");
			case "fr-FR" : switchLang("fr-FR");
			case "onQook" : onQook();
			case "onScript" : onScript();
			case "onExit" : onExit();
			case "onBack" : onBack();
			case "onHowTo" : onHowTo();
			case "toogleTrainingMode" : toogleTrainingMode();
			case "onComment" : onComment();
			case "setStyle" : setStyle();
			case "openSubState" : openSubState(dataView);
		}
	}
	
	function onScript() 
	{
		memoTxtArea.show( false );
		memoTxtArea.inputtextfield.visible = false;
		openSubState( scriptView );
	}
	
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