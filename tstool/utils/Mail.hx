package tstool.utils;
import Main;
import tstool.layout.History.Interactions;
import tstool.utils.SwiftMailWrapper.Result;

import flixel.util.FlxSignal.FlxTypedSignal;
//import haxe.Json;
import js.Browser;
import tstool.layout.History.Snapshot;
import tstool.process.Process;
import tstool.salt.SOTickets;
/**
 * ...
 * @author bbaudry
 */

class Mail
{
	//var http:Http;
	//var _mailSubject:String;
	//var _queue:String;
	var _ticket:SOTickets;
	var mailWrapper:tstool.utils.SwiftMailWrapper;
	var _currentProcess(default, set):Process;
	//var _mailBody:String;
	@:isVar public var successSignal(get, set):FlxTypedSignal<Result->Void>;
	@:isVar public var statusSignal(get, set):FlxTypedSignal<Int->Void>;
	@:isVar public var errorSignal(get, set):FlxTypedSignal<Dynamic->Void>;
	//static var PHP_MAIL_PATH:String = Main.LIB_FOLDER + "php/mail/index.php";
	static var PHP_MAIL_PATH:String = "../trouble/php/mail/index.php";
	var resolved:Bool;

	//@:isVar public var params(get, set):haxe.ds.Map<Parameters,Dynamic>;

	public function new(ticket:SOTickets, currentProcess:Process, ?resolved:Bool= false)
	{
		_ticket = ticket;
		this.resolved = resolved;
		
		_currentProcess = currentProcess;
		mailWrapper = new SwiftMailWrapper(Browser.location.origin + Browser.location.pathname + PHP_MAIL_PATH);
		//_mailBody = mailWrapper.setCommonStyle();
		successSignal = mailWrapper.successSignal;
		statusSignal = mailWrapper.statusSignal;
		errorSignal = mailWrapper.errorSignal;
		//params = new Map<Parameters,String>();
		//params = new Map<Parameters,Dynamic>();
		//setStyle();
		
		

	}
	

	public function send(memo:String= "")
	{
		setFrom();
		setReciepients();
		setSubject();
		setBody(memo);
		
		#if debug
			trace(mailWrapper.values);
			if (Main.DEBUG) mailWrapper.send(MainApp.agent.canDispach);
		#else
			mailWrapper.send(MainApp.agent.canDispach);
		#end
		
	}
	function setReciepients()
	{
		#if debug
			//params.set(to_email, "superofficetest@salt.ch"); // Test on cs-sit.test
			if (!Main.DEBUG)
			{
				mailWrapper.setTo(["bruno.baudry@salt.ch"]);
			}
			else{
				mailWrapper.setTo(["superofficetest@salt.ch"]);
			}
			//trace("tstool.utils.Mail::Mail::MainApp.agent.iri", MainApp.agent.iri );
			if(MainApp.agent.iri != null) mailWrapper.setCc(['${MainApp.agent.iri}']);
			mailWrapper.setBcc(["bruno.baudry@salt.ch"]);

		#else
		mailWrapper.setTo([_ticket.email]);
		mailWrapper.setCc(['${MainApp.agent.iri}']);
		mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
		#end
	}
	function setSubject()
	{
		var isResolved = resolved?"[RESOLVED]":"";	
		var _queue =_ticket.queue + "_"; // Nico change 25.03.2020
		var _mailSubject = _ticket.domain + "-" + _ticket.number + " " + _ticket.desc;
		
		mailWrapper.setSubject('[${Main.customer.voIP}][$_queue][${MainApp.agent.sAMAccountName}]$isResolved $_mailSubject' );
	}
	function setFrom()
	{
		mailWrapper.setFrom(
			MainApp.agent.iri == null ? "bruno.baudry@salt.ch" : MainApp.agent.iri, 
			MainApp.agent.sAMAccountName == null ? "bbaudry" : MainApp.agent.sAMAccountName
		);
		#if debug
			trace(MainApp.agent);
		#end
	}
	function setBody(memo) 
	{
		var _mailBody = buildCustomerBody(memo);
		_mailBody += buildHistoryBody();
		_mailBody += buildAgentBody();
		mailWrapper.setBody(_mailBody );
		
	}
	
	function buildCustomerBody(memo:String= "")
	{
		var  b = "";
		#if debug
			trace(Main.customer);
		#end
		try
		{
			//b += '<h1>$_mailSubject</h1>';
			b += "<p>"+ (memo == ""? "No memo written by agent" : memo) + "</p>";
			b += '<h2>';
			if(Main.customer.iri !="" && Main.customer.iri != "not found")
				b += 'ID: ${Main.customer.iri}<br/>';
			if(Main.customer.voIP !="")
				b += 'MSISDN-VoIP: ${Main.customer.voIP}<br/>';
			b += '</h2>';
			if(Main.customer.contract.mobile !="" && memo.indexOf(Main.customer.contract.mobile)==-1 )
				b += '<h3>CONTACT: ${Main.customer.contract.mobile}</h3>';
			b += "<p>";
			if(Main.customer.contract.owner != null && Main.customer.contract.owner.name !="")
				b += '${Main.customer.contract.owner.name}<br/>';
			if (Main.customer.shipingAdress != null && Main.customer.shipingAdress._zip != "")
			{
				if (Main.customer.shipingAdress._co != "")
				{
					b += 'c/o: ${Main.customer.shipingAdress._co}<br/>';
				}
				b += '${Main.customer.shipingAdress._street}, ${Main.customer.shipingAdress._number}<br/>';
				b += '<strong>${Main.customer.shipingAdress._zip}</strong> ${Main.customer.shipingAdress._city}';	
			}
			b += "</p>";
		}
		catch (e:Dynamic)
		{
			trace(e);
		}
		//params.set(body, b);
		return b;
	}
	static inline public function formatMapToHtml( map :Map<String, Dynamic>):String
	{
		var out = "";
		for ( title => value in map)
		{
			if (StringTools.trim(value) != "" ) out += '<li>$title ... <strong>$value</strong></li>';
		}
		
		return out ==""?"":'<ul>$out</ul>';
	}
	
	function buildAgentBody()
	{
		var start:Date = Main.HISTORY.getFirst().start;
		var end:Date = Main.HISTORY.getLast().start;
		var seconds = Math.floor( (end.getTime() - start.getTime()) / 1000 );
		var durationMinutes = Math.floor (seconds / 60);
		var durationSeconds = seconds % 60;
		var bodyList = '<li>Agent: ${MainApp.agent.firstName} ${MainApp.agent.sirName} (${MainApp.agent.sAMAccountName}) ${MainApp.agent.title}</li>';
		bodyList += '<li>${MainApp.agent.company} | ${MainApp.agent.department} | ${MainApp.agent.division} | ${MainApp.agent.workLocation} </li>';
		bodyList += '<li>Script version : ${Main.VERSION} </li>';
		bodyList += '<li>Started: ${start.toString()}, ended: ${end.toString()} ( ~ ' + durationMinutes + "'" + durationSeconds + "''" + " )</li>";
		return '<h5>Troubleshot in ${MainApp.agent.mainLanguage} by:</h5><ul>$bodyList</ul>';
	}
	
	
	function buildHistoryBody()
	{
		var  b = "";
		#if debug
			trace("tstool.utils.Mail::buildHistoryBody::MainApp.agent.mainLanguage", MainApp.agent.mainLanguage );
		#end
		var needsEnTranslation = MainApp.agent.mainLanguage != "en-GB";
		var steps = Main.HISTORY.getStoredStepsArray();
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
		//var historyList = listHtmlSteps( steps );
		//var englishLst = listTranlsatedTextHtmlSteps( steps );
		
		//historyList += "<li><strong>"+_currentProcess.question.text +"</strong></li>";

		
		b += '<h4>Steps:</h4>';
		//b += '<ol>$historyList</ol>';
		b += '<ol>${listSteps(steps)}</ol>';
		//historyList += "<li><strong>"+_currentProcess.question.text +"</strong></li>";
		if (needsEnTranslation)
		{
			b += "<h4>English:</h4>";
			Main.tongue.initialize( "en-GB" );
			b += '<ol>${listSteps(steps)}</ol>';
			#if debug
				Main.tongue.initialize(Main.LANGS[0]);
			#else
			Main.tongue.initialize(MainApp.agent.mainLanguage);
			#end
		}
		//b += !needsEnTranslation ? '<h4>English:</h4><ol>$englishLst</ol>' :"";

		return b;
	}
	static inline function listSteps(stepsArray:Array<Snapshot>):String
	{
		var s = "";
		
		var title ="";
		var values = "";
		var interaction = "";
		if (stepsArray == null) return "";

		for (h in stepsArray)
		{
			title = stripTags(Main.tongue.get("$" + h.processName + "_TITLE", "data"));
			//c = getDefaultOrCutomChoice( h.processName, h.interaction);
			interaction = h.interaction == Next ? "" : '... <strong>${getDefaultOrCutomChoice( h.processName, h.interaction)}</strong>';
			values = h.values == null ? "" : formatMapToHtml(h.values);
			s+= '<li>$title $interaction $values</li>';
		}
		return s;
	}
	/**
	static inline function listTranlsatedTextHtmlSteps(stepsArray:Array<Snapshot>, ?lang:String="en-GB"):String
	{
		var s = "";
		
		var title ="";
		var values = "";
		var interaction = "";
		if (stepsArray == null) return "";
		
		Main.tongue.initialize( lang );
		for (h in stepsArray)
		{
			title = Main.tongue.get("$" + h.processName + "_TITLE", "data");
			//c = getDefaultOrCutomChoice( h.processName, h.interaction);
			interaction = h.interaction == Next ? "" : '... <strong>${getDefaultOrCutomChoice( h.processName, h.interaction)}</strong>';
			values = h.values == null ? "" : formatMapToHtml(h.values);
			s+= '<li>$title $interaction $values</li>';
		}
		#if debug
			Main.tongue.initialize("fr-FR");
		#else
		Main.tongue.initialize(MainApp.agent.mainLanguage);
		#end
		return s;
	}
	static inline function listHtmlSteps(stepsArray:Array<Snapshot>):String
	{
		var s = "";
		var interaction = "";
		var values = "";
		var title = "";
		if (stepsArray == null) return "";
		
		for (h in stepsArray)
		{
			title = h.processTitle;
			interaction = h.interaction == Next ? "" : '... <strong>${h.iteractionTitle}</strong>';
			values = h.values == null ? "" : formatMapToHtml(h.values);
			s+= '<li>$title $interaction $values</li>';
		}
		return s;
	}*/
	public static inline function getDefaultOrCutomChoice( process:String, interaction:Interactions): String
	{
		var choice = Main.tongue.get("$" + process + "_" + getCustomInteractionTranslationHeader(interaction), "data");
		if (choice == "" || choice == null || choice.indexOf("$") == 0)
		{
			choice = Main.tongue.get("$defaultBtn_" + getDefaultInteractionTranslationHeader(interaction), "meta");
		}
		return choice;
	}
	static inline function getDefaultInteractionTranslationHeader( interaction:Interactions)
	{
		return switch(interaction)
		{
			case Yes: "UI3";
			case No: "UI1";
			case Mid: "UI2";
			default: "UI2";
		}
	}
	
	static inline function getCustomInteractionTranslationHeader( interaction:Interactions)
	{
		return switch(interaction)
		{
			case Yes: "RIGHT-BTN";
			case No: "LEFT-BTN";
			case Mid: "MID-BTN";
			default: "MID-BTN";
		}
	}
	function getItInEnglsh(i:Snapshot):String
	{
		Main.tongue.initialize("en-GB");
		var s = "";
		var interaction = switch(i.interaction){
			case Yes: "RIGHT-BTN";
			case No: "LEFT-BTN";
			case Next: "MID-BTN";
			default: "MID-BTN";
		};
		var interactionEN = Main.tongue.get("$" + i.processName + "_" + interaction, "data");
		if (interactionEN == "" || interactionEN == null || interactionEN.indexOf("$") == 0)
		{
			interactionEN = Main.tongue.get("$defaultBtn_" + switch(i.interaction){
			case Yes: "UI3";
			case No: "UI1";
			case Next: "UI2";
			default: "UI2";
		}, "meta");
		}	
		
		s += Main.tongue.get("$" + i.processName + "_TITLE", "data") + " : " + interactionEN;
		#if debug
		Main.tongue.initialize("fr-FR");
		#else
		Main.tongue.initialize(MainApp.agent.mainLanguage);
		#end
		return s;
	}
	public static function stripTags(s:String):String
	{
		s = StringTools.replace(s, "<B>", " ");
		s = StringTools.replace(s, "<b>", " ");
		s = StringTools.replace(s, "<N>", " ");
		s = StringTools.replace(s, "<T>", " ");
		s = StringTools.replace(s, "<EM>", " ");
		s = StringTools.replace(s, "<em>", " ");
		s = StringTools.replace(s, "\t", " ");
		s = StringTools.replace(s, "\n", " ");
		return s;
	}
	function get_successSignal():FlxTypedSignal<Result->Void>
	{
		return successSignal;
	}
	
	function set_successSignal(value:FlxTypedSignal<Result->Void>):FlxTypedSignal<Result->Void> 
	{
		return successSignal = value;
	}

	function get_statusSignal():flixel.util.FlxSignal.FlxTypedSignal<Int->Void>
	{
		return statusSignal;
	}
	
	function set_statusSignal(value:FlxTypedSignal<Int->Void>):FlxTypedSignal<Int->Void> 
	{
		return statusSignal = value;
	}

	function get_errorSignal():flixel.util.FlxSignal.FlxTypedSignal<Dynamic->Void>
	{
		return errorSignal;
	}
	
	function set_errorSignal(value:FlxTypedSignal<Dynamic->Void>):FlxTypedSignal<Dynamic->Void> 
	{
		return errorSignal = value;
	}

	function set__currentProcess(value:Process):Process
	{
		return _currentProcess = value;
	}

}
