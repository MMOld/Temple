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
 
 package temple.data.url 
{
	import temple.data.collections.HashMap;
	import temple.data.loader.ILoader;
	import temple.data.loader.preload.IPreloadable;
	import temple.data.xml.XMLParser;
	import temple.data.xml.XMLService;
	import temple.data.xml.XMLServiceEvent;
	import temple.debug.DebugManager;
	import temple.debug.IDebuggable;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.utils.TraceUtils;
	import temple.utils.types.ObjectUtils;

	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * The URLManager handles all urls of a project. In most projects the urls will depend on the environment. The live application uses different urls as the development environment.
	 * To handles this you can store the urls in an external xml file, 'urls.xml'. By changing the 'currentgroup' inside the XML you can easely switch between different urls.
	 * The 'urls.xml' uses the following syntax:
	 * <listing version="3.0">
	 * &lt;?xml version="1.0" encoding="UTF-8"?&gt;
	 * &lt;urls currentgroup="development"&gt;
	 * 	&lt;group id="development"&gt;
	 * 		&lt;url name="link" url="http://www.development_url.com" target="_blank" /&gt;
	 * 		&lt;var name="path" value="http://www.development_path.com" /&gt;
	 * 	&lt;/group&gt;
	 * 	&lt;group id="live"&gt;
	 * 		&lt;url name="link" url="http://www.live_url.com" target="_blank" /&gt;
	 * 		&lt;var name="path" value="http://www.live_path.com" /&gt;
	 * 	&lt;/group&gt;
	 * 	&lt;url name="global" url="http://www.global.com" target="_blank" /&gt;
	 * 	&lt;url name="submit" url="{path}/submit" /&gt;
	 * &lt;/urls&gt;
	 * </listing>
	 * 
	 * <p>Every 'url'-node has a 'name', 'url' and (optional) 'target' attribute. Environment-dependent urls are place inside a 'group'-node, global-urls are placed outside a group-node.
	 * It is also possible to use variables inside the urls.xml. You can define a variable by using a 'var'-node, with a 'name' and 'value' attribute. You can use the variable inside a url with '{name-of-the-variable}', wich will be replaced with the value.
	 * By defining the variable in different 'groups' the actual url will we different.</p>
	 * 
	 * <p>The 'currentgroup' can be overruled by code. This only works before the urls.xml is loaded and parsed!</p>
	 * 
	 * <p>The URLManager is a singleton and can be accessed by URLManager.getInstance() or by his static functions.</p>
	 * 
	 * <p>By enabling the debug-property more information is logged.</p>
	 * 
	 * @example urls.xml used by the URLManagerExample.as example:
	 * 
	 * @includeExample xml/urls.xml
	 * 
	 * @includeExample URLManagerExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public final class URLManager extends XMLService implements IDebuggable, ILoader, IPreloadable
	{
		private static var _instance:URLManager;

		/** 
		 * Default name for urls.xml
		 */
		private static const _URLS:String = "urls";
		
		/**
		 * Get named url data
		 * @param name name of data block
		 * @return the data block, or null if none was found
		 */
		public static function getURLDataByName(name:String):URLData 
		{
			return URLManager.getInstance().getURLDataByName(name);
		}

		/**
		 * Get named url 
		 * @param name name of data block
		 * @return url as string or null if none was found
		 */
		public static function getURLByName(name:String):String 
		{
			return URLManager.getInstance().getURLByName(name);
		}

		/**
		 * Open a browser window for url with specified name
		 */
		public static function openURLByName(name:String):void 
		{
			URLManager.getInstance().openURLByName(name);
		}

		/**
		 * Open a browser window for specified url
		 */
		public static function openURL(url:String, target:String = ""):void 
		{
			URLManager.getInstance().openURL(url, target);
		}
		
		/**
		 * Load settings from specified url if provided, or from default url
		 * @param url url to load settings from
		 * @param group set wich group is used in the url.xml
		 */
		public static function loadURLs(url:String = "xml/urls.xml", group:String = null):void 
		{
			URLManager.getInstance().loadURLs(url, group);
		}
		
		/**
		 * Directly set the XML data instead of loading is. Usefull if you already loaded the XML file with an external loader. Or when you use inline XML
		 */
		public static function parseXML(xml:XML, group:String = null):void
		{
			URLManager.getInstance().parseXML(xml, group);
		}

		/**
		 * Indicates if the urls.xml is loaded yet
		 */
		public static function isLoaded():Boolean
		{
			return URLManager.getInstance()._loaded;
		}

		/**
		 * Indicates if the urls.xml is beeing loaded, but not loaded yet
		 */
		public static function isLoading():Boolean
		{
			return URLManager.getInstance()._loading;
		}
		
		/**
		 * The used group in the urls.xml. When the xml is loaded, the group cannot be changed.
		 */
		public static function get group():String
		{
			return URLManager.getInstance()._group;
		}

		/**
		 * @private
		 */
		public static function set group(value:String):void
		{
			if(URLManager.getInstance()._loaded)
			{
				URLManager.getInstance().logError("group: URLs are already loaded, changing group does not affect anything anymore");
			}
			else
			{
				URLManager.getInstance()._group = value;
			}
		}
		
		/**
		 * Wrapper function for URLManager.getInstance().addEventListener
		 */
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			URLManager.getInstance().addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * Wrapper function for URLManager.getInstance().removeEventListener
		 */
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			URLManager.getInstance().removeEventListener(type, listener, useCapture);
		}

		/**
		 * Wrapper function for URLManager.getInstance().removeAllEventListeners
		 */
		public static function removeAllEventListeners():void 
		{
			URLManager.getInstance().removeAllEventListeners();
		}
		
		/**
		 * Returns the instance of the URLManager
		 */
		public static function getInstance():URLManager 
		{
			if(URLManager._instance == null) URLManager._instance = new URLManager();
			
			return URLManager._instance;
		}

		private var _urls:Array = [];

		private var _loaded:Boolean = false;
		private var _loading:Boolean = false;
		private var _group:String;

		/**
		 * @private
		 */
		public function URLManager() 
		{
			super();

			if (URLManager._instance) throwError(new TempleError(this, "Singleton, use URLManager.getInstance()"));
			
			DebugManager.add(this);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoaded():Boolean
		{
			return this._loaded;
		}

		/**
		 * @inheritDoc
		 */
		public function isLoading():Boolean
		{
			return this._loading;
		}

		private function loadURLs(url:String, group:String):void 
		{
			if(this._loaded) throwError(new TempleError(this, "Data is already loaded"));
			if(this._loading) throwError(new TempleError(this, "Data is already loading"));
			
			this._loading = true;
			if(group) this._group = group;
			this.load(new URLData(URLManager._URLS, url));
		}
		
		private function parseXML(xml:XML, group:String):void
		{
			if(this._loaded) throwError(new TempleError(this, "Data is already loaded"));
			if(this._loading) throwError(new TempleError(this, "Data is already loading"));
			
			this._loaded = true;
			if(group) this._group = group;
			this.processData(xml, URLManager._URLS);
		}

		private function getURLDataByName(name:String):URLData 
		{
			if (name == null) throwError(new TempleArgumentError(this, "name can not be null"));
			
			if(!this._loaded)
			{
				this.logError("getURLDataByName: URLs are not loaded yet");
				return null;
			}
			
			var len:Number = _urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				var ud:URLData = URLData(_urls[i]);
				if (ud.name == name) return ud;
			}
			this.logError("getURLDataByName: url with name '" + name + "' not found. Check urls.xml!");
			
			this.logError(TraceUtils.stackTrace());
			
			return null;
		}

		private function getURLByName(name:String):String 
		{
			if (name == null) throwError(new TempleArgumentError(this, "name can not be null"));
			
			if(!this._loaded)
			{
				this.logError("getURLByName: URLs are not loaded yet");
				return null;
			}
			
			var len:Number = _urls.length;
			for (var i:Number = 0;i < len; i++) 
			{
				var ud:URLData = URLData(_urls[i]);
				if (ud.name == name) return ud.url;
			}
			this.logError("getURLByName: url with name '" + name + "' not found. Check urls.xml!");
			return null;
		}

		private function openURLByName(name:String):void 
		{
			var ud:URLData = URLManager.getURLDataByName(name);
			if (!ud) return;
			
			this.openURL(ud.url, ud.target);
		}

		private function openURL(url:String, target:String):void 
		{
			if (url == null) throwError(new TempleArgumentError(this, "url can not be null"));
			
			try 
			{
				var request:URLRequest = new URLRequest(url);
				
				if (!ExternalInterface.available) 
				{
					navigateToURL(request, target);
				} 
				else 
				{
					var strUserAgent:String = String(ExternalInterface.call("function() {return navigator.userAgent;}")).toLowerCase();
					
					if (strUserAgent.indexOf("firefox") != -1 || (strUserAgent.indexOf("msie") != -1 && uint(strUserAgent.substr(strUserAgent.indexOf("msie") + 5, 3)) >= 7)) 
					{
						ExternalInterface.call("window.open", request.url, target);
					} 
					else 
					{
						navigateToURL(request, target);
					}
				}
			}
			catch (e:Error) 
			{
				this.logError("openURLByName: Error navigating to URL '" + url + "', system says:" + e.message);
			}
		}

		/**
		 * Process loaded XML
		 * @param data loaded XML data
		 * @param name name of load operation
		 */
		override protected function processData(data:XML, name:String):void 
		{
			if(this._group)
			{
				this.logInfo("processData: group is set to '" + this._group + "'");
			}
			else
			{
				this._group = data.@currentgroup; 
			}
			
			// variables
			var variables:HashMap = new HashMap("URLManager variables");
			
			// get grouped variables
			var groupedVars:XMLList = data.group.(@id == (this._group)).child('var');
			
			var leni:int;
			var i:int;
			var key:String;
			
			leni = groupedVars.length();
			for (i = 0;i < leni; i++)
			{
				variables[groupedVars[i].@name] = groupedVars[i].@value;
			}
			
			// add ungrouped variables
			var ungroupedVars:XMLList = data.child('var');
			
			leni = ungroupedVars.length();
			for (i = 0;i < leni; i++)
			{
				variables[ungroupedVars[i].@name] = ungroupedVars[i].@value;
			}
			
			if(this._debug)
			{
				var s:String = "";
				for (key in variables)
				{
					s += "\n" + key + ": " + variables[key];
				}
				this.logDebug("Current vars in URLManager: " + s);
			}

			// get grouped urls
			var groupedURLs:XMLList = data.group.(@id == (this._group)).url;
			
			this._urls = XMLParser.parseList(groupedURLs, URLData);

			// check if currentgroup is valid
			if (this._group && groupedURLs.length() == 0 && groupedVars.length() == 0)
			{
				this.logError("processData: group '" + this._group + "' not found, check urls.xml");
			}

			// add ungrouped urls
			var ungroupedURLs:Array = XMLParser.parseList(data.url, URLData);
			if (ungroupedURLs) this._urls = this._urls.concat(ungroupedURLs);
			
			this._loaded = true;
			this._loading = false;
			
			this._loader.destruct();
			this._loader = null;
			
			var ud:URLData;
			
			if(this._debug)
			{
				s = "";
				for each (ud in this._urls)
				{
					s += "\n" + ud.name + ": " + ud.url;
				}
				
				this.logDebug("Current urls in XML: " + s);
			}
			
			// replace vars in urls
			if(ObjectUtils.hasValues(variables))
			{
				for each (ud in this._urls)
				{
					for (key in variables)
					{
						ud.url = ud.url.replace('{' + key + '}', variables[key]);
					}
				}
			}
			
			if(this._debug)
			{
				s = "";
				for each (ud in this._urls)
				{
					s += "\n" + ud.name + ": " + ud.url;
				}
				
				this.logDebug("Current urls in URLManager: " + s);
			}

			// send event we're done
			this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.COMPLETE, name)); 
			this.dispatchEvent(new XMLServiceEvent(XMLServiceEvent.ALL_COMPLETE)); 
		}

		/**
		 * Destructs the URLManager
		 */
		override public function destruct():void
		{
			URLManager._instance = null;
			this._urls = null;
			super.destruct();
		}
	}
}
