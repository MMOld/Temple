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
 
package temple.core 
{
	import temple.data.loader.IPreloader;
	import temple.data.loader.PreloadableBehavior;
	import temple.debug.Registry;
	import temple.debug.getClassName;
	import temple.debug.log.Log;
	import temple.destruction.DestructEvent;
	import temple.destruction.EventListenerManager;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	/**
	 * Dispatched just before the object is destructed
	 * @eventType temple.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.destruction.DestructEvent")]
	
	/**
	 * Base class for all NetStreams in the Temple.
	 */
	public class CoreNetStream extends NetStream implements ICoreLoader
	{
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _preloaderBehavior:PreloadableBehavior;
		private var _isLoaded:Boolean;
		private var _framePulseSprite:Sprite;
		private var _registryId:uint;
		private var _isLoading:Boolean;
		private var _logErrors:Boolean;
		private var _url:String;

		public function CoreNetStream(nc:NetConnection) 
		{
			super(nc);
			
			this._eventListenerManager = new EventListenerManager(this);
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			this._preloaderBehavior = new PreloadableBehavior(this);
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
		override public function play(...args:*):void
		{
			this._isLoaded = false;
			this._isLoading = true;
			this._url = args[0];
			
			this._framePulseSprite = new Sprite();
			this._framePulseSprite.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
			
			this._preloaderBehavior.onLoadStart(this, this._url);
			
			super.play.apply(this, args);
		}
		
		private function handleEnterFrame(event:Event):void
		{
			if (this.bytesLoaded == this.bytesTotal && this.bytesLoaded > 0)
			{
				this._framePulseSprite.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				
				this._preloaderBehavior.onLoadComplete(this);
				
				this._isLoaded = true;
				this._isLoading = false;
			}
			else
			{
				this._preloaderBehavior.onLoadProgress();
			}
		}
		
		/**
		 * Get or set the IPreloader
		 */
		public function get preloader():IPreloader
		{
			return this._preloaderBehavior.preloader;
		}
		
		/**
		 * @private
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloaderBehavior.preloader = value;
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
			this._eventListenerManager.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			this._eventListenerManager.removeAllStrongEventListenersForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			this._eventListenerManager.removeAllStrongEventListenersForListener(listener);
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
			
			this.removeAllEventListeners();
			
			if (this._framePulseSprite)
			{
				this._framePulseSprite.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this._framePulseSprite = null;
			}
			
			if(this._eventListenerManager)
			{
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
			}
			
			this._isDestructed = true;
		}

		/**
		 *	@inheritDoc
		 */
		override public function toString():String 
		{
			return getClassName(this);
		}
	}
}
