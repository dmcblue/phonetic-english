package dmcblue.phoneticEnglish;

using interealmGames.common.StringToolsExtension;

import haxe.io.Path;
import dmcblue.phoneticEnglish.Application;

/**
 * Manages display of Help messages
 */
class Help 
{
	static private var HELP_TEXT = "
Usage: %s [-h | --help] [-v | --version] <INPUT_TYPE> <OUTPUT_TYPE> <INPUT>

General Options:
  -%s, --%s: Displays program information
  -%s, --%s: Displays the program version information
  -%s, --%s: Path to the config file

Input/Output Types:
  %s - ARPAbet, 1 letter format
  %s - ARPAbet, 2 letter format
  %s - IPA format
  %s - General American, a standard for pronunciaiton used in the United States
  %s - The Phonetic English spelling system

%s init: Creates a base config and download the necessary dictionaries
";
	
	static public function display() {
		var path = new Path(Sys.programPath());
		var executableName = path.file;
		
		// In Neko, the filename is missing => https://github.com/HaxeFoundation/haxe/issues/5708
		if (executableName.length == 0) {
			executableName = 'phoneng';
		}
		var helpText = StringTools.format(Help.HELP_TEXT, [
      executableName,
      Application.OPTION_VERSION_SHORT,
      Application.OPTION_VERSION,
      Application.OPTION_HELP_SHORT,
      Application.OPTION_HELP,
      Application.OPTION_CONFIG_SHORT,
      Application.OPTION_CONFIG,
      Application.TYPE_ARPA1,
      Application.TYPE_ARPA2,
      Application.TYPE_IPA,
      Application.TYPE_GA,
      Application.TYPE_PHONETIC,
			executableName
    ]);
		Sys.println(helpText); // Sys not Log
	}
}
