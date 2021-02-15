package tstool.salt;

import tstool.layout.History.Interactions;
import tstool.layout.History.Snapshot;
import tstool.process.Process;
import tstool.utils.Mail;

/**
 * ...
 * @author bb
 */
class TicketMail extends Mail 
{
	var _ticket:SOTickets;
	var _currentProcess(default, set):Process;
	var resolved:Bool;
	public function new(ticket:SOTickets, currentProcess:Process, ?resolved:Bool=false) 
	{
		super();
		this._ticket = ticket;
		this.resolved = resolved;
		this._currentProcess = currentProcess;
		setReciepients(_ticket.email);
		setTicketSubject();
	}
	/**
	 * called by embeder
	 * @param	body
	 */
	override function setBody(memo:String) 
	{
		var mailBody = memo;
		mailBody += Main.customer.buildCustomerBody( memo.indexOf( Main.customer.contract.mobile ) >-1);
		mailBody += Main.HISTORY.buildHistoryEmailBody(MainApp.agent.mainLanguage, _currentProcess);
		mailBody += MainApp.agent.buildEmailBody( Main.HISTORY.getFirst().start, Main.HISTORY.getLast().start);
		super.setBody(mailBody);
	}
	function setTicketSubject()
	{
		var isResolved = resolved?"[RESOLVED]":"";	
		var _queue =_ticket.queue + "_"; // Nico change 25.03.2020
		var _mailSubject = _ticket.domain + "-" + _ticket.number + " " + _ticket.desc;
		
		var s = '[${Main.customer.iri}][$_queue][${MainApp.agent.sAMAccountName}]$isResolved $_mailSubject' ;
		setSubject(s);
	}
	
	/**
	 * 
	 * @param	s
	 */
	//function buildCustomerBody(memo:String= "")
	//{
		//var  b = "";
		//#if debug
			//trace(Main.customer);
		//#end
		//try
		//{
			//b += "<p>"+ (memo == ""? "No memo written by agent" : memo) + "</p>";
			//b += '<h2>';
			//if(Main.customer.contract.contractorID != null && Main.customer.contract.contractorID != "" && Main.customer.contract.contractorID != Customer.TEST_IRI)
				//b += 'ID: ${Main.customer.contract.contractorID}<br/>';
			//else{
				//b += 'ID: ${Main.customer.iri}<br/>';
			//}
			//if(Main.customer.voIP !="")
				//b += 'MSISDN-VoIP: ${Main.customer.voIP}<br/>';
			//b += '</h2>';
			//if(Main.customer.contract.mobile !="" && memo.indexOf(Main.customer.contract.mobile)==-1 )
				//b += '<h3>CONTACT: ${Main.customer.contract.mobile}</h3>';
			//b += "<p>";
			//if(Main.customer.contract.owner != null && Main.customer.contract.owner.name !="")
				//b += '${Main.customer.contract.owner.name}<br/>';
			//if (Main.customer.shipingAdress != null && Main.customer.shipingAdress._zip != "")
			//{
				//if (Main.customer.shipingAdress._co != "")
				//{
					//b += 'c/o: ${Main.customer.shipingAdress._co}<br/>';
				//}
				//b += '${Main.customer.shipingAdress._street}, ${Main.customer.shipingAdress._number}<br/>';
				//b += '<strong>${Main.customer.shipingAdress._zip}</strong> ${Main.customer.shipingAdress._city}';	
			//}
			//b += "</p>";
		//}
		//catch (e:Dynamic)
		//{
			//trace(e);
		//}
		//return b;
	//}
	/**
	 * @param	s
	 */
	//function buildAgentBody()
	//{
		//var start:Date = Main.HISTORY.getFirst().start;
		//var end:Date = Main.HISTORY.getLast().start;
		//var seconds = Math.floor( (end.getTime() - start.getTime()) / 1000 );
		//var durationMinutes = Math.floor (seconds / 60);
		//var durationSeconds = seconds % 60;
		//var bodyList = '<li>Agent: ${MainApp.agent.firstName} ${MainApp.agent.sirName} (${MainApp.agent.sAMAccountName}) ${MainApp.agent.title}</li>';
		//bodyList += '<li>${MainApp.agent.company} | ${MainApp.agent.department} | ${MainApp.agent.division} | ${MainApp.agent.workLocation} </li>';
		//bodyList += '<li>Script version : ${Main.VERSION} </li>';
		//bodyList += '<li>Started: ${start.toString()}, ended: ${end.toString()} ( ~ ' + durationMinutes + "'" + durationSeconds + "''" + " )</li>";
		//return '<h5>Troubleshot in ${MainApp.agent.mainLanguage} by:</h5><ul>$bodyList</ul>';
	//}
	/**
	 * 
	 * @param	s
	 */
	/*function buildHistoryBody( currentLang:String )
	{
		var lang = currentLang;
		var  b = "";
		#if debug
			trace("tstool.utils.Mail::buildHistoryBody::MainApp.agent.mainLanguage", lang );
		#end
		var needsEnTranslation = lang != "en-GB";
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
		
		b += '<h4>Steps:</h4>';
		b += '<ol>${listSteps(steps)}</ol>';
		if (needsEnTranslation)
		{
			b += "<h4>English:</h4>";
			Main.tongue.initialize( "en-GB" );
			b += '<ol>${listSteps(steps)}</ol>';
			#if debug
				Main.tongue.initialize(Main.LANGS[0]);
			#else
			Main.tongue.initialize(lang);
			#end
		}
		return b;
	}*/
	/**
	 * 
	 * @param	s
	 */
	//static inline function listSteps(stepsArray:Array<Snapshot>):String
	//{
		//var s = "";
		//
		//var title ="";
		//var values = "";
		//var interaction = "";
		//if (stepsArray == null) return "";
//
		//for (h in stepsArray)
		//{
			//title = Mail.stripTags(Main.tongue.get("$" + h.processName + "_TITLE", "data"));
			//interaction = h.interaction == Next ? "" : '... <strong>${getDefaultOrCutomChoice( h.processName, h.interaction)}</strong>';
			//values = h.values == null ? "" : formatMapToHtml(h.values);
			//if (interaction == "") s += '<li>$title $values</li>';
			//else if (values == "" ) s += '<li>$title $interaction</li>';
			//else s +='<li>$title $values $interaction</li>';
			//
		//}
		//return s;
	//}
	/**
	 * 
	 * @param	s
	 */
	//public static inline function getDefaultOrCutomChoice( process:String, interaction:Interactions): String
	//{
		//var choice = Main.tongue.get("$" + process + "_" + getCustomInteractionTranslationHeader(interaction), "data");
		//if (choice == "" || choice == null || choice.indexOf("$") == 0)
		//{
			//choice = Main.tongue.get("$defaultBtn_" + getDefaultInteractionTranslationHeader(interaction), "meta");
		//}
		//return choice;
	//}
	///**
	 //* 
	 //* @param	s
	 //*/
	//static inline function getDefaultInteractionTranslationHeader( interaction:Interactions)
	//{
		//return switch(interaction)
		//{
			//case Yes: "UI3";
			//case No: "UI1";
			//case Mid: "UI2";
			//default: "UI2";
		//}
	//}
	///**
	 //* 
	 //* @param	s
	 //*/
	//static inline function getCustomInteractionTranslationHeader( interaction:Interactions)
	//{
		//return switch(interaction)
		//{
			//case Yes: "RIGHT-BTN";
			//case No: "LEFT-BTN";
			//case Mid: "MID-BTN";
			//default: "MID-BTN";
		//}
	//}
	/**
	 * 
	 * @param	s
	 */
	//function getItInEnglsh(i:Snapshot):String
	//{
		//Main.tongue.initialize("en-GB");
		//var s = "";
		//var interaction = switch(i.interaction){
			//case Yes: "RIGHT-BTN";
			//case No: "LEFT-BTN";
			//case Next: "MID-BTN";
			//default: "MID-BTN";
		//};
		//var interactionEN = Main.tongue.get("$" + i.processName + "_" + interaction, "data");
		//if (interactionEN == "" || interactionEN == null || interactionEN.indexOf("$") == 0)
		//{
			//interactionEN = Main.tongue.get("$defaultBtn_" + switch(i.interaction){
			//case Yes: "UI3";
			//case No: "UI1";
			//case Next: "UI2";
			//default: "UI2";
		//}, "meta");
		//}	
		//
		//s += Main.tongue.get("$" + i.processName + "_TITLE", "data") + " : " + interactionEN;
		//#if debug
		//Main.tongue.initialize("fr-FR");
		//#else
		//Main.tongue.initialize(MainApp.agent.mainLanguage);
		//#end
		//return s;
	//}
	/**
	 * 
	 * @param	s
	 */
	//static inline public function formatMapToHtml( map :Map<String, Dynamic>):String
	//{
		//var out = "";
		//for ( title => value in map)
		//{
			//if (StringTools.trim(value) != "" ) out += '<li>$title ... <strong>$value</strong></li>';
		//}
		//return out ==""?"":'<ul>$out</ul>';
	//}
	
	function set__currentProcess(value:Process):Process 
	{
		return _currentProcess = value;
	}
	
}
