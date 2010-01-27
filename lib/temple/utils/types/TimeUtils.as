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
	 * This class contains some functions for Time.
	 * 
	 * @author Thijs Broerse
	 */
	public final class TimeUtils 
	{
		/**
		 * Convert a string to seconds, with these formats supported:
		 * 00:03:00.1 / 03:00.1 / 180.1s / 3.2m / 3.2h / 00:01:53,800
		 **/
		public static function stringToSeconds(string:String):Number 
		{
			var arr:Array = string.split(':');
			var sec:Number = 0;
			if (string.substr(-1) == 's') 
			{
				sec = Number(string.substr(0, string.length - 1));
			}
			else if (string.substr(-1) == 'm') 
			{
				sec = Number(string.substr(0, string.length - 1)) * 60;
			}
			else if (string.substr(-1) == 'h') 
			{
				sec = Number(string.substr(0, string.length - 1)) * 3600;
			}
			else if (arr.length > 1) 
			{
				if (arr[2] && String(arr[2]).indexOf(',') != -1) arr[2] = String(arr[2]).replace(/\,/,".");
				
				sec = Number(arr[arr.length - 1]);
				sec += Number(arr[arr.length - 2]) * 60;
				if (arr.length == 3) 
				{
					sec += Number(arr[arr.length - 3]) * 3600;
				}
			} 
			else 
			{
				sec = Number(string);
			}
			return sec;
		}

		/** 
		 * Convert number to MIN:SS string.
		 */
		public static function secondsToString(seconds:Number):String 
		{
			return StringUtils.padLeft(Math.floor(seconds / 60).toString(), 2, "0") + ":" + StringUtils.padLeft(Math.floor(seconds % 60).toString(), 2, "0");
		}

		/**
		 * Format miliseconds as mm:ss.mmm 
		 */
		public static function formatTime(miliseconds:Number):String
		{
			return StringUtils.padLeft(Math.floor(miliseconds / 60000).toString(), 2, "0") + ':' + StringUtils.padLeft((Math.floor(miliseconds * .001) % 60).toString(), 2, "0") + '.' + StringUtils.padLeft((Math.round(Math.floor(miliseconds % 1000))).toString(), 3, "0");;
		}

		/**
		 * Format miliseconds as mm:ss 
		 */
		public static function formatMinutesSeconds(miliseconds:Number):String
		{
			return StringUtils.padLeft((Math.floor(miliseconds / 1000) % 60).toString(), 2, "0") + ':' + StringUtils.padLeft((Math.floor(miliseconds / 60000) % 60).toString(), 2, "0");
		}

		/**
		 * Format miliseconds as m:ss 
		 */
		public static function formatMinutesSecondsAlt(miliseconds:Number):String
		{
			return (Math.floor(miliseconds / 60000)).toString() + ':' + StringUtils.padLeft((Math.floor(miliseconds / 60000) % 60).toString(), 2, "0");
		}
		
		public static function toString():String
		{
			return getClassName(TimeUtils);
		}
	}
}
