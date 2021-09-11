package dmcblue.phoneticEnglish;

import Map in Dictionary;

import interealmGames.common.dictionary.DictionaryTools;

import dmcblue.phoneticEnglish.ConfigurationObject;

/**
 * Represents the user's task configuration, including task descriptions and required programs
 */
class Configuration
{
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
		// ConfigurationObjectValidator.validate(configurationObject);
		this.version = configurationObject.version;
		
		this.conversionPath = Reflect.hasField(configurationObject, 'conversionPath')
			? configurationObject.conversionPath
			: '~/.phoneng/'; // @TODO Make OS agnostic

		// if (Reflect.hasField(configurationObject, 'arpa1Path')) {
		// 	this.arpa1Path = configurationObject.arpa1Path;
		// } else {
		// 	var arpa1Filename = Reflect.hasField(configurationObject, 'arpa1Name')
		// 		? configurationObject.arpa1Name
		// 		: 'arpa1.tsv';
		// 	this.arpa1Path = this.conversionPath + arpa1Filename;
		// }
		this.arpa1Path = this.getPath(configurationObject, 'arpa1');
	
		// if (Reflect.hasField(configurationObject, 'arpa2Path')) {
		// 	this.arpa2Path = configurationObject.arpa2Path;
		// } else {
		// 	var arpa2Filename = Reflect.hasField(configurationObject, 'arpa1Name')
		// 		? configurationObject.arpa2Name
		// 		: 'arpa2.tsv';
		// 	this.arpa2Path = this.conversionPath + arpa2Filename;
		// }
		this.arpa2Path = this.getPath(configurationObject, 'arpa2');
	
		// if (Reflect.hasField(configurationObject, 'phonPath')) {
		// 	this.phonPath = configurationObject.phonPath;
		// } else {
		// 	var phonFilename = Reflect.hasField(configurationObject, 'phonName')
		// 		? configurationObject.phonName
		// 		: 'phon.tsv';
		// 	this.phonPath = this.conversionPath + phonFilename;
		// }
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
			// path = configurationObject.phonPath;
			path = Reflect.getProperty(configurationObject, '${prefix}Path');
		} else {
			var filename = Reflect.hasField(configurationObject, '${prefix}Name')
				? Reflect.getProperty(configurationObject, '${prefix}Name')
				: '${prefix}.tsv';
			path = this.conversionPath + filename;
		}
		// trace(path);
		// trace(configurationObject);
		// trace('${prefix}Path');
		return path;
	}
}
