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

package temple.utils.types 
{
	import temple.Temple;
	import temple.utils.ObjectType;
	import temple.data.xml.XMLParser;
	import temple.debug.getClassName;

	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * This class contains some functions for Objects.
	 * 
	 * @author Thijs Broerse
	 */
	public class ObjectUtils 
	{
		/**
		 * Indicates if a Date will be fully traced (including all properties) on traceObject() (true) or only as a simple String (false)
		 */
		public static var subTraceDate:Boolean = false;
		
		/**
		 *
		 */
		public static function isPrimitive(value:*):Boolean
		{
			if(value is String || value is Number || value is int || value is uint || value == null)
			{
				return true;	
			}
			return false;
		}
		
		/**
		 * Recursively traces the properties of an object
		 * @param object object to trace
		 * @param maxDepth indicates the recursive factor
		 * @param doTrace indicates if the function will trace the output or only return it
		 * 
		 * @return the object tree as String
		 */
		public static function traceObject(object:Object, maxDepth:Number = 3, doTrace:Boolean = true):String
		{
			var output:String = ObjectUtils._traceObject(object, maxDepth);
			
			if(doTrace) trace(output);
			
			return output;
		}

		private static function _traceObject(object:Object, maxDepth:Number = 3, inOpenChar:String = null, isInited:Boolean = false, openChar:String = null, tabs:String = ""):String
		{
			var output:String = "";
			
			// every time this function is called we'll add another
			// tab to the indention in the output window
			tabs += "\t";
			
			if(maxDepth < 0 )
			{
				output += tabs + "\n(...)";
				output += "\n" + tabs + ((inOpenChar == "[") ? "]" : "}");
				return output;
			}
			
			if (!isInited) 
			{
				isInited = true;
				if (object is Array) 
				{
					openChar = "[";
				}
				else 
				{
					openChar = "\u007B";
				}
				output += "TraceObject: " + ObjectUtils.objectToString(object) + " (" + getClassName(object) + ")";
				output += "\n" + openChar;
			}
			
			var variables:Array;
			var key:*;

			if(object is Array)
			{
				
				variables = new Array();
				for (key in object)
				{
					variables.push(new ObjectVariableData(key));
				}
			}
			else
			{
				// variables
				variables = XMLParser.parseList(describeType(object).variable, ObjectVariableData, true);
				
				// getters
				variables = variables.concat(XMLParser.parseList(describeType(object).accessor, ObjectVariableData, true));
				
				// dynamic values
				for (key in object)
				{
					variables.push(new ObjectVariableData(key));
				}
				// sort variables alphabaticly
				variables = variables.sortOn('name', Array.CASEINSENSITIVE);
			}
			
			var variable:*;
			
			var leni:int = variables.length;
			for (var i:int = 0;i < leni; i++) 
			{
				var vardata:ObjectVariableData = variables[i] as ObjectVariableData;
				
				if(vardata.name == "textSnapshot" || vardata.name == null) continue;
				
				try
				{
					variable = object[vardata.name];
				}
				catch(e:Error)
				{
					variable = e.message;
				}
				
				// determine what's inside...
				switch (typeof(variable))
				{
					case ObjectType.STRING:
						output += "\n" + tabs + vardata.name + " : \"" + variable + "\"";
						break;
					case ObjectType.OBJECT:
						// check to see if the variable is an array.
						if (variable is Array) 
						{
							if (ObjectUtils.hasValues(variable) && maxDepth)
							{
								output += "\n" + tabs + vardata.name + " : Array\n" + tabs + "[";
								output += ObjectUtils._traceObject(variable, maxDepth - 1, "[", isInited, openChar, tabs);
							}
							else
							{
								output += "\n" + tabs + vardata.name + " : Array []";
							}
						}
						else 
						{
							// object, make exepction for Date, we do not 
							if (variable && maxDepth && (ObjectUtils.subTraceDate || !(variable is Date)))
							{
								// recursive call
								output += "\n" + tabs + vardata.name + " : " + variable;
								if (ObjectUtils.hasValues(variable))
								{
									output += "\n" + tabs + "\u007B";
									output += ObjectUtils._traceObject(variable, maxDepth - 1, "\u007B", isInited, openChar, tabs);
								}
							}
							else
							{
								output += "\n" + tabs + vardata.name + " : " + variable + (vardata.type ? " (" + ((Temple.displayFullPackageInToString || vardata.type.indexOf('::') == -1) ? vardata.type : vardata.type.split('::')[1]) + ")" : "");
							}
						}
						break;
					default:				
						//variable is not an object or string, just trace it out normally
						output += "\n" + tabs + vardata.name + " : " + variable;
						break;
				}
			}
			
			// here we need to displaying the closing '}' or ']', so we bring
			// the indent back a tab, and set the outerchar to be it's matching
			// closing char, then display it in the output window
			tabs = tabs.substr(0, tabs.length - 1);
			 
			output += "\n" + tabs + ((inOpenChar == "[") ? "]" : "}");
			
			return output;
		}

		/**
		 * Get the Class of an Object
		 */
		public static function getClass(object:Object):Class
		{
			return getDefinitionByName(getQualifiedClassName(object)) as Class;
		}

		/**
		 * Checks if the object has (one or more) values
		 */
		public static function hasValues(object:Object):Boolean
		{
			if(object is Array) return (object as Array).length > 0;
			
			for(var key:* in object) return true;
			key;
			
			var description:XML = describeType(object);
			
			return description.variable.length() || description.accessor.length();
		}

		/**
		 * Counts the number of elements in an Object
		 */
		public static function length(object:Object):int
		{
			var count:int = 0;
			for(var key:String in object) count++;
			key;
			return count;
		}
		
		/**
		 * Checks if the object is dynamic
		 */
		public static function isDynamic(object:Object):Boolean
		{
			var type:XML = describeType(object);
			return type.@isDynamic.toString() == "true";
		}

		/**
		 * Converts a typed object to an untyped dynamic object
		 */
		public static function toDynamic(object:Object):Object
		{
			var result:Object = new Object();
			for each (var node : XML in describeType(object).accessor.(@access == 'readwrite' || @access == 'readonly')) {
				result[node.@name] = object[node.@name];
			};
			
			return result;
		}
		
		/**
		 * Converts an object to a readable String
		 */
		public static function objectToString(object:*):String
		{
			if(typeof(object) == ObjectType.STRING)
			{
				return "\"" + object + "\"";
			}
			else if (object is XML)
			{
				return (object as XML).toXMLString();
			}
			return String(object);
		}

		public static function toString():String
		{
			return getClassName(ObjectUtils);
		}
	}
}