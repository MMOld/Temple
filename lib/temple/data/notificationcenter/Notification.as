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
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;

	import flash.events.Event;

	/**
	 * A Notification. Posted by the NotificationCenter
	 * 
	 * <p>Although thiss class extends from Event this is not used as Event. The reason is that this
	 * is the only way to use weak references to functions.</p>
	 * 
	 * @see temple.data.notificationcenter.NotificationCenter
	 */
	public class Notification extends Event
	{
		private var _notificationCenter:NotificationCenter;
		private var _data:*;

		/**
		 * Creates a new Notification.
		 * @param name the name of the notification
		 * @param data the (optional) data to send with the notification
		 */
		public function Notification(notificationCenter:NotificationCenter, type:String, data:* = null)
		{
			super(type);
			
			this._notificationCenter = notificationCenter;
			this._data = data;

			if(type == null) throwError(new TempleArgumentError(this, "type can't be null"));
		}
		
		/**
		 * The name of the Notification, used as identifier
		 */
		public function get name():String
		{
			return this.type;
		}
		
		/**
		 * The data send with the Notification. The data is optional and can be null
		 */
		public function get data():*
		{
			return this._data;
		}

		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			return new Notification(this._notificationCenter, this.type, this._data);
		}

		/**
		 * @inheritDoc
		 */
		override public function get target():Object
		{
			return this._notificationCenter;
		}

		/**
		 * @inheritDoc
		 */
		override public function get currentTarget():Object
		{
			return this._notificationCenter;
		}
		
		/**
		 * Returns a reference of the NotificationCenter which created this Notification.
		 * Same as target and currentTarget.
		 */
		public function get notificationCenter():NotificationCenter
		{
			return this._notificationCenter;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String 
		{
			return getClassName(this) + " type='" + this.type + "', data=" + this._data;
		}
	}
}