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

package temple.debug 
{
	import temple.Temple;
	import temple.debug.log.Log;
	import temple.destruction.Destructor;

	import flash.utils.Dictionary;

	/**
	 * This class holds objects with their unique id to identify them when needed.
	 * 
	 * <p><strong>What does it do</strong></p>
	 * <p>The Registry class stores objects in a weak-referenced Dictionary with an auto-incrementing id as value.  
	 * This class is used internally by the Temple for logging (where the unique id identifies the logging object),
	 * in the DebugManager and for storing objects in the Memory class (when 'Temple.registerObjectsInMemory' is set to true, all objects added to the Registry
	 * are also added to the Memory class to track their memory usage)</p>
	 * 
	 * <p><strong>Why should you use it</strong></p>
	 * <p>Having the Registry track all objects makes debugging of your code easier, since all logging and debugging functions specify which object traces a certain message.</p>
	 * 
 	 * <p><strong>How should you use it</strong></p>
	 * <p>If you make use of the Temple's CoreObjects (or their descendants) your objects will automatically be added to the Registry, so no extra action is needed to use the Registry.
	 * If you want to manually add your own objects to the Registry, you can do so by using the add function.</p>
	 *
	 * @see temple.Temple#registerObjectsInMemory
	 * 
	 * @date 9 jun 2009 15:05:27
	 * @author Arjan van Wijk (arjan at mediamonks dot com)
	 */
	public final class Registry 
	{
		private static var _objectList:Dictionary;
		private static var _object_id:uint = 0;
		
		/**
		 * Adding an object the the registry<br />
		 * When 'Temple.registerObjectsInMemory' is set to true, the object is also added to the Memory<br />
		 * Throws a warning when the object is added before
		 * @param object The object to add
		 * @return uint An unique id for the object added
	 	 * @see temple.debug.Memory#registerObject()
		 * @example
		 * <listing version="3.0">
		 * // In the constructor
		 * public function TestClass()
		 * {
		 * 		var id:uint = Registry.add(this);
		 * }
		 * 
		 * // or after creating an object
		 * var testClass:TestClass = new TestClass();
		 * var id:uint = Registry.add(testClass);
		 * </listing>
		 */
		public static function add(object:*):uint
		{
			if (!Registry._objectList)
			{
				Registry._objectList = new Dictionary(true);
			}
			
			if (Registry._objectList[object])
			{
				Log.warn("add: object '" + object + "' is already registered in Registry", "temple.debug.Registry");
				
				return Registry._objectList[object];
			}
			else
			{
				Registry._objectList[object] = ++Registry._object_id;
				
				if (Temple.registerObjectsInMemory && object)
				{
					Memory.registerObject(object);
				}
				if(Registry._object_id == uint.MAX_VALUE)
				{
					Log.warn("Max value reached in Registry", Registry);
				}
				
				return Registry._object_id;
			}
		}
		
		/**
		 * Gets the object by id.
		 * @param id the unique id of the object
		 * @return the object
		 * @example
		 * <listing version="3.0">
		 * var object:* = Registry.getObject(id);
		 * </listing>
		 * 
		 * Note: this function is slow, use only for debugging.
		 */
		public static function getObject(id:uint):*
		{
			if (Registry._objectList)
			{
				for (var object:* in Registry._objectList)
				{
					if (Registry._objectList[object] == id) return object;
				}
			}
			
			return null;
		}
		
		/**
		 * Gets the id of an object
		 * @param object The object added in the registry before
		 * @return uint The id of the Object
		 * @example
		 * <listing version="3.0">
		 * var objectId:uint = Registry.getId(object);
		 * </listing>
		 */
		public static function getId(object:*):uint
		{
			return Registry._objectList[object];
		}

		/**
		 * Destruct all objects in Registry
		 */
		public static function destructAll():void
		{
			for (var object:Object in Registry._objectList) Destructor.destruct(object);
		}
	}
}
