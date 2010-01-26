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

package temple 
{
	import temple.debug.DebugMode;
	import temple.debug.Registry;
	import temple.debug.getClassName;
	import temple.debug.log.Log;

	/**
	 * This class contains information about the Temple Library and some global properties and settings.
	 * 
	 * <p>Note: This class contains only static properties. Therefore this class cannot be instantiated.</p> 
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
		public static const VERSION:String = "2.2.1";
		
		/**
		 * The Authors of the Temple
		 */
		public static const AUTHOR:String = "MediaMonks: Thijs Broerse, Arjan van Wijk, Quinten Beek";
		
		/**
		 * Last modified date of the Temple
		 */
		public static const DATE:String = "2010-01-26";
		
		/**
		 * When set to true, all Temple objects are registered in the Memory class with a weak reference.
		 * Usefull for debugging to track all existing objects.
		 * After destructing an object (and force a Garbage Collection) the object should no longer exist.
		 * 
		 * Note: Changing this value must be done here or before the super() inside the constructor of your application root
		 * 
		 * @see temple.debug.Registry
		 * @see temple.debug.Memory
		 */
		public static var registerObjectsInMemory:Boolean = true;
		
		/**
		 * When debug is not set in the url, this debugmode is used for the DebugManager.
		 * Possible values are:
		 * <table class="innertable">
		 * 	<tr>
		 * 		<th>DebugMode Constant</th>
		 * 		<th>Description</th>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.NONE</td>
		 * 		<td>Debug will be set to false on all debuggable objects. So no debug messages will be logged.</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.CUSTOM</td>
		 * 		<td>Debug can be set to each debuggable object individually.</td>
		 * 	</tr>
		 * 	<tr>
		 * 		<td>DebugMode.ALL</td>
		 * 		<td>Debug will be set to true on all debuggable objects. So debug messages will be logged</td>
		 * 	</tr>
		 * </table>
		 * 
		 * @see temple.debug.DebugManager
		 */
		public static var defaultDebugMode:int = DebugMode.CUSTOM;

		/**
		 * Indicates if Temple errors should be ignored. If set to true, Temple errors are still logged, but not throwed
		 * 
		 * @see temple.debug.errors.throwError
		 */
		public static var ignoreErrors:Boolean = false;
		
		/**
		 * Indicates if the package will be displayed when calling a toString() method on an object or class
		 * Example:
		 * If set to true trace(Temple) will output 'temple::Temple'
		 * If set to false trace(Temple) will output 'Temple'
		 * 
		 * @see temple.debug.getClassName#getClassName()
		 */
		public static var displayFullPackageInToString:Boolean = false;
		
		/**
		 * Destructs all objects of the Temple. Usefull when unloading an ApplicationDomainRoot object.
		 */
		public static function destruct():void
		{
			Log.warn(Temple, "All objects of the Temple are being destructed");
			Registry.destructAll();
		}
		
		/**
		 * Creates a readable string of the class
		 */
		public static function toString():String
		{
			return getClassName(Temple);
		}
	}
}
