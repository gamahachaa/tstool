package tstool.process;
import flixel.FlxG;
import tstool.process.Process.ProcessContructor;

/**
 * ...
 * @author bb
 */
class TripletLoop extends Triplet 
{
	var _yesProcess:ProcessContructor;
	var _noProcess:ProcessContructor;
	var _midProcess:ProcessContructor;

	public function new(?yesProcess:ProcessContructor,?noProcess:ProcessContructor, ?midProcess:ProcessContructor) 
	{
		super();
		_yesProcess = yesProcess;
		_noProcess = noProcess;
		_midProcess = midProcess;
	}
	override function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		Main.HISTORY.add({step:this._class, params: [_yesProcess, _noProcess, _midProcess] }, interactionType, _titleTxt, buttonTxt, values);
	}
	override public function onYesClick():Void
	{
		this._nexts = [_yesProcess == null ? Main.HISTORY.getPreviousClass() : _yesProcess];
		super.onYesClick();
	}
	override public function onNoClick():Void
	{
		this._nexts = [_noProcess == null ? Main.HISTORY.getPreviousClass() : _noProcess];
		super.onNoClick();
	}
	override public function onMidClick():Void
	{
		this._nexts = [_midProcess == null ? Main.HISTORY.getPreviousClass() : _midProcess];
		super.onMidClick();
	}
	override function switchLang(lang:String, ?pos:PosInfos)
	{
	
		MainApp.agent.mainLanguage = lang;
		MainApp.flush();
		
		MainApp.translator.initialize(lang , ()->(
										FlxG.switchState( 
											Type.createInstance( _class, [_nextYesProcess, _nextNoProcess, _midProcess])
											)
										)
						);
	}
}