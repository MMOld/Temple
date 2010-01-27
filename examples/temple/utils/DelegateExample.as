/**
 * @exampleText
 * 
 * <p>This is an example about how to use the Delegate class</p>
 *  
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/DelegateExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/utils/DelegateExample.swf</a></p>
 */
package  
{
	import temple.utils.Delegate;
	import temple.debug.log.Log;
	import nl.acidcats.yalog.util.YaLogConnector;
	import flash.display.Sprite;

	public class DelegateExample extends Sprite 
	{
		public function DelegateExample()
		{
			// Connect to Yala, so we can see the output of the log in Yala: http://yala.acidcats.nl/
			YaLogConnector.connect();
			
			// create a delegate, you can store the delegate in a variable so you can call is later
			var delegate:Function = Delegate.create(this.myFunction, this, "some data");
			
			// call delegate
			Log.info("Call delegate:", this);
			delegate();


			// call again
			Log.info("Call delegate again:", this);
			delegate();
		}

		private function myFunction(argument:String):void
		{
			Log.info("myFunction call with argument '" + argument + "'", this);
		}
	}
}
