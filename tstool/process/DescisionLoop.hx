package tstool.process;
import flixel.FlxG;
import tstool.layout.History.Interactions;
import tstool.process.Process.ProcessContructor;

/**
 * ...
 * @author bb
 */
class DescisionLoop extends Descision
{
	var _nextYesProcess:ProcessContructor;
	var _nextNoProcess:ProcessContructor;
	override public function new(?yesProcess:ProcessContructor,?noProcess:ProcessContructor) 
	{
		super();
		_nextYesProcess = yesProcess;
		_nextNoProcess = noProcess;
	}
	/**
	* @todo String to Class<Process>
	*/
	override function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		Main.HISTORY.add({step:this._class, params: [_nextYesProcess, _nextNoProcess] }, interactionType, _titleTxt, buttonTxt, values);
	}
	
	
	override public function onYesClick():Void
	{
		this._nexts = [_nextYesProcess == null ? Main.HISTORY.getPreviousClass() : _nextYesProcess];
		//this._nextYesProcesses = [];
		super.onYesClick();
	}
	override public function onNoClick():Void
	{
		this._nexts = [_nextNoProcess == null ? Main.HISTORY.getPreviousClass() : _nextNoProcess];
		super.onNoClick();
	}
	override function switchLang(lang:String)
	{
	
		Main.user.mainLanguage = lang;
		Main.COOKIE.flush();
		
		Main.tongue.initialize(lang , ()->(
										FlxG.switchState( 
											Type.createInstance( _class, [_nextYesProcess, _nextNoProcess])
											)
										)
						);
	}
}