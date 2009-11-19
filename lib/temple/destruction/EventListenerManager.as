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

package temple.destruction 
{	import temple.debug.errors.TempleError;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.core.CoreObject;

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * The EventListenerManager store information about event listeners on an object. Since all listeners are stored they can easely be removed, by type, listener or all.
	 */
	public class EventListenerManager extends CoreObject implements IEventDispatcher, IDestructableEventDispatcher 	{		private var _eventDispatcher:IEventDispatcher;		private var _events:Array;		private var _blockRequest:Boolean;

		/**
		 * Returns a list of all listeners of the dispatcher (registered by the EventListenerManager)
		 * @param dispatcher The dispatcher you want info about
		 */
		public static function getDispatcherInfo(dispatcher:IDestructableEventDispatcher):Array
		{
			var list:Array = new Array();
			
			var listenerManager:EventListenerManager = dispatcher.eventListenerManager;
			
			if (listenerManager && listenerManager._events.length)
			{
				for each (var eventData:EventData in listenerManager._events)
				{
					list.push(eventData.type);
				}
			}
			return list;
		}
		/**		 * Creates a new instance of a EventListenerManager. Do not create more one EventListenerManager for each IDestructableEventDispatcher!
		 * @param eventDispatcher the EventDispatcher of this EventListenerManager		 */		public function EventListenerManager(eventDispatcher:IDestructableEventDispatcher) 		{
			this._eventDispatcher = eventDispatcher;			this._events = new Array();			
			super();
			
			if(eventDispatcher == null) throwError(new TempleArgumentError(this, "dispatcher can not be null"));
			if(eventDispatcher.eventListenerManager) throwError(new TempleError(this, "dispatcher already has an EventListenerManager"));
		}
		
		/**
		 * Returns a reference to the EventDispatcher
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return this._eventDispatcher;
		}		/**		 * Notifies the ListenerManager instance that a listener has been added to the {@code IEventDispatcher}.		 * 			 * @param type The type of event.		 * @param listener The listener function that processes the event.		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.		 * @param priority The priority level of the event listener.		 * @param useWeakReference Determines whether the reference to the listener is strong or weak.		 */		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 		{			var l:int = this._events.length;			while (l--)
			{				if ((this._events[l] as EventData).equals(type, listener, useCapture)) return;
			}			this._events.push(new EventData(type, listener, useCapture));		}		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean 		{
			return this._eventDispatcher.dispatchEvent(event);		}		/**		 * @inheritDoc		 */		public function hasEventListener(type:String):Boolean 		{
			return this._eventDispatcher.hasEventListener(type);		}		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean 		{
			return this._eventDispatcher.willTrigger(type);		}		/**		 * Notifies the ListenerManager instance that a listener has been removed from the {@code IEventDispatcher}.		 * 			 * @param type The type of event.		 * @param listener The listener function that processes the event.		 * @param useCapture Determines whether the listener works in the capture phase or the target and bubbling phases.		 */		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void 		{			if (this._blockRequest || !this._events) return;						var l:int = this._events.length;			while (l--)
			{				if ((this._events[l] as EventData).equals(type, listener, useCapture))
				{					EventData(this._events.splice(l, 1)[0]).destruct();
				}
			}		}		/**
		 * @inheritDoc
		 */
		public function removeAllEventsForType(type:String):void 		{			this._blockRequest = true;						var l:int = this._events.length;			var eventData:EventData;			while (l--) 			{				eventData = this._events[l];								if (eventData.type == type) 				{					eventData = this._events.splice(l, 1)[0];										if (this._eventDispatcher) this._eventDispatcher.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					
					eventData.destruct();				}			}						this._blockRequest = false;		}		/**
		 * @inheritDoc
		 */
		public function removeAllEventsForListener(listener:Function):void 		{			this._blockRequest = true;						var l:int = this._events.length;			var eventData:EventData;			while (l--) 			{				eventData = this._events[l];								if (eventData.listener == listener) 				{					eventData = this._events.splice(l, 1)[0];										if (this._eventDispatcher) this._eventDispatcher.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					
					eventData.destruct();				}			}						this._blockRequest = false;		}		/**
		 * @inheritDoc
		 */
		public function removeAllEventListeners():void 		{			this._blockRequest = true;			
			if (this._events)
			{				var l:int = this._events.length;				var eventData:EventData;				while (l--) 				{					eventData = this._events.splice(l, 1)[0];										if (this._eventDispatcher) this._eventDispatcher.removeEventListener(eventData.type, eventData.listener, eventData.useCapture);
					
					eventData.destruct();				}
			}						this._blockRequest = false;		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventListenerManager():EventListenerManager
		{
			return null;
		}		/**
		 * @inheritDoc
		 */
		override public function destruct():void 		{
			this.removeAllEventListeners();			
			for each (var eventData:EventData in this._events) eventData.destruct();
			
			this._eventDispatcher = null;
			this._events = null;
			
			super.destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + " : " + this._eventDispatcher;		}
	}}

import temple.debug.getClassName;

class EventData{	public var type:String;	public var listener:Function;	public var useCapture:Boolean;		public function EventData(type:String, listener:Function, useCapture:Boolean) 	{		this.type = type;
		this.listener = listener;		this.useCapture = useCapture;
		
		super();	}	public function equals(type:String, listener:Function, useCapture:Boolean):Boolean 	{		return this.type == type && this.listener == listener && this.useCapture == useCapture;	}

	/**
	 * Destructs the object
	 */
	public function destruct():void
	{
		this.type = null;
		this.listener = null;
	}
	
	public function toString():String
	{
		return getClassName(this) + ":" + this.type;
	}}