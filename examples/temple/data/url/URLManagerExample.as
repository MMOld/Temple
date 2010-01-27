/**
 * @exampleText
 * 
 * <p>This is an example about the URLManager.</p>
 * 
 * <p>View this example online at: <a href="http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/url/URLManagerExample.swf" target="_blank">http://templelibrary.googlecode.com/svn/trunk/examples/temple/data/url/URLManagerExample.swf</a></p>
 */
package  
{
	import temple.data.xml.XMLServiceEvent;
	import nl.acidcats.yalog.util.YaLogConnector;
	import temple.data.url.URLManager;
	import temple.core.CoreSprite;

	public class URLManagerExample extends CoreSprite 
	{
		public function URLManagerExample()
		{
			super();
			
			// Connect to Yalog, so you can see all log message at: http://yala.acidcats.nl/
			YaLogConnector.connect();
			
			// set debug mode to get debug log messages from the URLManager
			URLManager.getInstance().debug = true; 
			
			// add EventListenr
			URLManager.addEventListener(XMLServiceEvent.COMPLETE, this.handleURLManagerComplete);
			
			// load urls.xml
			URLManager.loadURLs("xml/urls.xml");
		}
		
		private function handleURLManagerComplete(event:XMLServiceEvent):void
		{
			// urls.xml is loaded, let's open an url
			URLManager.openURLByName("website");
		}
	}
}
