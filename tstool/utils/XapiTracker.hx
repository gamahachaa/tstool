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
	static inline var PARAM_STATEMENTREF:String = "statement";
	static inline var PARAM_VERB:String = "verb";
	static inline var PARAM_MBOX:String = "mbox";
	static inline var PARAM_NAME:String = "name";
	static inline var PARAM_MSISDN:String = "msisdn";
	static inline var PARAM_CONTRACTOR:String = "contractor";
	static inline var PARAM_VOIP:String = "voip";
	static inline var PARAM_CASE:String = "case";
	static inline var PARAM_TOTAL_STEPS:String = "total_steps";
	static inline var PARAM_VALUES:String = "values";
	static inline var PARAM_STEPS:String = "steps";
	static inline var PARAMS_ACTIVITY:String = "activity";
	static var INITABLE = [PARAM_STATEMENTREF, PARAM_VERB,PARAM_MSISDN, PARAM_CONTRACTOR, PARAM_VOIP, PARAM_CASE, PARAM_TOTAL_STEPS, PARAM_VALUES, PARAM_STEPS, PARAMS_ACTIVITY]; 
	public var dispatcher(get, null):FlxTypedSignal<Bool->Void>;

	public function new(wraperPath:String) 
	{
		dispatcher = new FlxTypedSignal<Bool->Void>();
		u = new Http(wraperPath + "xapi/index.php");
		u.async = true;
		u.onData = onData;
	}
	
	function onData(data:String) 
	{
		#if debug
		if (Main.DEBUG) trace(data);
		#end
		try{
			var d = Json.parse(data);
			if (d.status == "success") 
			{
				//data.indexOf("success")>-1)
				var s:Array<String> = cast d.statementsIds;
				setStatementRef(s[0]);
				setVerb("resolved");
				dispatcher.dispatch(true);
			}
			else{
				setVerb("initialized");
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
		u.setParameter(PARAM_MBOX, MainApp.agent.iri);
		u.setParameter(PARAM_NAME, MainApp.agent.sAMAccountName);
	}
	public function setCustomer(?mobile=false)
	{
		if (mobile)
		{
			u.setParameter(PARAM_MSISDN, Main.customer.iri);
		}
		else{
			u.setParameter(PARAM_CONTRACTOR, Main.customer.contract.contractorID);
			u.setParameter(PARAM_VOIP, Main.customer.voIP);
		}
	}
	public function setCase( soTicket:SOTickets )
	{
		//setVerb("submitted");
		u.setParameter(PARAM_CASE, soTicket.domain + "_" + soTicket.number );
	}
	public function setResolution()
	{
		//setVerb("resolved");
		var steps = "";
		var step = "";
		var interaction = "";
		var values = "";
		/**
		 * @todo String to Class<Process> / isInHistory
		 */
		
		var h = Main.HISTORY.getStoredStepsTranslatedArray();
		for (i in h)
		{
			step = StringTools.replace(i.step, "\n", " ");
			interaction = StringTools.replace(i.interaction, "\n", " ");
			step = StringTools.replace(i.step, "\r", " ");
			interaction = StringTools.replace(i.interaction, "\r", " ");
			steps += '$step|$interaction£';
		}
		for (j in h)
		{
			if(j.values != "") values += '${j.values}|';
		}
		u.setParameter(PARAM_TOTAL_STEPS,  Std.string(h.length) );
		u.setParameter(PARAM_VALUES, values );
		u.setParameter(PARAM_STEPS,  steps);
	}
	function init(?filter:Array<String>)
	{
		for (i  in INITABLE)
		{
			if( filter.indexOf(i) == -1) u.setParameter(i, null);
		}
	}
	public function initKeepActor()
	{
		init([PARAM_MBOX,PARAM_NAME]);
	}
	public function initKeepActorAndStatementRef()
	{
		init([PARAM_MBOX,PARAM_NAME, PARAM_STATEMENTREF]);
	}
	public function setActivity(object:String)
	{
		u.setParameter(PARAMS_ACTIVITY, object.indexOf("http")==0? object: MainApp.location.origin + MainApp.location.pathname + object);
	}
	public function setVerb(did:String)
	{
		u.setParameter(PARAM_VERB, did);
	}
	public function setStatementRef(id:String)
	{
		u.setParameter(PARAM_STATEMENTREF, id);
	}
	/*
	public function sendInitial(activity:String)
	{
		Main.track.initKeepActor();
		Main.track.setVerb("initialized");
		Main.track.setStatementRef(null);
		Main.track.setCustomer(true);
		Main.track.setActivity( activity);
        Main.track.send();
		Main.track.setVerb("resolved");
	}
	  */
	function get_dispatcher():FlxTypedSignal<Bool->Void> 
	{
		return dispatcher;
	}
	
	public function send()
	{
		//trace(u);
		//trace("statementSent");
		#if !debug
		u.request(true);
		#else
		if (Main.DEBUG) u.request(true);
		else{
			onData("{'status':'success'}");
		}
		#end
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