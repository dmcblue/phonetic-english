package dmcblue.phoneticEnglish;
import dmcblue.phoneticEnglish.Converter;

import utest.Assert;
import utest.Async;

typedef ConvertTest = {
	var expected:String;
	var value:String;
}

class ConverterTest extends utest.Test {
	function testConvert() {
		var mapping:Map<String, String> = [
			"a" => "α",
			"Ou" => "Ξ",
			"O" => "Ω",
			"u" => "υ"
		];
		var tests:Array<ConvertTest> = [{
			expected: "Ωα",
			value: "Oa"
		}, {
			expected: "bαd", 
			value: "bad"
		}, {
			expected: "bαd Ξd", 
			value: "bad Oud"
		}];

		for(test in tests) {
			Assert.equals(
				test.expected,
				Converter.convert(mapping, test.value)
			);
		}
	}
}
