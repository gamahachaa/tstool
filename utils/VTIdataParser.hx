package tstool.utils;
import flixel.util.FlxSignal.FlxTypedSignal;
import js.Browser;
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
class VTIdataParser 
{
	var type:VtiInterface;
	var getLangEreg:EReg;
	var allInclusivEReg:EReg;
	public var signal(get, null):FlxTypedSignal<Map<String,Map<String,String>>->Void>;
	public function new(what:VtiInterface) 
	{
		this.type = what;
		getLangEreg = new EReg("^(PROD|SIT)(EN|FR|IT|DE)", "");
		allInclusivEReg = new EReg("^[\\s\\S]+$","");
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
			"FR" => ["Meta"=>"meta", "Owner"=>"owner", "Payeur"=>"payer", "Solde courant"=>"balance", "Offre : Salt Fiber"=>"plan"],
			"IT" => ["Meta"=>"meta", "Owner"=>"owner", "Pagatore"=>"payer", "Saldo"=>"balance", "Abo : Salt Fiber"=>"plan"],
			"DE" => ["Meta"=>"meta", "Owner"=>"owner", "Zahler"=>"payer", "Aktueller Saldo"=>"balance", "Angebot : Salt Fiber"=>"plan"],
			"EN" => ["Meta"=>"meta", "Owner"=>"owner", "Payer"=>"payer", "Current Balance"=>"balance", "Abo : Salt Fiber"=>"plan"],
		];
		//var addressEreg:EReg = ~/^[0-9]+\s[\S\s-.]+,\s[0-9]{4}\s[\S\s-.]+$/i;
		var addressEreg:EReg = new EReg("^[0-9a-zA-Z]+\\s[\\S\\s-.]+,\\s[0-9]{4}\\s[\\S\\s-.]+$","i");
		var moneyReg:EReg = new EReg("^[0-9]+,[0-9]{2}\\sCHF$","");
		//var moneyReg:EReg = ~/^[0-9]+,[0-9]{2}\sCHF$/;
		var dateReg:EReg = new EReg("^2[0-9]{3}\\-[0-9]{2}\\-[0-9]{2}$","");
		//var dateReg:EReg = ~/^2[0-9]{3}\-[0-9]{2}\-[0-9]{2}$/;
		var contractorEreg:EReg = new EReg("^3\\d{7}$","");
		//var contractorEreg:EReg = ~/^3\d{7}$/;
		var personEreg:EReg = new EReg("^(Mr\\.|Ms\\.|Herr)\\s[\\S\\s]+$","");
		//var personEreg:EReg = ~/^(Mr\.|Ms\.|Herr)\s[\S\s]+$/;
		var phoneEreg:EReg = new EReg("^41[0-9]{9}$","");
		//var phoneEreg:EReg = ~/^41[0-9]{9}$/;
		//var emailReg:EReg = new EReg("[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/","i");
		var emailReg:EReg = ~/[a-z0-9!#$%&'*+\/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/i;
		var topics = [
			"FR" => [
				//"mainTopics"=>["Owner","Payeur","Solde courant","Offre : Salt Fiber"],
				"meta" =>[
					"logoSalt.png " => {universal:"vtiContractor", ereg: contractorEreg}
				],
				"owner"=>[
					"Owner" => {universal:"vtiOwner", ereg: personEreg},
					"Email" => {universal:"vtiOwnerEmail", ereg:emailReg},
					"Validation de l'adresse email"=>{universal:"vtiOwnerEmailValidated",ereg:allInclusivEReg},
				],
				"payer" => [
					"Payeur" => {universal:"vtiPayer", ereg: personEreg},
					"Email" => {universal:"vtiPayerEmail", ereg:emailReg},
				],
				"plan" => [
					"Numéro de VoIP" => {universal:"vtiVoip", ereg:phoneEreg},
					"Utilisateur Ligne" => {universal:"vtiUser", ereg: personEreg},
					"Adresse" => {universal:"vtiAdress", ereg:addressEreg},
					"Téléphone Fixe"=>{universal:"vtiFix",ereg:phoneEreg},
					"Mobile Number" => {universal:"vtiMobile", ereg:phoneEreg},
					"Email" => {universal:"vtiUserEmail", ereg:emailReg}
				],
				"balance"=>[
					"Balance"=>{universal:"vtiBalance",ereg:moneyReg},
					"Balance non soldée"=>{universal:"vtiOverdue",ereg:moneyReg},
					"En retard depuis" => {universal:"vtiOverdueDate", ereg: dateReg}
					]
				],
				
			"IT" => [
				//"mainTopics"=>["Owner","Payeur","Solde courant","Offre : Salt Fiber"],
				"meta" =>[
					"logoSalt.png " => {universal:"vtiContractor", ereg: contractorEreg}
				],
				"owner"=>[
					"Owner" => {universal:"vtiOwner", ereg: personEreg},
					"Email" => {universal:"vtiOwnerEmail", ereg:emailReg},
					"Email validation"=>{universal:"vtiOwnerEmailValidated",ereg:allInclusivEReg},
				],
				"payer" => [
					"Pagatore" => {universal:"vtiPayer", ereg: personEreg},
					"Email" => {universal:"vtiPayerEmail", ereg:emailReg},
				],
				"plan" => [
					"VoIP Number" => {universal:"vtiVoip", ereg:phoneEreg},
					"Line user" => {universal:"vtiUser", ereg: personEreg},
					"Address" => {universal:"vtiAdress", ereg:addressEreg},
					"Téléphone Fixe"=>{universal:"vtiFix",ereg:phoneEreg},
					"Mobile Number" => {universal:"vtiMobile", ereg:phoneEreg},
					"Email" => {universal:"vtiUserEmail", ereg:emailReg}
				],
				"balance"=>[
					"Saldo"=>{universal:"vtiBalance",ereg:moneyReg},
					"Saldo in ritardo"=>{universal:"vtiOverdue",ereg:moneyReg},
					"Data di scadenza" => {universal:"vtiOverdueDate", ereg: dateReg}
					]
				],	
			"DE" => [
				//"mainTopics"=>["Owner","Payeur","Solde courant","Offre : Salt Fiber"],
				"meta" =>[
					"logoSalt.png " => {universal:"vtiContractor", ereg: contractorEreg}
				],
				"owner"=>[
					"Owner" => {universal:"vtiOwner", ereg: personEreg},
					"Email" => {universal:"vtiOwnerEmail", ereg:emailReg},
					"Validierung der E-Mail-Adresse"=>{universal:"vtiOwnerEmailValidated",ereg:allInclusivEReg},
				],
				"payer" => [
					"Zahler" => {universal:"vtiPayer", ereg: personEreg},
					"Email" => {universal:"vtiPayerEmail", ereg:emailReg},
				],
				"plan" => [
					"VoIP-Nummer" => {universal:"vtiVoip", ereg:phoneEreg},
					"Benutzer" => {universal:"vtiUser", ereg: personEreg},
					"Address" => {universal:"vtiAdress", ereg:addressEreg},
					"Festnetznummer"=>{universal:"vtiFix",ereg:phoneEreg},
					"Mobile Number" => {universal:"vtiMobile", ereg:phoneEreg},
					"Email" => {universal:"vtiUserEmail", ereg:emailReg}
				],
				"balance"=>[
					"Saldo"=>{universal:"vtiBalance",ereg:moneyReg},
					"Überfälliger Saldo"=>{universal:"vtiOverdue",ereg:moneyReg},
					"Überfällig seit" => {universal:"vtiOverdueDate", ereg: dateReg}
					]
				],		
			
			"EN" => [
				//"mainTopics"=>["Owner","Payeur","Solde courant","Offre : Salt Fiber"],
				"meta" =>[
					"logoSalt.png " => {universal:"vtiContractor", ereg: contractorEreg}
				],
				"owner"=>[
					"Owner" => {universal:"vtiOwner", ereg: personEreg},
					"Email" => {universal:"vtiOwnerEmail", ereg:emailReg},
					"Email validation"=>{universal:"vtiOwnerEmailValidated",ereg:allInclusivEReg},
				],
				"payer" => [
					"Payer" => {universal:"vtiPayer", ereg: personEreg},
					"Email" => {universal:"vtiPayerEmail", ereg:emailReg},
				],
				"plan" => [
					"VoIP Number" => {universal:"vtiVoip", ereg:phoneEreg},
					"User of the line" => {universal:"vtiUser", ereg: personEreg},
					"Address" => {universal:"vtiAdress", ereg:addressEreg},
					"Fixed number"=>{universal:"vtiFix",ereg:phoneEreg},
					"Mobile Number" => {universal:"vtiMobile", ereg:phoneEreg},
					"Email" => {universal:"vtiUserEmail", ereg:emailReg}
				],
				"balance"=>[
					"Balance"=>{universal:"vtiBalance",ereg:moneyReg},
					"Overdue balance"=>{universal:"vtiOverdue",ereg:moneyReg},
					"Overdue date" => {universal:"vtiOverdueDate", ereg: dateReg}
					]
				]
		];
		var currentTopic = "";
		var currentSubTopic = "";
		for (line in t){
			
			if (LANG =="" && getLangEreg.match(line))
			{
				LANG = getLangEreg.matched(2);
				currentTopic = "Meta";
				currentSubTopic = "";
			}
			else if(LANG !="")
			{
				if (mainTopics.get(LANG).exists(line) && currentTopic != line)
				{
					//trace("STORE MAIN -------------");
					currentTopic = line;
					currentSubTopic = "";
				}
				else if (currentSubTopic != "" && topics.get(LANG).get( mainTopics.get(LANG).get(currentTopic) ).get(currentSubTopic).ereg.match(line))
				{
					//trace("MATCH");
					if (!profile.exists( mainTopics.get(LANG).get(currentTopic) ))
					{
						profile.set( mainTopics.get(LANG).get(currentTopic), [topics.get(LANG).get( mainTopics.get(LANG).get(currentTopic) ).get(currentSubTopic).universal => line]);
					}
					else{
						profile.get( mainTopics.get(LANG).get(currentTopic)).set(topics.get(LANG).get( mainTopics.get(LANG).get(currentTopic) ).get(currentSubTopic).universal ,line);
					}
					
					currentSubTopic = "";
				}
				else if (topics.get(LANG).get( mainTopics.get(LANG).get(currentTopic) ).exists(line))
				{
					//trace("STORE SUB ###############");
					currentSubTopic = line;
				}
			}

		}
		//trace(profile);
		return profile;
		//trace(profile.exists("meta"));
		//if (!profile.exists("meta") || !profile.exists("plan")) return null;
		//return new Contractor(
			//profile.get("meta").exists("vtiContractor")? profile.get("meta").get("vtiContractor"):"",
			//profile.get("plan").exists("vtiVoip")? profile.get("plan").get("vtiVoip"):"",
			//profile.get("plan").exists("vtiFix")? profile.get("plan").get("vtiFix"):"",
			//profile.get("plan").exists("vtiMobile")? profile.get("plan").get("vtiMobile"):"",
			//profile.get("plan").exists("vtiAdress")? profile.get("plan").get("vtiAdress"):"",
			//profile.exists("owner")? new Role(owner,profile.get("owner").get("vtiOwner"),profile.get("owner").get("vtiOwnerEmail")):null,
			//profile.exists("payer")? new Role(payer,profile.get("payer").get("vtiPayer"),profile.get("payer").get("vtiPayerEmail")):null,
			//new Role(user, profile.get("plan").get("vtiUser"), profile.get("plan").get("vtiUserEmail")),
			//profile.exists("owner")? StringTools.trim(profile.get("owner").get("vtiOwnerEmailValidated").toLowerCase()) == "ok":false,
			//profile.exists("balance")?new Balance( profile.get("balance").get("vtiBalance"), profile.get("balance").get("vtiOverdue"), profile.get("balance").get("vtiOverdueDate")):null
		//);
	}
	function parseHealthCheckDashboard(s:String):Map<String,Map<String,String>>
	{
		//trace("parseHealthCheckDashboard");
		
		var mainTopics:Array<String> = ["META", "CRM", "TV", "VOD", "Selfcare", "Voice", "Fiber FLL", "IPs", "DHCP", "ONT Config TFTP", "OLT (nokia/huawei)", "Router"];
		var dataSet:Map<String, Map<String,String>> = [];
		for ( f in mainTopics)
		{
			dataSet.set(f, new Map<String,String>());
		}
		//var t:Array<String> = s.split("\r\n");
		var t:Array<String> = s.split("\n");
		//trace(t);
		var n:Array<String> = [];
		var trimed = "";
		var skip = ["", "{", "}", "[", "]", "},", "],"];
		//var skip = ["", "{", "}", "[", "]", "},", "],", "success","message","result","argument","name","value"];
		for (i in t)
		{
			trimed = StringTools.trim(i);
			//if ( skip.indexOf(trimed) > -1) continue;
			//else 
				n.push(trimed);

		}
		//trace(n);
		var currentSet = "META";
		var currentSubSet = "";
		var value = "";
		var hasCollum = 0;
		var hasEqual = 0;
		var fiberFFLSubset:Map<String,EReg> = [
			"otoId" => new EReg("^[A-B.0-9]+$",""),	
			"otoPortId"=>new EReg("^[A-D1-4]$",""),
			"routerSerialNumber"=>new EReg("^SFAA[0-9]{8}$",""),
			"lexId"=>new EReg("^[A-Z0-9]+$",""),
			"oltName"=>new EReg("^[0-9]{2}$",""),
			"status"=>allInclusivEReg,
			"oltObject" => new EReg("^[0-9A-Z_\\-:]+$","")
			];
		var ontSubset:Map<String,EReg> = [
			"ARC_WAN_1_IP4_Gateway" => new EReg("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",""),	
			"ARC_WAN_1_IP6_StaticGateway"=>allInclusivEReg
			];
		var oltSubSet:Map<String,EReg> = [
			"provider" => new EReg('^"provider": "([\\S]+)",$',"")
		];
		var routerSet:Map<String, EReg> = [
			"idStatus"=>new EReg("^[0-9]+$",""),
			"eventdate"=>new EReg("^[0-9]{4}\\-[0-9]{2}\\-[0-9]{2}\\s[0-9]{2}:[0-9]{2}:[0-9]{2}\\.[0-9]+$",""),
			"reachable" => new EReg("^true|false$","i"),
			"tempCpu"=>new EReg("^[0-9.]+$",""),
			"tempTransceiver"=>new EReg("^[0-9.]+$",""),
			"uptime"=>new EReg("^[0-9]+$",""),
			"statusWanmgt"=>new EReg("^true|false$","i"),
			"statusWanhsi"=>new EReg("^true|false$","i"),
			"statusWanvoip"=>new EReg("^true|false$","i"),
			"statusVoiceReg"=>new EReg("^true|false$","i"),
			"nberDectHandset"=>new EReg("[0-9]+",""),
			"statusWifi24g"=>new EReg("^true|false$","i"),
			"statusWifi5g"=>new EReg("^true|false$","i"),
			"cpuUsage"=>new EReg("^[0-9]+$",""),
			"usedMemory"=>new EReg("^[0-9]+",""),
			"statusFwupgrade"=>new EReg("^true|false$","i"),
			"version"=>allInclusivEReg,
			"snBox"=>new EReg("^SFAA[0-9]{8}$",""),
			"snTecrep"=>new EReg("^SFAA[0-9]{8}$",""),
			"rx"=>new EReg("^\\-[0-9.]+$",""),
			"tx"=>new EReg("^[0-9.]+$",""),
			"remoteManagement"=>new EReg("^true|false$","i")
		];
		//var ontConfigSubset = ["otoId","otoPortId","routerSerialNumber","lexId","oltName","status","oltObject"];
		for (j in n)
		{

			if ( mainTopics.indexOf(j) > -1 )
			{
				currentSet = j;
				currentSubSet = "";
				continue;
			}
			else
			{
				var statusEreg:EReg = new EReg('^"status": "([0-9a-zA-Z_]+)"',"");
				var tmpReg = allInclusivEReg;
				//trace(currentSet);
				//trace(currentSubSet);
				//trace(j);
				if (getLangEreg.match(j)){
					//trace(getLangEreg.matched(1));
					dataSet.get("META").set("lang", getLangEreg.matched(2));
				}
				else if (statusEreg.match(j)){
					//trace(statusEreg.matched(1));
					dataSet.get(currentSet).set("status", statusEreg.matched(1));
				}
				else if (currentSet == "Fiber FLL"){
					if (currentSubSet != "")
					{
						tmpReg = fiberFFLSubset.get(currentSubSet);
						if (tmpReg.match(j))
						{
							dataSet.get("Fiber FLL").set(currentSubSet, j);
						}
						currentSubSet = "";
					}
					else if( fiberFFLSubset.exists(j) )
						currentSubSet = j;
				}
				else if (currentSet == "ONT Config TFTP"){
					var tmp = j.split("=");
					if (ontSubset.exists(tmp[0]))
					{
						tmpReg = ontSubset.get(tmp[0]);
						if (tmpReg.match(tmp[1]))
						{
							dataSet.get("ONT Config TFTP").set(tmp[0], tmp[1]);
						}
					}
					
				}
				else if (currentSet == "OLT (nokia/huawei)"){
					var tmp = cleanKey(j).split(":");
					
					if (oltSubSet.exists(tmp[0]))
					{
						//trace(tmp);
						tmpReg = oltSubSet.get(tmp[0]);
						if (tmpReg.match(j))
						{
							dataSet.get("OLT (nokia/huawei)").set(tmp[0], tmpReg.matched(1));
						}
					}
					
				}
				else if (currentSet == "Router"){
					if (j == "") continue;
					var tmp = cleanKey(j).split(":");
					if (tmp.length != 2) continue;
					var key = StringTools.trim(tmp[0]);
					var val = StringTools.trim(tmp[1]);
					//trace(tmp);
					if (routerSet.exists(key))
					{
						tmpReg = routerSet.get(key);
						if (tmpReg.match(val))
						{
							dataSet.get("Router").set(key, val);
						}
						//else{
							//trace('not MATCHED $key $val $tmpReg');
						//}
					}
					//else{
						//trace("not found "+ key);
					//}
					
				}
			}

		}
		//trace(t);
		//for (k => v in dataSet)
		//{
			//trace(k);
			//for (ke => value in v){
				//trace("\t"+ ke, value);
			//}
		//}
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