package tstool.process;
import flixel.FlxG;
import tstool.layout.History.Interactions;
import tstool.process.Process.ProcessContructor;

/**
 * ...
 * @author bb
 */
class ActionLoop extends Action 
{

	var _next:ProcessContructor;
	override public function new( ?next:ProcessContructor)
	{
		super();
		_next = next;
	}

	override public function onClick():Void
	{
		//this._nextProcesses = [_next == null ? Process.GET_PREVIOUS_INSTANCE() : _next];
		this._nexts = [_next == null ? Main.HISTORY.getPreviousClass() : _next];
		super.onClick();
	}
	override function pushToHistory(buttonTxt:String, interactionType:Interactions,?values:Map<String,Dynamic>=null):Void
	{
		Main.HISTORY.add({step:this._class, params: _nexts }, interactionType, _titleTxt, buttonTxt, values);
	}
	override function switchLang(lang:String)
	{
	
		Main.user.mainLanguage = lang;
		Main.COOKIE.flush();
		
		Main.tongue.initialize(lang , ()->(
										FlxG.switchState( 
											Type.createInstance( _class, _nexts)
											)
										)
						);
	}
}