package dmcblue.phoneticEnglish;

import dmcblue.phoneticEnglish.ConfigurationObject;
import dmcblue.phoneticEnglish.Translator;
import utest.Assert;
import utest.Async;
import utest.Test;

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

	public function testResolveCommand() {
		var output = this.translator.translate("hi", ScriptType.GA, ScriptType.PHONETIC);
		Assert.equals("hix", output);
	}
}
