package tstool.utils;

import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.Exception;
import haxe.Http;
import haxe.Json;
import tstool.salt.SOTickets;

/**
 * ...
 * @author bb
 */
class XapiTracker
{
	var u:Http;
	public var dispatcher(get, null):FlxTypedSignal<Bool->Void>;

	public function new() 
	{
		dispatcher = new FlxTypedSignal<Bool->Void>();
		u = new Http(Main.LOCATION.origin + Main.LOCATION.pathname+ "php/xapi/index.php");
		u.async = true;
		u.onData = onData;
		//u.onError = onError;
		//u.onStatus = onStatus;
	}
	
	function onData(data:String) 
	{
		//trace(data);
		try{
		var d = Json.parse(data);
		if (d.status == "success") 
		{
			//data.indexOf("success")>-1)
			var s:Array<String> = cast d.statementsIds;
			setStatementRef(s[0]);
			dispatcher.dispatch(true);
		}
		else{
			dispatcher.dispatch(false);
		}
		}
		catch (e:Exception)
		{
			trace(e);
			trace(data);
		}
	}
	public function setActor()
	{
		u.setParameter("mbox", Main.user.iri);
		u.setParameter("name", Main.user.sAMAccountName);
	}
	public function setCustomer()
	{
		u.setParameter("contractor", Main.customer.iri);
		u.setParameter("voip", Main.customer.voIP);
	}
	public function setCase( soTicket:SOTickets)
	{
		//setVerb("submitted");
		u.setParameter("case", soTicket.domain + "_" + soTicket.number );
	}
	public function setResolution()
	{
		//setVerb("resolved");
		u.setParameter("steps", Json.stringify( Main.HISTORY.getRawSteps()) );
	}
	public function setActivity(object:String)
	{
		u.setParameter("activity", object.indexOf("http")==0? object: Main.LOCATION.origin + Main.LOCATION.pathname + object);
	}
	public function setVerb(did:String)
	{
		u.setParameter("verb", did);
	}
	public function setStatementRef(id:String)
	{
		u.setParameter("statement", id);
	}
	
	function get_dispatcher():FlxTypedSignal<Bool->Void> 
	{
		return dispatcher;
	}
	
	public function send()
	{
		//trace(u);
		//trace("statementSent");
		u.request(true);
	}
	
}
//if(!params.exists("mbox")) params.set("mbox","bruno.baudry@salt.ch");
//if(!params.exists("name"))params.set("name", "bbaudry");
//if(!params.exists("verb"))params.set("verb", "resolved");
//if(!params.exists("activity"))params.set("activity", "https://qook.test.salt.ch/trouble");
//if(!params.exists("contractor"))params.set("contractor", "31234567");
//if(!params.exists("voip"))params.set("voip", "0234567891");
//if(!params.exists("case"))params.set("case","FIX_521");
//var tab = ['flow.nointernet.GetContractorVTI', 'flow.saltv.cannontCNX'];
//if(!params.exists("steps")) params.set("steps", Json.stringify(tab));