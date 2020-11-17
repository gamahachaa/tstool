package tstool.layout;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSignal.FlxTypedSignal;
import lime.math.Rectangle;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

/**
 * ...
 * @author bb
 */
class UI extends FlxTypedSpriteGroup<FlxSprite> 
{
	var menu:Menu;
	var separatorH: FlxShapeBox;
	var isFocused:Bool;
	static inline var BUTTON_HEIGTH:Float = 40;
	var btns:Array<FlxButton>;
	public var separatorV: FlxShapeBox;
	public var illustration:FlxSprite;
	public var qook:flixel.ui.FlxButton;
	public var backBtn:flixel.ui.FlxButton;
	public var stringSignal(get, null):FlxTypedSignal<String->Void>;
	public var question(get, null):Question;
	public var details(get, null):FlxText;
	public static inline var PADDING:Int = 30;
	public function new(X:Float=0, Y:Float=0, MaxSize:Int=0) 
	{
		super(X, Y, MaxSize);
		stringSignal = new FlxTypedSignal<String->Void>();
		isFocused = false;
		menu = new Menu(0, 0);
		for (i in menu.buttons)
		{
			registerButton(i);
		}
		menu.stringSignal.add( listener );
		separatorH = new FlxShapeBox(0, 0, FlxG.width, PADDING / 4, {thickness:0, color:0x00000000}, SaltColor.BLACK);
		separatorV = new FlxShapeBox(0, 0,  PADDING / 6, FlxG.height, {thickness:0, color:0x00000000}, SaltColor.BLACK);
		separatorV.visible = false;
		
		question = new Question(0, 0, 1000, "", 24, true);
		question.setFormat(Main.TITLE_FMT.font, Main.TITLE_FMT.size);
		details = new FlxText(0, 0,  FlxG.width / 3, "", 16 , true);
		details.autoSize = question.autoSize = false;
		/**
		 * @todo resize if hasIllustration
		 */
		//details = new FlxText(0, 0, hasIllustration ? FlxG.width / 3 : FlxG.width-PADDING, "", hasIllustration? 16:24 , true);
			//details.setFormat(Main.BASIC_FMT.font, hasIllustration ? Main.BASIC_FMT.size: Main.BASIC_FMT.size+4);
		details.setFormat(Main.BASIC_FMT.font, Main.BASIC_FMT.size );
		
		illustration = new FlxSprite(0, 0);
		illustration.visible = false;
		
		
		backBtn = new FlxButton(0, 0, "", ()->(stringSignal.dispatch("onBack")) );
		backBtn.loadGraphic("assets/images/ui/back.png", true, 50, 40);
		backBtn.visible = false;
		registerButton(backBtn);
		
		
		qook = new FlxButton(0, 0, "",()->(stringSignal.dispatch("onQook"))  );
		qook.visible = false;
		registerButton(qook);
		qook.loadGraphic("assets/images/ui/help.png", true, 50, 50);
		var ptNo:FlxPoint = new FlxPoint( -4, -20);
		qook.labelOffsets = [ptNo, ptNo, ptNo];
		qook.label.setFormat(Main.META_FMT.font, Main.META_FMT.size);
		qook.label.wordWrap = false;
		qook.label.autoSize = true;
		qook.updateHitbox();
		
		add(menu);
		add(question);
		add(details);
		add(qook);
		add(backBtn);
		add(separatorH);
		add(separatorV);
		add(illustration);
	}
	
	function listener(s:String):Void 
	{
		switch (s){
			case "en-GB" : stringSignal.dispatch("en-GB");
			case "it-IT" : stringSignal.dispatch("it-IT");
			case "de-DE" : stringSignal.dispatch("de-DE");
			case "fr-FR" : stringSignal.dispatch("fr-FR");
			case "onExit" : stringSignal.dispatch("onExit");
			//case "onBack" : stringSignal.dispatch("onBack");
			case "onHowTo" : stringSignal.dispatch("onHowTo");
			case "toggleStyle" : toggleStyle();
			case "toogleTrainingMode" : stringSignal.dispatch("toogleTrainingMode");
			case "onComment" : stringSignal.dispatch("onComment");
		}
	}
	public function position(btns:Array<FlxButton>)
	{
		this.btns = btns;
		menu.position();
		question.positionMe(new Rectangle(menu.x+PADDING/2, menu.y+PADDING/2, menu.width, menu.height));
		
		backBtn.y = question.y; 
		backBtn.x = FlxG.width -(PADDING * 2);
		
		positionButtons();
		positionBottom();
	}
	public function positionBottom(?Y:Float=0)
	{
		//trace(Y);
		//var offsetY = Y;
		separatorH.x = 0;
		
		separatorH.y = Math.max(question.y + question.height + (BUTTON_HEIGTH*2), Y + PADDING) ;
		//trace(question.y , question.height , BUTTON_HEIGTH);
		
		details.x = PADDING/2;
		details.y = separatorH.y + PADDING;
		
		//trace(illustration.visible);
		if (!illustration.visible)
		{
			details.width = FlxG.width - PADDING;
			details.textField.width = FlxG.width - PADDING;
			details.setFormat(Main.BASIC_FMT.font, Main.BASIC_FMT.size+4);
			details.updateFramePixels();
		}
		else{
			illustration.x = FlxG.width/3 + PADDING;
			illustration.y = details.y;
			separatorV.x = details.x + details.width - (separatorV.width/2);
			separatorV.y = separatorH.y;
		}
		
		illustration.x = FlxG.width/3 + PADDING;
		illustration.y = details.y;
		separatorV.x = details.x + details.width - (separatorV.width/2);
		separatorV.y = separatorH.y;
		
		qook.y = this.details.y + this.details.height + (PADDING * 2);
		qook.x = PADDING/2;
	}
	public function positionButtons(?X:Float=0,?Y:Float=0)
	{
		var l:Int = btns.length;
		var btnsMargin = FlxG.width / 3 + PADDING;
		
		var btnSpace = FlxG.width - X;
		var unit = btnSpace / (l + 1);
		var btnH = Math.max(this.question.y + this.question.height + PADDING , Y - PADDING);
		for ( i in 0...l )
		{
			btns[i].x = unit * ( i + 1) + X;
			btns[i].y = btnH;
		}
	}
	function toggleStyle()
	{
		Main.TOGGLE_MAIN_STYLE();
		setStyle();
	}
	function setStyle()
	{
		//this.bgColor = Main.THEME.bg;
		this.details.color = Main.THEME.basic;
		this.details.applyMarkup(this.details.text, [Main.THEME.basicStrong, Main.THEME.basicEmphasis]);
		this.question.color = Main.THEME.title;
		//if (hasQook)
		this.qook.label.color = Main.THEME.meta;
		//menu.exitBtn.label.color = Main.THEME.meta;
		stringSignal.dispatch("setStyle");
	}
	public function showHowto(?show:Bool = true)
	{
		menu.howTo.visible = show;
	}
	public function setReminder(?text:String = "")
	{
		menu.reminderMsgBox.text = text;
		menu.reminderMsgBox.visible = text != "";
	}
	public function loadIllustrationGraphics(?s:String="")
	{
		if (s != "")
		{
			var tmp = [];
				
			if (s.indexOf("#") > 0)
			{
				//isAnimated = true;
				tmp = s.split("#") ;
				//illustration = new FlxSprite();
				illustration.loadGraphic("assets/images/" + tmp[0] + ".png", true, Std.parseInt(tmp[1]), Std.parseInt(tmp[2]));
				illustration.animation.add("anim", [for (i in 0...Std.parseInt(tmp[3])) i], 12, true);
				illustration.animation.play("anim");
			}
			else{
				illustration.loadGraphic("assets/images/" + s + ".png");
			}
			separatorV.visible = true;
			illustration.visible = true;
		}
	}
	
	
	
	override public function update(elapsed:Float):Void
	{
		if (Main.DEBUG && FlxG.keys.pressed.ALT && FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT &&  FlxG.keys.pressed.S  && !isFocused)
		{
			/***************************************
			 * Debug only 
			 * CTRL + ALT + SHIFT + S
			 * Open interactive stack
			/***************************************/
			//openSubState(dataView);
			stringSignal.dispatch("openSubState");
		}
		else if (Main.HISTORY.history.length > 0 && FlxG.keys.justReleased.UP)
		{
			/***************************************
			 * Goi back one step
			/***************************************/
			//onBack();
			stringSignal.dispatch("onBack");
		}
		else if (FlxG.keys.pressed.ALT && FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.C && !isFocused)
		{
			/***************************************
			 * Generate comment mail
			/***************************************/
			//onComment();
			stringSignal.dispatch("onComment");
		}
		else if (qook.visible == true && FlxG.keys.pressed.Q && FlxG.keys.pressed.ALT && FlxG.keys.pressed.CONTROL && FlxG.keys.pressed.SHIFT && !isFocused)
		{
			/***************************************
			* Open Qook links
			/***************************************/
			//onQook();
			stringSignal.dispatch("onQook");
		}
		else if (FlxG.keys.pressed.ESCAPE && FlxG.keys.pressed.SHIFT)
		{
			//onExit();
			stringSignal.dispatch("onExit");
		}
		setStyle();
		super.update(elapsed);
	}
	function get_details():FlxText 
	{
		return details;
	}
	
	function get_question():Question 
	{
		return question;
	}
	
	function get_stringSignal():FlxTypedSignal<String->Void> 
	{
		return stringSignal;
	}
	function registerButton(btn:Dynamic)
	{
		btn.onOver.callback = onButtonOver;
		btn.onOut.callback = onOut;
	}
	function onButtonOver()
	{
		Mouse.cursor = MouseCursor.BUTTON;
	}
	function onOut()
	{
		Mouse.cursor = MouseCursor.ARROW;
	}
}