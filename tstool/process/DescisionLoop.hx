package tstool.process;

/**
 * ...
 * @author bb
 */
class DescisionLoop extends Descision
{
	var _nextYesProcess:Process;
	var _nextNoProcess:Process;
	override public function new(?yesProcess:Process,?noProcess:Process) 
	{
		super();
		_nextYesProcess = yesProcess;
		_nextNoProcess = noProcess;
	}
	/**
	* @todo String to Class<Process>
	*/
	override public function create():Void
	{
		this._nextYesProcesses = [_nextYesProcess == null ? Process.GET_PREVIOUS_INSTANCE() : _nextYesProcess];
		this._nextNoProcesses= [_nextNoProcess == null ? Process.GET_PREVIOUS_INSTANCE() : _nextNoProcess];

		super.create();
	}
}