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
	 * Event class for use with the Service class. Listen to the generic event type to receive these events.
	 * The event has room for both a list of objects as result of a load operation, or a single object.
	 * It is left to the implementation of an extension of Service to determine which of these are used.
	 */
	public class XMLServiceEvent extends Event 
	{

		/** 
		 * Event sent when loading and parsing is completed
		 */
		public static const COMPLETE:String = "XMLServiceEvent.complete";

		/**
		 * Event sent when all requests have completed; does not check for errors
		 */
		public static const ALL_COMPLETE:String = "XMLServiceEvent.allComplete";

		/**
		 * Event sent when there was an error loading the data
		 */
		public static const LOAD_ERROR:String = "XMLServiceEvent.loadError";

		/**
		 * Event sent when there was an error parsing the data
		 */
		public static const PARSE_ERROR:String = "XMLServiceEvent.parseError";

		/** name of original request*/
		public var name:String;
		/** if applicable, a single array of typed data objects */
		public var list:Array;
		/** if applicable, a single object */
		public var object:Object;
		/** if applicable, a string describing the error */
		public var error:String;

		
		public function XMLServiceEvent(type:String, name:String = null, list:Array = null, object:Object = null, error:String = null) 
		{
			super(type);
			
			this.name = name;
			this.list = list;
			this.object = object;
			this.error = error;
		}

		override public function clone():Event 
		{
			return new XMLServiceEvent(this.type, this.name, this.list, this.object, this.error);
		}

		override public function toString():String 
		{
			return getClassName(this) + ": type = " + this.type + ", name = " + name;
		}
	}
}
