package tstool.salt.products;

/**
 * ...
 * @author bb
 */
enum Brand{
	sagem;
	arcadyan;
}
class Product 
{
	var _brand:Brand;
	var _id:String;
	var _name:String;
	public function new(brand:Brand, name:String, ?id:String="") 
	{
		_brand = brand;
		_id = id;
		_name =name ;
	}
}