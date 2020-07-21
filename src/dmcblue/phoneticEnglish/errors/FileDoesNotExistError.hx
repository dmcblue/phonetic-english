package dmcblue.phoneticEnglish.errors;

/**
 * Indicates that a needed file does not exist
 */
class FileDoesNotExistError extends BaseError 
{
	static public var TYPE = "FILE_DOES_NOT_EXIST";
	
	public function new(filename:String) 
	{
		super(JsonParsingError.TYPE, filename);
	}
}
