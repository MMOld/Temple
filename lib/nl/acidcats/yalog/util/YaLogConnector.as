/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package nl.acidcats.yalog.util 
{
	import nl.acidcats.yalog.Yalog;

	import temple.debug.log.Log;
	import temple.debug.log.LogEvent;
	import temple.debug.log.LogLevels;

	public class YaLogConnector 
	{
		private static var _instance:YaLogConnector;

		/**
		 * @return singleton instance of YaLogConnector
		 */
		public static function getInstance():YaLogConnector 
		{
			if (YaLogConnector._instance == null) YaLogConnector._instance = new YaLogConnector();
			return YaLogConnector._instance;
		}

		public function YaLogConnector() 
		{
			Log.addLogListener(this.handleLogEvent);
			Yalog.showTrace = false;
		}

		/**
		 *	
		 */
		private function handleLogEvent(event:LogEvent):void 
		{
			switch (event.level) 
			{
				case LogLevels.DEBUG: 
					Yalog.debug(event.data, event.sender); 
					break;
				case LogLevels.ERROR: 
					Yalog.error(event.data, event.sender); 
					break;
				case LogLevels.FATAL: 
					Yalog.fatal(event.data, event.sender); 
					break;
				case LogLevels.INFO: 
					Yalog.info(event.data, event.sender); 
					break;
				case LogLevels.STATUS: 
					Yalog.info(event.data, event.sender); 
					break;
				case LogLevels.WARN: 
					Yalog.warn(event.data, event.sender); 
					break;
			}
		}

		/**
		 *	Connect to the Log
		 */
		public static function connect():void 
		{
			YaLogConnector.getInstance();
		}
	}
}