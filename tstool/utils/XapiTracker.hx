package tstool.utils;

import haxe.Exception;
import haxe.Http;
import haxe.Json;
import haxe.Serializer;
import http.XapiHelper;
import js.Browser;
import signals.Signal1;
import xapi.Activity;
import xapi.Agent;
import xapi.Context;
import xapi.Statement;
import xapi.Verb;
import xapi.activities.Definition;
import xapi.types.IObject;
//import xapi.types.Score;
import xapi.Result;
import xapi.types.StatementRef;
using StringTools;

/**
 * ...
 * @author bb
 */
class XapiTracker extends XapiHelper
{
	public static inline var VERB_RECIEVED:String = "http://activitystrea.ms/schema/1.0/receive";
	public static inline var VERB_MENTORED:String = "http://id.tincanapi.com/verb/mentored";
	//var map:Map<String, String>;
	//var nullKeys:Array<String>;
	//var canRequest:Bool;
	//var statementsRefs:Array<StatementRef>;
	var statement: xapi.Statement;
	@:isVar public var object(get, set):IObject;
	var verb:Verb;
	var result:xapi.Result;
	var context:Context;
	var _mainDebug:Bool;
	var _start:Float;
	@:isVar var actor(get, set):Agent;
	//public var dispatcher:Signal1<Bool>;
	public function new(url:String)
	{
		super(url + "xapi-new/index.php");
		#if debug
		trace('tstool.utils.XapiHelper::XapiHelper::url', this.url);
		#end
		_mainDebug = Browser.location.origin.indexOf("salt.ch") > -1;
		//this.async = true;
		//Serializer.USE_CACHE = true;
		//Serializer.USE_ENUM_INDEX = true;
		//serializer = new Serializer();
		//statementsRefs = [];
		statement = null;
		actor = null;
		object = null;
		verb = null;
		context = null;
		result = new xapi.Result();
		//dispatcher = new Signal1<Bool>();
		_start = Date.now().getTime();
		//map = new Map<String,String>();
		// minimal statement needs
		//map.set("mbox", "");
		//map.set("activity", "");
		//map.set("verb", "");
		//canRequest = true;
		this.onData = onMyData;
	}
	override public function reset(?referenceLast:Bool=false)
	{
		if (!referenceLast){
			statementsRefs = [];
			_start = Date.now().getTime();
		}
		else{
			
		}
		statement = null;
		actor = null;
		object = null;
		verb = null;
		context = null;
		
	}
	public function validateBeforeSending()
	{
		if (actor == null || object == null || verb == null) return false;
		return true;
	}
	public function setActor( agent:Agent)
	{
		actor = agent;
	}
	public function setActivityObject(objectID:String, ?name:Map<String,String>=null, ?description:Map<String,String>=null, ?type:String="", ?extensions:Map<String,Dynamic>=null,?moreInfo:String="")
	{
		var def:Definition = null;
		if (type != "" || moreInfo != "" || extensions != null || name != null || description != null)
		{
			def = new Definition();
			if (type != "")
			{
				def.type = type;
			}
			if (moreInfo != "")
			{
				def.type = type;
			}
			if (extensions != null)
			{
				def.extensions = extensions;
			}
			if (description != null)
			{
				def.description = description;
			}
			if (name != null)
			{
				def.name = name;
			}
		}

		object = new Activity(Browser.location.origin + Browser.location.pathname + objectID, def);

		//map.set("activity", object.indexOf("http")==0? object: Browser.location.origin + Browser.location.pathname + object);
	}
	public function setAgentObject(agent:Agent)
	{
		object = agent;
	}
	public function setVerb(did:Verb)
	{
		//verb = new Verb(did.id);
		verb = did;
	}
	/*
	public function setResult(
		?scoreScaled:Float,
		?extensions:Map<String,Dynamic>,
		?success:Bool,
		?completion:Bool,
		?response:String,
		?duration:Float)
	{
		result = new Result(
			scoreScaled == null ? scoreScaled : new Score(scoreScaled * 100),
			success,
			completion,
			null,
			duration,
			extensions
		);
	}*/
	/**/
	public function setDefaultContext(locale:String, instructor:String)
	{
		setContext(
			new Agent(instructor), 
			Browser.location.protocol + Browser.location.hostname + Browser.location.pathname,
			"trouble", 
			locale, 
			null
			);
	}
	
	public function setContext(instructor:Agent, parentActivity:String, platform:String, language:String, extensions:Map<String,Dynamic>)
	{

		context = new Context(
			null, 
			instructor, 
			null,
			null, 
			null, 
			platform, 
			language, 
			statementsRefs.length > 0?statementsRefs[statementsRefs.length - 1]:null, 
			extensions
			);
			if (parentActivity != null)
				context.addContextActivity(parent, new Activity(parentActivity));
	}
	public function updateStatementRef()
	{
		context.statement = statementsRefs.length > 0?statementsRefs[statementsRefs.length - 1]:null;
	}
	/**/
	/*public function setStatementRefs(statementRef:StatementRef)
	{
		statementsRefs = [statementRef];
	}
	public function addStatementRef(id:StatementRef)
	{
		statementsRefs.push(id);
	}
	public function getStatementRef():Array<StatementRef>
	{
		return statementsRefs;
	}
	public function getLastStatementRef():StatementRef
	{
		return statementsRefs[statementsRefs.length -1];
	}*/
	public function send()
	{
		//prepareParams();
		try
		{
			this.result.toISO8601Duration( Date.now().getTime() - _start );
            statement = new Statement(actor, verb, object, result, context);
			sendMany([statement]);
			//sendSignle(statement);
			#if debug
			
			//var serialized = Serializer.run(statement);
			//trace(statement);
			//trace(serialized);
			/*if (_mainDebug)
			{
				this.setParameter("statement", serialized);
				this.request(true);
			}
			else
			{
				//trace(serialized);
				onMyData(Json.stringify({status:"success", statementsIds:["24b31561-6138-4dbc-995e-d725b8b39dda"]}));
			}*/

			#else
			//statement = new Statement(actor, verb, object, result, context);
			//var serialized = Serializer.run(cast statement);
			
			/*this.setParameter("statement", Serializer.run(statement));
			this.request(true);
			*/
			#end
		}
		catch (e:Exception)
		{
			#if debug
			trace(e.message);
			trace(e.stack);
			trace(e.details());
			#end
		}

	}

	/*function onMyData(data:String)
	{
		//trace(data);
		try
		{
			var d = Json.parse(data);
			#if debug
			trace(d);
			#end
			if (d.status == "success")
			{
				//data.indexOf("success")>-1)
				statementsRefs.push(new StatementRef(d.statementsIds[0]));
				//setStatementRef(statementsRef[0]);
				dispatcher.dispatch(true);
			}
			else
			{
				dispatcher.dispatch(false);
			}
		}
		catch (e:Exception)
		{
			//trace(e);
			//trace(data);
			dispatcher.dispatch(false);
		}
	}*/

	function get_actor():xapi.Agent
	{
		return actor;
	}

	function set_actor(value:xapi.Agent):xapi.Agent
	{
		return actor = value;
	}

	function get_object():IObject
	{
		return object;
	}

	function set_object(value:IObject):IObject
	{
		return object = value;
	}

}