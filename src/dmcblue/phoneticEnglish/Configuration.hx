package dmcblue.phoneticEnglish;

import haxe.io.Path;
import Map in Dictionary;

import interealmGames.common.dictionary.DictionaryTools;

import dmcblue.phoneticEnglish.ConfigurationObject;

/**
 * Represents the user's task configuration, including task descriptions and required programs
 */
class Configuration
{
	static private var DEFAULT_CONFIG_PATH:String = null;
	static private var DEFAULT_MAPPING_PATH:String = null;

	static public function defaultConfigurationPath():String {
		if(Configuration.DEFAULT_CONFIG_PATH == null) {
			Configuration.DEFAULT_CONFIG_PATH = Path.join([Configuration.homeFolder(), '.phoneng.json']);
		}

		return Configuration.DEFAULT_CONFIG_PATH;
	}

	static public function defaultMappingPath():String {
		if(Configuration.DEFAULT_MAPPING_PATH == null) {
			Configuration.DEFAULT_MAPPING_PATH = Path.addTrailingSlash(Path.join([Configuration.homeFolder(), '.phoneng']));
		}

		return Configuration.DEFAULT_MAPPING_PATH;
	}

	static public function homeFolder() {
		// https://stackoverflow.com/a/60684961/2329474
		return Sys.getEnv(if (Sys.systemName() == "Windows") "UserProfile" else "HOME");
	}

	/** Version of this schema, semantic versioning */
	public var version:String;

	/** Where conversion files are found */
	public var conversionPath:String = '';

	/** Path to the ARPAbet 1-char to IPA conversion file */
	public var arpa1Path:String = '';

	/** Path to the ARPAbet 2-char to IPA conversion file */
	public var arpa2Path:String = '';

	/** Path to the Phonetic English to IPA description file */
	public var phonPath:String = '';

	/** Path to the GA to ARPA2 description file */
	public var dictPath:String = '';
		
	public function new(configurationObject:ConfigurationObject) 
	{
		this.version = configurationObject.version;
		
		this.conversionPath = Reflect.hasField(configurationObject, 'conversionPath')
			? configurationObject.conversionPath
			: Configuration.defaultMappingPath();

		this.arpa1Path = this.getPath(configurationObject, 'arpa1');
		this.arpa2Path = this.getPath(configurationObject, 'arpa2');
		this.phonPath = this.getPath(configurationObject, 'phon');
		this.dictPath = this.getPath(configurationObject, 'dict');
	}

	/**
		Requires conversionPath to be set before use
	**/
	public function getPath(
		configurationObject:ConfigurationObject,
		prefix:String
	):String {
		var path:String = "";
		if (Reflect.hasField(configurationObject, '${prefix}Path')) {
			path = Reflect.getProperty(configurationObject, '${prefix}Path');
		} else {
			var filename = Reflect.hasField(configurationObject, '${prefix}Name')
				? Reflect.getProperty(configurationObject, '${prefix}Name')
				: '${prefix}.tsv';
			path = this.conversionPath + filename;
		}

		return path;
	}
}
