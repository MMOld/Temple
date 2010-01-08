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
	public class TimeUtils 
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
			else if(string.substr(-1) == 'h') 
			{
				sec = Number(string.substr(0, string.length - 1)) * 3600;
			}
			else if(arr.length > 1) 
			{
				if(arr[2] && String(arr[2]).indexOf(',') != -1) arr[2] = String(arr[2]).replace(/\,/,".");
				
				sec = Number(arr[arr.length - 1]);
				sec += Number(arr[arr.length - 2]) * 60;
				if(arr.length == 3) 
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
		 * TODO: refactor method in this class
		 */

		/** 
		 * Convert number to MIN:SS string.
		 */
		public static function secondsToString(seconds:Number):String 
		{
			var min:int = Math.floor(seconds / 60);
			var sec:int = Math.floor(seconds % 60);
			return StringUtils.padLeft(min.toString(), 2, "0") + ":" + StringUtils.padLeft(sec.toString(), 2, "0");
		}

		// returns mm:ss:mm
		public static function formatTime(argTimeMili:Number):String
		{
			var intMilliSeconds:Number = Math.floor(argTimeMili % 1000);
			var strMilliSeconds:String = Math.round(intMilliSeconds / 10).toString();
			strMilliSeconds = (strMilliSeconds.length == 1) ? '0' + strMilliSeconds : strMilliSeconds;
			
			var intSeconds:Number = Math.floor(argTimeMili / 1000) % 60;
			var strSeconds:String = intSeconds.toString();
			strSeconds = (strSeconds.length == 1) ? '0' + strSeconds : strSeconds;
			
			var intMinutes:Number = Math.floor(argTimeMili / 60000);
			var strMinutes:String = intMinutes.toString();
			strMinutes = (strMinutes.length == 1) ? '0' + strMinutes : strMinutes;
			
			var strFormatted:String = strMinutes + ':' + strSeconds + ':' + strMilliSeconds;
			
			return strFormatted;
		}

		// returns mm:ss
		public static function formatMinutesSeconds(argTimeMili:Number):String
		{
			var intSeconds:Number = Math.floor(argTimeMili / 1000) % 60;
			var strSeconds:String = intSeconds.toString();
			strSeconds = (strSeconds.length == 1) ? '0' + strSeconds : strSeconds;
			
			var intMinutes:Number = Math.floor(argTimeMili / 60000);
			var strMinutes:String = intMinutes.toString();
			strMinutes = (strMinutes.length == 1) ? '0' + strMinutes : strMinutes;
			
			var strFormatted:String = strMinutes + ':' + strSeconds;
			
			return strFormatted;
		}

		// returns m:ss
		public static function formatMinutesSecondsAlt(argTimeMili:Number):String
		{
			var intSeconds:Number = Math.floor(argTimeMili / 1000) % 60;
			var strSeconds:String = intSeconds.toString();
			strSeconds = (strSeconds.length == 1) ? '0' + strSeconds : strSeconds;
			
			var intMinutes:Number = Math.floor(argTimeMili / 60000);
			var strMinutes:String = intMinutes.toString();
			
			var strFormatted:String = strMinutes + ':' + strSeconds;
			
			return strFormatted;
		}
		
		public static function toString():String
		{
			return getClassName(TimeUtils);
		}
	}
}
