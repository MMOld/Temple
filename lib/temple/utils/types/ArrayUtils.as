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
	 * This class contains some functions for Array's.
	 * 
	 * @author Arjan van Wijk
	 */
	public class ArrayUtils 
	{
		/**
		 * Checks if an array contains a specific value
		 */
		public static function inArray(array:Array, value:*):Boolean
		{
			return (array.indexOf(value) != -1);
		}
		/**
		 * Checks if an element in the array has a field with a specific value
		 */
		public static function inArrayField(array:Array, field:String, value:*):Boolean		{
			for each (var i:* in array) 
			{
				if (i[field] == value) return true;
			}
			
			return false;
		}

		/**
		 * Get a random element form the array
		 */
		public static function randomElement(array:Array):*
		{
			if(array.length > 0)
			{
				return array[Math.floor(Math.random() * array.length)];
			}
			return null;
		}

		/**
		 * Shuffles an array (sort random) 
		 */
		public static function shuffle(array:Array):Array 
		{
			return array.sort(sortByRandom);
		}

		private static function sortByRandom(a:Object, b:Object):Number 
		{
			// just use vars to get rid of 'never used' warnings
			a;
			b;			
			return Math.round(Math.random()) * 2 - 1;
		}

		/**
		 * copies the source array to the target array, without remove the reference
		 */
		public static function copy(array:Array, target:Array):void
		{
			var leni:int = target.length = array.length;
			for (var i:int = 0;i < leni; i++) 
			{
				target[i] = array[i];
			}
		}

		/**
		 * 	potential better shuffle, slower but scalable, needs testing
		 * 	
		 * 	Bart
		 */
		public static function shuffleHard(array:Array):Array
		{
			var target:Array = new Array();
			var i:int;
			while(array.length > 0)
			{
				i = Math.round(Math.random() * (array.length - 1));
				target.push(array[i]);
				array.splice(i, 1);
			}
			return target;
		}

		
		/**
		 * recursively clone an Array and it's sub-Array's (doesn't clone content objects)
		 */
		public static function deepArrayClone(array:Array):Array
		{	
			var ret:Array = array.concat();
			var iLim:uint = ret.length;
			var i:uint;
			for(i = 0;i < iLim;i++)
			{
				if(ret[i] is Array)
				{
					ret[i] = ArrayUtils.deepArrayClone(ret[i]);
				}
			}
			return ret;
		}

		/**
		 * Calculates the average value of all elements in an array
		 * Works only for array's with numeric values
		 */
		public static function average(array:Array):Number
		{
			if(array == null || array.length == 0) return NaN;
			var total:Number = 0;
			for each (var n : Number in array) total += n;
			return total / array.length;
		}


		/**
		 *	Remove all instances of the specified value from the array,
		 * 	@param array The array from which the value will be removed
		 *	@param value The object that will be removed from the array.
		 */		
		public static function removeValueFromArray(array:Array, value:Object):void
		{
			var len:uint = array.length;
			
			for(var i:Number = len;i > -1; i--)
			{
				if(array[i] === value)
				{
					array.splice(i, 1);
				}
			}					
		}

		/**
		 *	Create a new array that only contains unique instances of objects
		 *	in the specified array.
		 *
		 *	<p>Basically, this can be used to remove duplication object instances
		 *	from an array</p>
		 * 
		 * 	@param array The array which contains the values that will be used to
		 *	create the new array that contains no duplicate values.
		 *
		 *	@return A new array which only contains unique items from the specified
		 *	array.
		 */	
		public static function createUniqueCopy(array:Array):Array
		{
			var newArray:Array = new Array();
			
			var len:Number = array.length;
			var item:Object;
			
			for (var i:uint = 0;i < len; ++i)
			{
				item = array[i];
				
				if(ArrayUtils.inArray(newArray, item))
				{
					continue;
				}
				
				newArray.push(item);
			}
			
			return newArray;
		}

		/**
		 *	Creates a copy of the specified array.
		 *
		 *	<p>Note that the array returned is a new array but the items within the
		 *	array are not copies of the items in the original array (but rather 
		 *	references to the same items)</p>
		 * 
		 * 	@param array The array that will be copies
		 *
		 *	@return A new array which contains the same items as the array passed
		 *	in.
		 */			
		public static function clone(array:Array):Array
		{	
			return array.slice();
		}

		/**
		 *	Compares two arrays and returns a boolean indicating whether the arrays
		 *	contain the same values at the same indexes.
		 * 
		 * 	@param array1 The first array that will be compared to the second.
		 * 	@param array2 The second array that will be compared to the first.
		 *
		 *	@return True if the arrays contains the same values at the same indexes.
		 *		False if they do not.
		 */		
		public static function arraysAreEqual(array1:Array, array2:Array):Boolean
		{
			if(array1.length != array2.length)
			{
				return false;
			}
			
			var len:Number = array1.length;
			
			for(var i:Number = 0;i < len; i++)
			{
				if(array1[i] !== array2[i])
				{
					return false;
				}
			}
			
			return true;
		}
		
		public static function toString():String
		{
			return getClassName(ArrayUtils);
		}
	}
}
