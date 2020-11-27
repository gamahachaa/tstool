package tstool.layout;

import flixel.FlxSprite;
import tstool.process.ActionLoop;
import tstool.process.DescisionLoop;
import tstool.process.Process;

/**
 * ...
 * @author ...
 */
typedef Snapshot =
{
	var processName: String;
	var interaction: Interactions;
	var processTitle:String;
	var iteractionTitle:String;
	var values:Map<String,Dynamic>;
	var start:Date;
	var ?step:ProcessContructor;
	var ?_class:Class<Process>;
	var ?_params:Array<Class<Process>>;
}
enum Interactions
{
	Yes;
	No;
	Mid;
	Next;
	Exit;
}
class History
{
	public var history(get, null):Array<Snapshot>;
	var stack:FlxSprite;

	public function new()
	{
		//super();
		history = new Array<Snapshot>();
		//stack = new FlxSprite();
	}
	/**
	 * @todo pass proceses as Class and buil only when needed (not here)
	 * @param	process
	 * @param	interaction
	 * @param	title
	 * @param	iteractionTitle
	 * @param	values
	 * @param	Dynamic>=nul
	 */
	public function add( process:ProcessContructor, interaction:Interactions, title:String, iteractionTitle:String, ?values:Map<String,Dynamic>=null)
	{
		history.push(
		{
			processName : Type.getClassName(process.step),
			interaction: interaction,
			processTitle:title,
			iteractionTitle:iteractionTitle,
			values:values,
			start: Date.now(),
			step: process
			//_class: process.step,
			//_params: process.params
		}
		);
	}

	public function init():Void
	{
		history = [];
	}
	public function clearHistoryFrom(index:Int)
	{
		#if debug
		//trace(index);
		//trace(history.length);
		//trace(history.length - index -1);
		#end
		var old = history.splice(index, history.length - index);
		/**
		 * @todo String to Class<Process>
		 */
		//return Type.createInstance( Type.resolveClass( old[0].processName), [] );
		return Type.createInstance( old[0].step.step, old[0].step.params);
	}
	public function onStepBack()
	{
		var last = history.pop();
		
		if (Type.getSuperClass(last.step.step) == DescisionLoop || Type.getSuperClass(last.step.step) == ActionLoop)
		{
			/**
			* @todo String to Class<Process> CHECK IF LOOPING WORKS WITH CLASSES CREATED FROM TYPE REMOVE this steps back
			*/
			last = history.pop();
			//lastObject = Type.resolveClass( last._class );
			
		} 
		return Type.createInstance( last.step.step, last.step.params );
	}
	public function getClassIterations(process:Class<Process>, ?interaction:Interactions):Int
	{
		/**
		 * @testme getClassIterations Class<Process> 
		 */
		var count = 0;
		for ( i in history )
		{
			if ((interaction == null && i.step.step == process) || (interaction == i.interaction && i.step.step == process) )
			{
				count++;
			}

		}
		return count;
	}
	public function getIterations(processName:String, ?interaction:Interactions):Int
	{
		var count = 0;
		for ( i in history )
		{
			if ((interaction == null && i.processName == processName) || (interaction == i.interaction && i.processName == processName) )
			{
				count++;
			}

		}
		return count;
	}
	
	inline function getPreviousProcess()
	{
		return history[history.length - 1];
	}
	/**
	 * @todo  Remove
	 *
	inline public function getPreviousInstance()
	{
		
		return Type.createInstance( Type.resolveClass( getPreviousProcess().processName), [] );
	}*/
	inline public function getPreviousClass():ProcessContructor
	{
		return getPreviousProcess().step;
	}

	function get_history():Array<Snapshot>
	{
		return history;
	}
	public function getFirst()
	{
		return history[0];
	}
	public function getLast()
	{
		return history[history.length-1];
	}
	/**
	 * @todo Change isInHistory in all sub classes with isClassInteractionInHistory
	 */
	public function isInHistory(processName:String, interaction:Interactions)
	{
		for ( i in history )
		{
			if (interaction == i.interaction && i.processName == processName )
			{
				return true;
			}

		}
		return false;
	}
	/**
	 * @testme getClassIterations Class<Process>
	 */
	public function isClassInteractionInHistory(step:Class<Process>, interaction:Interactions)
	{
		for ( i in history )
		{
			if (interaction == i.interaction && i.step.step == step )
			{
				return true;
			}

		}
		return false;
	}
	/**
	 * @todo Change isProcessInHistory in all sub classes with isClassInHistory
	 */
	public function isProcessInHistory(processName:String)
	{
		for ( i in history )
		{
			if (i.processName == processName )
			{
				return true;
			}

		}
		return false;
	}
	
	public function isClassInHistory(step:Class<Process>)
	{
		for ( i in history )
		{
			if (i.step.step == step )
			{
				return true;
			}

		}
		return false;
	}
	/**
	* @todo Change findStepsInHistory in all sub classes with findStepsClassInHistory
	*/
	public function findStepsInHistory(processName:String, ?times:Int=1, ?fromBegining:Bool=true):Array<Snapshot>
	{
		var tab = [];
		var count = 0;
		if (fromBegining)
		{
			for (i in 0...history.length)
			{
				if ( history[i].processName == processName )
				{
					tab.push(history[i]);
					if ( ++count == times) break; 
					
				}
			}
		}
		else{
			var l = history.length;
		
			while (l > 0)
			{
				--l;
				if (history[l].processName == processName )
				{
					tab.push(history[l]);
					if ( ++count == times) break; 
					
				}
			}
		}
		return tab;
	}
	public function findStepsClassInHistory(step:Class<Process>, ?times:Int=1, ?fromBegining:Bool=true):Array<Snapshot>
	{
		var tab = [];
		var count = 0;
		if (fromBegining)
		{
			for (i in 0...history.length)
			{
				if ( history[i].step.step == step )
				{
					tab.push(history[i]);
					if ( ++count == times) break; 
					
				}
			}
		}
		else{
			var l = history.length;
		
			while (l > 0)
			{
				--l;
				if (history[l].processName == processName )
				{
					tab.push(history[l]);
					if ( ++count == times) break; 
					
				}
			}
		}
		return tab;
	}
	public function getStoredStepsArray( )
	{
		var t = [];
		var s = 0;
		for (i in history)
		{
			t.push({nb:s++, step:i.processTitle, interaction: i.iteractionTitle, values: i.values==null?"":i.values.toString()});
		}
		return t;
	}
	public function getStepsAsString( toLangPair:String="en-GB" )
	{
		var t = "";
		var h = getStoredStepsTranslatedArray(toLangPair);
		var v = "";
		for (i in h)
		{
			t += '${i.nb}|${i.step}|${i.interaction}|${i.values}_';
		}
		return t;
	}
	
	public function getRawStepsArray()
	{
		var t = [];
		var s = 0;
		for (i in history)
		{
			t.push({nb:s++, step:i.step, interaction: i.interaction, values: i.values==null?"":i.values.toString()});
		}
		return t;
	}
	/**
	 * Default to English
	 * @param	toLangPair
	 */
	public function getStoredStepsTranslatedArray( toLangPair:String="en-GB" )
	{
		var t = [];
		var s = 0;
		
		var question = "";
		var choice = "";
		Main.tongue.initialize( toLangPair );
		for (i in history)
		{
			question = Main.tongue.get("$" + i.processName + "_TITLE", "data");
			choice = getDefaultOrCutomChoice( i.processName, i.interaction);
			t.push({nb:s++, step: question, interaction: choice, values: i.values==null?"":i.values.toString()});
		}
		#if debug
		Main.tongue.initialize("fr-FR");
		#else
		Main.tongue.initialize(Main.user.mainLanguage);
		#end
		return t;
	}
	function getDefaultOrCutomChoice( process:String, interaction:Interactions): String
	{
		var choice = Main.tongue.get("$" + process + "_" + getCustomInteractionTranslationHeader(interaction), "data");
		if (choice == "" || choice == null || choice.indexOf("$") == 0)
		{
			choice = Main.tongue.get("$defaultBtn_" + getDefaultInteractionTranslationHeader(interaction), "meta");
		}
		
		return choice;
	}
	function getDefaultInteractionTranslationHeader( interaction:Interactions)
	{
		return switch(interaction)
		{
			case Yes: "UI3";
			case No: "UI1";
			case Mid: "UI2";
			default: "UI2";
		}
	}
	function getCustomInteractionTranslationHeader( interaction:Interactions)
	{
		return switch(interaction)
		{
			case Yes: "RIGHT-BTN";
			case No: "LEFT-BTN";
			case Mid: "MID-BTN";
			default: "MID-BTN";
		}
	}
}