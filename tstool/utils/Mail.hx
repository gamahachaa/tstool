package tstool.utils;
import Main;
import tstool.utils.SwiftMailWrapper.Result;

import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.Json;
import js.Browser;
import tstool.layout.History.Snapshot;
import tstool.process.Process;
import tstool.salt.SOTickets;
/**
 * ...
 * @author bbaudry
 */
//enum Parameters
//{
	//subject;
	//from_email;
	//from_full_name;
	//to_email;
	//to_full_name;
	//cc_email;
	//cc_full_name;
	//bcc_email;
	//bcc_full_name;
	//body;
//}
//typedef Result =
//{
	//var status:String;
	//var error:String;
	//var additional:String;
//}
//typedef MailReciepient =
//{
	//var to:String;
	//var fullName:String;
//}
class Mail
{
	//var http:Http;
	var _mailSubject:String;
	//var _queue:String;
	var _ticket:SOTickets;
	var mailWrapper:tstool.utils.SwiftMailWrapper;
	var _currentProcess(default, set):Process;
	var _mailBody:String;
	@:isVar public var successSignal(get, set):FlxTypedSignal<Result->Void>;
	@:isVar public var statusSignal(get, set):FlxTypedSignal<Int->Void>;
	@:isVar public var errorSignal(get, set):FlxTypedSignal<Dynamic->Void>;
	static inline var PHP_MAIL_PATH:String = Main.LIB_FOLDER + "php/mail/index.php";
	var resolved:Bool;

	//@:isVar public var params(get, set):haxe.ds.Map<Parameters,Dynamic>;

	public function new(ticket:SOTickets, currentProcess:Process, ?resolved:Bool= false)
	{
		_ticket = ticket;
		this.resolved = resolved;
		//_mailSubject = ticket.desc;
		_currentProcess = currentProcess;
		mailWrapper = new SwiftMailWrapper(Browser.location.origin + Browser.location.pathname + PHP_MAIL_PATH);
		_mailBody = mailWrapper.setCommonStyle();
		successSignal = mailWrapper.successSignal;
		statusSignal = mailWrapper.statusSignal;
		errorSignal = mailWrapper.errorSignal;
		//params = new Map<Parameters,String>();
		//params = new Map<Parameters,Dynamic>();
		//setStyle();
		
		#if debug
		//params.set(to_email, "superofficetest@salt.ch"); // Test on cs-sit.test
		if (!Main.DEBUG)
		{
			mailWrapper.setTo(["bruno.baudry@salt.ch"]);
		}
		else{
			mailWrapper.setTo(["superofficetest@salt.ch"]);
		}
		
		mailWrapper.setCc(['${Main.user.iri}']);
		mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
		//mailWrapper.setTo(["superofficetest@salt.ch"]);
		//mailWrapper.setCc(['${Main.user.iri}']);
		//mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
		//params.set(to_email, "bruno.baudry@salt.ch");
		
		//params.set(to_email, ticket.email); // Test on SO prod cs.salt.ch
		#else
		if (Main.DEBUG)
		{
			
			//mailWrapper.setTo(["bruno.baudry@salt.ch"]);
			mailWrapper.setTo(["superofficetest@salt.ch"]);
			mailWrapper.setCc(['${Main.user.iri}']);
			mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
			//mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
		}
		else
		{
			//params.set(to_email, ticket.email);
			mailWrapper.setTo([ticket.email]);
			
			//params.set(cc_email, '${Main.user.iri}');
			mailWrapper.setCc(['${Main.user.iri}']);
			//params.set(bcc_email, "qook@salt.ch");
			mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
		}
		
		//params.set(bcc_full_name, "qook");
		#end

	}

	function setSubject()
	{
		// test GIT DEV
		var _queue = "";
		var isResolved = resolved?"[RESOLVED]":"";
		
		
		#if debug
			//_queue =_ticket.queue + "_EN" ;
			_queue =_ticket.queue + "_"; // Nico change 24.03.2020
		#else
			//_queue =_ticket.queue + "_" + Main.user.mainLanguage.substr(0, 2).toUpperCase(); 
			_queue =_ticket.queue + "_"; // Nico change 25.03.2020
		#end
		_mailSubject = _ticket.domain + "-" + _ticket.number + " " + _ticket.desc;
		
		//params.set(subject, '[${Main.customer.voIP}][$_queue] $_mailSubject' );
		if(Main.DEBUG)
			//mailWrapper.setSubject('[${Main.customer.voIP}][$_queue][${Main.user.sAMAccountName}] $_mailSubject' );
			mailWrapper.setSubject('[${Main.customer.voIP}][$_queue][${Main.user.sAMAccountName}]$isResolved $_mailSubject' );
		else
			mailWrapper.setSubject('[${Main.customer.voIP}][$_queue][${Main.user.sAMAccountName}]$isResolved $_mailSubject' );
	}

	public function send(memo:String= "")
	{
		setSubject();
		buildCustomerBody(memo);
		buildHistoryBody();
		buildAgentBody();
		//params.set(body, "<body>" + params.get(body) + "</body>" );
		mailWrapper.setBody("<body>" + _mailBody + "</body>" );

		#if debug
		if (Main.DEBUG)
			mailWrapper.send(Main.user.canDispach);
		else
			trace("<body>" + _mailBody + "</body>");
		
		#else
			mailWrapper.send(Main.user.canDispach);
		#end
		
	}
	function buildCustomerBody(memo:String= "")
	{
		//var  b = params.exists(body)?params.get(body):"";
		var  b = _mailBody;
		//var bodyList = "";
		#if debug
		trace(Main.customer);
		#end
		try
		{
			//b += '<h1>$_mailSubject</h1>';
			if (memo != "") b += '<p>$memo</p>';
			b += '<h2>';
			if(Main.customer.iri !="" || Main.customer.iri != "not found")
				b += 'ID: ${Main.customer.iri} ';
			if(Main.customer.voIP !="")
				b += 'MSISDN: ${Main.customer.voIP}';
			if(Main.customer.contract.mobile !="")
				b += 'CONTACT: ${Main.customer.contract.mobile}';
			b += '</h2>';
			if(Main.customer.contract.owner != null && Main.customer.contract.owner.name !="")
				b += '<h3>${Main.customer.contract.owner.name}</h3>';
			
			if (Main.customer.shipingAdress != null && Main.customer.shipingAdress._zip != "")
			{
				//b += "<h4>Adress :</h4>";
				b += "<p>";
				if (Main.customer.shipingAdress._co != "")
				{
					b += 'c/o: ${Main.customer.shipingAdress._co}<br/>';
				}
				b += '${Main.customer.shipingAdress._street}, ${Main.customer.shipingAdress._number}<br/>';
				b += '<strong>${Main.customer.shipingAdress._zip}</strong> ${Main.customer.shipingAdress._city}';
				b += "</p>";
			}
		}
		catch (e:Dynamic)
		{
			trace(e);
		}
		//params.set(body, b);
		_mailBody = b;
	}
	function buildAgentBody()
	{
		//var  b = params.exists(body)?params.get(body):"";
		var  b = _mailBody;
		var bodyList = "";
		mailWrapper.setFrom(Main.user.iri, Main.user.sAMAccountName);
		//params.set(from_email, );
		//params.set(from_full_name, );
		//Main.user.firstName;
		#if debug
		trace(Main.user);
		#end
		bodyList += '<li>Agent: ${Main.user.firstName} ${Main.user.sirName} (${Main.user.sAMAccountName}) ${Main.user.title}</li>';
		//bodyList += '<li>NT: </li>';
		//bodyList += '<li>: ${Main.user.mobile} </li>';
		bodyList += '<li>${Main.user.company} | ${Main.user.department} | ${Main.user.division} | ${Main.user.workLocation} </li>';
		bodyList += '<li>Script version : ${Main.VERSION} </li>';
		if (Main.customer.contract.owner == null){
			var userAgent = Browser.navigator.userAgent;
			bodyList += '<li>a1a3e0cc-c512-4935-9ca1-0ca2746a0fa2</li>';
			bodyList += '<li>$userAgent</li>';
		}

		b += '<h5>Troubleshot in ${Main.user.mainLanguage} by:</h5><ul>$bodyList</ul>';
		//params.set(body, b);
		_mailBody = b;

	}
	function buildHistoryBody()
	{
		//var  b = params.exists(body)?params.get(body):"";
		var  b = _mailBody;
		var bodyList = "";
		var start:Date = Main.HISTORY.getFirst().start;
		var end:Date = Main.HISTORY.getLast().start;
		var isEnglish = Main.user.mainLanguage == "en-GB";
		var histroryArray = Main.HISTORY.getStoredStepsArray();
		var historyList = "";
		var englishLst = "";
		for (h in histroryArray)
		{
			historyList += '<li>${h.step} _ <strong>${h.interaction}</strong> ${h.values}</li>';
			
		}
		historyList += "<li><strong>"+_currentProcess.question.text +"</strong></li>";
		if (!isEnglish)
		{
			/**
			 * @todo String to Class<Process> / isInHistory
			 */

			var englishHistroryArray = Main.HISTORY.getStoredStepsTranslatedArray();
			
		
			for (i in englishHistroryArray)
			{
				
				//englishLst += '<li>${i.step} &rarr; <strong>${i.interaction}</strong> ${i.values}</li>';
				englishLst += '<li>${i.step} _ <strong>${i.interaction}</strong> ${i.values}</li>';
			}
		}

		//bodyList += "<li><strong>"+_currentProcess.question.text +"</strong></li>";
		b += '<h4>Start: ${start.toString()} End: ${end.toString()}</h4>';
		b += '<h4>Steps:</h4>';
		b += '<ol>$historyList</ol>';
		if (!isEnglish)
		{
			b += '<h4>English:</h4>';
			b += '<ol>$englishLst</ol>';
		}
		//params.set(body, b);
		_mailBody = b;
	}
	
	function getItInEnglsh(i:Snapshot):String
	{
		Main.tongue.initialize("en-GB");
		var s = "";
		var interaction = switch(i.interaction){
			case Yes: "RIGHT-BTN";
			case No: "LEFT-BTN";
			case ProcessContructor: "MID-BTN";
			default: "MID-BTN";
		};
		var interactionEN = Main.tongue.get("$" + i.processName + "_" + interaction, "data");
		if (interactionEN == "" || interactionEN == null || interactionEN.indexOf("$") == 0)
		{
			interactionEN = Main.tongue.get("$defaultBtn_" + switch(i.interaction){
			case Yes: "UI3";
			case No: "UI1";
			case ProcessContructor: "UI2";
			default: "UI2";
		}, "meta");
		}	
		
		s += Main.tongue.get("$" + i.processName + "_TITLE", "data") + " : " + interactionEN;
		#if debug
		Main.tongue.initialize("fr-FR");
		#else
		Main.tongue.initialize(Main.user.mainLanguage);
		#end
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
