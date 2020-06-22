package tstool.utils;
import tstool.layout.History;
import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.Http;
import haxe.Json;
import js.Browser;
import tstool.layout.History.Snapshot;
import tstool.process.Process;
import Main;
import salt.SOTickets;
/**
 * ...
 * @author bbaudry
 */
enum Parameters
{
	subject;
	from_email;
	from_full_name;
	to_email;
	to_full_name;
	cc_email;
	cc_full_name;
	bcc_email;
	bcc_full_name;
	body;
}
typedef Result =
{
	var status:String;
	var error:String;
	var additional:String;
}
typedef MailReciepient =
{
	var to:String;
	var fullName:String;
}
class Mail
{
	var http:Http;
	var _mailSubject:String;
	//var _queue:String;
	var _ticket:SOTickets;
	var _currentProcess(default, set):Process;
	public var successSignal(get, null):FlxTypedSignal<Result->Void>;
	public var statusSignal(get, null):FlxTypedSignal<Int->Void>;
	public var errorSignal(get, null):FlxTypedSignal<Dynamic->Void>;

	@:isVar public var params(get, set):haxe.ds.Map<Parameters,Dynamic>;

	public function new(ticket:SOTickets, currentProcess:Process)
	{
		_ticket = ticket;

		//_mailSubject = ticket.desc;
		_currentProcess = currentProcess;
		successSignal = new FlxTypedSignal<Result->Void>();
		statusSignal = new FlxTypedSignal<Int->Void>();
		errorSignal = new FlxTypedSignal<Dynamic->Void>();
		//params = new Map<Parameters,String>();
		params = new Map<Parameters,Dynamic>();
		setStyle();
		
		#if debug
		//params.set(to_email, "superofficetest@salt.ch"); // Test on cs-sit.test
		params.set(to_email, "bruno.baudry@salt.ch");

		//params.set(to_email, ticket.email); // Test on SO prod cs.salt.ch
		#else
		if (Main.DEBUG)
		{
			params.set(to_email, "bruno.baudry@salt.ch");
		}
		else
		{
			params.set(to_email, ticket.email);
			params.set(cc_email, '${Main.user.iri}');
			params.set(bcc_email, "qook@salt.ch");
		}
		
		//params.set(bcc_full_name, "qook");
		#end
		//params.set(subject, '[${Main.customer.iri}] $mailSubject' );


		http = new Http(Browser.location.origin + Browser.location.pathname+ "php/mail/index.php" );
		http.async = true;
		http.onData = onData;
		http.onError = onError;
		http.onStatus = onStatus;
		//trace(Browser.location.origin + Browser.location.pathname+ "php/mail/index.php" );
	}
	function setStyle()
	{
		var b = '<style type="text/css">';
		b += 'table {border-collapse: collapse;}';
		b += '@font-face {font-family: "Superior"; src: url("http://intranet.salt.ch/static/fonts/superior/SuperiorTitle-Black.woff") format("woff"); font-weight: normal;}';
		b += '@font-face {font-family: "Univers"; src: url("http://intranet.salt.ch/static/fonts/univers/ecf89914-1896-43f6-a0a0-fe733d1db6e7.woff") format("woff"); font-weight: normal;}';
		b += 'h3,h4,h5,h5 {color: #65a63c;}';
		b += 'body, table, td, li, span, h3,h4,h5,h5  {font-family: "Univers", Arial, Helvetica, sans-serif !important;}';
		b += 'h2{color: #000000; font-family: "Superior" !important;}';
		b += 'li{font-size: 11pt !important; padding-top:8px !important;  margin-top:8px !important;}';
		b += 'li em{font-size: 9pt !important;}';
		b += '</style>';
		//http://intranet.salt.ch/static/fonts/superior/SuperiorTitle-Black.woff
		params.set(body, b);
	}
	function setSubject()
	{
		// test GIT DEV
		var _queue = "";
		#if debug
			//_queue =_ticket.queue + "_EN" ;
			_queue =_ticket.queue + "_"; // Nico change 24.03.2020
		#else
			//_queue =_ticket.queue + "_" + Main.user.mainLanguage.substr(0, 2).toUpperCase(); 
			_queue =_ticket.queue + "_"; // Nico change 25.03.2020
		#end
		_mailSubject = _ticket.domain + "-" + _ticket.number + " " + _ticket.desc;
		params.set(subject, '[${Main.customer.voIP}][$_queue] $_mailSubject' );
	}

	public function send(memo:String= "")
	{
		
		setSubject();
		buildCustomerBody(memo);
		buildHistoryBody();
		buildAgentBody();
		params.set(body, "<body>" + params.get(body) + "</body>" );
		for (key => value in params)
		{
			http.setParameter(Std.string(key), value);
			if (Main.DEBUG) trace(key, value);
		}
		// do not create ticket in training mode
		if (Main.user.canDispach)
		{
			#if debug
			trace("testing");
			trace(params.get(body));
			
			#else
			http.request(true);
			#end
		}
		else
		{
			successSignal.dispatch({status:"success",error:"", additional:"training"});
		}
	}
	function buildCustomerBody(memo:String= "")
	{
		var  b = params.exists(body)?params.get(body):"";
		//var bodyList = "";
		#if debug
		trace(Main.customer);
		#end
		try
		{
			//b += '<h1>$_mailSubject</h1>';
			if (memo != "") b += '<p>$memo</p>';
			b += '<h2>Contractor: ${Main.customer.iri} ';
			b += 'VoIP: ${Main.customer.voIP}';
			b += '</h2>';
			if(Main.customer.contract.owner.name !="")
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
		params.set(body, b);
	}
	function buildAgentBody()
	{
		var  b = params.exists(body)?params.get(body):"";
		var bodyList = "";
		params.set(from_email, Main.user.iri);
		params.set(from_full_name, Main.user.sAMAccountName);
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
		params.set(body, b);

	}
	function buildHistoryBody()
	{
		var  b = params.exists(body)?params.get(body):"";
		var bodyList = "";
		var start:Date = Main.HISTORY.getFirst().start;
		var end:Date = Main.HISTORY.getLast().start;
		var isEnglish = Main.user.mainLanguage == "en-GB";
		for (i in Main.HISTORY.history)
		{
			bodyList += "<li>";
			bodyList += getItInEnglsh(i);
			if (i.values != null) {
				
				bodyList += i.values.toString();
			}
			if(!isEnglish){
				bodyList += "<br/><em>";
				bodyList += '${i.processTitle} : <strong>${i.iteractionTitle}</strong>';
				bodyList += "</em>";
			}
			bodyList += "</li>";
			//bodyList += Main.tongue.get("$"+i.processName + "_TITLE","data") + " : " + Main.tongue.get(i.processName,"data")}:${i.interaction}</li>';
			
		}
		
		bodyList += "<li><strong>"+_currentProcess.question.text +"</strong></li>";
		b += '<h4>Start: ${start.toString()}</h4><ol>$bodyList</ol><h4>End: ${end.toString()}</h4>';
		params.set(body, b);
	}
	
	function getItInEnglsh(i:Snapshot):String
	{
		Main.tongue.init("en-GB");
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
		Main.tongue.init("fr-FR");
		#else
		Main.tongue.init(Main.user.mainLanguage);
		#end
		return s;
	}
	function onStatus(s:Int)
	{
		//trace(s);
		statusSignal.dispatch(s);
	}

	function onError(e:Dynamic):Void
	{
		//trace(e);
		errorSignal.dispatch(e);
	}

	function onData(data:Dynamic)
	{
		//trace(data);
		var s:Result = Json.parse(data);
		successSignal.dispatch(s);
	}

	function get_params():haxe.ds.Map<Parameters, Dynamic>
	{
		return params;
	}

	function get_successSignal():FlxTypedSignal<Result->Void>
	{
		return successSignal;
	}

	function get_statusSignal():flixel.util.FlxSignal.FlxTypedSignal<Int->Void>
	{
		return statusSignal;
	}

	function get_errorSignal():flixel.util.FlxSignal.FlxTypedSignal<Dynamic->Void>
	{
		return errorSignal;
	}

	function set_params(value:haxe.ds.Map<Parameters, Dynamic>):haxe.ds.Map<Parameters, Dynamic>
	{
		return params = value;
	}

	function set__currentProcess(value:Process):Process
	{
		return _currentProcess = value;
	}

}
