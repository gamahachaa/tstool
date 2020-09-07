package tstool.process;
//import _AddMemoVti;
import flow._AddMemoVti;
import lime.math.Rectangle;
import tstool.layout.History;
import tstool.layout.Question;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.ui.FlxUIButton;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
//import flixel.text.FlxTextBB;
import flixel.ui.FlxButton;
//import flow.TutoTree;
//import flow.all.vti._AddMemoVti;
import haxe.ds.Either;
import haxe.ds.StringMap;
import js.Browser;
import tstool.layout.History.Interactions;
import tstool.layout.Instructions;
import tstool.layout.SaltColor;
import openfl.system.Capabilities;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import tstool.process.DataView;


/**
 * @TODO Split pureprocess logic / Interactions / Graphic / Main UI
 * ...
 * @author
 */
class Process extends FlxState
{
	static public var STORAGE:StringMap<Dynamic> = new StringMap<Dynamic>();
	public var _padding(get, null):Int = 30;
	public var question(get, null):Question;
	#if debug
		//public var details(get, null):FlxTextBB;
		public var details(get, null):FlxText;
	#else
	
		public var details(get, null):FlxText;
	#end
	var _titleTxt(default, set):String = "";
	var _detailTxt(default, set):String = "";
	var _illustration(default, set):String = "";
	var _qook(default, set):String = "";
	
	public var _name(get, null):String;
	var _historyTxt:String = "";
	var illustration:FlxSprite;


	var _qookLink:Array<String>;
	var dataView:tstool.process.DataView;
	var qook:flixel.ui.FlxButton;
	var hasQook:Bool;
	var hasIllustration:Bool;
	var comment:flixel.ui.FlxButton;
	var bucket:flixel.ui.FlxButton;
	var fr:FlxButton;
	var de:FlxButton;
	var it:FlxButton;
	var en:FlxButton;
	var separatorV:flixel.addons.display.shapes.FlxShapeBox;
	var separatorH:flixel.addons.display.shapes.FlxShapeBox;
	var exitBtn:FlxButton;
	var trainingMode:FlxUIButton;
	var voipReminder:FlxText;
	var hasVoip:Bool;
	var menuBG:flixel.addons.display.shapes.FlxShapeBox;
	//var clipBoardBtn:flixel.ui.FlxButton;
	var backBtn:flixel.ui.FlxButton;
	var isFocused:Bool;
	var howTo:flixel.ui.FlxButton;
	var howToSubState:Instructions;
	var isAnimated:Bool;

	//var _myClass:Class<T>;

	public function new()
	{
		super();
		isFocused = false;
		//_myClass = Type.getClass(this);
		_name = Type.getClassName(Type.getClass(this));
		_titleTxt = translate(_titleTxt, "TITLE");
		_detailTxt = translate(_detailTxt, "DETAILS");
		_illustration = translate(_illustration, "ILLUSTRATION");
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
		var ptNo:FlxPoint = new FlxPoint( -4, -20);
		menuBG = new FlxShapeBox(0, 0, FlxG.width, 50, {thickness:0, color:0x00000000}, SaltColor.BLACK);
		voipReminder = new FlxText(0, 0, 460, "", 10, true);
		voipReminder.setFormat(Main.INTERACTION_FMT.font, Main.META_FMT.size, SaltColor.MUSTARD);
		separatorH = new FlxShapeBox(0, 0, FlxG.width, _padding / 4, {thickness:0, color:0x00000000}, SaltColor.BLACK);
		separatorV = new FlxShapeBox(0, 0,  _padding / 6, FlxG.height, {thickness:0, color:0x00000000}, SaltColor.BLACK);
		exitBtn = new FlxButton(0, 0, "", onExit );
		exitBtn.loadGraphic("assets/images/ui/exit.png", true, 40, 40);
		
		
		backBtn = new FlxButton(0, 0, "", onBack );
		backBtn.loadGraphic("assets/images/ui/back.png", true, 50, 40);
		
		howTo = new FlxButton(0, 0, "", onHowTo );
		howTo.loadGraphic("assets/images/ui/howto.png", true, 40, 40);
		howToSubState = new Instructions();
		
		bucket = new FlxButton(0, 0, "", toggleStyle);
		bucket.loadGraphic("assets/images/ui/light.png", true, 40, 40);
		registerButton(bucket);
		
		//clipBoardBtn = new FlxButton(0, 0, "", onClipBoardClick);
		//clipBoardBtn.loadGraphic("assets/images/ui/clipBoard.png", true , 40, 40);
		
		trainingMode = new FlxUIButton(0, 0, "", toogleTrainingMode);
		trainingMode.loadGraphic("assets/images/ui/trainingMode.png", true, 40, 40);
		trainingMode.has_toggle = true;
		trainingMode.toggled = !Main.user.canDispach;

		registerButton(trainingMode);
		
		
		fr = new FlxButton(0, 0, "", function() { switchLang("fr-FR"); } );
		fr.loadGraphic("assets/images/ui/fr.png", true, 40, 40);
		registerButton(fr);
		//
		de = new FlxButton(0, 0, "", function() { switchLang("de-DE");});
		de.loadGraphic("assets/images/ui/de.png", true, 40, 40);
		registerButton(de);
		//
		it = new FlxButton(0, 0, "", function() {switchLang("it-IT");});
		it.loadGraphic("assets/images/ui/it.png", true, 40, 40);
		registerButton(it);
		//
		en = new FlxButton(0, 0, "", function() {switchLang("en-GB");});
		en.loadGraphic("assets/images/ui/en.png", true, 40, 40);
		registerButton(en);

		destroySubStates = false;
		dataView = new DataView(Main.THEME.bg, this._name);
		
		hasQook = _qookLink.length>0 && _qookLink[0]!="";
		hasIllustration = _illustration != "";
		hasVoip = !Main.customer.isInitial();
		/**
		 * removing the comment button only available with Keyboard
		 * */
		comment = new FlxButton(0, 0, "", onComment);
		comment.loadGraphic("assets/images/ui/comment.png", true, 40, 40);
		registerButton( comment );
		
		// MAIN UI
		add(menuBG);
		add(separatorH);
		add(bucket);
		if(!Std.is(this,DescisionMultipleInput) && !Std.is(this,ActionMultipleInput) && !Std.is(this,ActionMail) )
			add(howTo);
		add(comment);
		add(fr);
		add(de);
		add(it);
		add(en);
		add(exitBtn);
		
		add(trainingMode);

		// PROCESS UI		
		//question = new FlxText(0, 0, 1000, _titleTxt, 24, true);
		question = new Question(0, 0, 1000, _titleTxt, 24, true);
		
		
		#if debug
		details = new FlxText(0, 0, hasIllustration ? FlxG.width / 3 : FlxG.width-_padding, _detailTxt, hasIllustration? 16:24 , true);
		#else
		details = new FlxText(0, 0, hasIllustration ? FlxG.width / 3 : FlxG.width-_padding, _detailTxt, hasIllustration? 16:24 , true);
		#end
		
		question.setFormat(Main.TITLE_FMT.font, Main.TITLE_FMT.size);
		details.setFormat(Main.BASIC_FMT.font, hasIllustration ? Main.BASIC_FMT.size: Main.BASIC_FMT.size+4);
		details.autoSize = question.autoSize = false;
		
		add(question);
		add(details);

		if (hasQook)
		{

			qook = new FlxButton(0, 0, Main.tongue.get("$helpBtn_UI1","meta") + " "+ parseAllLinksForNames().join(", ") +")", onQook);
			registerButton(qook);
			qook.loadGraphic("assets/images/ui/help.png", true, 50, 50);
			qook.labelOffsets = [ptNo, ptNo, ptNo];
			qook.label.setFormat(Main.META_FMT.font, Main.META_FMT.size);
			qook.label.wordWrap = false;
			qook.label.autoSize = true;
			qook.updateHitbox();
			add(qook);
		}

		if (hasIllustration)
		{
			var tmp = [];
			
			if (_illustration.indexOf("#") > 0)
			{
				isAnimated = true;
				tmp = _illustration.split("#") ;
				illustration = new FlxSprite();
				illustration.loadGraphic("assets/images/" + tmp[0] + ".png", true, Std.parseInt(tmp[1]), Std.parseInt(tmp[2]));
				illustration.animation.add("anim", [for (i in 0...Std.parseInt(tmp[3])) i], 12, true);
			}
			else
				illustration = new FlxSprite(0, 0, "assets/images/" + _illustration + ".png");
			add(separatorV);
			add(illustration);

		}
		if (hasVoip)
		{
			//081 304 10 13
			var voip = Main.customer.voIP.split("");
			voip.insert(8, " ");
			voip.insert(6, " ");
			voip.insert(3, " ");
			
			var displayVoip = voip.join("");
			var owner = Main.customer.contract.owner == null? "":Main.customer.contract.owner.name;
			voipReminder.text = '$displayVoip (${Main.customer.iri})\n$owner';
			//voipReminder.text = '$displayVoip (${Main.customer.iri})\n' + Main.tongue.get("$voipCopyPaste_UI1", "meta");
			//registerButton(clipBoardBtn);
			//add(clipBoardBtn);
			add(voipReminder);
			/**
			 * @TODO keep clipboard trick to fill clipboard with data
			 */
			//Browser.document.addEventListener("copy", function(e){e.clipboardData.setData('text/plain', Main.customer.voIP);e.preventDefault();});
		}
		if (Main.HISTORY.history.length > 0)
		{
			registerButton(backBtn);
			add(backBtn);
		}
		question.positionMe(new Rectangle(_padding, _padding * 2, 0, 0));
		question.x = _padding;
		question.y = _padding * 2;

		registerButton(exitBtn);
		registerButton(howTo);
		
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
		//trace( Main.user.canDispach );
		//trainingMode.status = Main.user.canDispach ? FlxButton.NORMAL : FlxButton.HIGHLIGHT;
	}
	function positionMain( ?detailsTop:Float )
	{
		menuPosition();
		//question.positionMe(new Rectangle(_padding, _padding * 2, 0, 0));
		separatorH.x = 0;
		separatorH.y = detailsTop;

		details.x = _padding/2;
		details.y = separatorH.y + _padding;

		if (hasQook)
		{
			qook.y = this.details.y + this.details.height + (_padding * 2);
			//qook.y = _padding;
			//qook.x = FlxG.width - (qook.width + (_padding*2));
			qook.x = _padding/2;
		}
		if (hasIllustration)
		{
			illustration.x = FlxG.width/3 + _padding;
			illustration.y = details.y;
			separatorV.x = details.x + details.width - (separatorV.width/2);
			separatorV.y = separatorH.y;
			if (isAnimated) illustration.animation.play("anim");
		}
		if (hasVoip)
		{
			//clipBoardBtn.y = 4;
			//clipBoardBtn.x = 0;
			voipReminder.y = menuBG.height/2 - (voipReminder.height/2);
			voipReminder.x = _padding/2 ;
			//voipReminder.x = clipBoardBtn.x + clipBoardBtn.width + (_padding/2) ;
		}

	}
	function menuPosition()
	{
		bucket.y = 4;
		bucket.x = FlxG.width / 2;

		fr.y = de.y  = 4;
		it.y = en.y = 4;
		fr.x = bucket.x + bucket.width + (_padding * 2);
		de.x = fr.x + _padding*2;
		it.x = de.x + _padding*2;
		en.x = it.x + _padding*2;
		
		backBtn.y = exitBtn.y = 4;
		exitBtn.x = FlxG.width -(_padding * 2);
		backBtn.x = exitBtn.x - _padding - trainingMode.width;
		trainingMode.y = exitBtn.y;
		trainingMode.x = backBtn.x - _padding - trainingMode.width;
		howTo.x = bucket.x - (_padding * 3) - howTo.width;
		howTo.y = 4;
		comment.x = howTo.x - (_padding * 3) - comment.width;
		comment.y = 4;
	}
	function onExit()
	{
		pushToHistory("ALL GOOD", Interactions.Exit);
		FlxG.switchState(new flow._AddMemoVti() );
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
		var to = "mailto:bruno.baudry@salt.ch; aron.peter@salt.ch?";
		var subject = "subject=[TROUBLE comment] " + this._name;
		var doubleBreak = "\n\n";
		var content = "TITLE:\n" + stripTags(_titleTxt) + doubleBreak;

		content += "DETAILS:\n" + stripTags(_detailTxt) + doubleBreak ;
		var history = "";
		var line = "";
		try{
			for (i in 0...Main.HISTORY.history.length)
			{
				//trace(Main.HISTORY.history[i]);
				line = "";
				line += (i+1) + ". " ;
				line += Main.HISTORY.history[i].processTitle +" ";
				line += Main.HISTORY.history[i].iteractionTitle +" ";
				//line += Main.HISTORY.history[i].processName +" ";
				//line += Main.HISTORY.history[i].interaction+")";
				history += stripTags(line) + "\n";
				//trace(line);
			}
			//trace(history);
			//trace(history.length);
			
			//content += "CUSTOMER:\n" + Main.customer.iri + doubleBreak;
			//if (Main.customer.processStage == recaller)
				//content += "S.O ticket:\n" + Main.customer._history[0] + doubleBreak;
			content += "HISTORY:\n" + history + doubleBreak;
			//trace(content);
			//content += "Thanks,\n" + Main.user.firstName + " " + Main.user.sirName + " (" + Main.user.department + ")" + doubleBreak;
			
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
		/**
		 * @todo make it nicer
		 */
		var defaultString = "$" + txt + "_" + suffix;
		var customString = "$" + this._name + "_" + suffix;
		
		var t = context == "data" ? Main.tongue.get("$" + this._name + "_" + suffix, context) : Main.tongue.get("$" + txt + "_" + suffix, context);
		#if debug
			//trace(defaultString);
			//trace(customString);
			//trace(t);
		#end
		return t.indexOf("$") == 0 || StringTools.trim(t) == "" ? txt : t;
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

	override public function update(elapsed:Float):Void
	{
		//trace(FlxG.keys.justReleased.Q && FlxG.keys.justReleased.SHIFT);
		if (Main.user.isAdmin && FlxG.keys.pressed.ALT && FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT &&  FlxG.keys.pressed.S  && !isFocused)
		{
			openSubState(dataView);
		}
		else if (Main.HISTORY.history.length > 0 && FlxG.keys.justReleased.UP)
		{
			onBack();
		}
		else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.C && !isFocused)
		{
			onComment();
		}
		else if (hasQook && FlxG.keys.pressed.Q && FlxG.keys.pressed.ALT && FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT && !isFocused)
		{
			onQook();
		}
		else if (FlxG.keys.pressed.ESCAPE && FlxG.keys.pressed.SHIFT)
		{
			onExit();
		}
		setStyle();
		super.update(elapsed);
	}

	static public function INIT()
	{
		FlxG.keys.preventDefaultKeys = [FlxKey.BACKSPACE, FlxKey.TAB];
		Main.customer.reset();
		Main.HISTORY.init();
		//Main.CHECK_NEW_VERSION();
	}

	static public function GET_PREVIOUS_INSTANCE()
	{
		return Main.HISTORY.getPreviousInstance();
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

	function set__qook(value:String):String
	{
		return _qook = value;
	}
	function toggleStyle()
	{
		Main.TOGGLE_MAIN_STYLE();
		setStyle();
	}
	function setStyle()
	{
		this.bgColor = Main.THEME.bg;
		this.details.color = Main.THEME.basic;
		this.details.applyMarkup(_detailTxt, [Main.THEME.basicStrong, Main.THEME.basicEmphasis]);
		this.question.color = Main.THEME.title;
		if (hasQook)
			this.qook.label.color = Main.THEME.meta;
		this.exitBtn.label.color = Main.THEME.meta;

	}

	override public function destroy():Void
	{
		super.destroy();

		dataView.destroy();
		dataView = null;
	}
	function onBack()
	{
		FlxG.switchState(Main.HISTORY.onStepBack());
	}
	function onButtonOver()
	{
		Mouse.cursor = MouseCursor.BUTTON;
	}
	function onTextfieldOver()
	{
		Mouse.cursor = MouseCursor.IBEAM;
	}
	function onOut()
	{
		Mouse.cursor = MouseCursor.ARROW;
	}
	
	function get__padding():Int 
	{
		return _padding;
	}
	
	function get_question():Question 
	{
		return question;
	}
	 function get__name():String 
	 {
		 return _name;
	 }
	 #if debug
	 //function get_details():FlxTextBB 
	 function get_details():FlxText
	 {
		 return details;
	 }
	 #else
	 function get_details():FlxText 
	 {
		 return details;
	 }
	 #end
	function registerButton(btn:Dynamic)
	{
		btn.onOver.callback = onButtonOver;
		btn.onOut.callback = onOut;
	}
}
