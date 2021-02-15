package tstool.process;
import tstool.layout.History.Interactions;
import tstool.layout.UI;
import tstool.salt.SOTemplate;
import tstool.salt.TemplateMail;
import tstool.utils.ExpReg;
import tstool.utils.SwiftMailWrapper.Result;

/**
 * ...
 * @author bb
 */
class TripletTemplate extends TripletMultipleInput 
{
	var soTemplate:SOTemplate;
	static inline var EMAIL_INPUT:String = "email";
	static inline var MSISDN_INPUT:String = "msisdn";
	var mail:TemplateMail;
	var clicked:Interactions;
	var mobileReg:EReg;

	public function new (soTemplate:SOTemplate)
	{
		mobileReg = new EReg(ExpReg.MISIDN_UNIVERAL, "i");
		super(
		[{
			ereg: new EReg(ExpReg.EMAIL,"i"),
			input:{
				width:250,
				prefix: EMAIL_INPUT,
				position: [bottom, left],
				mustValidate: [No, Yes]
			}
		},
		{
			ereg: mobileReg,
			input:{
				width:250,
				prefix: MSISDN_INPUT,
				buddy: EMAIL_INPUT,
				position: [bottom, left],
				mustValidate: [Mid, Yes]
			}
		}
		]
		);
		
		clicked = Mid;
		this.soTemplate = soTemplate;
		mail = new TemplateMail(soTemplate, this);
	}
	override public function create():Void{
		super.create();
		
		
		if (Main.customer.contract != null && Main.customer.contract.user != null && Main.customer.contract.user.iri.indexOf("@") > -1)
		{
			multipleInputs.setInputDefault(EMAIL_INPUT, Main.customer.contract.user.iri);
		}
		else if (Main.customer.contract != null && Main.customer.contract.user != null && Main.customer.contract.owner.iri.indexOf("@") > -1)
		{
			multipleInputs.setInputDefault(EMAIL_INPUT, Main.customer.contract.owner.iri);
		}
		else if (Main.customer.contract != null &&  Main.customer.contract.user != null && Main.customer.contract.payer.iri.indexOf("@") > -1)
		{
			multipleInputs.setInputDefault(EMAIL_INPUT, Main.customer.contract.payer.iri);
		}
		if (Main.customer.contract != null && mobileReg.match(Main.customer.contract.mobile))
		{
			multipleInputs.setInputDefault(MSISDN_INPUT, Main.customer.contract.mobile);
		}
	}
	function getNext():Class<Process>{
		return null;
	}
	/****************************
	* Needed for validation
	*****************************/
	override public function onYesClick():Void
	{
		//Both
		if (validateYes())
		{
			mail.setTemplateSubject(BOTH, multipleInputs.getText(MSISDN_INPUT), multipleInputs.getText(EMAIL_INPUT));
			
			send();
			this.clicked = Yes;
		}
	}
	/*
	override public function validateYes():Bool
	{
		return true;
	}
	*/
	
	override public function onNoClick():Void
	{
		//email
		if (validateNo())
		{
			mail.setTemplateSubject(EMAIL, multipleInputs.getText(MSISDN_INPUT), multipleInputs.getText(EMAIL_INPUT));
			send();
			this.clicked = No;
		}
	}
	/*
	override public function validateNo():Bool
	{
		return true;
	}
	*/
	override public function onMidClick():Void
	{
		//SMS
		if (validateMid())
		{
			mail.setTemplateSubject(SMS, multipleInputs.getText(MSISDN_INPUT), multipleInputs.getText(EMAIL_INPUT));
			send();
			this.clicked = Mid;
		}
	}
	function clickListener()
	{
		this._nexts = [{step: getNext(), params: []}];
		switch (clicked)
		{
			case Yes: super.onYesClick();
			case No: super.onNoClick();
			case Mid: super.onMidClick();
			case _: return;
			
		}
	}
	function send()
	{
		
		#if debug
		trace("tstool.process.ActionMail::onClick");
		openSubState(new TicketSendSub(UI.THEME.bg));
		mail.successSignal.addOnce(onMailSuccess);
		mail.build( "<h1>Super Office Template</h1>" );
		mail.send();
		
		#else
		openSubState(new TicketSendSub(UI.THEME.bg));
		mail.successSignal.addOnce(onMailSuccess);
		mail.build( "<h1>Super Office Template</h1>" );
		mail.send();
		#end
	}
	
	function onMailSuccess(parameter0:Result):Void 
	{
		#if debug
		trace("tstool.process.TripletTemplate::onMailSuccess::parameter0", parameter0 );
		#end
	}
	/*
	override public function validateMid():Bool
	{
		return true;
	}
	*/
	
}