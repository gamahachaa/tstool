package tstool.layout;

import tstool.process.Descision;

/**
 * ...
 * @author bb
 */
class TestLayout extends Descision 
{

	override public function create()
	{
		this._titleTxt = "Test title\nbllou";
		this._detailTxt = "Test title\nbllou\nTest title\nbllou\nTest title\nbllou\nTest title\nbllou\nTest title\nbllou\nTest title\nbllou\nTest title\nbllou";
		this._illustration = "Intro_new";
		this._buttonNoTxt = "Balsh blah blah blah blah blah"; 
		this._buttonYesTxt = "Balsh blah blah blah blah blah";
		this._qook = "http://qook.salt.ch";
		super.create();
	}
	
}