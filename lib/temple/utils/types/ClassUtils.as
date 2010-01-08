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
	import temple.debug.getClassName;

	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * This class contains some functions for Classes.
	 *
	 * @author Bart (bart at mediamonks dot com)
	 * 
	 */
	public class ClassUtils 
	{
		/**
		 * Check if a given Class is a subClass of another Class or implements a Class or Interface.
		 * (Somewhat expensive (describeType) so take care.)
		 */
		public static function isSubClassOf(checkType:Class, superType:Class):Boolean
		{
			var superName:String = getQualifiedClassName(superType); 
			var factoryList:XMLList = describeType(checkType)['factory'];
			var checkList:XMLList;
			var elem:XML;
			if(checkType == superType)
			{
				return true;
			}
			
			checkList = factoryList['extendsClass'];			for each (elem in checkList)
			{
				if(elem.@['type'] == superName)
				{
					return true;	
				}
			}
			
			checkList = factoryList['implementsInterface'];
			for each (elem in checkList)
			{
				if(elem.@['type'] == superName)
				{
					return true;	
				}
			}
			
			return false;
		}

		/**
		 * Check if a given Class has a parameterless constructor
		 * (Somewhat expensive (describeType) so take care.)
		 */
		public static function hasSimpleConstructor(checkType:Class):Boolean
		{
			var factoryList:XMLList = describeType(checkType)['factory'];
			if(factoryList.elements('constructor').length() > 0)
			{
				return false;	
			}
			return true;
		}
		
		public static function toString():String
		{
			return getClassName(ClassUtils);
		}
	}
}
