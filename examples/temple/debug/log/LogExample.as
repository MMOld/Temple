package  
{
	import temple.debug.log.Log;
	import nl.acidcats.yalog.util.YaLogConnector;
	import temple.core.CoreSprite;

	public class LogExample extends CoreSprite 
	{
		public function LogExample()
		{
			super();
			
			// Connect to Yala, so we can see the output of the log in Yala: http://yala.acidcats.nl/
			YaLogConnector.connect();
			
			// log an info message
			Log.info("This is an info message", this);
			
			// log an error
			Log.error("This is an error", this);
			
			// For all core object there is a shortcut for logging:
			this.logInfo("This is also an info message");
			
			// or
			this.logWarn("This is a warning");
			this.logDebug("This is a debug message");
			this.logFatal("This is a fatal message");
			
			
		}
	}
}
