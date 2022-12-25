package dmcblue.phoneticEnglish;

import utest.Runner;
import utest.ui.Report;
import dmcblue.phoneticEnglish.TranslatorTest;

/**
 * All tests for this package
 */
class Test {
	public static function main() {
		var runner:Runner = new Runner();
		runner.addCase(new TranslatorTest());
		Report.create(runner);
		runner.run();
	}
}
