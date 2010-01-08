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

package temple.data.object 
{
	import temple.data.object.IObjectParsable;

	/**
	 * The ObjectParser parses an Object (ig JSON) to an other object (ig a type DataValueObject).
	 * The objects to parse to must be of type IObjectParsable. The ObjectParser calles the 'parseObject'
	 * method on the IObjectParsable and passes the Object that needs to be parsed.
	 * 
	 * @see temple.data.object.IObjectParsable
	 * 
	 * @date 12 nov 2008 16:10:20
	 * @author Arjan van Wijk (arjan[at]mediamonks.com)
	 */
	public class ObjectParser 
	{
		/**
		 * Parses a list (Array) of Objects to a listed of IObjectParsable objects
		 */
		public static function parseList(list:Array, classRef:Class, ignoreError:Boolean = false):Array 
		{
			var a:Array = new Array();
			
			if (list == null) return a;
			
			var len:int = list.length;
			for (var i:int = 0;i < len; i++) 
			{
				var ipa:IObjectParsable = parseObject(list[i], classRef, ignoreError);
				
				if ((ipa == null) && !ignoreError)
				{
					return null;
				}
				else
				{
					a.push(ipa);
				}
			}
			
			return a;
		}

		/**
		 * Parses a single Object to an IObjectParsable
		 */
		public static function parseObject(object:Object, classRef:Class, ignoreError:Boolean = false):IObjectParsable 
		{
			var ipa:IObjectParsable = new classRef();
			
			if (ipa.parseObject(object) || ignoreError) 
			{
				return ipa;
			}
			else 
			{
				return null;
			}
		}
	}
}
