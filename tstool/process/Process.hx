package tstool.process;

import tstool.layout.History;
import tstool.layout.PageLoader;
import tstool.layout.ScriptView;
import tstool.process.DataView;
import tstool.layout.Menu;
import tstool.layout.UI;
import tstool.layout.Question;
import tstool.layout.History.Interactions;
import tstool.layout.Instructions;
//import tstool.utils.Mail;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import js.Browser;
import openfl.system.Capabilities;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

using string.StringUtils;

typedef ProcessContructor =
{
	var step:Class<Process>;
	var ?params:Array<ProcessContructor>;
}
/**
 * @TODO Split pureprocess logic / Interactions / Graphic / Main UI
 * ...
 * @author
 */

class Process extends FlxState
{
	static public var STORAGE:Map<String,Dynamic> = new Map<String,Dynamic>();

	var _titleTxt(default, set):String = "";
	var _detailTxt(default, set):String = "";
	var _illustration(default, set):String = "";
	var _qook(default, set):String = "";

	public var _name(get, null):String;
	public var _class(get, null):Class<Process>;
	var _nexts:Array<ProcessContructor>;

	var _historyTxt:String = "";
	var _qookLink:Array<String>;
	var hasQook:Bool;
	var hasIllustration:Bool;
	var hasReminder:Bool;
	//var isFocused:Bool;
	var isAnimated:Bool;
	var commentDebounce:Int;

	/************************
	 * UI
	/************************/
	var _menu:Menu;
	var ui:UI;
	var howToSubState:Instructions;
	var dataView:tstool.process.DataView;

	public var _padding(get, null):Int = 30;
	public var details(get, null):FlxText;
	public var question(get, null):Question;

	/**
	 * @todo REMOVE once all tested ok
	 */
	public function new()
	{
		super();

		commentDebounce = 0;// prevent to send share duplicate mails
		_class = Type.getClass(this);
		_name = Type.getClassName(_class);

		_titleTxt = MainApp.translator.translate(_name, _titleTxt, "TITLE");
		_detailTxt = MainApp.translator.translate(_name, _detailTxt, "DETAILS");
		_illustration = MainApp.translator.translate(_name, _illustration, "ILLUSTRATION");
		_qookLink = MainApp.translator.translate(_name,_qook, "QOOK").split("|");
	}

	override public function create()
	{
		_nexts = [];

		isAnimated = false;
		parseAllLinksForNames();

		//FlxG.camera.fade(UI.THEME.bg, 0.33, true);

		super.create();

		/************************
		 * UI
		/************************/

		ui = new UI(0, 0);

		ui.stringSignal.add( listener );

		howToSubState = new Instructions();
		/**
		 * @todo change to Class<T>
		 */
		dataView = new DataView(UI.THEME.bg, this._name);

		// PROCESS UI
		question = ui.question;
		question.text = _titleTxt;

		details = ui.details;
		details.text = _detailTxt;

		add(ui);

		destroySubStates = false;

		hasQook = _qookLink.length>0 && _qookLink[0]!="";
		hasIllustration = _illustration != "";

		//FIXME texet input displays over
		ui.showHowto(false);

		if (hasQook)
		{
			ui.qook.text = MainApp.translator.get("$helpBtn_UI1", "meta") + " " + parseAllLinksForNames().join(", ") +")";
			ui.qook.visible = true;
		}

		if (hasIllustration)
		{
			ui.loadIllustrationGraphics(_illustration);
		}
		if (!Lambda.empty(STORAGE))
		{
			ui.setReminder(buildReminderString());
		}
		ui.backBtn.visible = Main.HISTORY.history.length > 0;

	}
	function buildReminderString():String
	{
		var s = "";
		var i = 0;
		var separator = "\t";
		for ( k => v in STORAGE )
		{

			separator = ( i % 2 == 0) ?".\t": "\n";
			s += k + ": " + v + separator;
			i++;
		}
		return s;
	}
	function positionMain(btns:Array<FlxButton>, ?offSet:FlxPoint)
	{
		ui.position(btns);
	}
	function positionButtons(?offSet:FlxPoint)
	{
		ui.positionButtons(offSet.x,offSet.y);
	}
	function positionBottom(?offSet:FlxPoint)
	{
		ui.positionBottom(offSet.y);
	}

	//UI
	function setStyle()
	{
		//trace("tstool.process.Process::setStyle");

		this.bgColor = UI.THEME.bg;
		//this.bgColor = UI.THEME.bg;
		this.details.color = UI.THEME.basic;
		this.details.applyMarkup(this._detailTxt, [UI.THEME.basicStrong, UI.THEME.basicEmphasis]);

		this.question.color = UI.THEME.title;
		this.question.applyMarkup(this._titleTxt, [UI.THEME.basicStrong, UI.THEME.basicEmphasis]);

		question.drawFrame();

		details.drawFrame();

	}

	//ui
	function onButtonOver()
	{
		Mouse.cursor = MouseCursor.BUTTON;
	}
	//ui
	function onOut()
	{
		Mouse.cursor = MouseCursor.ARROW;
	}
	//ui
	function get__padding():Int
	{
		return _padding;
	}
	//ui
	function get_question():Question
	{
		return question;
	}

	//ui
	function get_details():FlxText
	{
		return details;
	}
	//ui
	function registerButton(btn:Dynamic)
	{
		btn.onOver.callback = onButtonOver;
		btn.onOut.callback = onOut;
	}
	// NOT UI
	static public function INIT()
	{
		FlxG.keys.preventDefaultKeys = [FlxKey.BACKSPACE, FlxKey.TAB];
		STORAGE = [];

		Main.customer.reset();
		Main.HISTORY.init();
		//Main.CHECK_NEW_VERSION();
	}
	/**
	 * @todo REMOVE
	 *
	static public function GET_PREVIOUS_INSTANCE()
	{

		return Main.HISTORY.getPreviousInstance();
	}
	*/
	function listener(s:String):Void
	{
		//trace("tstool.process.Process::listener");
		switch (s)
		{
			case "en-GB" : switchLang("en-GB");
			case "it-IT" : switchLang("it-IT");
			case "de-DE" : switchLang("de-DE");
			case "fr-FR" : switchLang("fr-FR");
			case "onQook" : onQook();
			//case "onScript" : openSubState(ScriptView);
			case "onExit" : onExit();
			case "onBack" : onBack();
			case "onHowTo" : onHowTo();
			case "toogleTrainingMode" : toogleTrainingMode();
			case "logout" : onlogout();
			case "onComment" : if (commentDebounce ==0) onComment();
			case "setStyle" : setStyle();
			case "openSubState" : openSubState(dataView);
		}
	}

	function onlogout()
	{
		MainApp.clearCookie();
	}

	function switchLang(lang:String, ?pos: haxe.PosInfos)
	{

		MainApp.agent.mainLanguage = lang;
		MainApp.flush();
		MainApp.translator.initialize(lang, ()->(
										  //FlxG.camera.fade(UI.THEME.bg, 0.33, false, ()->
										  FlxG.switchState(
											  Type.createInstance( _class, [])
										  )
									  )
									  //)
									 );
	}
	function onClipBoardClick()
	{
		//Browser.document.execCommand("copy");
		//trace('Browser.document.execCommand("copy")');
	}
	function onHowTo()
	{
		openSubState(howToSubState);
	}

	function toogleTrainingMode()
	{
		MainApp.agent.canDispach = !MainApp.agent.canDispach;
	}

	function set__qook(value:String):String
	{
		return _qook = value;
	}
	function onExit()
	{
		//pushToHistory({step: AllGood}, Interactions.Exit);
		Main.HISTORY.add({step: AllGood }, Exit,"AllGood","Exit");
		FlxG.switchState(Type.createInstance(Main.LAST_STEP, []));
	}
	function onQook():Void
	{
		var str;
		var resW = Capabilities.screenResolutionX;
		var resH = Capabilities.screenResolutionY;
		var split = Math.round(resW / _qookLink.length);
		var x:Float = 0;
		for (i in _qookLink)
		{
			str = ('menubar=0,toolbar=0,location=0,status=0,width=$split,height=$resH,top=0,left=$x');
			Browser.window.open(i, "_blank", str);
			x = x + split;
		}
	}
	function parseAllLinksForNames():Array<String>
	{
		var regex:EReg = ~/^(https:\/\/|http:\/\/)([a-z.]*)(\/?)/gi;
		var t = [];
		for (i in _qookLink)
		{
			if (regex.match(i)) t.push(regex.matched(2));

		}
		return t;
	}
	function onComment():Void
	{
		commentDebounce = 300;
		var v = StringTools.replace(Main.VERSION, ".min.js", "");
		var to = "mailto:qook@salt.ch?";
		var subject = "subject=[TROUBLE share "+ MainApp.config.scriptName +"] " + this._name;
		var doubleBreak = "\n---------------\n";
		var content = "SCRIPT VERSION: " + v + doubleBreak;
		content += "TITLE:\n" + History.stripTags(_titleTxt) + doubleBreak;

		content += "DETAILS:\n" + History.stripTags(_detailTxt) + doubleBreak ;
		content += "HISTORY:\n" + Main.HISTORY.getLocalizedStepsStringsList() + doubleBreak;

		Browser.window.location.href = to + subject + "?&body=" + StringTools.urlEncode(content);

	}

	/*
	public function translate(txt:String, ?suffix:String="", ?context="data"):String
	{

		var tString = switch (context)
		{
			case "data" : "$" + this._name + "_" + suffix;
			case "headers" : "$" + txt + "." + suffix.removeWhite();
			case _ : "$" + txt + "_" + suffix;
		}

		//var t = context == "data" ? MainApp.translator.get(customString, context) : MainApp.translator.get(defaultString, context);

		var t = MainApp.translator.get(tString, context);
		//var s = t.indexOf("$") == 0 || StringTools.trim(t) == "" ? context == "headers"? suffix: txt : t;
		var s = if (t.indexOf("$") == 0 || StringTools.trim(t) == "")
		{
			//couldn't translate
			if (context == "headers")
			{
				//then show the suffix
				suffix;
			}
			else
			{
				//or show the original string not translated
				txt;
			}
		}
		else {
			//could translate
			t;
		}
		#if debug
		if (Main.DEBUG || Main.DEBUG_LEVEL == 0)
			return s;
		else
			return StringTools.trim(t) == "" ? context == "headers"? suffix: txt : t;
		#else
		return s;
		#end

	}
	*/
	/**
	 * Override when child class takes contructor parameters
	 * @param	buttonTxt
	 * @param	interactionType
	 * @param	values
	 * @param	Dynamic>=nul
	 */
	function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		//Main.HISTORY.add({step:_class, params:[]}, interactionType, _titleTxt, buttonTxt, values);
		#if debug
		//trace("tstool.process.Process::pushToHistory::question.text", question.text );
		#end
		Main.HISTORY.add({step:_class, params:[]}, interactionType, question.text, buttonTxt, values);
	}

	function set__titleTxt(value:String):String
	{
		return _titleTxt = value;
	}

	function set__detailTxt(value:String):String
	{
		return _detailTxt = value;
	}

	function set__illustration(value:String):String
	{
		return _illustration = value;
	}
	/**
	 *
	 *
	function move_to_next(nexts:Array<Process>, interaction:Interactions)
	{
		//trace("tstool.process.Process::move_to_next");

		var iteration = Main.HISTORY.getIterations(_name, interaction) - 1;
		var index = iteration >= nexts.length ? nexts.length - 1 : iteration;
		FlxG.switchState(nexts[index]);
	}*/
	/**
	 * @param	interaction
	 */
	function moveToNextClassProcess(interaction:Interactions)
	{
		var slowClasses:Array<Dynamic> = [ActionDropDown, ActionMultipleInput, ActionRadios, ActionTicket, DescisionDropDown, DescisionLoop, DescisionMultipleInput, TripletMultipleInput];
		var iteration = Main.HISTORY.getClassIterations(_class, interaction);
		var index = iteration >= _nexts.length ? _nexts.length - 1 : iteration > 0?iteration - 1:0;
		#if debug
		//trace("tstool.process.Process::moveToNextClassProcess::Type.getSuperClass(_nexts[index].step)", Type.getSuperClass(_nexts[index].step) );
		#end
		if (slowClasses.indexOf(Type.getSuperClass(_nexts[index].step)) >-1)
		{
			openSubState(new PageLoader());
		}
		else
		{
			#if debug
			//trace("tstool.process.Process::moveToNextClassProcess::not sper slow");
			#end
		}

		FlxG.switchState(Type.createInstance(_nexts[index].step, _nexts[index].params));

	}
	override public function update(elapsed):Void
	{
		super.update(elapsed);
		//#if debug
		//trace("tstool.process.Process::update::commentDebounce", commentDebounce );
		//#end
		if (commentDebounce != 0)
		{
			commentDebounce--;
		}
		if (FlxG.mouse.justReleased)
		{
			
            MainApp.VERSION_TIMER_value = MainApp.VERSION_TIMER_DURATION;
		}
		
	}
	override public function destroy():Void
	{
		dataView.destroy();
		dataView = null;
		super.destroy();
	}
	function get__name():String
	{
		return _name;
	}

	public static function STORE(k:String,v:Dynamic):Void
	{
		//trace("tstool.process.Process::STORE");
		if (STORAGE.exists(k) && STORAGE.get(k).indexOf(v) == -1)
		{
			STORAGE.set(k, STORAGE.get(k) + v);
		}
		else{
			STORAGE.set(k, v);
		}
	}

	function get__class():Class<Process>
	{
		return _class;
	}

	function onBack()
	{
		FlxG.switchState(Main.HISTORY.onStepBack());
	}
}
