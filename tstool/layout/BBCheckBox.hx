package tstool.layout;

import flixel.addons.ui.FlxUICheckBox;
import signal.Signal2;
//import flixel.util.FlxSignal;
//import signal.Signal1;
/**
 * ...
 * @author bb
 */
class BBCheckBox extends FlxUICheckBox
{
	public static inline var DEFAULT_CHECK_WIDTH:Int = 200;
	public var id(get, null):String;
	public var signal:Signal2<String,Bool>;

	function get_id():String
	{
		return id;
	}

	public function new(id:String, parentClassName:String,  ?LabelW:Int=DEFAULT_CHECK_WIDTH)
	{
		this.id = id;
		
		super(0, 0, null, null, MainApp.translator.translate("", parentClassName, id, "headers"), LabelW, null, dispatch);
		button.over_color = UI.THEME.meta;
		this.button.setLabelFormat(UI.BASIC_FMT.font, UI.TITLE_FMT.size-4);
		this.textY = -8;
		signal = new Signal2<String,Bool>();
	}
	
	function dispatch() 
	{
		signal.dispatch(id, checked);
	}

}