package tstool.layout;
import firetongue.Replace;
import flixel.FlxG;
import flixel.FlxSprite;
//import flixel.FlxState;
import flixel.text.FlxText;
import tstool.layout.Question;
//import tstool.process.types.INamableClass;


/**
 * ...
 * @author bb
 */
class Alert extends ClosableSubState
{
	var text:String;
	
	var scriptTextField :FlxText;
	//var message:String;
	var hasIllustration:Bool;
	var question:tstool.layout.Question;
	var details:flixel.text.FlxText;
	var illustration:flixel.FlxSprite;
	var _titleTxt(default, default):String = "";
	var _detailTxt(default, default):String = "";
	var _illustration(default, default):String = "";
	public var _name(get, null):String;
	public var _class(get, null):Class<Alert>;
	public function new(message:Map<String,String>)
	{
		super (SaltColor.BLACK);
		_class = Type.getClass(this);
		_name = Type.getClassName(_class);
		//this.message = message;
		
		_titleTxt = MainApp.translator.translate(_name, _titleTxt, "TITLE");
		_detailTxt = MainApp.translator.translate(_name, _detailTxt, "DETAILS");
		_detailTxt = Replace.flags(_detailTxt, [for (i in message.keys()) i], [for (i in message) i]);
		_illustration = MainApp.translator.translate(_name, _illustration, "ILLUSTRATION");
		#if debug
		trace('tstool.layout.Alert::Alert::_illustration ${_illustration}');
		#end
		hasIllustration = _illustration != "";
	}
	
	
	
	override public function create():Void
	{
		//scriptTextField = new FlxText(UI.PADDING,UI.PADDING,FlxG.width-(UI.PADDING*2),this.message, UI.BASIC_FMT.size +8, true);
		//scriptTextField.setFormat( UI.BASIC_FMT.font, UI.BASIC_FMT.size);
		//add(scriptTextField);
		
		question = new Question(0, 0, 1000, _titleTxt, 24, true);
		question.setFormat( UI.TITLE_FMT.font, UI.TITLE_FMT.size);
		details = new FlxText(0, 0,  FlxG.width, _detailTxt, 16 , true);
		details.autoSize = question.autoSize = false;
		details.setFormat( UI.BASIC_FMT.font, UI.BASIC_FMT.size );
		illustration = new FlxSprite(0, 0);
		illustration.visible = hasIllustration;
		super.create();
		add(question);
		add(details);
		if (hasIllustration) {
			illustration.loadGraphic("assets/images/" + _illustration + ".png");
			add(illustration);
		}
		illustration.x = details.x  = question.x = UI.PADDING *2;
		question.y = UI.PADDING * 2;
		details.y = question.y + question.height + UI.PADDING;
		illustration.y = details.height + details.y + UI.PADDING;
		
		
		//scriptTextField.applyMarkup(_detailTxt, [UI.THEME.basicEmphasis, UI.THEME.basicStrong]);
		
	}
	function get__name():String 
	{
		return _name;
	}
	
	function get__class():Class<Alert> 
	{
		return _class;
	}
}