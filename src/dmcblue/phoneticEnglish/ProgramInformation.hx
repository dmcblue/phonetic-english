package dmcblue.phoneticEnglish;

using interealmGames.common.StringToolsExtension;

import dmcblue.phoneticEnglish.Application;
/**
 * Displays the information of this program
 */
class ProgramInformation 
{
	static public var PROGRAM_INFORMATION = "PhonEng v%s for %s
For more information, go to: https://github.com/dmcblue/phonetic-english/
";
	static public function display() 
	{
		var platform = Sys.systemName();
		var version = Application.VERSION;
		
		Sys.println(StringTools.format(ProgramInformation.PROGRAM_INFORMATION, [version, platform]));
	}
}
