package tstool.salt;
import tstool.process.Actor;

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
	public var shipingAdress(get, set):Adress;
	public var voIP(get, set):String;
	public static inline var TEST_IRI:String = "not found";
	public function new() 
	{
		super(TEST_IRI, true); // for now customers are authorized
		contract = new Contractor(TEST_IRI, "");
		dataSet = [];
	}
	public function reset()
	{
		this.contract.reset();
		this.shipingAdress = null;
		this.iri = TEST_IRI;
		this.dataSet = [];
		//this.voIP = "";
	}
	public function isInitial()
	{
		return TEST_IRI == this.iri;
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
	
	function set_contract(value:Contractor):Contractor 
	{
		//this.iri = value.contractorID==""?TEST_IRI:value.contractorID;
		//this.voIP = value.voip;
		return contract = value;
	}
	
}