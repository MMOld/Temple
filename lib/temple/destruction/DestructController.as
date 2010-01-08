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

package temple.destruction 
{
	import temple.core.CoreObject;

	import flash.utils.Dictionary;

	/**
	 * The DestructController us used to destruct multiple objects at once.
	 * 
	 * <p>Add objects to the DestructController, call destructAll() to destruct all objects.
	 * Objects are stored using a weak-reference, so the DestructController will not block
	 * objects for garbage collection.</p>
	 * 
	 * @author Bart, Thijs Broerse
	 */
	public class DestructController extends CoreObject
	{
		protected static var _instance:DestructController;

		private var _list:Dictionary;
		private var _debug:Boolean = false;

		/**
		 * Creates a new DestructController
		 */
		public function DestructController()
		{
			this._list = new Dictionary(true);
		}

		/**
		 * Add an object to the DestructController for later destruction.
		 */
		public function add(object:Object):void
		{
			this._list[object] = true;
			if (this._debug) this.logDebug("Add " + object);
		}

		/**
		 * Destruct all objects of the DestructController
		 */
		public function destructAll():void
		{
			for (var object:Object in this._list) 
			{
				if (this._debug) this.logDebug("Destruct " + object);
				Destructor.destruct(object);
				delete this._list[object];
			}
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
			if(this._list)
			{
				this.destructAll();
				this._list = null;
			}
			super.destruct();
		}
	}
}