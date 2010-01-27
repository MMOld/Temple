/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2010 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	http://code.google.com/p/templelibrary/
 *	
 *	Redistribution and use in source and binary forms, with or without
 *	modification, are permitted provided that the following conditions are met:
 *	
 *	- Redistributions of source code must retain the above copyright notice,
 *	this list of conditions and the following disclaimer.
 *	
 *	- Redistributions in binary form must reproduce the above copyright notice,
 *	this list of conditions and the following disclaimer in the documentation
 *	and/or other materials provided with the distribution.
 *	
 *	- Neither the name of the Temple Library nor the names of its contributors
 *	may be used to endorse or promote products derived from this software
 *	without specific prior written permission.
 *	
 *	
 *	Temple Library is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU Lesser General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *	
 *	Temple Library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU Lesser General Public License for more details.
 *	
 *	You should have received a copy of the GNU Lesser General Public License
 *	along with Temple Library.  If not, see <http://www.gnu.org/licenses/>.
 *	
 */

package temple.data.xml 
{
	import temple.core.CoreEventDispatcher;
	import temple.data.loader.preload.IPreloader;
	import temple.data.url.URLData;
	import temple.debug.IDebuggable;

	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * @eventType temple.data.xml.XMLServiceEvent.COMPLETE
	 */
	[Event(name="XMLServiceEvent.complete", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLServiceEvent.ALL_COMPLETE
	 */
	[Event(name="XMLServiceEvent.allComplete", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLServiceEvent.LOAD_ERROR
	 */
	[Event(name="XMLServiceEvent.loadError", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLServiceEvent.PARSE_ERROR
	 */
	[Event(name="XMLServiceEvent.parseError", type="temple.data.xml.XMLServiceEvent")]
	
	/**
	 * Base class for loading XML data, with or without parameters. Extend this class to create a proper service for use in a MVCS-patterned application.
	 * The base class provides functionality for transferring an Object with parameters to the request, loading the XML, a virtual function for parsing the result, parsing a list, and error handling on response &amp; parsing.
	 * When extending this class, the function <code>protected function processData (inData:XML, inName:String) : void;</code> has to be overridden &amp; implemented to handle a successful load. When parsing a list of XMl nodes into an array of objects of one class, the <code>parseList()</code> function can be used.
	 */
	public class XMLService extends CoreEventDispatcher implements IDebuggable
	{
		protected var _loader:XMLLoader;
		protected var _debug:Boolean;

		public function XMLService()
		{
			super();
			
			this._loader = new XMLLoader();
			this._loader.addEventListener(XMLLoaderEvent.COMPLETE, handleLoaderEvent);
			this._loader.addEventListener(XMLLoaderEvent.ALL_COMPLETE, handleLoaderEvent);
			this._loader.addEventListener(XMLLoaderEvent.ERROR, handleLoadError);
		}

		/**
		 *	Load from specified location, optionally with specified parameters
		 *	@param urlData: url of xml data to be loaded
		 *	@param sendData: optional object containing parameters to be posted
		 *	@param method Method to send the sendData object (GET of POST)
		 */
		public function load(urlData:URLData, sendData:Object = null, method:String = URLRequestMethod.GET):void 
		{
			if(urlData == null)
			{
				this.logError("load: urlData cannot be null");
				return;
			}
			
			// copy input object to URLVariables object			
			var vars:URLVariables;
			if (sendData) 
			{
				vars = new URLVariables();
				for (var s : String in sendData) 
				{
					vars[s] = sendData[s];
				}
			}
			
			if (this._debug) this.logInfo("load: '" + urlData.name + "' from " + urlData.url);
			
			this._loader.loadXML(urlData.url, urlData.name, vars, method);
		}

		/**
		 * Cancel a load by name
		 * @return true if cancel was succesfull, otherwise returns false
		 */
		public function cancelLoad(name:String):Boolean
		{
			return this._loader.cancelLoad(name);
		}

		/**
		 * The number of parallel loaders
		 */
		public function get loaderCount():uint 
		{
			return this._loader ? this._loader.loaderCount : 0;
		}

		/**
		 * @private
		 */
		public function set loaderCount(value:uint):void 
		{
			this._loader.loaderCount  = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
			
			if(this._debug) this.logDebug("debug: " + debug);
		}
		
		/**
		 * Get or set the IPreloader
		 */
		public function get preloader():IPreloader
		{
			return this._loader.preloader;
		}
		
		/**
		 * @private
		 */
		public function set preloader(value:IPreloader):void
		{
			this._loader.preloader = value;
		}

		protected function handleLoaderEvent(event:XMLLoaderEvent):void 
		{
			switch (event.type) 
			{
				case XMLLoaderEvent.COMPLETE: 
				{
					this.processData(event.data, event.name); 
					break;
				}
				case XMLLoaderEvent.ALL_COMPLETE: 
				{
					this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.ALL_COMPLETE, event.name)); 
					break;
				}
				
			}
		}

		/**
		 *	Override this function to perform specific xml parsing
		 */
		protected function processData(data:XML, name:String):void 
		{
			this.logWarn("processData: override this function");
			
			// just use them to get rid of 'never used' warning
			data;
			name;
		}

		/**
		 *	Handle load error event
		 */
		protected function handleLoadError(event:XMLLoaderEvent):void 
		{
			this.logError("handleLoadError: " + event.error);
			this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.LOAD_ERROR, event.name, null, null, event.error));
		}

		/**
		 *  Helper function
		 *	Parse a list into a vo class
		 *	If an error occurs, handleDataParseError() is called
		 *	@param list: the repeatable xml node
		 *	@param objectClass: the class to use to parse the data
		 *	@param name: the name of the loaded data
		 *	@param sendEvent: if true, a ServiceEvent is sent when parsing is successful
		 *	@return the list of objects of specified class, or null if an error occurred
		 */
		protected function parseList(list:XMLList, objectClass:Class, name:String, sendEvent:Boolean = true):Array 
		{
			var a:Array = XMLParser.parseList(list, objectClass);
			
			if (a == null) 
			{
				this.onDataParseError(name);
				return null;
			}
			
			// send event we're done
			if (sendEvent) this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.COMPLETE, name, a, null));
			
			return a;
		}

		/**
		 *	Handle error occurred during parsing of data
		 */
		protected function onDataParseError(name:String):void 
		{
			this.logError("handleDataParseError: error parsing xml with name '" + name + "'");
			
			var error:String = "The XML was well-formed but incomplete. Be so kind and check it. It goes by the name of " + name;
			var event:XMLServiceEvent = new XMLServiceEvent(XMLServiceEvent.PARSE_ERROR, name, null, null, error);
			this.dispatchEvent(event);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this._loader)
			{
				this._loader.destruct();
				this._loader = null;
			}
			super.destruct();
		}
	}
}
