package dmcblue.phoneticEnglish.errors;

/**
 * Unable to save file
 */
class FileUnableToSave extends BaseError 
{
	static public var TYPE = "FILE_UNABLE_TO_SAVE";
	
	public function new(filename:String) 
	{
		super(FileUnableToSave.TYPE, 'Unable to save "$filename"');
	}
}
