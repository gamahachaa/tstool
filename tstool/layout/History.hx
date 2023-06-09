package tstool.layout;

//import flixel.FlxSprite;
//import tstool.salt.TicketMail;
//import tstool.utils.Mail;
//import tstool.process.ActionLoop;
//import tstool.process.DescisionLoop;
import firetongue.Replace;
import haxe.PosInfos;
import tstool.process.Process;
using string.StringUtils;

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
}
typedef Steps =
{
	var nb:Int;
	var processName:String;
	var interaction:Interactions;
	var values:String;
}
enum Interactions
{
	Yes;
	No;
	Mid;
	Next;
	Exit;
}
typedef ValueReturn =
{
	var exists:Bool;
	var value:Dynamic;
}
class History
{
	public var history(get, null):Array<Snapshot>;
	//var stack:FlxSprite;
	//public static var STACK:Array<Snapshot>=[];
	public static var STACK:History = new History();
	public function new()
	{
		//super();
		history = new Array<Snapshot>();
		//stack = new FlxSprite();
	}
	/**
	 *
	 * @param	process
	 * @param	interaction
	 * @param	title
	 * @param	iteractionTitle
	 * @param	values
	 * @param	Dynamic>=nul
	 */
	public function add(
			process:ProcessContructor,
			interaction:Interactions,
			title:String,
			iteractionTitle:String,
			?values:Map<String,Dynamic>=null)
	{
		history.push(
		{
			processName : Type.getClassName(process.step),
			interaction: interaction,
			processTitle: stripTags(title),
			iteractionTitle:iteractionTitle,
			values:values,
			start: Date.now(),
			step: process
			//_class: process.step,
			//_params: process.params
		}
		);
		//trace(history);
	}

	public function init():Void
	{
		history = [];
	}
	public function isEmpty()
	{
		//trace(history.length > 0);
		return history.length == 0;
	}
	public function clearHistoryFrom(index:Int)
	{
		#if debug
		//trace(index);
		//trace(history.length);
		//trace(history.length - index -1);
		#end
		var old = history.splice(index, history.length - index);

		//return Type.createInstance( Type.resolveClass( old[0].processName), [] );
		return Type.createInstance( old[0].step.step, old[0].step.params);
	}
	public function onStepBack()
	{
		var last = history.pop();
		return Type.createInstance( last.step.step, last.step.params );
	}
	public function getClassIterations(process:Class<Process>, ?interaction:Interactions):Int
	{
		//trace("------------");

		var count = 0;
		for ( i in history )
		{
			//trace(interaction, i.interaction, interaction == i.interaction);
			//trace(process, i.step.step, i.step.step == process);
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
	inline public function getPreviousClass():ProcessContructor
	{
		/**
		 * @todo rename getPreviousProcessConstructor
		 */
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

	public function isClassInHistory(step:Class<Process>):Bool
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
		var tab:Array<Snapshot> = [];
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
				if (history[l].step.step == step )
				{
					tab.push(history[l]);
					if ( ++count == times) break;

				}
			}
		}
		return tab;
	}
	public function findFirstStepsClassInHistory(step:Class<Process>, ?fromBegining:Bool=true):Snapshot
	{
		return findStepsClassInHistory(step, 1, fromBegining)[0];
	}
	public function findAllValuesOffOfFirstClassInHistory(step:Class<Process>, ?fromBegining:Bool = true):Map<String,Dynamic>
	{
		return findFirstStepsClassInHistory(step).values;
	}
	public function findValueOfFirstClassInHistory(step:Class<Process>, valueIndex:String, ?fromBegining:Bool = true):ValueReturn
	{
		var steps = findStepsClassInHistory(step, 1, fromBegining);
		var v:Snapshot = steps[0];
		if ( steps.length == 0 || v.values == null || !v.values.exists(valueIndex))
		{
			return {exists:false, value: null};
		}
		else
		{
			return {exists:true, value: v.values.get(valueIndex)};
		}
	}
	public function buildHistoryEmailBody( currentLang:String, _currentProcess:Process, ?translate:Bool= true)
	{
		var lang = currentLang;
		var  b = "";
		#if debug
		trace("tstool.utils.Mail::buildHistoryBody::MainApp.agent.mainLanguage", lang );
		#end
		var needsEnTranslation = lang != "en-GB";
		var steps = this.getStoredStepsArray();
		steps.push(
		{
			processName: _currentProcess._name,
			interaction: Next,
			processTitle: "",
			iteractionTitle: "",
			values: null,
			start:Date.now()
		}
		);

		b += '<h4>Steps:</h4>';
		b += '<ol>';
		b += listSteps(steps);
		b += '</ol>';
		if (translate && needsEnTranslation)
		{
			b += "<h4>English:</h4>";
			MainApp.translator.initialize( "en-GB" );
			//b += '<ol>${listSteps(steps)}</ol>';
			b += '<ol>';
			b += listSteps(steps);
			b += '</ol>';
			#if debug
			MainApp.translator.initialize(MainApp.LANGS[0]);
			#else
			MainApp.translator.initialize(lang);
			#end
		}
		return b;
	}

	public function getStoredStepsArray( ):Array<Snapshot>
	{
		var t = [];
		//var s = 0;
		for (i in history)
		{
			t.push(i);
		}
		return t;
	}

	public function getLocalizedStepsStringsList()
	{
		var t = "";
		var nb = 1;
		//var v = "";
		for (i in history)
		{
			t += '${nb++}. ${i.processTitle} ${i.iteractionTitle} ${i.values==null?"":i.values.toString()}\n';
		}
		return t;
	}
	public function getLocalizedStepsStringsArray()
	{
		var t = [];
		var nb = 1;
		//var v = "";
		for (i in history)
		{
			t.push('${nb++}. ${i.processTitle} ${i.iteractionTitle} ${i.values!=null?i.values:[""=>""]}');
		}
		return t;
	}
	public function getRawStepsArray():Array<Steps>
	{
		var t = [];
		var s = 0;
		for (i in history)
		{
			t.push(
			{
				nb:s++,
				processName:i.processName,
				interaction: i.interaction,
				values: i.values==null?"":i.values.toString()
			});
		}
		return t;
	}

	/**
	 * Default to English
	 * @param	toLangPair
	 */
	public function getStoredStepsTranslatedArray( toLangPair:String="en-GB", ?pos:PosInfos )
	{
		#if debug
		trace('CALLED FROM ${pos.className} ${pos.methodName} ${pos.fileName} ${pos.lineNumber}');
		#end
		var t = [];
		//var s = 0;

		var question = "";
		var choice = "";
		MainApp.translator.initialize( toLangPair );
		for (i in history)
		{
			question = MainApp.translator.get("$" + i.processName + "_TITLE", "data");
			choice = getDefaultOrCutomChoice( i.processName, i.interaction);
			t.push({step: question, interaction: choice, values: i.values==null?"":i.values.toString()});
		}
		#if debug
		MainApp.translator.initialize("fr-FR");
		#else
		MainApp.translator.initialize(MainApp.agent.mainLanguage);
		#end
		return t;
	}
	public function prepareListHistory(forClipBoard:Bool=false)
	{
		/**
		 * @todo cleanup useless function var param
		 */
		var t = forClipBoard?"":"";
		var index = 1;
		for ( i in this.history )
		{
			t += index++ + ". " + stripTags(i.processTitle) + " :: " + i.iteractionTitle + (i.values == null? "\n": formatValuesToBasicText( i.values )) ;
		}
		#if debug
		//trace(t);
		#end
		return t;
	}
	///////////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////////
	public static function stripTags(s:String,?skip:Array<String>=null):String
	{
		var t = ["<B>", "<b>", "<N>", "<T>", "<EM>", "<em>", "\t", "\n"];
		if (Replace.TAGS.length>0)
		{
			t = Lambda.concat( t, Replace.TAGS);
		}
		//#if debug
		//trace("tstool.layout.History::stripTags::t", t );
		//#end
		for (i in t)
		{
			if (skip != null && skip.indexOf(i) != -1) continue;
			s = StringTools.replace(s, i, " ");
		}
		return s;
	}

	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	public function prepareClipboard(additionalText:String)
	{
		return stripTags(additionalText + "\n" + prepareListHistory(), ["\n"])  ;
	}
	//////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////
	function listSteps(stepsArray:Array<Snapshot>, ?pos:haxe.PosInfos):String
	{
		var s = "";

		var title ="";
		var values = "";
		var interaction = "";
		if (stepsArray == null) return "";
		#if debug
		trace("tstool.layout.History::listSteps::stepsArray", stepsArray );
		#end

		for (h in stepsArray)
		{
			//#if debug
			//trace("tstool.layout.History::listSteps::h", h );
			//#end
			title = stripTags(MainApp.translator.get("$" + h.processName + "_TITLE", "data"));
			//#if debug
			//trace('CALLED FROM ${pos.className} ${pos.methodName} ${pos.fileName} ${pos.lineNumber}');
			//#end
			interaction = h.interaction == Next ? "" : '... <strong>${getDefaultOrCutomChoice( h.processName, h.interaction)}</strong>';
			//#if debug
			//trace('CALLED FROM ${pos.className} ${pos.methodName} ${pos.fileName} ${pos.lineNumber}');
			//#end
			values = h.values == null ? "" : formatMapToHtml(h.values, h.processName);
			//#if debug
			//trace('CALLED FROM ${pos.className} ${pos.methodName} ${pos.fileName} ${pos.lineNumber}');
			//#end
			if (interaction == "") s += '<li>$title $values</li>';
			else if (values == "" ) s += '<li>$title $interaction</li>';
			else s +='<li>$title $values $interaction</li>';

		}
		return s;
	}
	inline function formatMapToHtml( map :Map<String, Dynamic>, processName:String):String
	{
		var out = "";
		var translation = "";
		for ( title => value in map)
		{
			if (StringTools.trim(Std.string(value)) != "" )
			{

				translation = MainApp.translator.get("$" + processName + title.removeWhite(), "headers");
				if (translation == null || translation == "" || translation.indexOf("$") == 0)
					translation = title;
				//out += '<li>$title ... <strong>$value</strong></li>';
				out += '<li>$translation ... <strong>$value</strong></li>';
			}
		}
		return out ==""?"":'<ul>$out</ul>';
	}
	inline function getDefaultOrCutomChoice( process:String, interaction:Interactions): String
	{
		var choice = MainApp.translator.get("$" + process + "_" + getCustomInteractionTranslationHeader(interaction), "data");
		if (choice == "" || choice == null || choice.indexOf("$") == 0)
		{
			choice = MainApp.translator.get("$defaultBtn_" + getDefaultInteractionTranslationHeader(interaction), "meta");
		}
		return choice;
	}
	/**
	 *
	 * @param	s
	 */
	inline function getDefaultInteractionTranslationHeader( interaction:Interactions)
	{
		return switch (interaction)
		{
			case Yes: "UI3";
			case No: "UI1";
			case Mid: "UI2";
			default: "UI2";
		}
	}
	/**
	 *
	 * @param	s
	 */
	inline function getCustomInteractionTranslationHeader( interaction:Interactions)
	{
		return switch (interaction)
		{
			case Yes: "RIGHT-BTN";
			case No: "LEFT-BTN";
			case Mid: "MID-BTN";
			default: "MID-BTN";
		}
	}
	inline function formatValuesToBasicText( map :Map<String, Dynamic>):String
	{
		var out = "\n";
		for ( title => value in map)
		{
			out += '\t\t - $title : $value\n';
		}
		//out += "";
		return out;
	}
}