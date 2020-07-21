package dmcblue.phoneticEnglish;

class Converter {
    static public function convert(mapping:Map<String, String>, input:String): String {
		var output = "";
		var errors = [];
		var maxCharSize = 0;
		for (key in mapping.keys()) {
			maxCharSize = Std.int(Math.max(maxCharSize, key.length));
		}

		var index = 0;
		while (index < input.length) {

			var substring = input.substr(index, maxCharSize);
			while (substring.length > 1 && !mapping.exists(substring)) {
				substring = substring.substr(0, substring.length - 1);
			}

			if (substring.length > 0 && mapping.exists(substring)) {
				output += mapping.get(substring);
			} else {
				errors.push(index);
				output += substring;
			}

			index = index + substring.length;
		}

		return output;
	}
}
