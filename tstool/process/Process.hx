package tstool.process;



import tstool.process.DataView;
import tstool.layout.Menu;
import tstool.layout.UI;
import tstool.layout.Question;
import tstool.layout.History.Interactions;
import tstool.layout.Instructions;
//import tstool.layout.SaltColor;

import flixel.FlxG;
//import flixel.FlxSprite;
//import flixel.addons.display.shapes.FlxShapeBox;
//import flixel.addons.ui.FlxUIButton;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import haxe.ds.StringMap;
import js.Browser;
import openfl.system.Capabilities;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
//import lime.math.Rectangle;


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

	var howToSubState:Instructions;	
	var dataView:tstool.process.DataView;
	var ui:UI;
	public var _padding(get, null):Int = 30;
	public var details(get, null):FlxText;
	public var question(get, null):Question;
	

	public function new()
	{
		super();
		//isFocused = false;
		_class = Type.getClass(this);
		_name = Type.getClassName(_class);
		
		
		_titleTxt = translate( _titleTxt, "TITLE");
		_detailTxt = translate( _detailTxt, "DETAILS");
		_illustration = translate( _illustration, "ILLUSTRATION");
		_qookLink = translate(_qook, "QOOK").split("|");
		isAnimated = false;
		parseAllLinksForNames();
	}

	override public function create()
	{
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
		dataView = new DataView(Main.THEME.bg, this._name);
		
		// PROCESS UI		
		question = ui.question;
		question.text = _titleTxt;
		
		details = ui.details;
		details.text = _detailTxt;
		
		add(ui);
		
		destroySubStates = false;
		
		hasQook = _qookLink.length>0 && _qookLink[0]!="";
		hasIllustration = _illustration != "";
		//hasReminder = !Main.customer.isInitial();
		
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
		this.bgColor = Main.THEME.bg;
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

	static public function GET_PREVIOUS_INSTANCE()
	{
		return Main.HISTORY.getPreviousInstance();
	}

	function listener(s:String):Void 
	{
		switch (s){
			case "en-GB" : switchLang("en-GB");
			case "it-IT" : switchLang("it-IT");
			case "de-DE" : switchLang("de-DE");
			case "fr-FR" : switchLang("fr-FR");
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
										FlxG.switchState( 
											Type.createInstance( Type.getClass(this), [])
											)
										)
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
		pushToHistory("ALL GOOD", Interactions.Exit);
		
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
		var history = "";
		var line = "";
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
		}
	}
	function stripTags(s:String):String
	{
		s = StringTools.replace(s, "<B>", " ");
		s = StringTools.replace(s, "<N>", " ");
		s = StringTools.replace(s, "<T>", " ");
		s = StringTools.replace(s, "<EM>", " ");
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
			//trace(defaultString);
			//trace(customString);
			//trace(t);
		//return t;
		//return StringTools.trim(t) == "" ? txt : t;
		return t.indexOf("$") == 0 || StringTools.trim(t) == "" ? txt : t;
		#else
		return t.indexOf("$") == 0 || StringTools.trim(t) == "" ? txt : t;
		#end
		
	}

	function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		Main.HISTORY.add(_name, interactionType, _titleTxt, buttonTxt, values);
		#if debug
			//trace(_name, interactionType, _titleTxt, buttonTxt, values);
		#end
		//trace(Main.HISTORY.history);
		// HISTORY.push({processName : this._name, interaction: buttonTxt});
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
	 * @todo identify branches ()
	 * @param	buttonTxt
	 */
	function move_to_next(nexts:Array<Process>, interaction:Interactions)
	{
		// Look in history if same step was passed
		var iteration = Main.HISTORY.getIterations(_name, interaction) - 1;
		var index = iteration >= nexts.length ? nexts.length - 1 : iteration;
		FlxG.switchState(nexts[index]);
	}
	function moveToNextClassProcess(nexts:Array<Class<Dynamic>>, interaction:Interactions)
	{
		FlxG.switchState(Type.createInstance(nexts[0],[]));
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
		/*if (Std.is(this, DescisionLoop) || Std.is(this, ActionLoop) )
		{
			trace("twoo steps back");
			FlxG.switchState(Main.HISTORY.twoStepsBack());
		}
		else{
			trace("ONe steps back");
			
		}*/
		FlxG.switchState(Main.HISTORY.onStepBack());
	}
}
