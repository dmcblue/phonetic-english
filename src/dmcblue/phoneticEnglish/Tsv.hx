package dmcblue.phoneticEnglish;

import haxe.io.Eof;

class Tsv {
	public var headers:Array<String>;
	public var rows:Array<Map<String, String>> = [];
	public function new(?headers:Null<Array<String>> = null) {
		if(headers != null) {
			this.headers = headers;
		}
	}

    /**
	 * Fetches the contents of a JSON file and returns them as an object
	 * @param	path The location of the JSON file.
	 * @return	Dynamic Object with the contents.
	 * @throws	JsonParsingError
	 */
	public function load(path:String):Void {
		var object:Array<Array<String>> = [];
		var content:String = "";
		try {
			var fin = sys.io.File.read(path, false);
			while(true) {
				var line = fin.readLine();
				object.push(line.split("\t"));
			}
		} catch(e:Eof) {

		} catch (e:Any) {
			// TODO better error handling
			throw e;
		}

		if(this.headers.length == 0) {
			this.headers = object.shift();
		}

		this.rows = [];
		for(tsvRow in object) {
			var row: Map<String, String> = new Map();
			for(i in 0...this.headers.length) {
				row.set(this.headers[i], tsvRow[i]);
			}

			this.rows.push(row);
		}
	}
}
