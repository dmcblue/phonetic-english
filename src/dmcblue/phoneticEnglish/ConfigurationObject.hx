package dmcblue.phoneticEnglish;

/**
 *
 */
typedef ConfigurationObject =
{
	/** Version of this schema, semantic versioning */
	version:String,
	
	/** Where conversion files are found */
	?conversionPath:String,
	
	/**
		Name properties will use 'conversionPath' as a prefix,
		Path properties will ignor 'conversionPath' in their resolution
		Thus, only use one (name, path) property, not both, for each
		writing system.
	**/

	/** Name of the ARPAbet 1-char conversion file */
	?arpa1Name:String,
	/** Path to the ARPAbet 1-char conversion file */
	?arpa1Path:String,

	/** Name of the ARPAbet 2-char conversion file */
	?arpa2Name:String,
	/** Path to the ARPAbet 2-char conversion file */
	?arpa2Path:String,

	/** Name of the Phonetic English description file */
	?phonName:String,
	/** Path to the Phonetic English description file */
	?phonPath:String
}
