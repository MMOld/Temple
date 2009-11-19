/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2009 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	THIS LIBRARY IS IN PRIVATE BETA, THEREFORE THE SOURCES MAY NOT BE
 *	REDISTRIBUTED IN ANY WAY.
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

package temple.core 
{
	import temple.data.loader.IPreloader;
	import temple.data.loader.PreloadableBehavior;
	import temple.debug.Registry;
	import temple.debug.getClassName;
	import temple.debug.log.Log;
	import temple.destruction.DestructEvent;
	import temple.destruction.EventListenerManager;
	import temple.utils.StageProvider;

	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	/**
	 * Dispatched just before the object is destructed
	 * @eventType temple.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.destruction.DestructEvent")]
	
	/**
	 * Base class for all Loaders in the Temple. The CoreLoader handles some core features of the Temple:
	* <ul>
	 * 	<li>Registration to the Registry class</li>
	 * 	<li>Global reference to the stage trough the StageProvider</li>
	 * 	<li>Corrects a timeline bug in Flash (see http://www.tyz.nl/2009/06/23/weird-parent-thing-bug-in-flash/)</li>
	 * 	<li>Event dispatch optimization</li>
	 * 	<li>Easy remove of all EventListeners</li>
	 * 	<li>Wrapper for Log class for easy logging</li>
	 * 	<li>Completely destructable</li>
	 * 	<li>Can be tracked in Memory (of this feature is enabled)</li>
	 * </ul>
	 * 
	 * You should always use and/or extend the CoreLoader instead of Loader if you want to make use of the Temple features.
	 * 
	 * @author Thijs Broerse
	 */
	public class CoreLoader extends Loader implements ICoreDisplayObject, ICoreLoader
	{
		private static const _DEFAULT_HANDLER : int = -50;
		
		private namespace temple;
		
		protected var _preloadableBehavior:PreloadableBehavior;
		protected var _isLoading:Boolean;
		protected var _isLoaded:Boolean;
		protected var _logErrors:Boolean;
		
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _onStage:Boolean;
		private var _onParent:Boolean;
		private var _registryId:uint;
		private var _url:String;

		/**
		 * Creates a new CoreLoader
		 */
		public function CoreLoader(logErrors:Boolean = true)
		{
			this._eventListenerManager = new EventListenerManager(this);
			super();
			
			this._logErrors = logErrors;
			
			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.UNLOAD, temple::handleUnload, false, 0, true);
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			this.addEventListener(Event.ADDED, temple::handleAdded);
			this.addEventListener(Event.ADDED_TO_STAGE,temple::handleAddedToStage);
			this.addEventListener(Event.REMOVED, temple::handleRemoved);
			this.addEventListener(Event.REMOVED_FROM_STAGE, temple::handleRemovedFromStage);
			
			// Add default listeners to Error events
			this.contentLoaderInfo.addEventListener(Event.OPEN, temple::handleLoadStart, false, 0, true);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, temple::handleLoadProgress, false, 0, true);
			this.contentLoaderInfo.addEventListener(Event.INIT, temple::handleLoadInit, false, 0, true);
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, temple::handleLoadComplete, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, temple::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, temple::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, temple::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, temple::handleIOError, false, CoreLoader._DEFAULT_HANDLER, true);
			this.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, temple::handleSecurityError, false, CoreLoader._DEFAULT_HANDLER, true);
			
			// preloader support
			this._preloadableBehavior = new PreloadableBehavior(this);
		}
		
		/**
		 * @inheritDoc
		 * 
		 * If the object does not have a width and is not scaled to 0 the object is empty, 
		 * setting the width is useless and can only cause weird errors, so we don't.
		 */
		override public function set width(value:Number):void
		{
			if(super.width || !this.scaleX) super.width = value;
		}

		/**
		 * @inheritDoc
		 * 
		 * If the object does not have a height and is not scaled to 0 the object is empty, 
		 * setting the height is useless and can only cause weird errors, so we don't. 
		 */
		override public function set height(value:Number):void
		{
			if(super.height || !this.scaleY) super.height = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get registryId():uint
		{
			return this._registryId;
		}

		/**
		 * @inheritDoc
		 */ 
		override public function load(request:URLRequest, context:LoaderContext = null):void
		{
			this._isLoading = true;
			this._isLoaded = false;
			this._url = request.url;
			super.load(request, context);
		}

		/**
		 * @inheritDoc
		 */ 
		override public function loadBytes(bytes:ByteArray, context:LoaderContext = null):void
		{
			this._isLoading = true;
			super.loadBytes(bytes, context);
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoading():Boolean
		{
			return this._isLoading;
		}
		
		/**
		 * @inheritDoc
		 */
		public function isLoaded():Boolean
		{
			return this._isLoaded;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get logErrors():Boolean
		{
			return this._logErrors;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set logErrors(value:Boolean):void
		{
			this._logErrors = value;
		}

		/**
		 * @inheritDoc
		 * 
		 * When object is not on the stage it gets is stage reference from the StageProvider
		 */
		override public function get stage():Stage
		{
			if (!super.stage) return StageProvider.stage;
			
			return super.stage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get onStage():Boolean
		{
			return this._onStage;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get hasParent():Boolean
		{
			return this._onParent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get autoAlpha():Number
		{
			return this.visible ? this.alpha : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set autoAlpha(value:Number):void
		{
			this.alpha = value;
			this.visible = this.alpha > 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get position():Point
		{
			return new Point(this.x, this.y);
		}
		
		/**
		 * @inheritDoc
		 */
		public function set position(value:Point):void
		{
			this.x = value.x;
			this.y = value.y;
		}

		/**
		 * @inheritDoc
		 * 
		 * Check implemented if object hasEventListener, must speed up the application
		 * http://www.gskinner.com/blog/archives/2008/12/making_dispatch.html
		 */
		override public function dispatchEvent(event:Event):Boolean 
		{
			if (this.hasEventListener(event.type) || event.bubbles) 
			{
				return super.dispatchEvent(event);
			}
			return true;
		}

		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			this._eventListenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 
		{
			super.removeEventListener(type, listener, useCapture);
			if (this._eventListenerManager) this._eventListenerManager.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventsForType(type:String):void 
		{
			this._eventListenerManager.removeAllEventsForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventsForListener(listener:Function):void 
		{
			this._eventListenerManager.removeAllEventsForListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			this._eventListenerManager.removeAllEventListeners();
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return this._eventListenerManager;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get preloader():IPreloader
		{
			return this._preloadableBehavior.preloader;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloadableBehavior.preloader = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 * Checks if the object is actually loading or has loaded something before call super.unload();
		 */
		override public function unload():void
		{
			if (this._isLoaded || this._isLoading)
			{
				super.unload();
			}
			else
			{
				this.logInfo('Nothing is loaded, so unloading is useless');
			}
		}
		
		/**
		 * Does a Log.debug, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logDebug(data:*):void
		{
			Log.debug(data, this, this._registryId);
		}
		
		/**
		 * Does a Log.error, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logError(data:*):void
		{
			Log.error(data, this, this._registryId);
		}
		
		/**
		 * Does a Log.fatal, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logFatal(data:*):void
		{
			Log.fatal(data, this, this._registryId);
		}
		
		/**
		 * Does a Log.info, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logInfo(data:*):void
		{
			Log.info(data, this, this._registryId);
		}
		
		/**
		 * Does a Log.status, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logStatus(data:*):void
		{
			Log.status(data, this, this._registryId);
		}
		
		/**
		 * Does a Log.warn, but has already filled in some known data
		 * @param data the data to be logged
		 */
		protected final function logWarn(data:*):void
		{
			Log.warn(data, this, this._registryId);
		}
		
		temple function handleUnload(event:Event):void
		{
			this.destruct();
		}
		
		temple function handleAdded(event:Event):void
		{
			if (event.currentTarget == this) this._onParent = true;
		}

		temple function handleAddedToStage(event:Event):void
		{
			this._onStage = true;
		}

		temple function handleRemoved(event:Event):void
		{
			if (event.currentTarget == this) this._onParent = false;
		}
		
		temple function handleRemovedFromStage(event:Event):void
		{
			this._onStage = false;
		}

		temple function handleLoadStart(event:Event):void
		{
			this._preloadableBehavior.onLoadStart(event, this._url);
			this.dispatchEvent(event.clone());
		}

		temple function handleLoadProgress(event:ProgressEvent):void
		{
			this._preloadableBehavior.onLoadProgress(event);
			this.dispatchEvent(event.clone());
		}
		
		temple function handleLoadInit(event:Event):void
		{
			this.dispatchEvent(event.clone());
		}
		
		temple function handleLoadComplete(event:Event):void
		{
			this._isLoading = false;
			this._isLoaded = true;
			this._preloadableBehavior.onLoadComplete(event);
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Default IOError handler
		 */
		temple function handleIOError(event:IOErrorEvent):void
		{
			this._isLoading = false;
			this._preloadableBehavior.onLoadComplete(event);
			
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * Default SecurityError handler
		 * If logErrors is set to true, a error log message is traced
		 */
		temple function handleSecurityError(event:SecurityErrorEvent):void
		{
			this._isLoading = false;
			this._preloadableBehavior.onLoadComplete(event);
			
			if (this._logErrors) this.logError(event.type + ': ' + event.text);
			
			this.dispatchEvent(event.clone());
		}
		
		/**
		 * @inheritDoc
		 */
		public function get isDestructed():Boolean
		{
			return this._isDestructed;
		}

		/**
		 * @inheritDoc
		 */
		public function destruct():void 
		{
			if (this._isDestructed) return;
			
			this.dispatchEvent(new DestructEvent(DestructEvent.DESTRUCT));
			
			this._preloadableBehavior.destruct();
			
			if (this._eventListenerManager)
			{
				this.removeAllEventListeners();
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			
			if (this._isLoading)
			{
				try
				{
					this.close();
				}
				catch (e:Error){}
			}
			
			// TODO:
			// - throws error if loader.content is addChilded away
			// - check numChildren?
			// - is loader realy destructed, or will it hold a reference to the content?
			try
			{
				this.unload();
			}
			catch (e:ArgumentError)
			{
				//the loader.content is addChilded somewhere else, so it cannot be unloaded
			}
			
			if(this.contentLoaderInfo)
			{
				this.contentLoaderInfo.removeEventListener(Event.OPEN, temple::handleLoadStart);
				this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, temple::handleLoadProgress);
				this.contentLoaderInfo.removeEventListener(Event.INIT, temple::handleLoadInit);
				this.contentLoaderInfo.removeEventListener(Event.COMPLETE, temple::handleLoadComplete);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, temple::handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.DISK_ERROR, temple::handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, temple::handleIOError);
				this.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, temple::handleIOError);
				this.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, temple::handleSecurityError);
			}
			
			if (this.parent)
			{
				if (this.parent is Loader)
				{
					Loader(this.parent).unload();
				}
				else
				{
					if (this._onParent)
					{
						this.parent.removeChild(this);
					}
					else
					{
						// something weird happened, since we have a parent but didn't receive an ADDED event. So do the try-catch thing
						try
						{
							this.parent.removeChild(this);
						}
						catch (e:Error){}
					}
				}
			}
			
			this._isDestructed = true;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return getClassName(this);
		}
	}
}
