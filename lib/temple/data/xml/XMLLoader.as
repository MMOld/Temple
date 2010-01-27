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
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.COMPLETE
	 */
	[Event(name="XMLLoaderEvent.complete", type="temple.data.xml.XMLLoaderEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.ALL_COMPLETE
	 */
	[Event(name="XMLLoaderEvent.allComplete", type="temple.data.xml.XMLLoaderEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.ERROR
	 */
	[Event(name="XMLLoaderEvent.error", type="temple.data.xml.XMLLoaderEvent")]
	
	/**
	 * @eventType temple.data.xml.XMLLoaderEvent.PROGRESS
	 */
	[Event(name="XMLLoaderEvent.progress", type="temple.data.xml.XMLLoaderEvent")]
	
	import temple.core.CoreEventDispatcher;
	import temple.core.CoreURLLoader;
	import temple.data.collections.DestructableArray;
	import temple.data.loader.preload.IPreloader;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	/**
	 * XMLLoader loads XML files 
	 */
	public class XMLLoader extends CoreEventDispatcher 
	{
		protected var _preloader:IPreloader;

		private var _waitingStack:DestructableArray;
		private var _loadingStack:DestructableArray;

		private var _loaderCount:uint;

		/**
		 * @param loaderCount number of parallel loaders
		 */
		public function XMLLoader(loaderCount:uint = 1) 
		{
			this._loaderCount = loaderCount;
			
			this._waitingStack = new DestructableArray();
			this._loadingStack = new DestructableArray();
		}
		
		/**
		 * The total number of parallel loaders
		 */
		public function get loaderCount():uint 
		{
			return this._loaderCount;
		}

		/**
		 * @private
		 */
		public function set loaderCount(value:uint):void 
		{
			this._loaderCount = value;
		}
		
		/**
		 * Get or set the IPreloader
		 */
		public function get preloader():IPreloader
		{
			return this._preloader;
		}
		
		/**
		 * @private
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloader = value;
		}

		/**
		 * Load XML
		 * @param url source url of the XML
		 * @param name (optional) unique identifying name
		 * @param variables (optional) URLVariables object to be sent to the server
		 * @param requestMethod (optional) URLRequestMethod POST or GET; default: GET
		 */
		public function loadXML(url:String, name:String = "", variables:URLVariables = null, requestMethod:String = URLRequestMethod.GET):void 
		{
			// Check if url is valid
			if ((url == null) || (url.length == 0)) 
			{
				throwError(new TempleArgumentError(this, "invalid url"));
			}

			var xld:XMLLoaderData = new XMLLoaderData(url, name, variables, requestMethod);
			this._waitingStack.push(xld);
			
			this.loadNext();
		}

		/**
		 * Cancels a load
		 * @return true if cancel was succesfull, otherwise returns false
		 */
		public function cancelLoad(name:String):Boolean
		{
			var xld:XMLLoaderData;
			var leni:int;
			var i:int;
			
			// first check if load is in waitingStack
			leni = this._waitingStack.length;
			for (i = 0; i < leni ; i++)
			{
				xld = this._waitingStack[i];
				
				if(xld.name == name)
				{
					this.logInfo("cancelLoad: succesfull removed form waiting stack");
					
					// found, remove from list and return
					xld.destruct();
					this._waitingStack.splice(i,1);
					return true;
				}
			}
			// maybe it's in the loadingStack
			leni = this._loadingStack.length;
			for (i = 0; i < leni ; i++)
			{
				xld = this._loadingStack[i];
				
				if(xld.name == name)
				{
					this.logInfo("cancelLoad: succesfull removed form loading stack");
					// found, remove form list and return
					xld.destruct();
					this._loadingStack.splice(i,1);
					return true;
				}
			}
			// not found, log error
			this.logError("cancelLoad: could not cancel load '" + name + "'");
			return false;
		}

		/**
		 * Load next xml while the waiting stack is not empty.
		 */
		private function loadNext():void 
		{
			// quit if all loaders taken
			if (this._loadingStack.length == this._loaderCount) return;
			
			// quit if no waiting data
			if (this._waitingStack.length == 0) return;

			// get the data
			var xld:XMLLoaderData = this._waitingStack.shift() as XMLLoaderData;
			
			// create loader
			var loader:CoreURLLoader = new CoreURLLoader();
			loader.addEventListener(Event.COMPLETE, this.handleURLLoaderEvent);
			loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleURLLoaderEvent);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleURLLoaderEvent);
			loader.addEventListener(ProgressEvent.PROGRESS, this.handleURLLoaderProgressEvent);
			loader.preloader = this._preloader;

			// create request
			var request:URLRequest = new URLRequest(xld.url);
			if (xld.variables != null) request.data = xld.variables;
			request.method = xld.requestMethod;
			
			// store loader in data
			xld.loader = loader;
			
			// store data in loading stack
			this._loadingStack.push(xld);
			
			// start loading
			loader.load(request);
		}

		/**
		 * Handle events from URLLoader
		 * @param event Event sent 
		 */
		private function handleURLLoaderEvent(event:Event):void 
		{
			// get loader
			var loader:CoreURLLoader = event.target as CoreURLLoader;
			
			// remove listeners
			loader.removeAllEventListeners();
			
			var e:XMLLoaderEvent;
			
			// get data for loader
			var xld:XMLLoaderData = this.getDataForLoader(loader);
			if (xld == null) 
			{
				this.logError("handleURLLoaderEvent: data for loader not found");
				e = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name);
				this.dispatchEvent(e);
				return;
			}

			// check if an IOError occurred
			if (event is ErrorEvent) 
			{
				// fill error event
				e = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name);
				e.error = ErrorEvent(event).text;
			}
			else 
			{
				try 
				{
					// notify we're done loading this xml
					e = new XMLLoaderEvent(XMLLoaderEvent.COMPLETE, xld.name, new XML(loader.data));
				}
				catch (error:Error) 
				{
					this.logError("An error has occurred : " + error.message + "\n" + loader.data);
					e = new XMLLoaderEvent(XMLLoaderEvent.ERROR, xld.name, null);
					e.error = error.message;
				}
			}
			this.dispatchEvent(e);
			
			xld.destruct();
			
			
			// this loader can be destructed after dispatching the event
			// if so, this code cannot be executed
			if (this.isDestructed != true)
			{
				// remove data from stack
				this._loadingStack.splice(this._loadingStack.indexOf(xld), 1);
				
				// continue loading
				this.loadNext();
				
				// check if we're done loading
				if ((this._waitingStack.length == 0) && (this._loadingStack.length == 0)) 
				{
					this.dispatchEvent(new XMLLoaderEvent(XMLLoaderEvent.ALL_COMPLETE, xld.name));
				}
			}
		}

		/**
		 * Handle ProgressEvent from URLLoader
		 * @param event ProgressEvent sent
		 */
		private function handleURLLoaderProgressEvent(event:ProgressEvent):void 
		{
			// get loader
			var loader:CoreURLLoader = event.target as CoreURLLoader;
			
			// get data for loader
			var xld:XMLLoaderData = getDataForLoader(loader);
			if (xld == null) 
			{
				this.logError("handleURLLoaderProgressEvent: data for loader not found");
				return;
			}

			// create & dispatch event with relevant data
			var e:XMLLoaderEvent = new XMLLoaderEvent(XMLLoaderEvent.PROGRESS, xld.name);
			e.bytesLoaded = event.bytesLoaded;
			e.bytesTotal = event.bytesTotal;
			this.dispatchEvent(e);
		}

		/**
		 * Get the data block in the loading stack for the specified URLLoader
		 * @param loader: URLLoader
		 * @return the data, or null if none was found
		 */
		private function getDataForLoader(loader:CoreURLLoader):XMLLoaderData 
		{
			var len:int = this._loadingStack.length;
			for (var i:int = 0;i < len; i++) 
			{
				var xld:XMLLoaderData = this._loadingStack[i] as XMLLoaderData;
				if (xld.loader == loader) return xld;
			}
			return null;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this._waitingStack)
			{
				this._waitingStack.destruct();
				this._waitingStack = null;
			}
			if(this._loadingStack)
			{
				this._loadingStack.destruct();
				this._loadingStack = null;
			}
			super.destruct();
		}
	}	
}

import temple.core.CoreURLLoader;
import temple.destruction.IDestructable;

import flash.net.URLRequestMethod;
import flash.net.URLVariables;

class XMLLoaderData implements IDestructable
{
	public var url:String;
	public var name:String;
	public var variables:URLVariables;
	public var loader:CoreURLLoader;
	public var requestMethod:String;
	private var _isDestructed:Boolean;

	public function XMLLoaderData(url:String, name:String, variables:URLVariables = null, requestMethod:String = URLRequestMethod.GET) 
	{
		this.url = url;
		this.name = name;
		this.variables = variables;
		this.requestMethod = requestMethod;
	}
	
	public function get isDestructed():Boolean
	{
		return _isDestructed;
	}
	
	public function destruct():void
	{
		this.variables = null;
		if(this.loader)
		{
			this.loader.destruct();
			this.loader = null;
		}
		
		this.url = null;
		this.name = null;
		this.requestMethod = null;
		
		this._isDestructed = true;
	}
}