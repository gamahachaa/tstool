package tstool.process;
import flixel.FlxG;
import flixel.math.FlxPoint;
import tstool.layout.BIGUIInputTfCore;
import tstool.layout.ScriptView;

/**
 * ...
 * @author bb
 */
class ActionMemo extends Action 
{
	var verfifyContctNumber:String;
	var memoDefault:String;
	var defaultMemo:String;
	var memoTxtArea:tstool.layout.BIGUIInputTfCore;
	var scriptView:tstool.layout.ScriptView;
	var memoTxt:String;
	
	override public function create()
	{
		memoTxt = "";
		//verfifyContctNumber = translate("verifiyContactDetails", "UI1", "meta");
		memoDefault = translate("describeIssue", "UI1", "meta");
		memoTxtArea = new BIGUIInputTfCore(750, 50, memoDefault, [bottom, left]);
		//memoTxtArea = new BIGUIInputTfCore(750, 50, memoDefault, [bottom, left]);
		defaultMemo = "";
		
		//_detailTxt = verfifyContctNumber + _detailTxt;
		//
		super.create();
		//
		memoTxtArea.inputtextfield.text = defaultMemo;
		scriptView = new ScriptView(Main.HISTORY.prepareListHistory());
		scriptView.signal.add(sbStateListener);
		memoTxtArea.addToParent(this);
		ui.script.visible = true;
	}
	function sbStateListener():Void 
	{
		memoTxtArea.show();
	}
	override public function setStyle()
	{
		super.setStyle();
		memoTxtArea.setStyle();
	}
	override function positionThis(?offSet:FlxPoint)
	{
		super.positionThis();
		var p = this.memoTxtArea.positionMe(this.question.boundingRect, 0);
		positionBottom(p);
		positionButtons(p);
		

	}
	override public function onClick()
	{
		if (validate())
		{
			memoTxtArea.show(false);
			super.onClick();
		}
	}
	function validate()
	{
		var check = memoTxt.split(" ").length >= 3 && StringTools.trim(memoTxt) != defaultMemo;
		if (check){
			memoTxtArea.show(false);
			return true;
		}
		else{
			memoTxtArea.blink(true);
			return false;
		}
		//return  ;
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
		scriptView.addMemoToScript( memoTxt );
		openSubState( scriptView );
	}
	override public function update(elapsed)
	{
		super.update(elapsed);
		memoTxt = memoTxtArea.getInputedText();
		if (FlxG.keys.justReleased.BACKSPACE)
		{
			memoTxtArea.clearText();
		}
	}
}