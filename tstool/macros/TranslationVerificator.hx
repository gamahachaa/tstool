package tstool.macros;

import Sys;
import haxe.ds.StringMap;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
using Lambda;
using StringTools;
/**
 * ...
 * @author bb
 */

typedef Translations = {
	var flag:String; // the class name preceeded by a $
	var file:String; // the file where the translation is stored
	var line:Int; // the line where the translation is stored
}
class TranslationVerificator
{

	public static function test(skips:Array<String>)
	{
		var cwd:String = Sys.getCwd();
		var localesSrcFolder = Path.join([cwd, "assets", "locales"]);
		var classFolder = Path.join([cwd, "source"]);
		var locales = recurse(localesSrcFolder, "txt");
		var classes = recurse(classFolder, "hx");
		var relativesClasses = classes.map((item)->(return item.replace(classFolder + "/","").replace("/",".").replace(".hx","") ));

		var localeMap = new StringMap<Array<Translations>>();
		var mainPath = "";
		// map of langs with all the keys 
		//Sys.println(locales);
		for (i in locales)
		{
			mainPath = Path.directory(i);
			if (localeMap.exists(mainPath))
			{
				localeMap.set(mainPath, localeMap.get(mainPath).concat(readFlags(i)));
			}
			else{
				 localeMap.set(mainPath,readFlags(i));
			}
		}
		// look in all local map
		Sys.println("    SEARCH FOR UNUSED TRANSLATIONS -----------");
		var lang = "";
		for (k1=>v1 in localeMap)
		{
			lang = k1.split("/").pop();
			Sys.println("         "+ lang +" -----------");
			for (k2=>v2 in v1)
			{
				if (!relativesClasses.exists((e)->(return e == v2.flag)))
				{
					Sys.println(v2.flag + " flag has no matching class. see file:///" + k1 +"/" + Path.withoutDirectory(v2.file) + " line:" + v2.line);
				}
				
				
			}
			Sys.println("         Classe not translated in that language ("+lang+")-----------");
			relativesClasses.foreach(
				function (e){
					if (!v1.exists((item)->(return item.flag == e)) && !skips.contains(e))
					{
						Sys.println(e + " NOT FOUND in " + lang);
					}
					return true;
				}
			);
			
		}
	}
	static function recurse(sourceDir:String, ext:String)
	{
		var t = [];
		var dir = FileSystem.readDirectory(sourceDir);
		dir = dir.filter(filter);
		
		for (entry in dir )
		{
			var child:String = Path.join([sourceDir, entry]);
			if (FileSystem.isDirectory(child)  )
			{
				t = t.concat(recurse(child,ext));
			}
			else if (Path.extension(child) == ext)
			{
				t.push(child);
			}
		}
		return t;
	}
	static function filter(s:String)
	{
		var skips = ["_icon", "meta", "header", ".xml"];
		return skips.find((item)->(return s.indexOf(item) > -1)) == null;
	}
	static function readFlags(path:String)
	{
		var t = [];
		var stream = File.read(path, false);
		//var e:EReg = new EReg("^\\$([a-zA-Z][_.a-zA-Z]+","g");
		var e:EReg = ~/^\$([a-zA-Z_][_.a-zA-Z0-9]+)/g;
		var line = 1;
		try
		{
			while (true)
			{
                var l = stream.readLine(); 
				//Sys.println(l);
				if (e.match(l))
				{
					t.push({flag: e.matched(1), line: ++line, file: path});
				}
				//else{
					//Sys.println("no match");
				//}
			}
		}
		catch (e)
		{
			//Sys.println("reading ended "+e);
		}
		return t;
	}

}