package dmcblue.phoneticEnglish;

using StringTools;

class Converter {
	static public var NULL = '�';
	static public var PUNCTUATION = ["'", "’"];

	static public function fromTsv(tsv:Tsv, from:String, to:String) {
		return new Converter(Converter.tsvToMapping(tsv, from, to));
	}

	static private function tsvToMapping(tsv:Tsv, from:String, to:String):Map<String, String> {
		var mapping:Map<String, String> = new Map();
		for(row in tsv.rows) {
			if(row.get(from) != null && row.get(to) != null) {
				mapping.set(
					row.get(from).toLowerCase().trim(),
					row.get(to).toLowerCase().trim()
				);
			} else {
				break;
			}
		}

		return mapping;
	}

	public var mapping:Map<String, String>;
	public function new(mapping:Map<String, String>) {
		this.mapping = mapping;
	}

    public function convert(input:String): String {
		if (this.mapping.exists(input)) {
			return this.mapping.get(input);
		} else if (Converter.PUNCTUATION.contains(input)) {
			return input;
		} else {
			return Converter.NULL;
		}
	}

    public function convertEach(input:Array<String>): Array<String> {
		var output: Array<String> = [];

		for(str in input) {
			output.push(this.convert(str));
		}

		return output;
	}
}
