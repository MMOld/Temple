/*
 *	 
 *	Temple Library for ActionScript 3.0
 *	Copyright © 2009 MediaMonks B.V.
 *	All rights reserved.
 *	
 *	THIS LIBRARY IS IN PRIVATE BETA, THEREFORE THE SOURCES MAY NOT BE
 *	REDISTRIBUTED IN ANY WAY.
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

	/**
	 * @author Arjan van Wijk
	 */
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

	public interface IDisplayObject extends IEventDispatcher, IBitmapDrawable
	{
		function get y():Number;

		function get transform():Transform;

		function get stage():Stage;

		function localToGlobal(point:Point):Point;

		function get name():String;

		function set width(value:Number):void;

		function get blendMode():String;

		function get scale9Grid():Rectangle;

		function set name(value:String):void;

		function set scaleX(value:Number):void;

		function set scaleY(value:Number):void;

		function get accessibilityProperties():AccessibilityProperties;

		function set scrollRect(value:Rectangle):void;

		function get cacheAsBitmap():Boolean;

		function globalToLocal(point:Point):Point;

		function get height():Number;

		function set blendMode(value:String):void;

		function get parent():DisplayObjectContainer;

		function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;

		function get opaqueBackground():Object;

		function set scale9Grid(innerRectangle:Rectangle):void;

		function set alpha(value:Number):void;

		function set accessibilityProperties(value:AccessibilityProperties):void;

		function get width():Number;

		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;

		function get scaleX():Number;

		function get scaleY():Number;

		function get mouseX():Number;

		function set height(value:Number):void;

		function set mask(value:DisplayObject):void;

		function getRect(targetCoordinateSpace:DisplayObject):Rectangle;

		function get mouseY():Number;

		function get alpha():Number;

		function set transform(value:Transform):void;

		function get scrollRect():Rectangle;

		function get loaderInfo():LoaderInfo;

		function get root():DisplayObject;

		function set visible(value:Boolean):void;

		function set opaqueBackground(value:Object):void;

		function set cacheAsBitmap(value:Boolean):void;

		function hitTestObject(obj:DisplayObject):Boolean;

		function set x(value:Number):void;

		function set y(value:Number):void;

		function get mask():DisplayObject;

		function set filters(value:Array):void;

		function get x():Number;

		function get visible():Boolean;

		function get filters():Array;

		function set rotation(value:Number):void;

		function get rotation():Number;
	}
}