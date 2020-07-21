package dmcblue.phoneticEnglish;

import sys.FileSystem;
import haxe.io.Path;
import Math;
import interealmGames.common.commandLine.OptionSet;
// import interealmGames.opentask.errors.FileDoesNotExistError;
// import interealmGames.opentask.errors.GroupDoesNotExistError;
import dmcblue.phoneticEnglish.errors.InvalidTypeError;
// import interealmGames.opentask.errors.InvalidConfigurationError;
// import interealmGames.opentask.errors.InvalidLocalConfigurationError;
// import interealmGames.opentask.errors.MissingArgumentError;
// import interealmGames.opentask.errors.MissingCommandError;
// import interealmGames.opentask.errors.TaskDoesNotExistError;
import interealmGames.common.commandLine.CommandLine;
// import interealmGames.opentask.Configuration;
import dmcblue.phoneticEnglish.Configuration;
import dmcblue.phoneticEnglish.ConfigurationObject;
import dmcblue.phoneticEnglish.errors.BaseError;
import dmcblue.phoneticEnglish.errors.JsonParsingError;
import dmcblue.phoneticEnglish.errors.InvalidNumberOfParametersError;
import thx.csv.Tsv;
// import interealmGames.opentask.Help;MissingParametersError
// import interealmGames.opentask.ProgramInformation;
// import interealmGames.opentask.Log;

/**
 * The program logic
 */
class Application 
{
	/**
	 * Command line arguments for various actions
	 */
	static public var TYPE_IPA = "ipa";
	static public var TYPE_RP = "rp";
	static public var TYPE_GA = "ga";
	static public var TYPE_PHONETIC = "ph";
	static public var TYPE_ARPA1 = "arpa1";
	static public var TYPE_ARPA2 = "arpa2";
	static public var TYPES:Array<String> = [
		Application.TYPE_GA,
		Application.TYPE_IPA,
		Application.TYPE_PHONETIC,
		Application.TYPE_RP,
		Application.TYPE_ARPA1,
		Application.TYPE_ARPA2
	];
	
	/**
	 * Command line options
	 */
	static public var OPTION_CONFIG = "config";
	static public var OPTION_CONFIG_SHORT = "c";
	static public var OPTION_HELP = "help";
	static public var OPTION_HELP_SHORT = "h";
	static public var OPTION_VERSION = "version";
	static public var OPTION_VERSION_SHORT = "v";
	
	/**
	 * Current Application Version
	 */
	static public var VERSION = "0.1.0";

	public function new() 
	{
		try {
			var options = CommandLine.getOptions();
			var arguments = CommandLine.getArguments();
			
			if (options.hasShortOption(Application.OPTION_HELP_SHORT) || options.hasLongOption(Application.OPTION_HELP)) {
				Help.display();
				this.end();
			}
			
			if (options.hasShortOption(Application.OPTION_VERSION_SHORT) || options.hasLongOption(Application.OPTION_VERSION)) {
				ProgramInformation.display();
				this.end();
			}

			var configuration = this.getConfiguration(options);
			
			//arguments[0] is the PhonEng application
			if (arguments.length != 4) {
				throw new InvalidNumberOfParametersError(4, arguments.length);
			}

			var inputType = arguments[1];
			var outputType = arguments[2];
			var input = arguments[3];
			
			if (Application.TYPES.indexOf(inputType) == -1) {
				throw new InvalidTypeError(inputType);
			}

			if (Application.TYPES.indexOf(outputType) == -1) {
				throw new InvalidTypeError(outputType);
			}

			if (inputType != Application.TYPE_IPA) {
				// convert to IPA
				if (inputType == Application.TYPE_GA) {
					// convert GA to ARPA
					// Get dictionary
					// convert from dictionary
					var c = this.loadTsvFile("/home/dmcblue/repos/phonetic-english/mappings/dict.tsv");
					trace(c);
					// convert ARPA to IPA
				}
			}

			var output = input;
			if (outputType != Application.TYPE_IPA) {
				// convert
			}

			Sys.println(output);
		} catch (e:BaseError) {
			this.end(e);
		}
	}
	
	/**
	 * Terminates the application gracefully. Any errors that occur are properly displayed and 
	 * various helpful responses can be displayed.
	 * @param	error Optional error
	 */
	public function end(?error:BaseError):Void {
		if (error != null) {
			Sys.println(error.toString());
			
			if (Std.is(error, InvalidNumberOfParametersError)) {
				Help.display();
			}
		}
		
		Sys.exit(error != null ? 1 : 0);
	}
	
	/**
	 * Analyzes the given options and determines the user's preferred configuration paths
	 * @param	options The options from the command line.
	 */
	public function getConfiguration(options:OptionSet):Configuration {
		var configurationPath = "~/.phoneng.json";

		if (options.hasShortOption('c') || options.hasLongOption('config')) {
			if (options.hasShortOption('c') && options.getShortValues('c').length > 0) {
				configurationPath = options.getShortValues('c')[0];
			} else if (options.hasLongOption('config') && options.getLongValues('config').length > 0) {
				configurationPath = options.getLongValues('config')[0];
			}
		}
		
		var configurationObject:ConfigurationObject;
		try{
			configurationObject = cast this.loadJsonFile(configurationPath);
		} catch (e:BaseError) {
			// var error = new InvalidLocalConfigurationError(configurationPath);
			// error.causedBy(e);
			// throw error;
			configurationObject = {version: Application.VERSION};
		}
		var configuration:Configuration = new Configuration({version: Application.VERSION});

		return configuration;
	}
	
	/**
	 * Fetches the contents of a JSON file and returns them as an object
	 * @param	path The location of the JSON file.
	 * @return	Dynamic Object with the contents.
	 * @throws	JsonParsingError
	 */
	public function loadJsonFile(path:String):Null<Dynamic> {
		
		var object = null;
		try {
			var content:String = sys.io.File.getContent(path);
			object = haxe.Json.parse(content);
		} catch (e:Any) {
			//throw new JsonParsingError(path, e);
		}
		
		return object;
	}
	
	/**
	 * Fetches the contents of a JSON file and returns them as an object
	 * @param	path The location of the JSON file.
	 * @return	Dynamic Object with the contents.
	 * @throws	JsonParsingError
	 */
	public function loadTsvFile(path:String):Null<Dynamic> {
		
		var object = null;
		try {
			var content:String = sys.io.File.getContent(path);
			trace(content);
			object = Tsv.decode(content);
		} catch (e:Any) {
			//throw new JsonParsingError(path, e);
			trace(e);
			throw e;
		}
		
		return content;
	}
}
