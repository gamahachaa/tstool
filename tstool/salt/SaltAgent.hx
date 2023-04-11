package tstool.salt;
import haxe.Json;
import haxe.ds.StringMap;

import roles.Actor;

/**
 * ...
 * @author bbaudry
 */
class SaltAgent extends Actor
{

	public static inline var WINBACK_GROUP_NAME:String = "WINBACK";
	public static inline var CSR1_GROUP_NAME:String = "TS_TOOL_CSR1";
	public static inline var CSR2_GROUP_NAME:String = "TS_TOOL_CSR2";
	/**
	 * @todo refactor the whole role to quality roles (extending xapi)
	 * @param	actor
	 * @return
	 */
	static public function DECORATE(actor: Actor ):SaltAgent
	{

		return new SaltAgent(
		{
			mail : actor.iri,
			samaccountname : actor.sAMAccountName,
			givenname : actor.firstName,
			sn : actor.sirName,
			mobile : actor.mobile,
			company : actor.company,
			l : actor.workLocation,
			division : actor.division,
			directreports : actor.directReports,
			accountexpires : actor.accountExpires,
			msexchuserculture : actor.mainLanguage,
			title : actor.title,
			initials : actor.initials,
			memberof : actor.memberOf
		}
		);
	}
	public static function CREATE_DUMMY():SaltAgent
	{
		return new SaltAgent(
		{
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
		}
		);
	}
	/*static public function FROM_ROLES_ACTOR(actor: Actor ):SaltAgent
	{
		return new SaltAgent(
		{
			authorised: actor.authorised,
			attributes : {
				mail : actor.iri,
				samaccountname : actor.sAMAccountName,
				givenname : actor.firstName,
				sn : actor.sirName,
				mobile : actor.mobile,
				company : actor.company,
				l : actor.workLocation,
				division : actor.division,
				directreports : actor.directReports,
				accountexpires : actor.accountExpires,
				msexchuserculture : actor.mainLanguage,
				title : actor.title,
				initials : actor.initials,
				memberof : actor.memberOf
			}
		}
		);
	}*/
	public function new(?jsonUser:Dynamic=null)
	{
		super(jsonUser, true);
	}
	public function addGroupAsMemberOf(groupName:String)
	{
		if (memberOf == null) memberOf = [];
		if (!isMember(groupName))
		{
			memberOf.push(groupName);
		}
	}
	public function removeGroupAsMember(groupName:String)
	{
		if (memberOf == null) return;
		if (isMember(groupName))
		{
			this.memberOf.remove(groupName);
		}
	}
	public function removeAllTSToolGroups()
	{
		removeGroupAsMember(SaltAgent.CSR1_GROUP_NAME);
		removeGroupAsMember(SaltAgent.CSR2_GROUP_NAME);
		removeGroupAsMember(SaltAgent.WINBACK_GROUP_NAME);
	}

	/**
	 * @todo move it too many dependencies
	 * @param	start
	 * @param	end
	 */
	public function buildTSEmailBody(start:Date,end:Date)
	{
		//var start:Date = Main.HISTORY.getFirst().start;
		//var end:Date = Main.HISTORY.getLast().start;
		var ul:String = this.buildEmailBody();
		var seconds = Math.floor( (end.getTime() - start.getTime()) / 1000 );
		var durationMinutes = Math.floor (seconds / 60);
		var durationSeconds = seconds % 60;
		var bodyList = '<li>Script version : ${Main.VERSION} </li>';
		bodyList += '<li>Started: ${start.toString()}, ended: ${end.toString()} ( ~ ${durationMinutes}&prime; ${durationSeconds}&Prime;)</li>';
		ul = StringTools.replace(ul,"</ul>", bodyList + "</ul>");
		return '<h5>Done in $mainLanguage by:</h5>$ul';
	}
}