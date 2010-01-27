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
	import temple.core.CoreEventDispatcher;
	import temple.data.encoding.IDecoder;
	import temple.data.loader.ILoader;
	import temple.ui.ICancellable;

	import flash.events.Event;

	/**
	 * Used by the XMLManager to store information about the URL of a XML
	 * 
	 * @author Thijs Broerse
	 */
	public class XMLLoadItem extends CoreEventDispatcher implements ILoader, ICancellable
	{
		private var _name:String;
		private var _url:String;
		internal var _sendData:Object;
		internal var _method:String;
		internal var _xml:XML;
		internal var _cache:Boolean;
		internal var _decoder:IDecoder;
		private var _xmlObjectDataList:Array;
		private var _isLoading:Boolean;
		internal var _isLoaded:Boolean;

		public function XMLLoadItem(name:String, url:String, xmlObjectData:XMLObjectData, sendData:Object, method:String, cache:Boolean, decoder:IDecoder) 
		{
			this._name = name;
			this._url = url;
			this._xmlObjectDataList = new Array;
			this.addXMLObjectData(xmlObjectData);
			this._sendData = sendData;
			this._method = method;
			this._cache = cache;
			this._decoder = decoder;
			this._isLoading = true;
		}
		
		public function get name():String
		{
			return this._name;
		}
		
		public function get url():String
		{
			return this._url;
		}
		
		public function get sendData():Object
		{
			return this._sendData;
		}
		
		public function get method():String
		{
			return this._method;
		}
		
		public function get xml():XML
		{
			return this._xml;
		}
		
		internal function get cache():Boolean
		{
			return this._cache;
		}
		
		internal function get decoder():IDecoder
		{
			return this._decoder;
		}
		
		internal function setLoaded():void
		{
			this._isLoaded = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
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

		internal function addXMLObjectData(xmlObjectData:XMLObjectData):void
		{
			this._isLoading = false;
			this._xmlObjectDataList.push(xmlObjectData);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Cancel a load
		 * @return true if cancel was succesfull, otherwise returns false
		 */
		public function cancel():Boolean
		{
			this._isLoading = false;
			return XMLManager.getInstance().cancelLoad(this._name);
		}

		internal function findXMLObjectData(objectClass:Class, node:String):XMLObjectData
		{
			for each (var data:XMLObjectData in this._xmlObjectDataList) 
			{
				if(data.objectClass == objectClass && data.node == node)
				{
					return data;
				}
			}
			return null;
		}

		public function get xmlObjectDataList():Array
		{
			return this._xmlObjectDataList;
		}
		
		public function get data():Array
		{
			var a:Array = new Array();
			for each (var data:XMLObjectData in this._xmlObjectDataList) 
			{
				a.push(data.object ? data.object : data.list);
			}
			return a;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this._isLoading) this.cancel();
			this._sendData = null;
			this._xml = null;
			this._decoder = null;
			if(this._xmlObjectDataList)
			{
				for each (var xmlObject : XMLObjectData in this._xmlObjectDataList) 
				{
					xmlObject.destruct();
				}
				this._xmlObjectDataList = null;
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
