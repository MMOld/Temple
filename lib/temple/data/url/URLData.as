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
 
 package temple.data.url 
{
	import temple.core.CoreObject;
	import temple.data.xml.IXMLParsable;

	/**
	 * Data object class to hold information about an url.
	 */
	public class URLData extends CoreObject implements IXMLParsable 
	{
		protected var _name:String;
		protected var _url:String;
		protected var _target:String;

		/**
		 * Creates a new URLData.
		 * The constructor will be called without parameters by the Parser.
		 */
		public function URLData(name:String = null, url:String = null, target:String = null) 
		{
			this._name = name;
			this._url = url;
			this._target = target;
			
			super();
		}
		
		/**
		 * Unique identifying name of the url
		 */
		public function get name():String
		{
			return this._name;
		}
		
		/**
		 * Actual url
		 */
		public function get url():String
		{
			return this._url;
		}
		
		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			this._url = value;
		}
		
		/**
		 * Target of getURL function.
		 */
		public function get target():String
		{
			return this._target;
		}

		/**
		 * @inheritDoc
		 */
		public function parseXML(xml:XML):Boolean 
		{
			this._name = xml.@name;
			this._url = xml.@url;
			this._target = xml.@target;
			
			return ((this._name != null) && (this._url != null));
		}

		/**
		 * Creates a copy
		 */
		public function clone():URLData
		{
			return new URLData(this._name, this._url, this._target);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return super.toString() + ' (name="' + this._name + '", url="' + this._url + '")';
		}
	}
}