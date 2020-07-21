package dmcblue.phoneticEnglish.errors;

/**
 * Indicates that an application command was not given by the user
 */
class InvalidNumberOfParametersError extends BaseError 
{
	static public var TYPE = "MISSING_PARAMETERS";
	
	public function new(expected:Int, actual:Int) 
	{
		super(InvalidNumberOfParametersError.TYPE, 'Missing paramters, received $actual, expected $expected');
	}
}
