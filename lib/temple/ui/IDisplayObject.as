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

package temple.ui 
{
	import flash.accessibility.AccessibilityProperties;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.IBitmapDrawable;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;

	/**
	 * Interface that contains all the properties of a DisplayObject. This interface is implemented by all
	 * DisplayObjects of the Temple, but not by Flash native DisplayObects. This interface is extended by
	 * other interface to force they can only be implemented by DisplayObjects. 
	 * 
	 * @author Arjan van Wijk
	 */
	public interface IDisplayObject extends IEventDispatcher, IBitmapDrawable
	{
		function get accessibilityProperties():AccessibilityProperties;
		function set accessibilityProperties(value:AccessibilityProperties):void;

		function get alpha():Number;
		function set alpha(value:Number):void;

		function get blendMode():String;
		function set blendMode(value:String):void;

		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap(value:Boolean):void;

		function get filters():Array;
		function set filters(value:Array):void;

		function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;

		function getRect(targetCoordinateSpace:DisplayObject):Rectangle;

		function globalToLocal(point:Point):Point;

		function get height():Number;
		function set height(value:Number):void;

		function hitTestObject(obj:DisplayObject):Boolean;

		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;

		function get loaderInfo():LoaderInfo;

		function localToGlobal(point:Point):Point;

		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;

		function get mouseX():Number;
		
		function get mouseY():Number;

		function get name():String;
		function set name(value:String):void;

		function get opaqueBackground():Object;
		function set opaqueBackground(value:Object):void;

		function get parent():DisplayObjectContainer;

		function get root():DisplayObject;

		function get rotation():Number;
		function set rotation(value:Number):void;

		function get scale9Grid():Rectangle;
		function set scale9Grid(innerRectangle:Rectangle):void;

		function get scaleX():Number;
		function set scaleX(value:Number):void;
	
		function get scaleY():Number;
		function set scaleY(value:Number):void;

		function get scrollRect():Rectangle;
		function set scrollRect(value:Rectangle):void;

		function get stage():Stage;

		function get transform():Transform;
		function set transform(value:Transform):void;

		function get visible():Boolean;
		function set visible(value:Boolean):void;

		function get width():Number;
		function set width(value:Number):void;

		function get x():Number;
		function set x(value:Number):void;

		function get y():Number;
		function set y(value:Number):void;
	}
}