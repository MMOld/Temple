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
	import temple.debug.Registry;
	import temple.debug.getClassName;
	import temple.debug.log.Log;
	import temple.destruction.DestructEvent;
	import temple.destruction.EventListenerManager;
	import temple.utils.StageProvider;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Dispatched just before the object is destructed
	 * @eventType temple.destruction.DestructEvent.DESTRUCT
	 */
	[Event(name = "DestructEvent.destruct", type = "temple.destruction.DestructEvent")]

	/**
	 * Base class for all Bitmaps in the Temple. The CoreBitmap handles some core features of the Temple:
	 * <ul>
	 * 	<li>Registration to the Registry class</li>
	 * 	<li>Global reference to the stage trough the StageProvider</li>
	 * 	<li>Event dispatch optimization</li>
	 * 	<li>Easy remove of all EventListeners</li>
	 * 	<li>Wrapper for Log class for easy logging</li>
	 * 	<li>Completely destructable</li>
	 * 	<li>Can be tracked in Memory (of this feature is enabled)</li>
	 * 	<li>Automatic disposes BitmapData on destruction</li>
	 * 	<li>Some usefull extra properties like autoAlpha, position and scale</li>
	 * </ul>
	 * 
	 * <p>Note: The CoreBitmap will automatic dispose the BitmapData on destruction. If you do not want that you should set disposeBitmapDataOnDestruct to false.</p>
	 * 
	 * <p>You should always use and/or extend the CoreBitmap instead of MovieClip if you want to make use of the Temple features.</p>
	 *
	 * @author Thijs Broerse
	 */
	public class CoreBitmap extends Bitmap implements ICoreDisplayObject
	{
		private namespace temple;
		
		private var _eventListenerManager:EventListenerManager;
		private var _isDestructed:Boolean;
		private var _onStage:Boolean;
		private var _onParent:Boolean;
		private var _registryId:uint;
		private var _disposeBitmapDataOnDestruct:Boolean;

		public function CoreBitmap(bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false, disposeBitmapDataOnDestruct:Boolean = true)
		{
			super(bitmapData, pixelSnapping, smoothing);

			this._eventListenerManager = new EventListenerManager(this);
			this._disposeBitmapDataOnDestruct = disposeBitmapDataOnDestruct;

			if (this.loaderInfo) this.loaderInfo.addEventListener(Event.UNLOAD, temple::handleUnload, false, 0, true);
			
			// Register object for destruction testing
			this._registryId = Registry.add(this);
			
			// Set listeners to keep track of object is on stage, since we can't trust the .parent property
			this.addEventListener(Event.ADDED, temple::handleAdded);
			this.addEventListener(Event.ADDED_TO_STAGE, temple::handleAddedToStage);
			this.addEventListener(Event.REMOVED, temple::handleRemoved);
			this.addEventListener(Event.REMOVED_FROM_STAGE, temple::handleRemovedFromStage);
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
		 * 
		 * When object is not on the stage it gets the stage reference from the StageProvider
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
		 */
		public function get scale():Number
		{
			if(this.scaleX == this.scaleY) return this.scaleX;
			return NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set scale(value:Number):void
		{
			this.scaleX = this.scaleY = value;
		}
		
		/**
		 * Indicates of the BitmapData should be disposed when the CoreBitmap is destructed. Default: true
		 */
		public function get disposeBitmapDataOnDestruct():Boolean
		{
			return this._disposeBitmapDataOnDestruct;
		}
		
		/**
		 * @private
		 */
		public function set disposeBitmapDataOnDestruct(value:Boolean):void
		{
			this._disposeBitmapDataOnDestruct = value;
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
			if (this._eventListenerManager) this._eventListenerManager.addEventListener(type, listener, useCapture, priority, useWeakReference);
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
		public function removeAllStrongEventListenersForType(type:String):void 
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllStrongEventListenersForType(type);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllStrongEventListenersForListener(listener:Function):void 
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllStrongEventListenersForListener(listener);
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 
		{
			if (this._eventListenerManager) this._eventListenerManager.removeAllEventListeners();
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
			if (event.target == this)
			{
				this._onParent = false;
				if (!this._isDestructed) this.addEventListener(Event.ENTER_FRAME, temple::handleDestructedFrameDelay);
			}
		}
		
		temple function handleDestructedFrameDelay(event:Event):void
		{
			this.removeEventListener(Event.ENTER_FRAME, temple::handleDestructedFrameDelay);
			temple::checkParent();
		}

		/**
		 * Check objects parent, after being removed. If the object still has a parent, the object has been removed by a timeline animation.
		 * If an object is removed by a timeline animation, the object is not used anymore and can be destructed
		 */
		temple function checkParent():void
		{
			if (this.parent && !this._onParent) this.destruct();
		}

		temple function handleRemovedFromStage(event:Event):void
		{
			this._onStage = false;
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
			
			if(this.bitmapData && this._disposeBitmapDataOnDestruct)
			{
				this.bitmapData.dispose();
			}
			this.bitmapData = null;
			
			// clear mask, so it won't keep a reference to an other object
			this.mask = null;
			
			if (this.loaderInfo) this.loaderInfo.removeEventListener(Event.UNLOAD, temple::handleUnload);
			
			this.removeEventListener(Event.ENTER_FRAME, temple::handleDestructedFrameDelay);
			
			if (this._eventListenerManager)
			{
				this.removeAllEventListeners();
				this._eventListenerManager.destruct();
				this._eventListenerManager = null;
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
			return getClassName(this) + ": " + this.name;
		}
	}
}
