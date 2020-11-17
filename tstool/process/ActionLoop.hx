package tstool.process;

/**
 * ...
 * @author bb
 */
class ActionLoop extends Action 
{

	var _next:Process;
	override public function new( ?next:Process )
	{
		super();
		_next = next;
	}
	override public function create():Void
	{
		//this._titleTxt = "Faire une remise au réglages d'usine de la Fiber Box";
		//this._detailTxt = "(reset box)";
		//this._illustration = "box/box_reset";
		

		super.create();
	}
	/*
	override public function create()
	{
		this._nextProcesses = [];
		super.create();
	}
	*/
	override public function onClick():Void
	{
		this._nextProcesses = [_next == null ? Process.GET_PREVIOUS_INSTANCE() : _next];
		super.onClick();
	}
}