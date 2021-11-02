package tstool.utils;
import Main;
import tstool.utils.SwiftMailWrapper.Result;
import flixel.util.FlxSignal.FlxTypedSignal;
import js.Browser;

/**
 * ...
 * @author bbaudry
 */

class Mail
{
	var mailWrapper:tstool.utils.SwiftMailWrapper;
	@:isVar public var successSignal(get, set):FlxTypedSignal<Result->Void>;
	@:isVar public var statusSignal(get, set):FlxTypedSignal<Int->Void>;
	@:isVar public var errorSignal(get, set):FlxTypedSignal<Dynamic->Void>;
	
	//static var PHP_MAIL_PATH:String = "../trouble/php/mail/index.php";
	static var PHP_MAIL_PATH:String = "/commonlibs/mail/index.php";
	
	public function new()
	{
		mailWrapper = new SwiftMailWrapper(Browser.location.origin + PHP_MAIL_PATH);
		successSignal = mailWrapper.successSignal;
		statusSignal = mailWrapper.statusSignal;
		errorSignal = mailWrapper.errorSignal;

	}
	public function build(memo:String)
	{
		setFrom();
		setBody(memo);
	}
	public function send()
	{
		//build();
		#if debug
			trace(mailWrapper.values);
			if (Main.DEBUG) {
				mailWrapper.send(MainApp.agent.canDispach);
			}
			else{
				successSignal.dispatch({status:"success",error:"",additional:""});
			}
		#else
			mailWrapper.send(MainApp.agent.canDispach);
		#end
		
	}
	/**
	 * 
	 */
	function setFrom()
	{
		mailWrapper.setFrom(
			MainApp.agent.iri == null ? "bruno.baudry@salt.ch" : MainApp.agent.iri, 
			MainApp.agent.sAMAccountName == null ? "bbaudry" : MainApp.agent.sAMAccountName
		);
		#if debug
			//trace(MainApp.agent);
		#end
	}
	/**
	 * 
	 */
	function setReciepients(to:String)
	{
		#if debug
			if (!Main.DEBUG)
			{
				mailWrapper.setTo(["bruno.baudry@salt.ch"]);
			}
			else{
				//mailWrapper.setTo(["superofficetest@salt.ch"]);
				mailWrapper.setTo([setSitMail(to)]);
				mailWrapper.setCc(['${MainApp.agent.iri}']);
			}
			mailWrapper.setBcc(["bruno.baudry@salt.ch"]);

		#else
		//mailWrapper.setTo([_ticket.email]);
		mailWrapper.setTo([to]);
		mailWrapper.setCc(['${MainApp.agent.iri}']);
		mailWrapper.setBcc(["bruno.baudry@salt.ch"]);
		#end
	}
	function setSitMail(email:String ):String
	{
		var t = email.split("@");
		t.insert(1, "-sit");
		t.insert(2, "@");
		return t.join("");
	}
	/**
	 * 
	 * @param	s
	 */
	function setSubject(s:String)
	{
		mailWrapper.setSubject( s );
	}
	
	/**
	 * @param	s
	 */
	function setBody(body:String) 
	{
		mailWrapper.setBody( body );
	}
	
	/**
	 * 
	 * @param	s
	 */
	//public static function stripTags(s:String):String
	//{
		//s = StringTools.replace(s, "<B>", " ");
		//s = StringTools.replace(s, "<b>", " ");
		//s = StringTools.replace(s, "<N>", " ");
		//s = StringTools.replace(s, "<T>", " ");
		//s = StringTools.replace(s, "<EM>", " ");
		//s = StringTools.replace(s, "<em>", " ");
		//s = StringTools.replace(s, "\t", " ");
		//s = StringTools.replace(s, "\n", " ");
		//return s;
	//}
	function get_successSignal():FlxTypedSignal<Result->Void>
	{
		return successSignal;
	}
	
	function set_successSignal(value:FlxTypedSignal<Result->Void>):FlxTypedSignal<Result->Void> 
	{
		return successSignal = value;
	}

	function get_statusSignal():FlxTypedSignal<Int->Void>
	{
		return statusSignal;
	}
	
	function set_statusSignal(value:FlxTypedSignal<Int->Void>):FlxTypedSignal<Int->Void> 
	{
		return statusSignal = value;
	}

	function get_errorSignal():FlxTypedSignal<Dynamic->Void>
	{
		return errorSignal;
	}
	
	function set_errorSignal(value:FlxTypedSignal<Dynamic->Void>):FlxTypedSignal<Dynamic->Void> 
	{
		return errorSignal = value;
	}

}
