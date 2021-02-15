package tstool.process;
import lime.system.Clipboard;
import tstool.layout.ScriptView;

/**
 * ...
 * @author bb
 */
class EndAction extends Action 
{
	var scriptView:ScriptView;
	var scriptText:String;
	override public function create()
	{
		//scriptText = Main.HISTORY.prepareListHistory(true);
		scriptView = new ScriptView( Main.HISTORY.prepareListHistory(true));
		super.create();
		ui.script.visible = true;
		Main.track.setResolution();
		Main.track.send();
	}
	override public function onClick():Void
	{
		
		this._nexts = [{step: Main.START_STEP}];
		super.onClick();
	}
	override function listener(s:String):Void 
	{
		Clipboard.text = this.scriptText;
		//trace("tstool.process.Process::listener");
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
		openSubState( scriptView );
	}
}