package tstool.layout;


import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeBox;
import flixel.addons.ui.FlxUIButton;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxSignal.FlxTypedSignal;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;


/**
 * ...
 * @author bb
 */
class Menu extends FlxTypedSpriteGroup<FlxSprite>
{
	
	var comment:flixel.ui.FlxButton;
	var bucket:flixel.ui.FlxButton;
	var fr:FlxUIButton;
	var de:FlxUIButton;
	var it:FlxUIButton;
	var en:FlxUIButton;
	var exitBtn:FlxButton;
	var trainingMode:FlxUIButton;
	
	var menuBG:flixel.addons.display.shapes.FlxShapeBox;
	var logout:flixel.addons.ui.FlxUIButton;
	//var langs:Map< String, FlxUIButton>;
	//var backBtn:flixel.ui.FlxButton;
	public var buttons:Array<Dynamic>;
	public var reminderMsgBox(get, null):FlxText;
	public var howTo(get, null):flixel.ui.FlxButton;
	public var stringSignal(get, null):FlxTypedSignal<String->Void>;
	
	public function new(X:Float = 0, Y:Float = 0, MaxSize:Int = 0) 
	{
		super(X, Y, MaxSize);
		buttons = [];
		stringSignal = new FlxTypedSignal<String->Void>();
		
		menuBG = new FlxShapeBox(0, 0, FlxG.width, 50, {thickness:0, color:SaltColor.BLACK_PURE}, SaltColor.BLACK_PURE);
		
		reminderMsgBox = new FlxText(0, 0, 460, "", 10, true);
		reminderMsgBox.setFormat(UI.INTERACTION_FMT.font, UI.META_FMT.size -2, SaltColor.MUSTARD);
		reminderMsgBox.visible = false;
		
		exitBtn = new FlxButton(0, 0, "", onExit );
		exitBtn.loadGraphic("assets/images/ui/exit.png", true, 40, 40);
		buttons.push(exitBtn);
		
		logout = new FlxUIButton(0, 0, "", onLogout);
		logout.loadGraphic("assets/images/ui/logout.png", true, 40, 40);
		logout.has_toggle = false;
		buttons.push(logout);
		
		howTo = new FlxButton(0, 0, "", onHowTo );
		howTo.loadGraphic("assets/images/ui/howto.png", true, 40, 40);
		buttons.push(howTo);
		howTo.visible = false;
		
		
		bucket = new FlxButton(0, 0, "", toggleStyle);
		bucket.loadGraphic("assets/images/ui/light.png", true, 40, 40);
		buttons.push(bucket);
		
		trainingMode = new FlxUIButton(0, 0, "", toogleTrainingMode);
		trainingMode.loadGraphic("assets/images/ui/trainingMode.png", true, 40, 40);
		trainingMode.has_toggle = true;
		trainingMode.toggled = !MainApp.agent.canDispach;
		buttons.push(trainingMode);
		

		
		
		fr = new FlxUIButton(0, 0, "", function() { switchLang("fr-FR"); } );
		fr.loadGraphic("assets/images/ui/fr.png", true, 40, 40);
		//fr.has_toggle = true;
		buttons.push(fr);
		
		//
		de = new FlxUIButton(0, 0, "", function() { switchLang("de-DE");});
		de.loadGraphic("assets/images/ui/de.png", true, 40, 40);
		de.has_toggle = true;
		buttons.push(de);
		//
		it = new FlxUIButton(0, 0, "", function() {switchLang("it-IT");});
		it.loadGraphic("assets/images/ui/it.png", true, 40, 40);
		buttons.push(it);
		//
		en = new FlxUIButton(0, 0, "", function() {switchLang("en-GB");});
		en.loadGraphic("assets/images/ui/en.png", true, 40, 40);

		buttons.push(en);
		//langs = new Map<String,FlxUIButton>();
		//langs.set("en-GB", en);
		//langs.set("it-IT", it);
		//langs.set("de-DE", de);
		//langs.set( "fr-FR", fr);
		
		comment = new FlxButton(0, 0, "", onComment);
		comment.loadGraphic("assets/images/ui/comment.png", true, 40, 40);
		buttons.push( comment );
		
		
		add(menuBG);
		
		add(bucket);
		add(comment);
		if (Main.LANGS != null)
		{
			if( Main.LANGS.indexOf("fr-FR")>-1)
				add(fr);
			if(Main.LANGS.indexOf("de-DE")>-1)			
				add(de);
			if(Main.LANGS.indexOf("it-IT")>-1)		
				add(it);
			if(Main.LANGS.indexOf("en-GB")>-1)		
				add(en);
		}
		else{
			add(fr);
			add(de);
			add(it);
			add(en);
		}
		add(exitBtn);
		add(trainingMode);
		add(logout);
		add(reminderMsgBox);
		add(howTo);
		
		
	}
	
	
	
	
	public function position()
	{
		bucket.y = 4;
		bucket.x = FlxG.width / 2;

		fr.y = de.y  = 4;
		it.y = en.y = 4;
		fr.x = bucket.x + bucket.width + (UI.PADDING * 2);
		de.x = fr.x + UI.PADDING*2;
		it.x = de.x + UI.PADDING*2;
		en.x = it.x + UI.PADDING*2;
		
		
		logout.y = 4;
		logout.x = FlxG.width -(UI.PADDING * 2);
		
		exitBtn.y = logout.y;
		exitBtn.x = logout.x - (UI.PADDING *3) - logout.width;
		
		trainingMode.y = exitBtn.y;
		trainingMode.x = exitBtn.x - UI.PADDING - trainingMode.width;
		howTo.x = bucket.x - (UI.PADDING * 3) - howTo.width;
		howTo.y = 4;
		comment.x = howTo.x - (UI.PADDING * 3) - comment.width;
		comment.y = 4;
		
		//reminderMsgBox.y = menuBG.height/2 - (reminderMsgBox.height/2);
		reminderMsgBox.y = 0;
		reminderMsgBox.x = UI.PADDING/2 ;
	}
	//function onBack() 
	//{
		//stringSignal.dispatch("onBack");
	//}
	function onLogout() 
	{
		stringSignal.dispatch("logout");
	}
	function toggleStyle() 
	{
		stringSignal.dispatch("toggleStyle");
	}
	function onHowTo() 
	{
		stringSignal.dispatch("onHowTo");
	}
	
	function toogleTrainingMode() 
	{
		stringSignal.dispatch("toogleTrainingMode");
	}
	
	function onComment() 
	{
		stringSignal.dispatch("onComment");
	}
	function onExit() 
	{
		stringSignal.dispatch("onExit");
	}
	
	function switchLang(string:String) 
	{
		stringSignal.dispatch(string);
	}
	
	function get_stringSignal():FlxTypedSignal<String->Void> 
	{
		return stringSignal;
	}
	
	
	function get_howTo():flixel.ui.FlxButton 
	{
		return howTo;
	}
	
	function get_reminderMsgBox():FlxText 
	{
		return reminderMsgBox;
	}
	
	
}