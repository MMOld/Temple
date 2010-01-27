/**
 * @exampleText
 * 
 * <p>This is an example about how to use the XMLManager.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/xml/XMLManagerExample.swf</a></p>
 */
package  
{
	import temple.utils.types.ObjectUtils;
	import temple.debug.log.Log;
	import nl.acidcats.yalog.util.YaLogConnector;

	import temple.core.CoreSprite;
	import temple.data.xml.XMLManager;

	import vo.PersonData;

	public class XMLManagerExample extends CoreSprite 
	{
		public function XMLManagerExample()
		{
			super();
			
			// Connect to Yala, so we can see the output of the log in Yala: http://yala.acidcats.nl/
			YaLogConnector.connect();
			
			// load XML named "persons" (see urls.xml) and parse it to PersonData objects.
			XMLManager.loadListByName("persons", PersonData, "person", this.onData);
		}

		private function onData(list:Array):void
		{
			// This method is called after loading and paring is complete, with the list of all PersonData objects.
			
			Log.info("XML loaded and parsed: " + ObjectUtils.traceObject(list, 3, false), this);
		}
	}
}
