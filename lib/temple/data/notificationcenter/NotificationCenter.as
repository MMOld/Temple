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

package temple.data.notificationcenter 
{
	import temple.core.CoreEventDispatcher;
	import temple.core.CoreObject;
	import temple.data.collections.HashMap;
	import temple.debug.DebugManager;
	import temple.debug.IDebuggable;
	import temple.debug.log.Log;

	/**
	 * The NotificationCenter is used for Objects to communicate with eachother without having a reference to eachother.
	 * 
	 * <p>An object (Observer) that wants to receive Notifications from the NotificationCenter adds itself to the
	 * NotificationCenter by using 'addObserver' and pass the type (String) of the Notification and a handler (function).
	 * This handler should accept one (and only one) argument of type Notification. The handler is called evertyime a 
	 * Notification of the specified type is posted.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance().addObserver("myNotification", handleNotification);
	 * 
	 * function handleNotification(notification:Notification):void
	 * {
	 * 		trace("Notification received: " + notification.type);
	 * }
	 * </listing>
	 * 
	 * <p>To post a Notification to the NotificationCenter use 'post'.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance().post("myNotification");
	 * </listing>
	 * 
	 * <p>It's possible to send a data object with a Notification. The Observer receives this data object in the Notification: notification.data.
	 * This data object is untyped, so you can send all types of objects.</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance().addObserver("myNotification", handleNotification);
	 * 
	 * function handleNotification(notification:Notification):void
	 * {
	 * 		trace("Notification received: " + notification.type + ", data:" + notification.data);
	 * }
	 * 
	 * NotificationCenter.getInstance().post("myNotification", "some data as String");
	 * </listing>
	 * 
	 * <p>All Observers are by default registered using weakReference. Therefor the objects can be removed by the Garbage Collector if there is no more
	 * (strong) reference to the object</p>
	 * 
	 * <p>The NotificationCenter is a multiton, so there can be multiple instances each with there own name:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * NotificationCenter.getInstance(); // returns the default NotificationCenter
	 * 
	 * NotificationCenter.getInstance("myNotificationCenter"); // returns a NotificationCenter with name "myNotificationCenter"
	 * </listing>
	 * 
	 * @see temple.data.notificationcenter.Notification
	 */
	public class NotificationCenter extends CoreObject implements IDebuggable
	{
		private static var _instances:HashMap;

		/**
		 * Static function to get instances by name. Multiton implementation
		 * @param name the name of the NotificationCenter
		 * @param createIfNull if set to true automaticly creates a new NotificationCenter if no NotificationCenter is found
		 * 
		 * @return a NotificationCenter instance
		 */
		public static function getInstance(name:String = 'default', createIfNull:Boolean = true):NotificationCenter
		{
			if(NotificationCenter._instances == null || NotificationCenter._instances[name] == null)
			{
				if(createIfNull)
				{
					if(NotificationCenter._instances == null)
					{
						NotificationCenter._instances = new HashMap("NotificationCenter instances");
					}
					NotificationCenter._instances[name] = new NotificationCenter(name);
				}
				else
				{
					Log.error("getInstance: no instance with name '" + name + "' found", 'temple.data.notificationcenter.NotificationCenter');
					return null;
				}
			}
			return NotificationCenter._instances[name] as NotificationCenter;
		}

		private var _eventDispatcher:CoreEventDispatcher; 
		private var _name:String;
		private var _debug:Boolean;

		/**
		 * Creates a new NotificationCenter. Call this constructor only if you explicitely don't want to use the getInstance() method
		 */
		public function NotificationCenter(name:String = null) 
		{
			this._name = name;
			
			super();
			
			this._eventDispatcher = new CoreEventDispatcher();
			
			DebugManager.add(this);
		}

		/**
		 * Get the name of the NotificationCenter
		 */
		public function get name():String
		{
			return this._name;
		}

		/**
		 * Registers observer to receive notifications of a specific type
		 * When a notification of the type is posted, method is called with a Notification as the argument.
		 * @param type notification identifier name
		 * @param listener The observer's method that will be called when notification is posted. This method should only have one argument (of type Notification).
		 * @param useWeakReference Determines whether the reference to the listener is strong or weak. A strong reference (the default) prevents your listener from being garbage-collected. A weak reference does not. 
		 */
		public function addObserver(type:String, listener:Function, useWeakReference:Boolean = true):void
		{
			if(this._debug) this.logDebug("addObserver: '" + type + "' ");
			
			this._eventDispatcher.addEventListener(type, listener, false, 0, useWeakReference);
		}
		
		/**
		 * Removes the observer(s) for a specific type and/or listeners.
		 * @param type notification identifier name
		 * @param listener The observer's method that will be called when notification is posted.
		 */
		public function removeObserver(type:String, listener:Function):void
		{
			this._eventDispatcher.removeEventListener(type, listener);
		}

		/**
		 * Creates a Notification instance and passes this to the observers associated through the type
		 * @param type notification identifier
		 * @param data (optional) object to pass - this will be packed in the Notification
		 */
		public function post(type:String, data:* = null):void
		{
			if(this._debug)
			{
				this.logDebug("post: '" + type + "', data: " + data);
				
				if (!this._eventDispatcher.hasEventListener(type))
				{
					this.logWarn("NotificationCenter has no observers for '" + type + "'");
				}
			}
			this._eventDispatcher.dispatchEvent(new Notification(this, type, data));
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
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this._eventDispatcher)
			{
				this._eventDispatcher.destruct();
				this._eventDispatcher = null;
			}
			
			if(NotificationCenter._instances)
			{
				delete NotificationCenter._instances[this._name];
				
				// check if there are some NotificationCenters left
				for(var key:String in NotificationCenter._instances);
				if(key == null) NotificationCenter._instances = null;
			}
			super.destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + " : " + this._name;
		}
	}
}