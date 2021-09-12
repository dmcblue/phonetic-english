package dmcblue.phoneticEnglish;

using StringTools;

class Converter {
	static public function fromTsv(tsv:Tsv, from:String, to:String) {
		return new Converter(Converter.tsvToMapping(tsv, from, to));
	}

	static private function tsvToMapping(tsv:Tsv, from:String, to:String):Map<String, String> {
		var mapping:Map<String, String> = new Map();
		for(row in tsv.rows) {
			mapping.set(
				row.get(from).toLowerCase().trim(),
				row.get(to).toLowerCase().trim()
			);
		}

		return mapping;
	}

	public var mapping:Map<String, String>;
	public function new(mapping:Map<String, String>) {
		this.mapping = mapping;
	}

    public function convert(input:String): String {
		return this.mapping.get(input);
	}

    public function convertEach(input:Array<String>): Array<String> {
		var output: Array<String> = [];

		for(str in input) {
			output.push(this.mapping.get(str));
		}

		return output;
	}
}
