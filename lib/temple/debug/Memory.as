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
	import temple.debug.Registry;
	import temple.debug.log.Log;
	import temple.destruction.EventListenerManager;
	import temple.destruction.IDestructable;
	import temple.destruction.IDestructableEventDispatcher;

	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.Dictionary;

	/**
	 * This class is used for Memory management
	 * - forcing garbage collection
	 * - tracking objects being hold in the memory
	 * - functions for outputting the memory info
	 */
	public class Memory
	{
		private static var _registry:Dictionary; 

		/**
		 * Forces the Garbage Collector to run
		 */
		public static function forceGarbageCollection():void
		{
			try
			{
			   new LocalConnection().connect('foo');
			   new LocalConnection().connect('foo');
			}
			catch (e:*) {}
		}
		
		/**
		 * Returns the totalMemory used by Flash
		 * @return The totalMemory used by Flash
		 */
		public static function get used():uint
		{
			return System.totalMemory;
		}

		/**
		 * Registers an object with a weak reference to track the object
		 * This only works when 'Temple.registerObjectsInMemory' is set to true or
		 * the forceRegister is set to true
		 * @param object The object to register in the memory
		 * @param object Force the registration of an object if 'Temple.registerObjectsInMemory' is set to false
		 * @example
		 * <listing version="3.0">
		 * // in the constructor of a class
		 * public function TestClass()
		 * {
		 * 		Memory.registerObject(this);
		 * }
		 * </listing> 
		 */
		public static function registerObject(object:Object, forceRegister:Boolean = false):void
		{
			if ((Temple.registerObjectsInMemory || forceRegister) && object)
			{
				if (!Memory._registry)
				{
					Memory._registry = new Dictionary(true);
					Log.warn("RegisterObjectsInMemory enabled: all Temple Objects are tracked", Memory);
				}
				
				if (Memory._registry[object])
				{
					Log.warn("Object '" + object + "' is already registered in Memory", Memory);
				}
				else
				{
					var registryId:uint = Registry.getId(object);
					
					// If not in Registry, add it there
					// Registry will add it to the memory again
					if (Temple.registerObjectsInMemory == true && registryId == 0)
					{
						Registry.add(object);
					}
					else
					{
						// If not in Registry, and 'Temple.registerObjectsInMemory' is set to false
						// add it here, because the Registry will not add it to the Memory again
						if (Temple.registerObjectsInMemory == false && registryId == 0) Registry.add(object);
						
						// get stack trace info
						var stacktrace:String = new Error("Get stack").getStackTrace();
						if (stacktrace)
						{
							var a:Array = stacktrace.split("\n");
							var stackList:Array = new Array();
							for (var i:int = 1;i < a.length; i++) 
							{
								stackList.push(String(a[i]).substr(4));
							}
						}
						
						// store info about the object
						Memory._registry[object] = new RegisteryInfo(stacktrace ? stackList.join("\n") : '', Registry.getId(object));
					}
				}
			}
		}

		/**
		 * Logs all objects that are currently registered by the memory and are not deleted by the Garbage Collector
		 * This function uses getRegistryObjects to get this objects
		 * @param traceTimestamp if set to true, the time when the object was registered is traced as wel
		 * @param traceStack if set to true, the stack when the object was registered is traced as wel, this comes in handy to check which object created the current object
		 * @param excludeFirstStacktraceLines Used mostly by tools; the array with stack-roots are excluded from the trace
		 * @return the log message
		 */
		public static function logRegistry(traceTimestamp:Boolean = false, traceStack:Boolean = false, excludeFirstStacktraceLines:Array = null):String
		{
			var message:String = "Current objects are registered and not cleaned by the Garbage Collector:\n";
			
			var arrMemoryObjects:Array = Memory.getRegistryObjects(traceTimestamp, traceStack, excludeFirstStacktraceLines);
			
			for (var i:int = 0; i < arrMemoryObjects.length; ++i)
			{
				message += arrMemoryObjects[i].value + "\n";
			}
			
			message += "Total objects: " + arrMemoryObjects.length;
			
			Log.info(message, Memory);
			
			return message;
		}
		
		/**
		 * Gets all objects that are currently registered by the memory and are not deleted by the Garbage Collector
		 * @param traceTimestamp if set to true, the time when the object was registered is traced as wel
		 * @param traceStack if set to true, the stack when the object was registered is traced as wel, this comes in handy to check which object created the current object
		 * @param excludeFirstStacktraceLines Used mostly by tools; the array with stack-roots are excluded from the trace
		 * @return An array of objects with the following information:
		 * 			- timestamp: When the object was added
		 * 			- value: object.toString() + timestamp + stacktrace
		 */
		public static function getRegistryObjects(traceTimestamp:Boolean = false, traceStack:Boolean = false, excludeFirstStacktraceLines:Array = null):Array
		{
			var arrTmp:Array = new Array();
			
			for (var object:* in Memory._registry)
			{
				var value:RegisteryInfo = Memory._registry[object];
				var str:String = '';
				str += " " + String(object) + (traceTimestamp ? " --- created:" + value.timestamp : "");
				if (traceStack)
				{
					str += "\n" + "  " + value.stack + "\n";
				}
				
				
				if (excludeFirstStacktraceLines)
				{
					if (excludeFirstStacktraceLines.indexOf(value.stack.substr(value.stack.lastIndexOf("\n") + String("\n").length)) == -1)
					{
						arrTmp.push({timestamp: value.timestamp, value: str});
					}
				}
				else
				{
					arrTmp.push({timestamp: value.timestamp, value: str});
				}
				
			}
			
			arrTmp.sortOn('timestamp', Array.NUMERIC);
			
			return arrTmp;
		}
		
		/**
		 * Gets a xml-formatted list of all the registered objects with their information
		 * This function is mostly used by tools
		 * @param excludeStackrootObjects An array with strackroots from objects to exclude from the result
		 * @param fullstacktrace Return the full stacktrace or only the stack root
		 * @returns
		 * <listing version="3.0">
		 * 	<root>
		 * 		...
		 * 		<memoryobject id="1" timestamp="123" object="flash.display::MovieClip" stackroot="flash.display::Sprite:construct()" numlisteners="3" isdestructed="false">
		 *			<listeners>
		 *				click
		 *				mouseUp
		 *				mouseDOwn
		 *			</listeners>   
		 *			<stack>
		 *				flash.display::DisplayObject:construct()
		 *				flash.display::InteractiveDisplayObject:construct()
		 *				flash.display::Sprite:construct()
		 *			</stack>   
		 *		</memoryobject>
		 *		...
		 * 	</root>
		 * </listing>
		 */
		public static function getRegistryObjectsAsXml(excludeStackrootObjects:Array = null, fullstacktrace:Boolean = true):XML
		{
			var xml:String = '<root>';
			var arrTmp:Array = new Array();
			
			for (var object:* in Memory._registry)
			{
				var value:RegisteryInfo = Memory._registry[object];
				arrTmp.push({timestamp: value.timestamp, info: value, object:object});
			}
			
			arrTmp.sortOn('timestamp', Array.NUMERIC);
			
			for (var i:int = 0; i < arrTmp.length; ++i)
			{
				var info:RegisteryInfo = arrTmp[i].info;
				
				var stackroot:String = info.stack.substr(info.stack.lastIndexOf("\n") + String("\n").length);
				if (excludeStackrootObjects && excludeStackrootObjects.indexOf(stackroot) != -1) continue;
				
				var arrListeners:Array = arrTmp[i].object is IDestructableEventDispatcher ? EventListenerManager.getDispatcherInfo(arrTmp[i].object as IDestructableEventDispatcher) : new Array();
				
				xml += '<memoryobject id="' + info.objectId + '" timestamp="'+ info.timestamp + '" object="' + String(arrTmp[i].object) + '" stackroot="' + (stackroot) + '" numlisteners="' + arrListeners.length + '" isdestructed="' + (arrTmp[i].object is IDestructable ? IDestructable(arrTmp[i].object).isDestructed : false) + '">' +
					'<listeners>' + (arrListeners.join("\n")) + '</listeners>' +   
					'<stack>' + (fullstacktrace ? info.stack : "enable 'fullstacktrace' to see this\n" + stackroot) + '</stack>' +   
				'</memoryobject>'; 
			}
			
			xml += '</root>';
			
			return XML(xml);
			
		}	

		/**
		 * Get the total of registered objects in Memory
		 * @return The total number of registered objects in Memory
		 */
		public static function totalRegisteredObject():Number
		{
			var total:Number = 0;
			for each (var value:* in Memory._registry)
			{
				total++;
				value;
			}
			return total;
		}
		
		public static function toString():String
		{
			return getClassName(Memory);
		}
	}
}

import flash.utils.getTimer;

class RegisteryInfo
{
	private var _stack:String;
	private var _timestamp:int;
	private var _objectId:uint;

	/**
	 * Internal class to store information about an object registration
	 */
	public function RegisteryInfo(stack:String, objectId:uint) 
	{
		this._timestamp = getTimer();
		this._stack = stack;
		this._objectId = objectId;
	}

	public function get stack():String
	{
		return this._stack;
	}
	
	public function get timestamp():int
	{
		return this._timestamp;
	}
	
	public function get objectId():uint
	{
		return this._objectId;
	}
}