package tstool.salt;
import roles.Actor;
import string.StringUtils;
//import tstool.process.Actor;
using StringTools;
/**
 * ...
 * @author bbaudry
 */
enum CustomerProcess{
	unknown;
	firstCall;
	recaller;
}

class Customer extends Actor
{
	@:isVar public var dataSet(get, set):Map<String,Map<String,String>>;
	@:isVar public var contract(get, set):Contractor;
	@:isVar public var shipingAdress(get, set):Adress;
	public var voIP(get, set):String;
	@:isVar public var indexer(get, set):String;
	public static inline var TEST_IRI:String = "not found";
	public function new() 
	{
		super(TEST_IRI, true); // for now customers are authorized
		contract = new Contractor(TEST_IRI, "");
		dataSet = [];
	}
	override public function reset()
	{
		super.reset();
		this.contract.reset();
		this.contract = new Contractor(TEST_IRI, "");
		this.shipingAdress = null;
		this.iri = TEST_IRI;
		for (k => i in dataSet)
		{
			for (j in i)
			{
				i.remove(j);
			}
			dataSet.remove(k);
		}
		this.dataSet = [];
		this.voIP = "";
	}
	public function isInitial()
	{
		return TEST_IRI == this.iri;
	}
	
	public function buildCustomerBody(addMobileContact:Bool)
	{
		var  b = '<h2>';
		try
		{
			//var isFiber = false;
			#if debug
			trace(this.get_voIP());
			trace(this);
			#else
			
			#end
			if (contract.contractorID != null && contract.contractorID != "" && contract.contractorID != Customer.TEST_IRI){
				//b += 'ID: <a href="https://vti.salt.ch/index.php?module=Contractors&action=BasicAjax&mode=redirectToContractor&phone=${voIP}">${contract.contractorID}</a><br/>';
				if(Main.customer.contract.fix != null && Main.customer.contract.fix.trim()!="")
				b += 'ID: ${StringUtils.buildVtiProneLink(contract.fix, contract.contractorID)}<br/>';
				else
					b += 'ID: ${contract.contractorID}';
			}
			else{
				b += 'ID: ${iri}<br/>';
			}
			if(voIP !="")
				b += 'MSISDN-VoIP: ${voIP}<br/>';
			b += '</h2>';
			// 
			if(contract.mobile !="" && addMobileContact )
				b += '<h3>CONTACT: ${contract.mobile}</h3>';
			b += "<p>";
			if(contract.owner != null && contract.owner.name !=null && contract.owner.name !="")
				b += '${contract.owner.name}<br/>';
			if (shipingAdress != null && shipingAdress._zip != "")
			{
				if (shipingAdress._co != "")
				{
					b += 'c/o: ${shipingAdress._co}<br/>';
				}
				b += '${shipingAdress._street}, ${shipingAdress._number}<br/>';
				b += '<strong>${shipingAdress._zip}</strong> ${shipingAdress._city}';	
			}
			b += "</p>";
		}
		catch (e:Dynamic)
		{
			trace(e);
		}
		return b;
	}
	public function getOwner()
	{
		return if (this.contract.owner == null || this.contract.owner.name== null){
			"";
		}else{
			this.contract.owner.name;
		}
	}
	function get_shipingAdress():Adress 
	{
		return this.contract.address;
	}
	
	function set_shipingAdress(value:Adress):Adress 
	{
		return this.contract.address = value;
	}
	
	function get_voIP():String 
	{
		return this.contract.voip;
	}
	
	function set_voIP(value:String):String 
	{
		return this.contract.voip = StringTools.trim(value);
	}
	
	function get_contract():Contractor 
	{
		return contract;
	}
	
	function get_dataSet():Map<String, Map<String, String>> 
	{
		return dataSet;
	}
	
	function set_dataSet(value:Map<String, Map<String, String>>):Map<String, Map<String, String>> 
	{
		return dataSet = value;
	}
	
	function get_indexer():String 
	{
		return indexer;
	}
	
	function set_indexer(value:String):String 
	{
		return indexer = value;
	}
	
	function set_contract(value:Contractor):Contractor 
	{
		//this.iri = value.contractorID==""?TEST_IRI:value.contractorID;
		//this.voIP = value.voip;
		return contract = value;
	}
	
}