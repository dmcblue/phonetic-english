package dmcblue.phoneticEnglish;

import haxe.io.BytesBuffer;
import dmcblue.phoneticEnglish.Configuration;
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
// import thx.csv.Tsv;
import dmcblue.phoneticEnglish.Tsv;
import dmcblue.phoneticEnglish.Converter;
// import interealmGames.opentask.Help;MissingParametersError
// import interealmGames.opentask.ProgramInformation;
// import interealmGames.opentask.Log;

enum Type {
	ARPA1;
	ARPA2;
	GA;
	IPA;
	PHONETIC;
	RP;
}

enum TextType {
	TEXT;
	WHITESPACE;
}

typedef TextNode =
{
	type:TextType,
	text:String
}

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
	
	/**
	 * Current Application Version
	 */
	static public var VERSION = "0.1.0";

	private var configuration:Configuration;
	private var converters:Map<Type, Map<Type, Converter>>;

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

			this.configuration = this.getConfiguration(options);
			
			//arguments[0] is the PhonEng application
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
			var output:Array<String> = []; // input;
			
			if (inputType == null) {
				throw new InvalidTypeError(arguments[1]);
			}

			if (outputType == null) {
				throw new InvalidTypeError(arguments[2]);
			}

			this.converters = this.buildConverters();
			var steps = this.conversionPath(inputType, outputType);
			var parts = this.splitText(input);
			for (part in parts) {
				if(part.type == TextType.WHITESPACE) {
					output.push(part.text);
				} else {
					var trans = part.text.toLowerCase().split('');
					for(i in 1...steps.length) {
						var from = steps[i - 1];
						var to = steps[i];
						var converter = this.converters.get(from).get(to);
						if (from == Type.GA) {
							trans = converter.convert(trans.join('')).split(' ');
						} else {
							trans = converter.convertEach(trans);
						}
					}

					for(str in trans) {
						output.push(str != null ? str : '?');
					}
				}
			}

			Sys.println(output.join(''));
		} catch (e:BaseError) {
			this.end(e);
		}
	}

	public function conversionPath(from: Type, to: Type): Array<Type> {
		var intermediateSteps = switch from {
			case Type.ARPA1:
				switch to {
					case Type.ARPA2: [Type.IPA];
					case Type.GA: [Type.IPA, Type.ARPA2];
					case Type.IPA: [];
					case Type.PHONETIC: [Type.IPA];
					case Type.RP: null;
					default: null;
				};
			case Type.ARPA2:
				switch to {
					case Type.ARPA1: [Type.IPA];
					case Type.GA: [];
					case Type.IPA: [];
					case Type.PHONETIC: [Type.IPA];
					case Type.RP: null;
					default: null;
				};
			case Type.GA:
				switch to {
					case Type.ARPA1: [Type.ARPA2, Type.IPA];
					case Type.ARPA2: [];
					case Type.IPA: [Type.ARPA2];
					case Type.PHONETIC: [Type.ARPA2, Type.IPA];
					case Type.RP: null;
					default: null;
				};
			case Type.IPA:
				switch to {
					case Type.ARPA1: [];
					case Type.ARPA2: [];
					case Type.GA: [Type.ARPA2];
					case Type.PHONETIC: [];
					case Type.RP: null;
					default: null;
				};
			case Type.PHONETIC:
				switch to {
					case Type.ARPA1: [Type.IPA];
					case Type.ARPA2: [Type.IPA];
					case Type.GA: [Type.ARPA2, Type.IPA];
					case Type.IPA: [];
					case Type.RP: null;
					default: null;
				};
			case Type.RP:
				switch to {
					case Type.ARPA1: null;
					case Type.ARPA2: null;
					case Type.GA: null;
					case Type.IPA: null;
					case Type.PHONETIC: null;
					default: null;
				};
			default: null;
		}

		intermediateSteps.unshift(from);
		intermediateSteps.push(to);
		return intermediateSteps;
	}

	public function typeFromString(str: String): Type {
		return switch str {
			case Application.TYPE_ARPA1: Type.ARPA1;
			case Application.TYPE_ARPA2: Type.ARPA2;
			case Application.TYPE_GA: Type.GA;
			case Application.TYPE_IPA: Type.IPA;
			case Application.TYPE_PHONETIC: Type.PHONETIC;
			case Application.TYPE_RP: Type.RP;
			default: null;
		}
	}

	public function buildConverters():Map<Type, Map<Type, Converter>> {
		var converters:Map<Type, Map<Type, Converter>> = new Map();

		converters.set(Type.ARPA1, new Map());
		converters.set(Type.ARPA2, new Map());
		converters.set(Type.GA, new Map());
		converters.set(Type.IPA, new Map());
		converters.set(Type.PHONETIC, new Map());
		converters.set(Type.RP, new Map());

		var tsv = new Tsv([Application.TYPE_ARPA1, Application.TYPE_IPA]);
		tsv.load(this.configuration.arpa1Path);
		converters.get(Type.ARPA1).set(Type.IPA, Converter.fromTsv(tsv, Application.TYPE_ARPA1, Application.TYPE_IPA));
		converters.get(Type.IPA).set(Type.ARPA1, Converter.fromTsv(tsv, Application.TYPE_IPA, Application.TYPE_ARPA1));

		var tsv = new Tsv([Application.TYPE_ARPA2, Application.TYPE_IPA]);
		tsv.load(this.configuration.arpa2Path);
		converters.get(Type.ARPA2).set(Type.IPA, Converter.fromTsv(tsv, Application.TYPE_ARPA2, Application.TYPE_IPA));
		converters.get(Type.IPA).set(Type.ARPA2, Converter.fromTsv(tsv, Application.TYPE_IPA, Application.TYPE_ARPA2));

		var tsv = new Tsv([Application.TYPE_GA, Application.TYPE_ARPA2]);
		tsv.load(this.configuration.dictPath);
		converters.get(Type.GA).set(Type.ARPA2, Converter.fromTsv(tsv, Application.TYPE_GA, Application.TYPE_ARPA2));
		converters.get(Type.ARPA2).set(Type.GA, Converter.fromTsv(tsv, Application.TYPE_ARPA2, Application.TYPE_GA));

		var tsv = new Tsv([Application.TYPE_PHONETIC, Application.TYPE_IPA]);
		tsv.load(this.configuration.phonPath);
		converters.get(Type.PHONETIC).set(Type.ARPA1, Converter.fromTsv(tsv, Application.TYPE_PHONETIC, Application.TYPE_IPA));
		converters.get(Type.IPA).set(Type.PHONETIC, Converter.fromTsv(tsv, Application.TYPE_IPA, Application.TYPE_PHONETIC));


		return converters;
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
		var configurationPath = "~/.phoneng.json";

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
			// var error = new InvalidLocalConfigurationError(configurationPath);
			// error.causedBy(e);
			// throw error;
			configurationObject = {version: Application.VERSION};
		}

		var configuration:Configuration = new Configuration(configurationObject);

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

	public function splitText(source:String): Array<TextNode> {
		var textNodes: Array<TextNode> = [];
		var whitespace = [" ", "\t", "\n"];
		var chars:EReg = ~/[A-Z]+/i;
		var text = "";
		var type: TextType = null;
		for(t in source.split('')) {
			// var thisType = whitespace.contains(t) ? TextType.WHITESPACE : TextType.TEXT;
			var thisType = chars.match(t) ? TextType.TEXT : TextType.WHITESPACE;
			if (type == null) {
				type = thisType;
			} else if (thisType != type) {
				textNodes.push({
					type: type,
					text: text
				});
				type = thisType;
				text = "";
			}

			text += t;
		}

		if (text.length > 0) {
			textNodes.push({
				type: type,
				text: text
			});
		}

		return textNodes;
	}
}
