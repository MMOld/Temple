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

package temple 
{

	/**
	 * This class contains information about the Temple Library and some global properties and settings 
	 */
	public class Temple 
	{
		/**
		 * The name of the Temple
		 */
		public static const NAME:String = "Temple";
		
		/**
		 * The current version of the Temple Library
		 */
		public static const VERSION:String = "2.1.0";
		
		/**
		 * The Authors of the Temple
		 */
		public static const AUTHOR:String = "MediaMonks: Thijs Broerse, Arjan van Wijk, Quinten Beek";
		
		/**
		 * When set to true, all Temple objects are registered in the Memory class with a weak reference.
		 * Usefull for debugging to track all existing objects.
		 * After destructing an object (and force a Garbage Collection) the object should no longer exist.
		 * 
		 * NOTE: Changing this value must be done here
		 */
		public static const REGISTER_OBJECTS:Boolean = true;
		
		/**
		 * When debug is not set in the url, this debugmode is used for the DebugManager.
		 * Possible values are:
		 * - NONE:uint = 1;
		 * - CUSTOM:uint = 2;
		 * - ALL:uint = 4;
		 */
		public static const DEFAULT_DEBUG_MODE:int = 2;
		
		/**
		 * Indicates if Temple errors should be ignored. If set to true, Temple errors are still logged, but not throwed
		 */
		public static const IGNORE_ERRORS:Boolean = false;
	}
}
