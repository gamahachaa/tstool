package tstool.layout;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import haxe.Exception;
//import flow.Intro;
//import flow.TutoTree;
//import openfl.text.TextField;
//import openfl.text.TextFieldType;

//import flow.TutoTree;
import haxe.Http;
import haxe.Json;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import js.Browser;
import js.html.ClipboardEvent;
import js.html.Event;
import js.html.Permissions;
import lime.system.Clipboard;
import tstool.salt.Agent;

//@:bitmap("assets/images/CustomPreload/default.png") class LogoImage extends BitmapData { }
/**
 * ...
 * @author bbaudry
 */

class Login extends FlxState
{
	//var location:js.html.Location;
	//var username: flixel.addons.ui.FlxUIInputText;
	var username: openfl.text.TextField;
	//var pwd:flixel.addons.ui.FlxUIInputText;
	var pwd: openfl.text.TextField;
	var _padding:Int = 20;
	static inline var lang:String = "en-GB";
	var logo:FlxSprite;
	var loginTxt:flixel.text.FlxText;
	var pwdTxt:flixel.text.FlxText;
	var pwdTxtInfo:flixel.text.FlxText;
	var _focused: openfl.display.InteractiveObject;
	var loginUrl:haxe.Http;
	var markerFormat:FlxTextFormatMarkerPair;
	var dummyAgent:tstool.salt.Agent;
	override public function create()
	{
		super.create();
		dummyAgent = cretaDummyAgent();
		//new Agent();
		
		loginUrl = new Http(Main.LOCATION.origin + Main.LOCATION.pathname + Main.LIB_FOLDER + "php/login/index.php" );
		Main.setUpSystemDefault(false);
		//lang =  // default
		//trace(Main.COOKIE);
		if (Main.COOKIE.data.user != null)
		{

			Main.user = Main.COOKIE.data.user;
			#if debug
			trace(Main.user.mainLanguage);
			#end
			//if (Main.user.mainLanguage == null || Main.user.mainLanguage == "")
			//{
				//Main.user.mainLanguage = lang;
			//}
			flushCookie();
			Main.MOVE_ON(true); // launch APPbbaudry
		}
		else
		{
			var textFieldFormat = new openfl.text.TextFormat( lime.utils.Assets.getFont("assets/fonts/Lato-Regular.ttf").name, 12, 0);
			var testFormat:FlxTextFormat = new FlxTextFormat(SaltColor.ORANGE, true);
			markerFormat = new FlxTextFormatMarkerPair( testFormat, "<b>");
			var logo = new FlxSprite(0, 0, "assets/images/" + Main.INTRO_PIC);
			var showPwd:FlxUIButton = new FlxUIButton(0, 0, "", onShowPwd);
			showPwd.loadGraphic("assets/images/ui/showPwd.png", true, 40, 40);
			showPwd.has_toggle = true;

			//location = Browser.location;
			logo.centerOrigin();
			logo.screenCenter();
			logo.x = FlxG.width/2 - logo.width/2;
			logo.y = 50;
			loginTxt = new FlxText(0, 0, 100, "USERNAME",14);
			pwdTxt = new FlxText(0, 0, 100, "PASSWORD", 14);

			pwdTxtInfo = new FlxText(0, 0, 1280, "", 14);
			pwdTxtInfo.screenCenter();
			

			pwdTxtInfo.alignment = "center";
			username = new openfl.text.TextField();
			username.multiline = true;
			username.type = username.type = openfl.text.TextFieldType.INPUT;
			//tf.autoSize = TextFieldAutoSize.LEFT;
			//username.width = 500;
			username.multiline = false;
			username.height = 16;
			//username.wordWrap = true;
			//username.textWidth = 500;
			username.backgroundColor = SaltColor.WHITE;
			username.textColor = SaltColor.BLACK;
			//username.text = memoDefault;
			username.border = true;
			username.borderColor = SaltColor.BLACK;
			username.background = true;
			//username.defaultTextFormat = textFieldFormat;

			FlxG.stage.focus = username;
			pwd = new openfl.text.TextField();
			pwd.displayAsPassword = true; //pwd.passwordMode = true;

			pwd.type = pwd.type = openfl.text.TextFieldType.INPUT;
			//tf.autoSize = TextFieldAutoSize.LEFT;
			//pwd.width = 500;
			pwd.multiline = false;
			pwd.height = 16;
			//pwd.wordWrap = true;
			//pwd.textWidth = 500;
			pwd.backgroundColor = SaltColor.WHITE;
			pwd.textColor = SaltColor.BLACK;
			//pwd.text = memoDefault;
			pwd.border = true;
			pwd.borderColor = SaltColor.BLACK;
			pwd.background = true;
			//pwd.defaultTextFormat = textFieldFormat;

			username.tabEnabled = true;
			username.tabIndex = 1;
			pwd.tabEnabled = true;
			pwd.tabIndex = 2;

			username.setTextFormat(textFieldFormat);
			pwd.setTextFormat(textFieldFormat);

			loginTxt.screenCenter();
			//username.screenCenter();
			pwdTxt.screenCenter();
			
			//pwd.screenCenter();
			
			// special Texfield  positioning
			FlxG.addChildBelowMouse( username );
			//add( username );
			FlxG.addChildBelowMouse( pwd );
			//add( pwd );
			//
			add( logo );
			add( loginTxt );
			add( pwdTxt );
			add( pwdTxtInfo  );

			
			add( showPwd );

			var submitButton = new FlxButton(0, 0, "LET'S GO", onSubmit);

			submitButton.screenCenter();

			username.x = (FlxG.width - username.width) / 2 ;
			pwd.x = (FlxG.width - pwd.width)/ 2 ;

			username.y = loginTxt.y + _padding;
			pwdTxt.y = username.y + _padding;

			pwd.y = pwdTxt.y + _padding;
			showPwd.y = pwdTxt.y + (_padding/3);
			showPwd.x = pwd.x + pwd.width + (_padding/2);
			submitButton.y = pwd.y + _padding * 2;

			pwdTxtInfo.y = submitButton.y + (_padding * 2);
			pwdTxtInfo.color = SaltColor.LIGHT_BLUE;

			add(submitButton);
		}

	}
	function cretaDummyAgent() 
	{
		var a = {
			authorized : true,
			attributes:{
				company : "Qook",
				department : "Service Design",
				division : "Customer Operations",
				givenname : "Bruno",
				initials : "bb",
				mail : "bruno.baudry@salt.ch",
				isAdmin : true,
				msexchuserculture : "en",
				samaccountname : "bbaudry",
				sn : "Baudry",
				title : "Factotum",
				l : "Biel"
			}
		}
		return new Agent(a);
	}

	function onShowPwd()
	{
		//pwd.passwordMode = !pwd.passwordMode;
		pwd.displayAsPassword = !pwd.displayAsPassword;
		//tf.updateHitbox();
		//pwd.hasFocus = true;
		//pwd.drawFrame(true);
	}

	override public function update(elapsed:Float):Void
	{
		//var _focused = username.hasFocus ? username:pwd.hasFocus?pwd:null;
		if ( FlxG.keys.justReleased.TAB)
		{
			_focused = FlxG.stage.focus;
			FlxG.stage.focus = _focused == pwd ? username :  pwd;
		}
		else if (FlxG.keys.justReleased.ENTER)
		{
			onSubmit();
		}
		super.update(elapsed);
	}
	function ondata(data:String)
	{
		//trace("tstool.layout.Login::ondata");
		var d:Dynamic = {};
		#if debug
			
			d.authorized = true;
			Main.user = dummyAgent;	
		#else
		d = Json.parse(data);
		#end
		if (d.authorized)
		{
			try{
				Main.user = new Agent(d);
			}
			catch (e: Exception)
			{
				trace(e.details,e.message,e.previous,e.native, e.stack);
			}
			#if !debug
				
				Main.track.setActor();
			#else 
				trace("tstool.layout.Login::ondata::Main.user", Main.user );
			#end
			
			flushCookie();
			Main.MOVE_ON(); // launch APP
		}
		else
		{
			pwdTxtInfo.applyMarkup ("\n\nNT login + password <b>did not match<b>.",[markerFormat]);
		}
	}
	function onSubmit()
	{
		
		#if debug
		trace("tstool.layout.Login::onSubmit");
		ondata("");
		#else
		pwdTxtInfo.text = "";
		if (StringTools.trim(username.text) == "")
		{
			pwdTxtInfo.applyMarkup("Need <b>username<b> (NT login)", [markerFormat]);
			return;
		}
		if (StringTools.trim(pwd.text) == "")
		{
			pwdTxtInfo.applyMarkup("Need <b>password<b> (Same as your NT one)", [markerFormat]);
			return;
		}
		//trace(location);
		loginUrl.setParameter("username", username.text);
		loginUrl.setParameter("pwd",  Base64.encode(Bytes.ofString(pwd.text)));
		loginUrl.async = true;
		loginUrl.onData = ondata;
		loginUrl.onError = onError;
		loginUrl.onStatus = onStatus;

		loginUrl.request(true);
		
		//u.request(true);
		#end
	}

	function onStatus(s:Int):Void
	{
		//trace(s);
		//@todo deal with http statuses
		#if debug
		trace(s);
		#end
		//trace(s);
		pwdTxtInfo.clearFormats();
		if (s == 500)
		{
			pwdTxtInfo.text += "\n\nUnknown user or missing password";
		}
		else if (s == 404)
		{
			pwdTxtInfo.text += "\n\nCannot connect to the directory script";
		}
		else if (s != 200 )
		{
			pwdTxtInfo.text += "\n\nError " + s;
		}
	}

	function onError(e:Dynamic):Void
	{
		//trace(e);
		//@todo deal with http errors
		#if debug
		trace(e);
		#end
		//pwdTxtInfo.text += "\n\n"+ e;
	}
	
	function flushCookie():Void 
	{
		if (Main.user.mainLanguage == null ||Main.user.mainLanguage == "" || Main.LANGS.indexOf(Main.user.mainLanguage) == -1)
		{
			Main.user.mainLanguage = lang;
		}
		Main.COOKIE.data.user = Main.user;
		Main.COOKIE.flush();
	}
}