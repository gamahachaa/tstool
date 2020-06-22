package tstool.process;
import Main;
import flixel.FlxG;
import tstool.layout.SaltColor;
import lime.utils.Assets;
import openfl.text.TextField;
import openfl.text.TextFieldType;
import openfl.text.TextFormat;
import salt.SOTickets;
import tstool.utils.Csv;
import tstool.utils.Mail;
/**
 * ...
 * @author bb
 */
class ActionMail extends Action
{
	var memoDefault:String;
	var mail:Mail;
	var ticket:SOTickets;
	var tf:TextField;
	public function new(ticket: SOTickets)
	{
		super();
		this.ticket = ticket;
		mail = new Mail(ticket, this);
		#if debug
		trace(ticket);
		#end
		//mail.currentProcess = this;
		//mail.statusSignal.add(onMailStatus);

		//mail.errorSignal.add(onMailError);
	}
	override public function create()
	{
		var textFieldFormat:TextFormat = new TextFormat(Assets.getFont("assets/fonts/Lato-Regular.ttf").name, 12, 0);
		var eta = translate("cycleTime", "UI1", "meta");
		
		eta = StringTools.replace(eta, "<X>", prepareCycleTime());
		memoDefault = translate("describeIssue", "UI1", "meta");
		tf = new TextField();
		tf.multiline = true;
		tf.type = tf.type = TextFieldType.INPUT;
		//tf.autoSize = TextFieldAutoSize.LEFT;
		tf.width = 500;
		tf.height = 50;
		tf.wordWrap = true;
		//tf.textWidth = 500;
		tf.backgroundColor = SaltColor.WHITE;
		tf.textColor = SaltColor.BLACK;
		tf.text = memoDefault;
		tf.border = true;
		tf.borderColor = SaltColor.BLACK;
		tf.background = true;
		tf.defaultTextFormat = textFieldFormat;
		// special Texfield  positioning
		FlxG.addChildBelowMouse( tf );
		//
		tf.x = 10;
		tf.y = 10;
		//if(Main.DEBUG) _detailTxt += '\n- $eta'; // en test seulement pour l'instant
		_detailTxt += prepareHistory();
		super.create();
		//FlxG.keys.preventDefaultKeys = [ FlxKey.TAB];
		this.question.text += "\n" + ticket.desc;
		
	}
	override function positionThis()
	{
		super.positionThis();
		this.tf.x = this.question.x;
		this.tf.y = this.question.y + this.question.height + (this._padding*2);
	}
	function onMailError(parameter0:Dynamic):Void
	{
		closeSubState();
		//openSubState(new DataView(0xEE000000, this._name, "\n\nCould not create the ticket !!!\n\nPlease do a print screen of this and send it to qook@salt.ch");
	}

	function onMailSuccess(data:Result):Void
	{
		closeSubState();
		Main.track.setCase(this.ticket);
		Main.track.setVerb("submitted");
		
		switch data.status {
			case "success" : super.onClick();
			case "failed" : openSubState(new DataView(Main.THEME.bg, this._name, "\n\nCould not create the ticket !!!\n\nPlease do a print screen of this and send it to qook@salt.ch\n"+data.error));
		}
	}

	function onMailStatus(parameter0:Int):Void
	{
		closeSubState();
		if (parameter0 != 200) openSubState(new DataView(Main.THEME.bg, this._name, '\n\nhttp status $parameter0, \n\nCould not create the ticket !!!\nPlease do a print screen of this and send it to qook@salt.ch'));
	}
	override public function onClick()
	{
		tf.visible = false;
		openSubState(new TicketSendSub(Main.THEME.bg));
		mail.successSignal.addOnce(onMailSuccess);
		mail.send( tf.text == memoDefault ?'': tf.text);
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
		trace(t);
		#end
		return t;
	}
	function prepareCycleTime()
	{
		var lang = Main.user.mainLanguage == null ? "EN" : Main.user.mainLanguage.split("-")[1];
		//var data = Assets.getText("assets/data/20200402_CycleTimeExpectedNextWeek_BB.csv");
		var csv:Csv = new Csv(Assets.getText("assets/data/20200402_CycleTimeExpectedNextWeek_BB.csv"), ";", false);
		var cycleTime = csv.dict.exists(this.ticket.queue) ? csv.dict.get(this.ticket.queue).get(lang) : "";
		return cycleTime ;
	}
}