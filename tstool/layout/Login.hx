package tstool.layout;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.ui.FlxUIButton;
//import flixel.addons.ui.FlxUIButton;
//import flixel.addons.ui.FlxUIInputText;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
//import flixel.util.FlxColor;
//import flixel.util.FlxSave;
import haxe.Exception;
import openfl.utils.Assets;
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
//import js.html.ClipboardEvent;
//import js.html.Event;
//import js.html.Permissions;
//import lime.system.Clipboard;
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

	var logo:FlxSprite;
	var loginTxt:flixel.text.FlxText;
	var pwdTxt:flixel.text.FlxText;
	var pwdTxtInfo:flixel.text.FlxText;
	var _focused: openfl.display.InteractiveObject;
	var loginUrl:haxe.Http;
	var markerFormat:FlxTextFormatMarkerPair;
	var dummyAgent:tstool.salt.Agent;
	var submitButton:flixel.ui.FlxButton;
	var testers_file:String;
	override public function create()
	{
		testers_file = Assets.getText("assets/data/testers.txt");
		loginUrl = new Http(MainApp.location.origin + MainApp.LIB_FOLDER + "login/index.php" );
		MainApp.setUpSystemDefault(false);

		if (MainApp.agent != null)
		{

			//MainApp.agent = MainApp.save.data.user;
			#if debug
			trace(MainApp.agent.mainLanguage);
			#end

			MainApp.flush();
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
			

			pwdTxtInfo = new FlxText(0, 0, 1280, Main.DEBUG?"Testing platform\nAUTHORISED PERSON ONLY\nIf you need access contact qook@salt.ch":"", 14);
			pwdTxtInfo.screenCenter();
			

			pwdTxtInfo.alignment = "center";
			username = new openfl.text.TextField();
			username.multiline = true;
			username.type = username.type = openfl.text.TextFieldType.INPUT;

			username.multiline = false;
			username.height = 16;

			username.backgroundColor = SaltColor.WHITE;
			username.textColor = SaltColor.BLACK;
			username.border = true;
			username.borderColor = SaltColor.BLACK;
			username.background = true;

			FlxG.stage.focus = username;
			pwd = new openfl.text.TextField();
			pwd.displayAsPassword = true;

			pwd.type = pwd.type = openfl.text.TextFieldType.INPUT;
			
			pwd.multiline = false;
			pwd.height = 16;
			
			pwd.backgroundColor = SaltColor.WHITE;
			pwd.textColor = SaltColor.BLACK;
			
			pwd.border = true;
			pwd.borderColor = SaltColor.BLACK;
			pwd.background = true;
			

			username.tabEnabled = true;
			username.tabIndex = 1;
			pwd.tabEnabled = true;
			pwd.tabIndex = 2;

			username.setTextFormat(textFieldFormat);
			pwd.setTextFormat(textFieldFormat);

			loginTxt.screenCenter();
			
			pwdTxt.screenCenter();
			
			// special Texfield  positioning
			FlxG.addChildBelowMouse( username );
			
			FlxG.addChildBelowMouse( pwd );
			
			//
			add( logo );
			add( loginTxt );
			add( pwdTxt );
			add( pwdTxtInfo  );

			
			add( showPwd );

			submitButton = new FlxButton(0, 0, "LET'S GO", onSubmit);

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
			//pwdTxtInfo.color = SaltColor.LIGHT_BLUE;

			add(submitButton);
		}
		super.create();
	}
	inline function cretaDummyAgent() 
	{
		return {
		status : "ldap could bind", 
		authorized : true, 
		username : "bbaudry", 
		attributes : {
			mail : "Bruno.Baudry@salt.ch", 
			samaccountname : "bbaudry", 
			givenname : "Bruno", 
			sn : "Baudry", 
			mobile : "+41 78 787 8673", 
			company : "Salt Mobile SA", 
			l : "Biel", 
			division : "Customer Operations", 
			department : "Process & Quality", 
			directreports : "CN=qook,OU=Domain-Generic-Accounts,DC=ad,DC=salt,DC=ch", 
			accountexpires : "0", 
			msexchuserculture : "fr-FR", 
			title : "Manager Knowledge & Learning", 
			initials : "BB", 
			memberof : ["Microsoft - Teams Members - Standard","Customer Operations - Training","RA-PulseSecure-Laptops-Salt","SG-PasswordSync","RA-EasyConnect-Web-Mobile-Qook","Customer Operations - Knowledge - Management","Customer Operations - Direct Reports","Customer Operations - Fiber Back Office","DOLPHIN_REC","Application-GIT_SALT-Operator","Application-GIT_SALT-Visitor","SG-OCH-WLAN_Users","SG-OCH-EnterpriseVault_DefaultProvisioningGroup","Entrust_SMS","MIS Mobile Users","GI-EBU-OR-CH-MobileUsers","Floor Marshalls Biel","CO_Knowledge And Translation Mgmt","co training admin_ud","Exchange_Customer Operations Management_ud","Exchange_CustomerCareServiceDesign_ud"]
		}};
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
		
		var d:Dynamic = parseJsonAgent(data);

		if (d.authorized)
		{
			createAgent(d);
			
			MainApp.flush();
			Main.MOVE_ON(); // launch APP
		}
		else
		{
			pwdTxtInfo.applyMarkup ("\n\nNT login + password <b>did not match<b>.",[markerFormat]);
		}
	}
	function createAgent(jsonAgent:Dynamic)
	{
		try{
				MainApp.agent = new Agent(jsonAgent);
			}
			catch (e: Exception)
			{
				trace(e.details,e.message,e.previous,e.native, e.stack);
			}
	}
	function parseJsonAgent(data:String)
	{
		#if debug
			//trace(data);
			if (Main.DEBUG)
			{
				return Json.parse(data);
			}
			else{
				return cretaDummyAgent();	
			}

		#else
		return Json.parse(data);
		#end
	}
	function onSubmit()
	{
		/**
		 * COMENT THIS WHOLE BLOCK WHEN NOT DEBUGGING LOGIN LDAP
		 */
		#if debug
		if (Main.DEBUG)
		{
			trace("tstool.layout.Login::onSubmit");
			pwdTxtInfo.text = "";
			if (StringTools.trim(username.text) == "")
			{
				pwdTxtInfo.applyMarkup("Need <b>username<b> (NT login)", [markerFormat]);
				return;
			}
			else if (testers_file.indexOf(username.text) ==-1)
			{
				pwdTxtInfo.applyMarkup('<b>${username.text}<b> not authorised\nto use this test platform', [markerFormat]);
				return;
			}
			if (StringTools.trim(pwd.text) == "")
			{
				pwdTxtInfo.applyMarkup("Need <b>password<b> (Same as your NT one)", [markerFormat]);
				return;
			}
			
			requestLoginToAD();
		}else{
			//trace("tstool.layout.Login::onSubmit WARNING LOGIN NOT FECTHING DATA");
			ondata("");
		}
		
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
		if (StringTools.trim(pwd.text) == "")
		{
			pwdTxtInfo.applyMarkup("Need <b>password<b> (Same as your NT one)", [markerFormat]);
			return;
		}
		//trace(location);
		
		requestLoginToAD();
		//u.request(true);
		#end
		
		
	}
	function requestLoginToAD()
	{
		loginUrl.setParameter("username", username.text);
		loginUrl.setParameter("pwd",  Base64.encode(Bytes.ofString(pwd.text)));
		loginUrl.async = true;
		loginUrl.onData = ondata;
		loginUrl.onError = onError;
		loginUrl.onStatus = onStatus;

		loginUrl.request(true);
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
	
}