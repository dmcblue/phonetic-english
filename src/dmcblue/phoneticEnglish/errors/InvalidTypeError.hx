package dmcblue.phoneticEnglish.errors;

/**
 * Indicates that an invalid or unknown type of language input has been given by the user
 */
class InvalidTypeError extends BaseError 
{
	static public var TYPE = "INVALID_TYPE";
	
	public function new(type:String) 
	{
		super(InvalidTypeError.TYPE, 'Unknown TYPE "$type"');
	}
}
