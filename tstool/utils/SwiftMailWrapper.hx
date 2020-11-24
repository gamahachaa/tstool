package tstool.utils;

import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.Http;
import haxe.Json;

/**
 * ...
 * @author bb
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
class SwiftMailWrapper extends Http 
{
	
	public var successSignal(get, null):FlxTypedSignal<Result->Void>;
	public var statusSignal(get, null):FlxTypedSignal<Int->Void>;
	public var errorSignal(get, null):FlxTypedSignal<Dynamic->Void>;
	var values:haxe.ds.Map<Parameters,Dynamic>;

	public function new(url:String) 
	{
		super(url);
		
		this.async = true;
		successSignal = new FlxTypedSignal<Result->Void>();
		statusSignal = new FlxTypedSignal<Int->Void>();
		errorSignal = new FlxTypedSignal<Dynamic->Void>();
		values = new Map<Parameters,Dynamic>();
		this.onData = ondata;
		this.onError = onerror;
		this.onStatus = onstatus;
	}
	//////////////////////////////////////////////////////////
	public function onerror(msg:String)
	{
		errorSignal.dispatch(msg);
	}
	public function ondata(data:String)
	{
		var s:Result = Json.parse(data);
		#if debug
		trace("tstool.utils.SwiftMailWrapper::ondata::s", s );
		#end
		successSignal.dispatch(s);
	}
	public function onstatus(status:Int)
	{
		#if debug
		trace("tstool.utils.SwiftMailWrapper::onstatus::onstatus", status );
		#end
		statusSignal.dispatch(status);
	}
	public function setFrom(reciepient:String,?fullname:String="")
	{
		values.set(from_email, reciepient);
		if(fullname!="")
			values.set(from_full_name, fullname);
		
	}
	//////////////////// PUBLIC /////////////////////////
	/**
	 * @todo allow multiple (now we are passing an array but then passing only recipient[0])
	 * @param	recipient
	 */
	public function setTo(recipient:Array<String>)
	{
		values.set(to_email, recipient[0]);
	}
/**
	 * @todo allow multiple (now we are passing an array but then passing only recipient[0])
	 * @param	recipient
	 */
	public function setCc(recipient:Array<String>)
	{
		values.set(cc_email, recipient[0]);
	}
/**
	 * @todo allow multiple (now we are passing an array but then passing only recipient[0])
	 * @param	recipient
	 */
	public function setBcc(recipient:Array<String>)
	{
		values.set(bcc_email, recipient[0]);
	}
	public function setBody(content:String)
	{
		values.set(body, content);
	}
	public function setSubject(content:String)
	{
		values.set(subject, content);
	}
	public function setCommonStyle()
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
		//params.set(body, b);
		//params.set(body, b);
		return b;
	}
	public function send(?dispatch:Bool=true)
	{
		for (key => value in values)
		{
			this.setParameter(Std.string(key), value);
			//if (Main.DEBUG) trace(key, value);
		}
		if (dispatch){
			
			#if debug
			trace(values);
			if (Main.DEBUG)
				this.request(true);
			else {
				trace("testing mail : will not send");
			}
			#else
			this.request(true);
			#end
		}
		else
			successSignal.dispatch({status:"success",error:"", additional:"training"});
	}
	///////////////////// GETTTERS //////////////////////
	function get_successSignal():FlxTypedSignal<Result->Void> 
	{
		return successSignal;
	}
	
	function get_statusSignal():FlxTypedSignal<Int->Void> 
	{
		return statusSignal;
	}
	
	
	
	function get_errorSignal():FlxTypedSignal<Dynamic->Void> 
	{
		return errorSignal;
	}
}