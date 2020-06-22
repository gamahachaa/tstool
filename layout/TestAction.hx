package tstool.layout;

import tstool.process.Action;

/**
 * ...
 * @author bb
 */
class TestAction extends Action 
{

	override public function create()
	{
		this._detailTxt = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.";
		this._titleTxt = "Lorem Ipsum is simply dummy text of the printing and typesetting industry.";
		this._illustration = "Intro_new";
		this._qook = "https://qook.salt.ch";
		super.create();
		
	}
	
}