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
	import temple.core.CoreObject;

	/**
	 * Internal class used by the XMLManager to store information about a loaded XML.
	 * 
	 * @author Thijs Broerse
	 */
	internal class XMLObjectData extends CoreObject
	{
		public static var OBJECT:int = 1;
		public static var LIST:int = 2;

		private var _type:int;
		private var _objectClass:Class;
		private var _node:String;
		private var _callback:Function;
		private var _object:Object;
		private var _list:Array;
		private var _cache:Boolean;

		public function XMLObjectData(type:int, objectClass:Class, node:String, cache:Boolean, callback:Function = null) 
		{
			this._type = type;
			this._objectClass = objectClass;
			this._node = node;
			this._cache = cache;
			this._callback = callback;
		}
		
		public function get type():int
		{
			return this._type;
		}
		
		public function get objectClass():Class
		{
			return this._objectClass;
		}
		
		public function get node():String
		{
			return this._node;
		}
		
		internal function get callback():Function
		{
			return this._callback;
		}
		
		internal function set callback(value:Function):void
		{
			this._callback = value;
		}

		public function get object():Object
		{
			return this._object;
		}
		
		internal function setObject(value:Object):void
		{
			this._object = value;
		}
		
		public function get list():Array
		{
			return this._list;
		}
		
		internal function setList(value:Array):void
		{
			this._list = value;
		}
		
		public function get cache():Boolean
		{
			return this._cache;
		}

		override public function toString():String 
		{
			return super.toString() + " : " + this._objectClass;
		}

		override public function destruct():void
		{
			this._objectClass = null;
			this._node = null;
			this._callback = null;
			this._object = null;
			this._list = null;
			
			super.destruct();
		}
	}
}
