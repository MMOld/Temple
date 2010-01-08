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

package temple.ui.layout 
{

	/**
	 * This class contains possible values for alignments. Not all alignments are valid for all alignable objects.
	 * 
	 * @author Thijs Broerse
	 */
	public class Align 
	{
		/**
		 * Align to the left
		 */
		public static const LEFT:String = "left";
		
		/**
		 * Align to the center
		 */
		public static const CENTER:String = "center";
		
		/**
		 * Align to the right
		 */
		public static const RIGHT:String = "right";
		
		/**
		 * Align to the top
		 */
		public static const TOP:String = "top";
		
		/**
		 * Align to the middle
		 */
		public static const MIDDLE:String = "middle";
		
		/**
		 * Align to the bottom
		 */
		public static const BOTTOM:String = "bottom";
		
		
		/**
		 * Align to the top and the left
		 */
		public static const TOP_LEFT:String = "topLeft";
		
		/**
		 * Align to the top and the right
		 */
		public static const TOP_RIGHT:String = "topRight";
		
		/**
		 * Align to the bottom and the left
		 */
		public static const BOTTOM_LEFT:String = "bottomLeft";
		
		/**
		 * Align to the bottom and the right
		 */
		public static const BOTTOM_RIGHT:String = "bottomRight";
		
		/**
		 * No alignment
		 */
		public static const NONE:String = "none";
	}
}
