package tstool.process;
import tstool.process.DataView;
import tstool.layout.Menu;
import tstool.layout.UI;
import tstool.layout.Question;
import tstool.layout.History.Interactions;
import tstool.layout.Instructions;

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

typedef ProcessContructor = {
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
		_class = Type.getClass(this);
		_name = Type.getClassName(_class);
		_titleTxt = translate( _titleTxt, "TITLE");
		_detailTxt = translate( _detailTxt, "DETAILS");
		_illustration = translate( _illustration, "ILLUSTRATION");
		_qookLink = translate(_qook, "QOOK").split("|");
	}

	override public function create()
	{
		_nexts = [];
		

		isAnimated = false;
		parseAllLinksForNames();
		
		//FlxG.camera.fade(UI.THEME.bg, 0.33, true);
		
		super.create();
		#if debug
		//trace(Main.VERSION);
		#end
		
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
		ui.showHowto(!Std.is(this, DescisionMultipleInput) && !Std.is(this, ActionMultipleInput) && !Std.is(this, ActionMail) );
		
		if (hasQook)
		{
			ui.qook.text = Main.tongue.get("$helpBtn_UI1", "meta") + " " + parseAllLinksForNames().join(", ") +")";
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
		switch (s){
			case "en-GB" : switchLang("en-GB");
			case "it-IT" : switchLang("it-IT");
			case "de-DE" : switchLang("de-DE");
			case "fr-FR" : switchLang("fr-FR");
			case "onQook" : onQook();
			case "onExit" : onExit();
			case "onBack" : onBack();
			case "onHowTo" : onHowTo();
			case "toogleTrainingMode" : toogleTrainingMode();
			case "onComment" : onComment();
			case "setStyle" : setStyle();
			case "openSubState" : openSubState(dataView);
		}
	}
	
	function switchLang(lang:String)
	{
	
		Main.user.mainLanguage = lang;
		Main.COOKIE.flush();
		
		Main.tongue.initialize(lang , ()->(
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
		Main.user.canDispach = !Main.user.canDispach;
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
		var to = "mailto:qook@salt.ch?";
		var subject = "subject=[TROUBLE share] " + this._name;
		var doubleBreak = "\n\n";
		var content = "TITLE:\n" + stripTags(_titleTxt) + doubleBreak;

		content += "DETAILS:\n" + stripTags(_detailTxt) + doubleBreak ;
		//var history = "";
		//var line = "";
		//var t = Main.HISTORY.getLocalizedStepsStrings();
		//for ( i in t)
		//{
			//history += i;
		//}
		content += "HISTORY:\n" + Main.HISTORY.getLocalizedStepsStringsList() + doubleBreak;
			
		Browser.window.location.href = to + subject + "?&body=" + StringTools.urlEncode(content);
		/*
		try{
			for (i in 0...Main.HISTORY.history.length)
			{
				line = "";
				line += (i+1) + ". " ;
				line += Main.HISTORY.history[i].processTitle +" ";
				line += Main.HISTORY.history[i].iteractionTitle +" ";
				history += stripTags(line) + "\n";
			}

			content += "HISTORY:\n" + history + doubleBreak;
			
			Browser.window.location.href = to + subject + "?&body=" + StringTools.urlEncode(content);
		}
		catch (e:Dynamic)
		{
			trace(e);
		}*/
	}
	function stripTags(s:String):String
	{
		s = StringTools.replace(s, "<B>", " ");
		s = StringTools.replace(s, "<b>", " ");
		s = StringTools.replace(s, "<N>", " ");
		s = StringTools.replace(s, "<T>", " ");
		s = StringTools.replace(s, "<EM>", " ");
		s = StringTools.replace(s, "<em>", " ");
		s = StringTools.replace(s, "\t", " ");
		s = StringTools.replace(s, "\n", " ");
		return s;
	}
	
	function translate(txt:String, suffix:String, ?context="data"):String
	{
		
		var defaultString = "$" + txt + "_" + suffix;
		var customString = "$" + this._name + "_" + suffix;
		
		//var t = context == "data" ? Main.tongue.get(customString, context) : Main.tongue.get(defaultString, context);
		/**
		 * @todo put context as an object
		 */
		var t = Main.tongue.get(context == "data" ? customString : defaultString, context);
		
		#if debug
			//trace("tstool.process.Process::translate::txt", txt );
			//trace("tstool.process.Process::translate::suffix", suffix );
			//trace("tstool.process.Process::translate::context", context );
			//trace(defaultString);
			//trace(customString);
			//trace(t);
			//return t;
			//return StringTools.trim(t) == "" ? txt : t;
		if(Main.DEBUG)
			return t.indexOf("$") == 0 || StringTools.trim(t) == "" ? txt : t;
		else	
			return StringTools.trim(t) == "" ? txt : t;
		#else
			return t.indexOf("$") == 0 || StringTools.trim(t) == "" ? txt : t;
		#end
		
	}
	/**
	 * Override when child class takes contructor parameters
	 * @param	buttonTxt
	 * @param	interactionType
	 * @param	values
	 * @param	Dynamic>=nul
	 */
	function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		Main.HISTORY.add({step:_class, params:[]}, interactionType, this.stripTags(_titleTxt), buttonTxt, values);
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
	 * @param	buttonTxt
	 */
	function move_to_next(nexts:Array<Process>, interaction:Interactions)
	{
		//trace("tstool.process.Process::move_to_next");
		var iteration = Main.HISTORY.getIterations(_name, interaction) - 1;
		var index = iteration >= nexts.length ? nexts.length - 1 : iteration;
		FlxG.switchState(nexts[index]);
	}
	/**
	 * @FIXME broken on BACK
	 * @param	interaction
	 */
	function moveToNextClassProcess(interaction:Interactions)
	{
		//trace("tstool.process.Process::moveToNextClassProcess", _nexts);
		//trace("tstool.process.Process::moveToNextClassProcess::_class", _class );
		var iteration = Main.HISTORY.getClassIterations(_class, interaction);
		//trace("tstool.process.Process::moveToNextClassProcess::iteration ", iteration  );
		var index = iteration >= _nexts.length ? _nexts.length - 1 : iteration >0?iteration-1:0;
		//trace("tstool.process.Process::moveToNextClassProcess::index", index );
		//trace("tstool.process.Process::moveToNextClassProcess::_nexts[index]", _nexts[index] );
		FlxG.switchState(Type.createInstance(_nexts[index].step ,_nexts[index].params));
	}
	override public function update(elapsed):Void
	{
		super.update(elapsed);
		//trace(this._titleTxt);
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
