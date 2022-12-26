package dmcblue.phoneticEnglish;

import dmcblue.phoneticEnglish.Translator.TextNode;
import dmcblue.phoneticEnglish.ScriptType;
import dmcblue.phoneticEnglish.ConfigurationObject;
import dmcblue.phoneticEnglish.Translator;
import utest.Assert;
import utest.Async;
import utest.Test;

typedef SplitTextTest = {
	input:String,
	output:Array<String>
}

typedef TranslateTest = {
	input:String,
	output:String,
	from: ScriptType,
	to: ScriptType
}

class TranslatorTest extends Test {
	var translator:Translator;
	public function setupClass():Void {
		var basePath = haxe.io.Path.join([Sys.getCwd(), 'mappings']);
		var configurationObject:ConfigurationObject = {
			conversionPath: haxe.io.Path.addTrailingSlash(basePath),
			version: Application.VERSION
		};
		var configuration:Configuration = new Configuration(configurationObject);
		this.translator = new Translator(configuration);
	}

	public function testSplitText() {
		var tests:Array<SplitTextTest> = [{
			input: "it's", output: ["it's"]
		}];

		for(test in tests) {
			var output = this.translator.splitText(test.input)
				.map(function(node:TextNode) {
					return node.text;
				});
			Assert.equals(test.output.length, output.length);
			for(i in 0...output.length) {
				Assert.equals(test.output[i], output[i]);
			}
		}
	}

	public function testTranslate() {
		var tests:Array<TranslateTest> = [{
			input: "hi", output: "hix", from: ScriptType.GA, to: ScriptType.PHONETIC
		}, {
			input: "eBook", output: "exbok", from: ScriptType.GA, to: ScriptType.PHONETIC
		}, {
			input: "it's", output: "it's", from: ScriptType.GA, to: ScriptType.PHONETIC
		}, {
			input: "I won't sing", output: "ix woxnt sing", from: ScriptType.GA, to: ScriptType.PHONETIC
		}, {
			input: '“It’s so dreadful to be poor!”', output: "“it\'s sox dredful tux bex puxr!”", from: ScriptType.GA, to: ScriptType.PHONETIC
		}, {
			input: 'unladylike', output: "unlaydexlixk", from: ScriptType.GA, to: ScriptType.PHONETIC
		}];
		for(test in tests) {
			var output = this.translator.translate(test.input, test.from, test.to);
			Assert.equals(test.output, output);
		}
	}
}
