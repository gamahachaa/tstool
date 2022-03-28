package tstool.layout;
import tstool.layout.IPositionable.Direction;
/**
 * ...
 * @author bb
 */
class BIGUIInputTfCore extends UIInputTfCore 
{

	public function new(textFieldWidth:Int, textFieldHeight:Int, inputPrefix:String, positionsToParent:Array<Direction>) 
	{
		super(textFieldWidth, inputPrefix, positionsToParent);
		inputtextfield.height = textFieldHeight;
	}
	override public function setStyle()
	{
		super.setStyle();
		inputtextfield.multiline = true;
	}
}
