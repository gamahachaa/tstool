package tstool.process;

import flixel.FlxG;
import tstool.layout.UI;
//import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import tstool.layout.ClosableSubState;
import tstool.layout.HitoryItem;
//import tstool.layout.SaltColor;

/**
 * ...
 * @author bbaudry
 */
class DataView extends ClosableSubState
{
	var stack:FlxTypedGroup<FlxText>;
	var padding:Int;
	var parentName:String;
	var additionalMassage:String;
	/**
	* @todo String to Class<Process>
	*/
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT, parentName:String, ?additionalMessage="" )
	{
		super(BGColor);
		this.parentName = parentName;
		additionalMassage = additionalMessage;
	}
	override public function create():Void
	{
		super.create();
		stack = new FlxTypedGroup<FlxText>();
		//FlxMouseEventManager.add(this, null, onStageClicked);
		padding = 20;
		buidStack();
		add(stack);
	}
	
	//function onStageClicked(parameter0):Void 
	//{
		//close();
	//}
	override public function update(elapser:Float)
	{
		if ( FlxG.keys.justReleased.ESCAPE )
		{
			#if debug
			trace("tstool.process.DataView::update::FlxG.keys.justReleased.ESCAPE", FlxG.keys.justReleased.ESCAPE );
			#end
			close();
		}
	}
	public function buidStack()
	{
		//trace("tstool.process.DataView::buidStack");
		var now:HitoryItem;
		var pt: FlxPoint = new FlxPoint(0, 40);
		var h = Main.HISTORY.getLocalizedStepsStringsArray();
		
		for (i in 0...h.length)
			{
				//var h = Main.HISTORY.history[i];
				//var s = '$i. ${h.processTitle} :: ${h.iteractionTitle}';
				var t:HitoryItem = new HitoryItem(i, padding, pt.y + padding , FlxG.width-padding, h[i], 6);
				
				t.setFormat(UI.BASIC_FMT.font, UI.TITLE_FMT.size, UI.THEME.meta);
				//t.color = FlxColor.GRAY;
				FlxMouseEventManager.add(t, onStepClicked, null, onStepOver, onStepOut);
				stack.add(t);
				pt.y = t.y;
				pt.x = i;
			}
		/*if (!Main.HISTORY.isEmpty())
		{
			for (i in 0...Main.HISTORY.history.length)
			{
				var h = Main.HISTORY.history[i];
				var s = '$i. ${h.processTitle} :: ${h.iteractionTitle}';
				var t:HitoryItem = new HitoryItem(i, padding, pt.y + padding , FlxG.width-padding, simplifyString(s), 10);
				
				t.setFormat(UI.BASIC_FMT.font, UI.TITLE_FMT.size, UI.THEME.meta);
				//t.color = FlxColor.GRAY;
				FlxMouseEventManager.add(t, onStepClicked, null, onStepOver, onStepOut);
				stack.add(t);
				pt.y = stack.members[stack.members.length - 1].y;
				pt.x = i;
			}
		}*/
		additionalMassage += "\n\n(Press ESC to close)";
		additionalMassage = pt.x +1 + ". " + parentName + additionalMassage;
		now = new HitoryItem(Main.HISTORY.history.length, padding , pt.y + padding * 2, FlxG.width - padding, additionalMassage, 12 );
		now.setFormat(UI.TITLE_FMT.font,  UI.TITLE_FMT.size, UI.THEME.title);
		stack.add(now);
		return stack;
	}
	function onStepOver(h:HitoryItem):Void
	{
		h.color = UI.THEME.interaction;
	}

	function onStepOut(h:HitoryItem):Void
	{
		h.color = UI.THEME.meta;
	}

	function onStepClicked(h:HitoryItem):Void
	{
		/**
		* @todo TEST String to Class<Process>
		*/
		FlxG.switchState( Main.HISTORY.clearHistoryFrom(h.index) );
	}
	function simplifyString(s:String)
	{
		var tmp = [];
		if (s.indexOf("\n") > 0)
		{
			tmp = s.split("\n");
			s = tmp[0];
		}
		if (s.length >= FlxG.width - padding )
		{
			var tmp = s.substr(0,  FlxG.width - padding).split(" ");
			tmp.pop();
			return tmp.join(" ");
		}
		else return s;
	}
	
}