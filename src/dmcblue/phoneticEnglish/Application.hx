package dmcblue.phoneticEnglish;

import haxe.Json;
import haxe.io.BytesBuffer;
import sys.FileSystem;
import haxe.io.Path;
import Math;
import interealmGames.common.commandLine.OptionSet;
import dmcblue.phoneticEnglish.errors.BaseError;
import dmcblue.phoneticEnglish.errors.FileUnableToSave;
import dmcblue.phoneticEnglish.errors.InvalidTypeError;
import interealmGames.common.commandLine.CommandLine;
import dmcblue.phoneticEnglish.Configuration;
import dmcblue.phoneticEnglish.ConfigurationObject;
import dmcblue.phoneticEnglish.errors.BaseError;
import dmcblue.phoneticEnglish.errors.JsonParsingError;
import dmcblue.phoneticEnglish.errors.InvalidNumberOfParametersError;
import dmcblue.phoneticEnglish.Tsv;
import dmcblue.phoneticEnglish.Converter;


/**
 * The program logic
 */
class Application 
{
	/**
	 * Command line arguments for various actions
	 */
	static public inline final TYPE_IPA = "ipa";
	static public inline final TYPE_RP = "rp";
	static public inline final TYPE_GA = "ga";
	static public inline final TYPE_PHONETIC = "ph";
	static public inline final TYPE_ARPA1 = "arpa1";
	static public inline final TYPE_ARPA2 = "arpa2";
	static public var TYPES:haxe.ds.ReadOnlyArray<String> = [
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
	static public final OPTION_CONFIG = "config";
	static public final OPTION_CONFIG_SHORT = "c";
	static public final OPTION_HELP = "help";
	static public final OPTION_HELP_SHORT = "h";
	static public final OPTION_VERSION = "version";
	static public final OPTION_VERSION_SHORT = "v";

	static public final COMMAND_INIT = "init";
	
	/**
	 * Current Application Version
	 */
	static public var VERSION = "0.1.0";

	private var configuration:Configuration;
	private var converters:Map<Type, Map<Type, Converter>>;
	private var translator: Translator;

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

			//arguments[0] is the PhonEng application
			if (arguments.length == 2 && arguments[1] == Application.COMMAND_INIT) {
				this.init();
				this.end();
			} else {
				this.configuration = this.getConfiguration(options);

				if (arguments.length != 4) {
					var stdin = Sys.stdin().readAll(32).toString();
					if (stdin == "") {
						throw new InvalidNumberOfParametersError(4, arguments.length);
					}

					arguments[3] = stdin;
				}

				var inputType = this.typeFromString(arguments[1]);
				var outputType = this.typeFromString(arguments[2]);
				var input = arguments[3];

				if (inputType == null) {
					throw new InvalidTypeError(arguments[1]);
				}

				if (outputType == null) {
					throw new InvalidTypeError(arguments[2]);
				}

				this.translator = new Translator(this.configuration);
				var output = this.translator.translate(input, inputType, outputType);

				Sys.println(output);
			}
		} catch (e:BaseError) {
			this.end(e);
		}
	}

	public function typeFromString(str: String): ScriptType {
		return switch str {
			case Application.TYPE_ARPA1: ScriptType.ARPA1;
			case Application.TYPE_ARPA2: ScriptType.ARPA2;
			case Application.TYPE_GA: ScriptType.GA;
			case Application.TYPE_IPA: ScriptType.IPA;
			case Application.TYPE_PHONETIC: ScriptType.PHONETIC;
			case Application.TYPE_RP: ScriptType.RP;
			default: null;
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
			
			if (Std.isOfType(error, InvalidNumberOfParametersError)) {
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
		var configurationPath = Configuration.defaultConfigurationPath();

		if (options.hasShortOption(Application.OPTION_CONFIG_SHORT) || options.hasLongOption(Application.OPTION_CONFIG)) {
			if (options.hasShortOption(Application.OPTION_CONFIG_SHORT) && options.getShortValues(Application.OPTION_CONFIG_SHORT).length > 0) {
				configurationPath = options.getShortValues(Application.OPTION_CONFIG_SHORT)[0];
			} else if (options.hasLongOption(Application.OPTION_CONFIG) && options.getLongValues(Application.OPTION_CONFIG).length > 0) {
				configurationPath = options.getLongValues(Application.OPTION_CONFIG)[0];
			}
		}

		var configurationObject:ConfigurationObject;
		try{
			configurationObject = cast this.loadJsonFile(configurationPath);
		} catch (error:BaseError) {
			configurationObject = {version: Application.VERSION};
		}

		var configuration:Configuration = new Configuration(configurationObject);

		return configuration;
	}

	public function init() {
		Sys.println('This operation requires "curl"');
		var configurationPath = Configuration.defaultConfigurationPath();
		var mappingPath = Configuration.defaultMappingPath();
		var baseConfig:ConfigurationObject = {
			version: Application.VERSION,
			conversionPath: mappingPath
		};
		if(!FileSystem.exists(configurationPath)) {
			Sys.println('Creating file "$configurationPath".');
			var contents = Json.stringify(baseConfig);
			try {
				sys.io.File.saveContent(configurationPath, contents);
			} catch (e:Any) {
				this.end(new FileUnableToSave(configurationPath));
			}
		} else {
			Sys.println('File "$configurationPath" already exists.');
		}

		if(FileSystem.exists(mappingPath)) {
			if(!FileSystem.isDirectory(mappingPath)) {
				this.end(new BaseError('NOT_A_DIRECTORY', '"$mappingPath" is not a directroy'));
			} else {
				Sys.println('Directory "$mappingPath" already exists.');
			}
		} else {
			Sys.println('Creating directory "$mappingPath".');
			FileSystem.createDirectory(mappingPath);
		}

		var config:Configuration = new Configuration(baseConfig);
		var paths = [
			config.arpa1Path,
			config.arpa2Path,
			config.dictPath,
			config.phonPath
		];
		for(path in paths) {
			if(FileSystem.exists(path)) {
				Sys.println('File "$path" already exists.');
			} else {
				Sys.println('File "$path" does not exist.');
				var f = new Path(path);
				var displayname = '${f.file}.${f.ext}';
				var remote = 'https://raw.githubusercontent.com/dmcblue/phonetic-english/main/mappings/$displayname';
				Sys.println('Downloading $displayname');
				this.downloadFile(remote, path);
			}
		}
	}

	public function downloadFile(remoteName, localName) {
		Sys.command('curl', ['-LJ', '-o', localName, remoteName]);
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
			throw new JsonParsingError(path, e);
		}
		
		return object;
	}
}
