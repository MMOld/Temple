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

	/**
	 * This class contains some functions for Integers.
	 */
	public class IntUtils 
	{

		/**
		 * Rotates x left n bits
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function rol( x:int, n:int ):int 
		{
			return ( x << n ) | ( x >>> ( 32 - n ) );
		}

		/**
		 * Rotates x right n bits
		 *
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function ror( x:int, n:int ):uint 
		{
			var nn:int = 32 - n;
			return ( x << nn ) | ( x >>> ( 32 - nn ) );
		}

		/** String for quick lookup of a hex character based on index */
		private static var hexChars:String = "0123456789abcdef";

		/**
		 * Outputs the hex value of a int, allowing the developer to specify
		 * the endinaness in the process.  Hex output is lowercase.
		 *
		 * @param n The int value to output as hex
		 * @param bigEndian Flag to output the int as big or little endian
		 * @return A string of length 8 corresponding to the 
		 *		hex representation of n ( minus the leading "0x" )
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function toHex( n:int, bigEndian:Boolean = false ):String 
		{
			var s:String = "";
			
			if ( bigEndian ) 
			{
				for ( var i:int = 0;i < 4; i++ ) 
				{
					s += hexChars.charAt(( n >> ( ( 3 - i ) * 8 + 4 ) ) & 0xF) + hexChars.charAt(( n >> ( ( 3 - i ) * 8 ) ) & 0xF);
				}
			} else 
			{
				for ( var x:int = 0;x < 4; x++ ) 
				{
					s += hexChars.charAt(( n >> ( x * 8 + 4 ) ) & 0xF) + hexChars.charAt(( n >> ( x * 8 ) ) & 0xF);
				}
			}
			
			return s;
		}
		
		public static function toString():String
		{
			return getClassName(IntUtils);
		}
	}
}