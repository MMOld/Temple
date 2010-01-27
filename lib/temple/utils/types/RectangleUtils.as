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

	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * This class contains some functions for Rectangles.
	 * 
	 * @author Thijs Broerse
	 */
	public final class RectangleUtils 
	{

		/**
		 * The center Point of the rectangle relative to its parent.
		 * @param rectangle : the Rectangle to get the center point of
		 * @example
		 * <listing version="3.0">
		 * var rectangle:Rectangle = new Rectangle(1,2,4,8);
		 * // the rectangle has witemple.utils.types.RectangleUtilsnter:Point = RectangleUtils.getCenter(rectangle);
		 * trace(center);
		 * // (x=3, y=6)
		 * </listing>
		 */
		public static function getCenter(rectangle:Rectangle):Point 
		{
			return new Point(rectangle.x + rectangle.width / 2.0, rectangle.y + rectangle.height / 2.0);
		}

		/**
		 * Set the center of a rectangle to a Point
		 * @param rectangle the rectangle to move
		 * @param point to center Point
		 */
		public static function setCenter(rectangle:Rectangle, point:Point):void 
		{
			rectangle.x = point.x - rectangle.width / 2.0;
			rectangle.y = point.y - rectangle.height / 2.0;
		}

		/**
		 * Sets the size and origin of a movieclip to the bounds of a Rectangle.
		 * @param movieClip the movieclip to set the size and origin of
		 * @param bounds the Rectangle which size and origin to use
		 */
		public static function setToBounds(movieClip:MovieClip, bounds:Rectangle):void 
		{
			movieClip.width = bounds.width;
			movieClip.height = bounds.height;
			movieClip.x = bounds.x;
			movieClip.y = bounds.y;
		}

		/**
		 * Utility fuction to set the center to another rectangle's center.
		 * @param r1: the rectangle to set the center to
		 * @param r2: the rectangle to get the center of
		 * @example
		 * <listing version="3.0">
		 * var rect1:Rectangle = new Rectangle(0,0,20,20);
		 * var rect2:Rectangle = new Rectangle(50,50,40,40);
	 	 * 
		 * trace("rect1 = " + rect1); // (x=0, y=0, w=20, h=20)
		 * trace("rect2 = " + rect2); // (x=50, y=50, w=40, h=40)
		 * 
		 * RectangleUtils.centerToRectangle(rect1, rect2);
		 * 
		 * trace("rect1 = " + rect1); // (x=60, y=60, w=20, h=20)
		 * trace("rect2 = " + rect2); // (x=50, y=50, w=40, h=40)
		 * </listing>
		 */
		public static function centerToRectangle(r1:Rectangle, r2:Rectangle):void 
		{
			RectangleUtils.setCenter(r1, RectangleUtils.getCenter(r2));
		}

		/**
		 * Utility function to flatten the height of the Rectangle to a new given height. In contrast to flattenHeight originates from the center.
		 * @param inRectangle: the Rectangle to flatten the height of
		 * @param inNewHeight: the new height of the Rectangle
		 */
		public static function flattenHeight(rectangle:Rectangle, newHeight:Number = 0):Rectangle 
		{
			var oldHeight:Number = rectangle.height;
			rectangle.height = newHeight;
			rectangle.y += (oldHeight - rectangle.height) / 2;
			
			return rectangle;
		}

		/**
		 * Utility function to flatten the width of the Rectangle to a new given width. In contrast to flattenWidth originates from the center.
		 * @param inRectangle: the Rectangle to flatten the width of
		 * @param inNewWidth: the new width of the Rectangle
		 */
		public static function flattenWidth(rectangle:Rectangle, newWidth:Number = 0):Rectangle 
		{
			var oldWidth:Number = rectangle.width;
			rectangle.width = newWidth;
			rectangle.x += (oldWidth - rectangle.width) / 2;
			
			return rectangle;
		}
		
		/**
		 * lazy create a rectangle centered on centerX/centerY, by B.
		 */
		public static function newCentered(centerX:Number, centerY:Number, width:Number, height:Number):Rectangle
		{
			return new Rectangle(centerX - width * .5, centerY - height * .5, width, height);
		}
		
		public static function toString():String
		{
			return getClassName(RectangleUtils);
		}
	}
}
