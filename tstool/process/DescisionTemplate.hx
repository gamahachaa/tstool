package tstool.process;
import tstool.layout.History.Interactions;
import tstool.layout.UI;
import tstool.process.MultipleInput.ValidatedInputs;
import tstool.salt.SOTemplate;
import tstool.salt.TemplateMail;
import tstool.utils.ExpReg;
import tstool.utils.StringUtils;
import tstool.utils.SwiftMailWrapper.Result;
import tstool.layout.IPositionable.Direction;

/**
 * ...
 * @author bb
 */

class DescisionTemplate extends DescisionMultipleInput
{
	var soTemplate:SOTemplate;
	static inline var EMAIL_INPUT:String = "email";
	static inline var MSISDN_INPUT:String = "msisdn";
	var mail:TemplateMail;
	var clicked:Interactions;
	var mobileReg:EReg;
	var fields:TemplateStyle;

	public function new (soTemplate:SOTemplate, ?fields:TemplateStyle=BOTH)
	{
		this.fields = fields;
		mobileReg = new EReg(ExpReg.MISIDN_UNIVERAL, "i");
		var f:Array<ValidatedInputs> = [];
		if (fields == BOTH || fields == EMAIL)
		{
			f.push(
			{
				ereg: new EReg(ExpReg.EMAIL,"i"),
				input:{
					width:250,
					prefix: EMAIL_INPUT,
					position: [bottom, left],
					mustValidate: [Yes]
				}
			}
			);
		}
		if (fields == BOTH || fields == SMS)
		{
			f.push(
			{
				ereg: mobileReg,
				input:{
					width:250,
					prefix: MSISDN_INPUT,
					buddy: fields == BOTH ? EMAIL_INPUT:null,
					position: [bottom, left],
					mustValidate: [Yes]
				}
			}
			);
		}
		super(f);

		clicked = Mid;
		this.soTemplate = soTemplate;
		mail = new TemplateMail(soTemplate, this);
	}
	override public function create():Void
	{
		super.create();
		if (fields == BOTH || fields == EMAIL)
		{
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
			
		}
		if ((fields == BOTH || fields == SMS) && (Main.customer.contract != null && mobileReg.match(Main.customer.contract.mobile)))
		{
			multipleInputs.setInputDefault(MSISDN_INPUT, Main.customer.contract.mobile);
		}
	}
	function getNext():Class<Process>
	{
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
			mail.setTemplateSubject(fields, StringUtils.removeWhite(multipleInputs.getText(MSISDN_INPUT)), StringUtils.removeWhite(multipleInputs.getText(EMAIL_INPUT)));

			send();
			//super.onYesClick();

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
			//mail.setTemplateSubject(EMAIL, StringUtils.removeWhite(multipleInputs.getText(MSISDN_INPUT)), StringUtils.removeWhite(multipleInputs.getText(EMAIL_INPUT)));
			//send();
			super.onNoClick();
			//this.clicked = No;
		}
	}
	/*
	override public function validateNo():Bool
	{
		return true;
	}
	*/
	/*override public function onMidClick():Void
	{
		//SMS
		if (validateMid())
		{
			mail.setTemplateSubject(SMS, StringUtils.removeWhite(multipleInputs.getText(MSISDN_INPUT)), StringUtils.removeWhite(multipleInputs.getText(EMAIL_INPUT)));
			send();
			//super.onMidClick();
			this.clicked = Mid;
		}
	}*/
	function clickListener()
	{
		this._nexts = [ {step: getNext(), params: []}];
		switch (clicked)
		{
			case Yes: super.onYesClick();
			case No: super.onNoClick();
			//case Mid: super.onMidClick();
			case _: return;
		}
	}
	function send()
	{
		this.multipleInputs.showAll(false); // hide input fields before sending as they are below mouse
		#if debug
		trace("tstool.process.ActionMail::onClick");
		openSubState(new TemplateSendSub());
		mail.successSignal.addOnce(onMailSuccess);
		mail.build( '<h1>S.O Template</h1> <h2>${soTemplate.desc}</h2><p>to:</p>' );
		mail.send();

		#else
		openSubState(new TemplateSendSub());
		mail.successSignal.addOnce(onMailSuccess);
		mail.build( '<h1>S.O Template</h1> <h2>${soTemplate.desc}</h2><p>to:</p>' );
		mail.send();
		#end
	}

	function onMailSuccess(data:Result):Void
	{
		#if debug
		trace("tstool.process.TripletTemplate::onMailSuccess::parameter0", data );
		#end
		closeSubState();
		switch data.status {
		case "success" : clickListener();
			case "failed" : openSubState(new DataView(UI.THEME.bg, this._name, '\nFailed to create the ticket !!!\n\nPlease do a print screen of this and send it to qook@salt.ch\n+${data.error} (${data.additional}). Also make note of the steps and send the same S.O. ${soTemplate.desc} tempalte manually '));
		}
	}
	function onMailError(parameter0:Dynamic):Void
	{
		#if debug
		trace("tstool.process.ActionMail::onMailError::onMailError", parameter0 );
		#end
		closeSubState();
	}
	function onMailStatus(parameter0:Int):Void
	{
		closeSubState();
		if (parameter0 != 200) openSubState(new DataView(UI.THEME.bg, this._name, '\n\nhttp status $parameter0, \n\nCould not send the template !!!\nPlease do a print screen of this and send it to qook@salt.ch STATUS ${parameter0} . \nAlso make note of the steps and send the same S.O. ${soTemplate.desc} tempalte manually '));
	}
	/*
	override public function validateMid():Bool
	{
		return true;
	}
	*/

}