package dmcblue.phoneticEnglish;

import thx.csv.Tsv in TsvParser;

class Tsv {
    public function loadTsvFile(path:String):Null<Dynamic> {
		
		var object = null;
		try {
			var content:String = sys.io.File.getContent(path);
			trace(content);
			object = Tsv.decode(content);
		} catch (e:Any) {
			//throw new JsonParsingError(path, e);
			trace(e);
			throw e;
		}
		
		return content;
	}
}
