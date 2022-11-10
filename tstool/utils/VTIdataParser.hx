package tstool.utils;
import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.DynamicAccess;
import haxe.Json;
import js.Browser;
import lime.utils.Assets;
import regex.ExpReg;
//import utils.VTIdataParser.VtiInterface;

/**
 * ...
 * @author bb
 */
enum VtiInterface
{
	//healtcheck;
	account;
	events;
}
typedef RegexableProfile =
{
	var matched:Bool;
	var universal:String;
	var ereg: String;
}
typedef MatchedEreg =
{
	var ereg:EReg;
	var matched:Int;
}

class VTIdataParser
{
	var type:VtiInterface;
	//var getLangEreg:EReg;
	//var allInclusivEreg:EReg;
	var regDict:Map<String, MatchedEreg>;
	public static inline var FIBER_FLL:String = "Fiber FLL";
	public static inline var otoId:String = "otoId";
	public static inline var otoPortId:String = "otoPortId";
	public static inline var routerSerialNumber:String = "routerSerialNumber";
	public static inline var lexId:String = "lexId";
	public static inline var oltName:String = "oltName";
	public static inline var oltBoard:String = "oltBoard";
	public static inline var ponPort:String = "ponPort";
	public static inline var breakoutCableId:String = "breakoutCableId";
	public static inline var fiberNumber:String = "fiberNumber";
	public static inline var oltObject:String = "oltObject";
	
	
	
	public var signal(get, null):FlxTypedSignal<Map<String,Map<String,String>>->Void>;
	public function new(what:VtiInterface)
	{
		this.type = what;
		#if debug
		//this.type = healtcheck;
		//this.type = account;
		#end
		regDict = [];
		regDict.set("getLangEreg", {ereg: new EReg(ExpReg.VTI_LANG_PARSE, ""), matched:2});
		regDict.set("allInclusivEreg", {ereg: new EReg("^[\\s\\S]+$", ""), matched:0});

		regDict.set("addressEreg", {ereg: new EReg("^[0-9a-zA-Z]+\\s[\\S\\s-.]+,\\s[0-9]{4}\\s[\\S\\s-.]+$", "i"), matched:0});

		regDict.set("moneyEreg", {ereg: new EReg("^\\-?[0-9]+,[0-9]{2}\\sCHF$", ""), matched:0});
		regDict.set("dateEreg", {ereg: new EReg("^(2[0-9]{3}\\-[0-9]{2}\\-[0-9]{2})|(\\-?)$", ""), matched:0});
		regDict.set("contractorEreg", {ereg: new EReg("^3\\d{7}$", ""), matched:0});
		regDict.set("personEreg", {ereg: new EReg("^(Mr\\.|Ms\\.|Herr|Personne morale)?\\s[\\S\\s]+$", ""), matched:0});
		regDict.set("personB2BEreg", {ereg: new EReg("^(Mr\\.|Ms\\.|Herr|Personne Morale)\\s[\\S\\s]+$", ""), matched:0});
		regDict.set("phoneEreg", {ereg: new EReg("^[- ]{0,2}(41[0-9]{9})$", ""), matched:0});
		//regDict.set("phoneB2BEreg", {ereg: new EReg("^[- ]{0,2}(41[0-9]{9})$", ""), matched:1});
		regDict.set("voipGigaBox", {ereg: new EReg("^([0-9]{11})$", ""), matched:0});   //00000000000
		regDict.set("optionalPhoneEreg", {ereg: new EReg("(41[0-9]{9})|(\\A\\z)", ""), matched:0});
		regDict.set("emailEreg", {ereg:~/[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i, matched:0});
		regDict.set("otoEreg", {ereg: new EReg(ExpReg.OTO_REG, ""), matched:0});
		regDict.set("otoPortEreg", {ereg: new EReg(ExpReg.OTO_PORT, ""), matched:1});
		regDict.set("boxSerialEreg", {ereg: new EReg(ExpReg.BOX_SERIAL_HEALTH, ""), matched:1});
		regDict.set("oltBoardEreg", {ereg: new EReg(ExpReg.PORTS_ID, ""), matched:1});
		regDict.set("ponPortEreg", {ereg: new EReg(ExpReg.PORTS_ID, ""), matched:1});
		regDict.set("breakoutCableIdEreg", {ereg: new EReg(ExpReg.BREAKOUT_CABLE, ""), matched:1});//KP100314-C0010 KP100314-C0009/4
		regDict.set("fiberNumberEreg", {ereg: new EReg(ExpReg.PORTS_ID, ""), matched:1});//KP100314-C0010 KP100314-C0009/4
		regDict.set("lexIdEreg", {ereg: new EReg(ExpReg.LEX_ID, ""), matched:1});
		regDict.set("oltNameEreg", {ereg: new EReg(ExpReg.OLT_NAME, "i"), matched:1});
		regDict.set("oltObject", {ereg: new EReg(ExpReg.OLT_OBJECT, ""), matched:1});
		//regDict.set("ip4GatewayEreg", {ereg: new EReg("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ""), matched:1});
		//regDict.set("providerEreg", {ereg: new EReg('^"provider": "([\\S]+)",$', "i"), matched:1});
		//regDict.set("providerEreg", {ereg: new EReg('^([\\S]+)"$', "i"), matched:1});
		//regDict.set("numberOnlyEreg", {ereg: new EReg("^[0-9]+$", ""), matched:1});
		//regDict.set("eventDateEreg", {ereg: new EReg("^[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}\\s[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]+$", ""), matched:1});
		//regDict.set("boolEreg", {ereg: new EReg("^true|false$", "i"), matched:1});
		//regDict.set("decimalNumberEreg", {ereg: new EReg("^[0-9.]+$", ""), matched:1});
		//regDict.set("numberOnlyFlexibleEreg", {ereg: new EReg("[0-9]+", ""), matched:1});
		//regDict.set("numberOnlyStartEreg", {ereg: new EReg("^[0-9]+", ""), matched:1});
		//regDict.set("rxValuesEreg", {ereg: new EReg("^\\-[0-9.]+$", ""), matched:1});
		//regDict.set("statusEreg", {ereg: new EReg('^"status": "([0-9a-zA-Z_]+)"', ""), matched:1});
		//regDict.set("idStatusEreg", {ereg: new EReg('^"idStatus": ([0-9a-zA-Z_]+),$', ""), matched:1});
		//regDict.set("eventdateEreg", {ereg: new EReg('^"eventdate": "([0-9_\\-\\:\\. ]+)",$', ""), matched:1});
		//regDict.set("reachableEreg", {ereg: new EReg('^"reachable": (true|false),$', ""), matched:1});
		//regDict.set("tempCpuEreg", {ereg: new EReg('^"tempCpu": ([0-9.]+),$', ""), matched:1});
		//regDict.set("tempTransceiverEreg", {ereg: new EReg('^"tempTransceiver": ([0-9.]+),$', ""), matched:1});
		//regDict.set("uptimeEreg", {ereg: new EReg('^"uptime": ([0-9]+),$', ""), matched:1});
		//regDict.set("statusWanmgtEreg", {ereg: new EReg('^"statusWanmgt": (true|false),$', ""), matched:1});
		//regDict.set("statusWanhsiEreg", {ereg: new EReg('^"statusWanhsi": (true|false),$', ""), matched:1});
		//regDict.set("statusWanvoipEreg", {ereg: new EReg('^"statusWanvoip": (true|false),$', ""), matched:1});
		//regDict.set("statusVoiceRegEreg", {ereg: new EReg('^"statusVoiceReg": (true|false),$', ""), matched:1});
		//regDict.set("nberDectHandsetEreg", {ereg: new EReg('^"nberDectHandset": ([0-9]+),$', ""), matched:1});
		//regDict.set("statusWifi24gEreg", {ereg: new EReg('^"statusWifi24g": (true|false),$', ""), matched:1});
		//regDict.set("statusWifi5gEreg", {ereg: new EReg('^"statusWifi5g": (true|false),$', ""), matched:1});
		//regDict.set("cpuUsageEreg", {ereg: new EReg('^"cpuUsage": ([0-9]+),$', ""), matched:1});
		//regDict.set("usedMemoryEreg", {ereg: new EReg('^"usedMemory": ([0-9]+),$', ""), matched:1});
		//regDict.set("statusFwupgradeEreg", {ereg: new EReg('^"statusFwupgrade": (true|false),$', ""), matched:1});
		//regDict.set("versionEreg", {ereg: new EReg('^"version": "([\\s\\S]+)",$', ""), matched:1});
		//regDict.set("snBoxEreg", {ereg: new EReg('^"snBox": "(SFAA[0-9]{8})",$', ""), matched:1});
		//regDict.set("snTecrepEreg", {ereg: new EReg('^"snTecrep": "(SFAA[0-9]{8})",$', ""), matched:1});
		//regDict.set("rxEreg", {ereg: new EReg('^"rx": (\\-[0-9.]+),$', ""), matched:1});
		//regDict.set("txEreg", {ereg: new EReg('^"tx": ([0-9.]+),$', ""), matched:1});
		//regDict.set("remoteManagementEreg", {ereg: new EReg('^"remoteManagement": (true|false),?$', ""), matched:1});
		signal = new FlxTypedSignal<Map<String,Map<String,String>>->Void>();
		Browser.document.addEventListener("paste", onPaste);
	}

	function onPaste(e):Void
	{
		var content = e.clipboardData.getData("text/plain");
		signal.dispatch(
			switch (type)
	{
		case account : parseCustomerProfile(content);
			//case healtcheck : parseHealthCheckDashboard(content);
			case events : parseHealthCheckDashboard(content);
		}
		);
	}
	public function destroy()
	{
		Browser.document.removeEventListener("paste", onPaste);
	}

	function get_signal():FlxTypedSignal<Map<String, Map<String, String>>->Void>
	{
		return signal;
	}

	function parseCustomerProfile(content:String):Map<String,Map<String,String>>
	{
		//trace(content);
		var profile:Map<String,Map<String,String>> = [];
		var t:Array<String> = content.split("\n");
		//trace(t);

		var LANG = "";
		var mainTopics:Map<String,Map<String,String>> = [
			"FR" => ["meta"=>"meta", "Owner"=>"owner", "Payeur"=>"payer", "Solde courant"=>"balance", "Offre : Salt Fiber"=>"plan","Offre : Salt GigaBox"=>"plan", "Offre : Salt Office"=>"plan", "Offre : Pro Office"=>"plan"],
			"IT" => ["meta"=>"meta", "Owner"=>"owner", "Pagatore"=>"payer", "Saldo"=>"balance", "Abo : Salt Fiber"=>"plan", "Abo : Salt GigaBox"=>"plan",  "Abo : Salt Office"=>"plan",  "Abo : Pro Office"=>"plan"],
			"DE" => ["meta"=>"meta", "Owner"=>"owner", "Zahler"=>"payer", "Aktueller Saldo"=>"balance", "Angebot : Salt Fiber"=>"plan", "Angebot : Salt GigaBox"=>"plan", "Angebot : Salt Office"=>"plan", "Angebot : Pro Office"=>"plan"],
			"EN" => ["meta"=>"meta", "Owner"=>"owner", "Payer"=>"payer", "Current Balance"=>"balance", "Abo : Salt Fiber"=>"plan", "Abo : Salt GigaBox"=>"plan",  "Abo : Salt Office"=>"plan",  "Abo : Pro Office"=>"plan"],
		];

		///////////////////////////////////////////////////////////////////////////////
		/**
		 * GET TOPICS FOR CONFIG
		 */
		var currentTopic = "";
		var currentSubTopic = "";
		var currentEreg = "";
		var dataMainTopic = "";
		var topicsLoded = Json.parse(Assets.getText("assets/data/customerProfile.json"));

		var topics:Map<String, Map<String, Map<String, RegexableProfile>>> = [];
		// map
		for ( lang in Reflect.fields(topicsLoded))
		{
			//trace(lang);
			if (!topics.exists(lang))
				topics.set(lang, []);
			var lanObj = Reflect.field( topicsLoded, lang);
			for ( mainT in Reflect.fields(lanObj))
			{
				//trace(mainT);
				if (!topics.get(lang).exists(mainT))
					topics.get(lang).set(mainT, []);
				var  mainTObject = Reflect.field(lanObj, mainT);
				for ( subT in Reflect.fields(mainTObject))
				{
					//trace(subT);
					var suTobject:RegexableProfile = Reflect.field(mainTObject, subT);
					if (!topics.get(lang).get(mainT).exists(subT))
						topics.get(lang).get(mainT).set(subT, suTobject );

				}
			}
		}

		for (line in t)
		{

			if (LANG =="" && regDict.get("getLangEreg").ereg.match(line))
			{
				//#if debug
				//trace('0. tstool.utils.LANG ${LANG}', line);
				//#end
				//LANG = getLangEreg.matched(2);
				LANG = regDict.get("getLangEreg").ereg.matched(regDict.get("getLangEreg").matched);
				currentTopic = "meta";
				currentSubTopic = "";
			}
			else if (LANG !="")
			{
				dataMainTopic = mainTopics.get(LANG).get(currentTopic);
				//#if debug
				//trace("1.A lang, line, dataMainTopic --> ", LANG, line, dataMainTopic, currentTopic );
				//trace(mainTopics.get(LANG));
				//#end

				/**
				 * FIND current sub topic
				 */
				if (currentTopic !="" && topics.get(LANG).exists( currentTopic ) && currentSubTopic!= "" && topics.get(LANG).get( currentTopic ).exists(currentSubTopic) )
				{
					currentEreg = topics.get(LANG).get( currentTopic ).get(currentSubTopic).ereg;
					//#if debug
					//trace('2.A found a sub topic $currentSubTopic setting the currentEreg -->', currentEreg);
					//#end
				}
				else
				{
					// do nothing
					currentEreg = "";
				}

				if (topics.get(LANG).exists(line) && currentTopic != line)
				{

					currentTopic = line;
					currentSubTopic = "";
					//#if debug
					////trace(" dataMainTopic ", dataMainTopic );
					//trace("3.A CHANGE OF currentTopic --> line, currentTopic ", line, currentTopic );
					//#end
				}
				//else if (currentSubTopic != "" && topics.get(LANG).get( mainTopics.get(LANG).get(currentTopic) ).get(currentSubTopic).ereg.match(line))
				else if (currentSubTopic != "" && regDict.get(currentEreg).ereg.match(line))
				{
					//#if debug
					//trace("3.B MATCH line, currentEreg --> ", line, currentEreg);
					//#end
					var matched = regDict.get(currentEreg).ereg.matched(regDict.get(currentEreg).matched);
					if (!profile.exists( dataMainTopic ))
					{
						//#if debug
						//trace('3.B.1 $dataMainTopic is not in the profile --> added now');
						//#end
						profile.set( dataMainTopic,
									 [topics.get(LANG).get( currentTopic ).get(currentSubTopic).universal => matched]);
						if (dataMainTopic == "plan")
						{
							//#if debug
							//trace('3.B.1.A dataMainTopic $dataMainTopic is of type PLAN  --> set ', currentTopic);
							//#end
							profile.get(dataMainTopic).set(dataMainTopic, currentTopic);
						}
					}
					else
					{
						//#if debug
						//trace('3.B.2 Set dataMainTopic to topics.get(LANG).get( currentTopic ).get(currentSubTopic).universal, line) -->', dataMainTopic, topics.get(LANG).get( currentTopic ).get(currentSubTopic).universal, matched);
						//#end
						profile.get( dataMainTopic ).set( topics.get(LANG).get( currentTopic ).get(currentSubTopic).universal, matched);
					}

					topics.get(LANG).get( currentTopic ).get(currentSubTopic).matched = true;
					//#if debug
					//trace('3.B.LAST tell topic parser that it matched --> topics.get($LANG).get( $currentTopic ).get($currentSubTopic).matched SET TO TRUE now ', topics.get(LANG).get( currentTopic ).get(currentSubTopic) );
					//#end
					currentSubTopic = "";
				}
				else if (topics.get(LANG).get( currentTopic ).exists(line))
				{
					//#if debug
					//trace('3.C temporary store the currentSubTopic ($currentSubTopic) now set to ', line );
					//#end
					currentSubTopic = line;
				}
				else
				{
					//#if debug
					//trace('3.D Line ($line) Not matched ($currentEreg) and $currentTopic not in TOPICS ', line );
					//#end
				}
			}
			else
			{

				#if debug
				trace("1.B line SKIPED", line );
				#end
			}

		}
		//#if debug
		//trace("profile --> ", profile );
		//trace("topics.get(LANG)",  topics.get(LANG));
		//#end
		/**
		 * @todo manage vti oparsing error send email to agent
		 */
		//if(LANG !="")
		//healthCheckCustomerProfile(topics, LANG, content);
		return profile;
	}
	/*
	function healthCheckCustomerProfile(topics, lng, content)
	{

		var noMatch: Array<Dynamic> = [];
		var top:Map<String,Map<String,Dynamic>> = cast(topics.get(lng));
		for ( k=>v in top)
		{
			for (key => Value  in v)
			{
				if (!Value.matched) {
					noMatch.push( {mainTopic:k, subtopic: Value.universal, textNotFound: key });
				}
			}
		}

		if (noMatch.length > 0)
		{
			var b = "language " + lng + "<br/><ul>";
			for (a in noMatch) b += '<li>TOPIC ${a.mainTopic} VAR ${a.subtopic} NOT FOUND: "${a.textNotFound}"</li>';

			var mail = new SwiftMailWrapper(Browser.location.origin + Browser.location.pathname + Main.MAIL_WRAPPER_URL);

			mail.setSubject('[TSTOOL ALERT] VTI customer profile $lng'  );
			mail.setFrom("bruno.baudry@salt.ch");
			mail.setTo(["bruno.baudry@salt.ch"]);
			mail.setBody("<body>" + b + "</ul>"+Main.user.iri + " " + Browser.navigator.userAgent+"<br/>" + content +"</body>");

			mail.send(true);//sending copy paste failure report

			#if debug
			trace("mail should be sent" );
			#end
		}
		else{
			#if debug
			trace("All good no mail should be sent" );
			#end

		}

	}*/
	/**/
	function parseHealthCheckDashboard(s:String):Map<String,Map<String,String>>
	{
		var profile:Map<String,Map<String,String>> = [];
		var t:Array<String> = s.split("\n");
		//var mainTopics:Array<String> = ["META", "CRM", "TV", "VOD", "Selfcare", "Voice", "Fiber FLL", "IPs", "DHCP", "ONT Config TFTP", "OLT (nokia/huawei)", "Router"];
		var mainTopics:Array<String> = ["META", FIBER_FLL];
		var topicsLoded = Json.parse(Assets.getText("assets/data/dashboardSante.json"));
		//var dataSet:Map<String, Map<String,String>> = [];
		for ( f in mainTopics)
		{
			profile.set(f, new Map<String,String>());
		}

		//trace(t);
		var n:Array<String> = [];
		var trimed = "";
		var skip = ["", "{", "}", "[", "]", "},", "],","Call raw result: +  See"];
		for (i in t)
		{
			trimed = StringTools.trim(i);
			n.push(trimed);
		}
		var currentSet = "META";
		var currentSubSet = "";
		var value = "";
		var hasCollum = 0;
		var hasEqual = 0;
		//regDict.set("
		
		var topics = [
			"META" => [
		"lang" => {matched:false, ereg: "getLangEreg"}
			],
		FIBER_FLL => [
			otoId =>{matched:false, ereg: "otoEreg"},
			otoPortId=>{matched:false, ereg: "otoPortEreg"},
			routerSerialNumber=>{matched:false, ereg: "boxSerialEreg"},
			lexId=>{matched:false, ereg: "lexIdEreg"},
			oltName=>{matched:false, ereg: "oltNameEreg"},
			oltBoard=>{matched:false, ereg: "oltBoardEreg"},
			ponPort=>{matched:false, ereg: "ponPortEreg"},
			breakoutCableId=>{matched:false, ereg: "breakoutCableIdEreg"},
			fiberNumber=>{matched:false, ereg: "fiberNumberEreg"},
			//"status"=>{matched:false, ereg: "allInclusivEreg"},
			oltObject =>{matched:false, ereg: "oltObject"}
		]/*,
		"ONT Config TFTP"=>[
		"ARC_WAN_1_IP4_Gateway" =>{matched:false, ereg: "ip4GatewayEreg"},
		"ARC_WAN_1_IP6_StaticGateway"=>{matched:false, ereg: "allInclusivEreg"}
		],
		"OLT (nokia/huawei)"=>[
		"provider" =>{matched:false, ereg: "providerEreg"}
		],
		"Router" => [
		"idStatus"=>{matched:false, ereg: "idStatusEreg"},
		"eventdate"=>{matched:false, ereg: "eventdateEreg"},
		"reachable" =>{matched:false, ereg: "reachableEreg"},
		"tempCpu"=>{matched:false, ereg: "tempCpuEreg"},
		"tempTransceiver"=>{matched:false, ereg: "tempTransceiverEreg"},
		"uptime"=>{matched:false, ereg: "uptimeEreg"},
		"statusWanmgt"=>{matched:false, ereg: "statusWanmgtEreg"},
		"statusWanhsi"=>{matched:false, ereg: "statusWanhsiEreg"},
		"statusWanvoip"=>{matched:false, ereg: "statusWanvoipEreg"},
		"statusVoiceReg"=>{matched:false, ereg: "statusVoiceRegEreg"},
		"nberDectHandset"=>{matched:false, ereg: "nberDectHandsetEreg"},
		"statusWifi24g"=>{matched:false, ereg: "statusWifi24gEreg"},
		"statusWifi5g"=>{matched:false, ereg: "statusWifi5gEreg"},
		"cpuUsage"=>{matched:false, ereg: "cpuUsageEreg"},
		"usedMemory"=>{matched:false, ereg: "usedMemoryEreg"},
		"statusFwupgrade"=>{matched:false, ereg: "statusFwupgradeEreg"},
		"version"=>{matched:false, ereg: "versionEreg"},
		"snBox"=>{matched:false, ereg: "snBoxEreg"},
		"snTecrep"=>{matched:false, ereg: "snTecrepEreg"},
		"rx"=>{matched:false, ereg: "rxEreg"},
		"tx"=>{matched:false, ereg: "txEreg"},
		"remoteManagement"=>{matched:false, ereg: "remoteManagementEreg"}
		] */
		];
		var line = "";
		var key = "";
		var val = "";
		var tmp = [];
		try{
		for (j in n)
		{
			line = StringTools.trim(j);
			if (skip.indexOf(line) >-1 )
			{
				continue;
			}

			if ( mainTopics.indexOf(line) > -1 )
			{
				currentSet = line;
				currentSubSet = "";
				continue;
			}
			else
			{
				//trace(currentSet + " " + currentSubSet + " " + line);
				if (currentSet != "META" )
				{
					if (currentSet == "Router" || currentSet == "OLT (nokia/huawei)")
					{
						//object parsing in one line
						tmp = line.split(":");
						if (tmp.length < 2) continue;
						key = StringTools.replace(StringTools.trim(tmp[0]),'"',"");
						val = StringTools.trim(tmp[1]);
						//trace(key, val);
						if (topics.get(currentSet).exists(key))
						{
							trace(currentSet + " " + currentSubSet + " " + line);
							var o = topics.get(currentSet).get(key);
							if ( regDict.get(o.ereg).ereg.match( line ))
							{
								profile.get(currentSet).set(key, regDict.get(o.ereg).ereg.matched(1));
								topics.get(currentSet).get(key).matched = true;
								currentSubSet = "";
							}

						}
					}
					else if (currentSet == "ONT Config TFTP")
					{
						// key=value lines
						var tmp = j.split("=");
						if (tmp.length < 2) continue;
						key = StringTools.trim(tmp[0]);
						val = StringTools.trim(tmp[1]);
						if (topics.get(currentSet).exists(key))
						{
							profile.get(currentSet).set(key, val);
							topics.get(currentSet).get(key).matched = true;
							currentSubSet = "";
						}
					}
					else
					{
						//all others
						if (!topics.exists(currentSet))
						{
							continue;
						}
						if (currentSubSet == "")
						{
							currentSubSet = topics.get(currentSet).exists(line)? line :"";
							continue;
						}
						else if (topics.get(currentSet).exists(currentSubSet) )
						{
							val = line;
							// set value
							if (regDict.get(topics.get(currentSet).get(currentSubSet).ereg).ereg.match(val) )
							{
								profile.get(currentSet).set(currentSubSet, val);
								topics.get(currentSet).get(currentSubSet).matched = true;
								currentSubSet = "";
							}
							else
							{
								trace("no match for " + currentSubSet + " " + val  + " (ereg) " + regDict.get(topics.get(currentSet).get(currentSubSet).ereg ));
							}

						}
						else
						{
							trace("UNKNOW currentSubSet " + currentSubSet);
						}
					}
				}
				else
				{
					var regex = regDict.get(topics.get(currentSet).get("lang").ereg).ereg;
					if ( regex.match(j) )
					{
						var matches = regex.matched(2);
						#if debug
						trace('tstool.utils.VTIdataParser::parseHealthCheckDashboard::matches ${matches}');
						#end
						//trace("currentSet " + currentSet + " " + line +" " + regex.matched + " " + regex.matched(0)+ " " + regex.matched(1)+ " " + regex.matched(2));
						profile.get(currentSet).set("lang", matches);
						topics.get(currentSet).get("lang").matched = true;
						currentSubSet = "";
					}
				}
			}

		}
		}
		catch (e)
		{
			trace(e);
			trace(currentSet);
			trace(currentSubSet);
		}
		//trace(topics);
		//trace(profile);
		return profile;
	}
	function cleanKey(s:String):String
	{
		return
		StringTools.replace(
			StringTools.replace(s,
		'"', ""),
			",", "");
	}
}