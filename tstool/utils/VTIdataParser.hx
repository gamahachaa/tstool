package tstool.utils;
import flixel.util.FlxSignal.FlxTypedSignal;
import haxe.DynamicAccess;
import haxe.Json;
import js.Browser;
import lime.utils.Assets;
//import utils.VTIdataParser.VtiInterface;

/**
 * ...
 * @author bb
 */
enum VtiInterface{
	healtcheck;
	account;
	events;
}
typedef RegexableProfile = {
	var matched:Bool;
	var universal:String;
	var ereg: String;
}
class VTIdataParser 
{
	var type:VtiInterface;
	//var getLangEreg:EReg;
	//var allInclusivEreg:EReg;
	var regDict:Map<String, EReg>;
	public var signal(get, null):FlxTypedSignal<Map<String,Map<String,String>>->Void>;
	public function new(what:VtiInterface) 
	{
		this.type = what;
		#if debug
		//this.type = healtcheck;
		//this.type = account;
		#end
		regDict = [];
		regDict.set("getLangEreg",new EReg("^(PROD|SIT)(EN|FR|IT|DE)", ""));
		regDict.set("allInclusivEreg", new EReg("^[\\s\\S]+$", ""));

		regDict.set("addressEreg",new EReg("^[0-9a-zA-Z]+\\s[\\S\\s-.]+,\\s[0-9]{4}\\s[\\S\\s-.]+$", "i"));

		regDict.set("moneyEreg",new EReg("^\\-?[0-9]+,[0-9]{2}\\sCHF$", ""));
		regDict.set("dateEreg", new EReg("^(2[0-9]{3}\\-[0-9]{2}\\-[0-9]{2})|(\\-?)$", ""));
		regDict.set("contractorEreg", new EReg("^3\\d{7}$", ""));
		regDict.set("personEreg", new EReg("^(Mr\\.|Ms\\.|Herr)\\s[\\S\\s]+$", ""));
		regDict.set("phoneEreg", new EReg("^41[0-9]{9}$", ""));
		regDict.set("optionalPhoneEreg", new EReg("(41[0-9]{9})|(\\A\\z)", ""));
		regDict.set("emailEreg", ~/[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i);
		signal = new FlxTypedSignal<Map<String,Map<String,String>>->Void>();
		Browser.document.addEventListener("paste", onPaste);
	}
	
	function onPaste(e):Void 
	{
		var content = e.clipboardData.getData("text/plain");
		signal.dispatch(
			switch(type)
			{
				case account : parseCustomerProfile(content);
				case healtcheck : parseHealthCheckDashboard(content);
				case events : [];
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
			"FR" => ["meta"=>"meta", "Owner"=>"owner", "Payeur"=>"payer", "Solde courant"=>"balance", "Offre : Salt Fiber"=>"plan"],
			"IT" => ["meta"=>"meta", "Owner"=>"owner", "Pagatore"=>"payer", "Saldo"=>"balance", "Abo : Salt Fiber"=>"plan"],
			"DE" => ["meta"=>"meta", "Owner"=>"owner", "Zahler"=>"payer", "Aktueller Saldo"=>"balance", "Angebot : Salt Fiber"=>"plan"],
			"EN" => ["meta"=>"meta", "Owner"=>"owner", "Payer"=>"payer", "Current Balance"=>"balance", "Abo : Salt Fiber"=>"plan"],
		];
		
		///////////////////////////////////////////////////////////////////////////////
		/**
		 * GET TOPICS FOR CONFIG
		 */
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
		var currentTopic = "";
		var currentSubTopic = "";
		var currentEreg = "";
		var dataMainTopic = "";
		for (line in t){
			
			if (LANG =="" && regDict.get("getLangEreg").match(line))
			{
				//LANG = getLangEreg.matched(2);
				LANG = regDict.get("getLangEreg").matched(2);
				currentTopic = "meta";
				currentSubTopic = "";
			}
			else if(LANG !="")
			{
				dataMainTopic = mainTopics.get(LANG).get(currentTopic);
				if(currentTopic !="" && topics.get(LANG).exists( currentTopic ) && currentSubTopic!= "" && topics.get(LANG).get( currentTopic ).exists(currentSubTopic) ){
					currentEreg = topics.get(LANG).get( currentTopic ).get(currentSubTopic).ereg;
				}
				else
				{
					// do nothing
					currentEreg = "";
					//trace("catched " + e);
				}
				//trace(currentEreg);
				
				if (topics.get(LANG).exists(line) && currentTopic != line)
				{
					//trace("STORE MAIN -------------");
					currentTopic = line;
					currentSubTopic = "";
				}
				//else if (currentSubTopic != "" && topics.get(LANG).get( mainTopics.get(LANG).get(currentTopic) ).get(currentSubTopic).ereg.match(line))
				else if (currentSubTopic != "" && regDict.get(currentEreg).match(line))
				{
					//trace("MATCH");
					if (!profile.exists( dataMainTopic ))
					{
						profile.set(dataMainTopic, [topics.get(LANG).get( currentTopic ).get(currentSubTopic).universal => line]);
					}
					else{
						profile.get( dataMainTopic ).set( topics.get(LANG).get( currentTopic ).get(currentSubTopic).universal ,line);
					}
					topics.get(LANG).get( currentTopic ).get(currentSubTopic).matched = true;
					currentSubTopic = "";
				}
				else if (topics.get(LANG).get( currentTopic ).exists(line))
				{
					//trace("STORE SUB ###############");
					currentSubTopic = line;
				}
			}

		}
		#if debug
			trace( profile );
			trace( topics.get(LANG));
		#end
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
	function parseHealthCheckDashboard(s:String):Map<String,Map<String,String>>
	{		
		var mainTopics:Array<String> = ["META", "CRM", "TV", "VOD", "Selfcare", "Voice", "Fiber FLL", "IPs", "DHCP", "ONT Config TFTP", "OLT (nokia/huawei)", "Router"];
		var dataSet:Map<String, Map<String,String>> = [];
		for ( f in mainTopics)
		{
			dataSet.set(f, new Map<String,String>());
		}
		var t:Array<String> = s.split("\n");
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
		regDict.set("otoEreg", new EReg("^[A-B.0-9]+$", ""));
		regDict.set("otoPortEreg", new EReg("^[A-D1-4]$", ""));
		regDict.set("boxSerialEreg", new EReg("^SFAA[0-9]{8}$", ""));
		regDict.set("lexIdEreg", new EReg("^[A-Z0-9]+$", ""));
		regDict.set("oltNameEreg", new EReg("^[0-9]{2}$", ""));
		regDict.set("oltObject", new EReg("^[0-9A-Z_\\-:]+$", ""));
		regDict.set("ip4GatewayEreg", new EReg("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", ""));
		regDict.set("providerEreg", new EReg('^"provider": "([\\S]+)",$', "i"));
		//regDict.set("providerEreg", new EReg('^([\\S]+)"$', "i"));
		regDict.set("numberOnlyEreg", new EReg("^[0-9]+$", ""));
		regDict.set("eventDateEreg", new EReg("^[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}\\s[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]+$", ""));
		regDict.set("boolEreg", new EReg("^true|false$", "i"));
		regDict.set("decimalNumberEreg", new EReg("^[0-9.]+$", ""));
		regDict.set("numberOnlyFlexibleEreg", new EReg("[0-9]+", ""));
		regDict.set("numberOnlyStartEreg", new EReg("^[0-9]+", ""));
		//regDict.set("rxValuesEreg", new EReg("^\\-[0-9.]+$", ""));
		//regDict.set("statusEreg", new EReg('^"status": "([0-9a-zA-Z_]+)"', ""));
		regDict.set("idStatusEreg", new EReg('^"idStatus": ([0-9a-zA-Z_]+),$', ""));
		regDict.set("eventdateEreg", new EReg('^"eventdate": "([0-9_\\-\\:\\. ]+)",$', ""));
		regDict.set("reachableEreg", new EReg('^"reachable": (true|false),$', ""));
		regDict.set("tempCpuEreg", new EReg('^"tempCpu": ([0-9.]+),$', ""));
		regDict.set("tempTransceiverEreg", new EReg('^"tempTransceiver": ([0-9.]+),$', ""));
		regDict.set("uptimeEreg", new EReg('^"uptime": ([0-9]+),$', ""));
		regDict.set("statusWanmgtEreg", new EReg('^"statusWanmgt": (true|false),$', ""));
		regDict.set("statusWanhsiEreg", new EReg('^"statusWanhsi": (true|false),$', ""));
		regDict.set("statusWanvoipEreg", new EReg('^"statusWanvoip": (true|false),$', ""));
		regDict.set("statusVoiceRegEreg", new EReg('^"statusVoiceReg": (true|false),$', ""));
		regDict.set("nberDectHandsetEreg", new EReg('^"nberDectHandset": ([0-9]+),$', ""));
		regDict.set("statusWifi24gEreg", new EReg('^"statusWifi24g": (true|false),$', ""));
		regDict.set("statusWifi5gEreg", new EReg('^"statusWifi5g": (true|false),$', ""));
		regDict.set("cpuUsageEreg", new EReg('^"cpuUsage": ([0-9]+),$', ""));
		regDict.set("usedMemoryEreg", new EReg('^"usedMemory": ([0-9]+),$', ""));
		regDict.set("statusFwupgradeEreg", new EReg('^"statusFwupgrade": (true|false),$', ""));
		regDict.set("versionEreg", new EReg('^"version": "([\\s\\S]+)",$', ""));
		regDict.set("snBoxEreg", new EReg('^"snBox": "(SFAA[0-9]{8})",$', ""));
		regDict.set("snTecrepEreg", new EReg('^"snTecrep": "(SFAA[0-9]{8})",$', ""));
		regDict.set("rxEreg", new EReg('^"rx": (\\-[0-9.]+),$', ""));
		regDict.set("txEreg", new EReg('^"tx": ([0-9.]+),$', ""));
		regDict.set("remoteManagementEreg", new EReg('^"remoteManagement": (true|false),?$', ""));
		var topics = [
			"META" => [
				"lang" => {matched:false, ereg: "getLangEreg"}
			],
			"Fiber FLL" => [	
				"otoId" =>{matched:false, ereg: "otoEreg"},
				"otoPortId"=>{matched:false, ereg: "otoPortEreg"},
				"routerSerialNumber"=>{matched:false, ereg: "boxSerialEreg"},
				"lexId"=>{matched:false, ereg: "lexIdEreg"},
				"oltName"=>{matched:false, ereg: "oltNameEreg"},
				"status"=>{matched:false, ereg: "allInclusivEreg"},
				"oltObject" =>{matched:false, ereg: "oltObject"}
				],
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
			]
		];
		var line = "";
		var key = "";
		var val = "";
		var tmp = [];
		for (j in n)
		{
			line = StringTools.trim(j);
			if (skip.indexOf(line) >-1 ) {
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
							if ( regDict.get(o.ereg).match( line ))
							{
								dataSet.get(currentSet).set(key , regDict.get(o.ereg).matched(1));
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
							dataSet.get(currentSet).set(key , val);
							topics.get(currentSet).get(key).matched = true;
							currentSubSet = "";
						}
					}
					else{
						//all others
						if (!topics.exists(currentSet)) {
							continue;
						}
						if (currentSubSet == "")
						{
							currentSubSet = topics.get(currentSet).exists(line)? line :"";
							continue;
						}
						else if (topics.get(currentSet).exists(currentSubSet) ){
							val = line;
							// set value
							if (regDict.get(topics.get(currentSet).get(currentSubSet).ereg).match(val) )
							{
								dataSet.get(currentSet).set(currentSubSet , val);
								topics.get(currentSet).get(currentSubSet).matched = true;
								currentSubSet = "";
							}
							else{
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
					if ( regDict.get(topics.get(currentSet).get("lang").ereg).match(j) )
					{
						dataSet.get(currentSet).set("lang", regDict.get("getLangEreg").matched(2));
						topics.get(currentSet).get("lang").matched = true;
						currentSubSet = "";
					}
				}
			}

		}
		trace(topics);
		trace(dataSet);
		return dataSet;
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