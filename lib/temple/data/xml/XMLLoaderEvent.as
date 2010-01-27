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
	import temple.debug.getClassName;

	import flash.events.Event;

	/**
	 * Event dispatched by the XMLLoader
	 */
	public class XMLLoaderEvent extends Event 
	{

		/**
		 * Event sent when loading of a single XML is complete
		 */
		public static const COMPLETE:String = "XMLLoaderEvent.complete";

		/**
		 * Event sent when the stack of loading XMLs is empty
		 */
		public static const ALL_COMPLETE:String = "XMLLoaderEvent.allComplete";

		/**
		 * Event sent when an error has occurred
		 */
		public static const ERROR:String = "XMLLoaderEvent.error";

		/**
		 * Event sent during loading of XML
		 */
		public static const PROGRESS:String = "XMLLoaderEvent.progress";

		private var _name:String;
		private var _data:XML;
		private var _error:String;
		private var _bytesLoaded:uint;
		private var _bytesTotal:uint;

		/**
		 * Creates a new XMLLoaderEvent.
		 * @param type see above
		 * @param name identifier name
		 * @param data the XML data object (only at COMPLETE)
		 */
		public function XMLLoaderEvent(type:String, name:String, data:XML = null) 
		{
			super(type);
			
			this._name = name;
			this._data = data;
		}
		
		/**
		 * The identifier name
		 */
		public function get name():String
		{
			return this._name;
		}
		
		/**
		 * The XML data, only available at COMPLETE
		 */
		public function get data():XML
		{
			return this._data;
		}
		
		public function set data(value:XML):void
		{
			this._data = value;
		}
		
		public function get error():String
		{
			return this._error;
		}
		
		public function set error(value:String):void
		{
			this._error = value;
		}
		
		public function get bytesLoaded():uint
		{
			return this._bytesLoaded;
		}
		
		public function set bytesLoaded(value:uint):void
		{
			this._bytesLoaded = value;
		}
		
		public function get bytesTotal():uint
		{
			return this._bytesTotal;
		}
		
		public function set bytesTotal(value:uint):void
		{
			this._bytesTotal = value;
		}
		
		/**
		 * Creates a copy of an existing XMLLoaderEvent.
		 */
		public override function clone():Event 
		{
			return new XMLLoaderEvent(this.type, this.name, this.data);
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String 
		{
			return getClassName(this) + "; name=" + this.name + "; type=" + this.type + "; error=" + this.error + "; bytesLoaded=" + this.bytesLoaded + "; bytesTotal=" + this.bytesTotal;
		}
	}
}
