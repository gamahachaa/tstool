package tstool.process;
import js.Browser;
import lime.system.Clipboard;
import tstool.layout.ScriptView;
import xapi.Activity;
using StringTools;

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
		scriptView = new ScriptView( Main.HISTORY.prepareListHistory(true) );
		super.create();
		ui.script.visible = true;

		//#if debug
			//Main.trackH.setResolution();
			if (Main.trackH.object != null)
			{
				setResolution();
				Main.trackH.send();
			}
		//#else
			//Main.track.setResolution();
			//Main.track.send();
		//#end
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
	function setResolution()
	{
		//setVerb("resolved");
		var steps = "";
		var stepsCode = "";
		//var step = "";
		//var interaction = "";
		var values = "";
		/**
		 * @todo String to Class<Process> / isInHistory
		 */
		
		var h = Main.HISTORY.getStoredStepsTranslatedArray();
		for (i in h)
		{
			steps += '${i.step}|${i.interaction}£'.replace(",","/");
			if(i.values != "") values += '${i.values}|';
		}
		steps = steps.replace(",", "/").replace("\r", " ").replace("\n", " ").replace('"', "-");
		
		var hc = Main.HISTORY.getRawStepsArray();
		for (i in hc)
		{
			stepsCode += '${i.processName}|${i.interaction}£';
		}
		Main.trackH.updateStatementRef();
//#if debug
		cast(Main.trackH.object, Activity).definition.extensions.set(Browser.location.origin + "/troubleshooting/total_steps/", Std.string(h.length));
		cast(Main.trackH.object, Activity).definition.extensions.set(Browser.location.origin +"/troubleshooting/steps/", steps);
		cast(Main.trackH.object, Activity).definition.extensions.set(Browser.location.origin +"/troubleshooting/stepsCode/", stepsCode);
		cast(Main.trackH.object, Activity).definition.extensions.set(Browser.location.origin +"/troubleshooting/script_version/", Main.VERSION);
		#if debug
		trace("tstool.process.EndAction::setResolution::steps", steps );
		trace("tstool.process.EndAction::setResolution::stepsCode", stepsCode );
		
		#end
		cast(Main.trackH.object, Activity).definition.extensions.set(Browser.location.origin +"/troubleshooting/values/", values);
//#else
//#end
		//u.setParameter(PARAM_TOTAL_STEPS,  Std.string(h.length) );
		//u.setParameter(PARAM_VALUES, values );
		//u.setParameter(PARAM_STEPS,  steps);
	}
	
	function onScript() 
	{
		openSubState( scriptView );
	}
}