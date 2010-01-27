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

	/**
	 * This class contains some functions for Regular Expressions.
	 * 
	 * @date 3 dec 2008 10:13:51
	 * @author Arjan van Wijk (arjan at mediamonks dot com)
	 */
	public final class RegExpUtils 
	{
		/**
		 * Searches text for all matches to the regular expression given in pattern and return the result.
		 * @param regExp the regular expression
		 * @param text the string to search on
		 */
		public static function preg_match_all(regExp:RegExp, text:String):Array
		{
			var resultList:Array = new Array();
			
			var result:Object = regExp.exec(text);
			
			var index:int = -1;
			while (result != null && index != result.index)
			{
				for (var i:int = 0; i < result.length; ++i)
				{
					if (true)
					{
						if (resultList[i] == null) resultList[i] = new Array();
						resultList[i].push(result[i] != undefined ? result[i] : '');
					}
					else
					{
						// PREG_SET_ORDER implementatie
					}
				}
				index = result.index;
				result = regExp.exec(text);
			}
			return resultList;
		}

		/**
		 * Searches for a match to the regular expression given in pattern.
		 * @param regExp the regular expression
		 * @param text the string to search on
		 */
		public static function preg_match(regExp:RegExp, content:String):Array
		{
			var resultList:Array = new Array();
			
			var result:Object = regExp.exec(content);
			if (result != null)
			{
				for (var i:int = 0; i < result.length; ++i)
				{
					resultList.push(result[i] != undefined ? result[i] : '');
				}
			}
			return resultList;
		}
	}
}
