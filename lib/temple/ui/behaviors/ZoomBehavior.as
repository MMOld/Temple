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

package temple.ui.behaviors 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @eventType temple.ui.behaviors.ZoomBehaviorEvent.ZOOMING
	 */
	[Event(name = "ZoomBehaviorEvent.zooming", type = "temple.ui.behaviors.ZoomBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.ZoomBehaviorEvent.ZOOM_START
	 */
	[Event(name = "ZoomBehaviorEvent.zoomStart", type = "temple.ui.behaviors.ZoomBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.ZoomBehaviorEvent.ZOOM_STOP
	 */
	[Event(name = "ZoomBehaviorEvent.zoomStop", type = "temple.ui.behaviors.ZoomBehaviorEvent")]
	
	/**
	 * The ZoomBehavior makes it possible to zoom in or out on a DisplayObject. The ZoomBehavior uses the decorator pattern,
	 * so you won't have to change the code of the DisplayObject. The DisplayObject can be zoomed by using code or the MouseWheel.
	 * 
	 * <p>If you have a MovieClip called 'mcClip' add ZoomBehavior like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new ZoomBehavior(mcClip);
	 * </listing> 
	 * 
	 * <p>If you want to limit the zooming to a specific bounds, you can add a Rectangle. By adding the
	 * Reactangle you won't be able to zoom the DisplayObject outside the Rectangle:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new ZoomBehavior(mcClip, new Reactangle(100, 100, 200, 200);
	 * </listing>
	 *
	 * <p>It is not nessessary to store a reference to the ZoomBehavior since the ZoomBehavior is automaticly destructed
	 * if the DisplayObject is destructed.</p>
	 * 
	 * @author Arjan van Wijk (arjan at mediamonks dot com)
	 */
	public class ZoomBehavior extends BoundsBehavior 
	{
		protected var _zoom:Number;
		protected var _minZoom:Number;
		protected var _maxZoom:Number;
		protected var _newScale:Number;
		protected var _newX:Number;
		protected var _newY:Number;
		protected var _running:Boolean;

		/**
		 * @param target The target to zoom
		 * @param minZoom Minimal zoom ratio (ie. 0.25)
		 * @param maxZoom Maximal zoom ratio (ie. 8)
		 */
		public function ZoomBehavior(target:DisplayObject, bounds:Rectangle = null, minZoom:Number = 1, maxZoom:Number = 4) 
		{
			super(target, bounds);
			
			this._minZoom = minZoom;
			this._maxZoom = maxZoom;
			
			this._zoom = 0;
			
			this._newScale = target.scaleX;
			this._newX = target.x;
			this._newY = target.y;
			
			target.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			
			this._running = false;
		}

		/**
		 * Zooms to a specific zoom level
		 * @param zoom the level to zoom to
		 * @param useCenter indicates if the zooming should be calculated from the center of the object (true) or the current mouse position (false), default: false
		 */
		public function zoomTo(zoom:Number, useCenter:Boolean = false):void
		{
			this._zoom = Math.log(zoom) / Math.log(2);
			this.updateZoom(useCenter);
		}

		/**
		 * Stops the zooming
		 */
		public function stopZoom():void
		{
			if (this._running == true)
			{
				this._running = false;
				this.displayObject.removeEventListener(Event.ENTER_FRAME, this.handleEnterFrame);
				this.dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOM_STOP, this.displayObject));
			}
		}

		/**
		 * The minimal zoom
		 */
		public function get minZoom():Number
		{
			return this._minZoom;
		}

		/**
		 * @private
		 */
		public function set minZoom(minZoom:Number):void
		{
			this._minZoom = minZoom;
		}

		/**
		 * The maximal zoom
		 */
		public function get maxZoom():Number
		{
			return this._maxZoom;
		}

		/**
		 * @private
		 */
		public function set maxZoom(maxZoom:Number):void
		{
			this._maxZoom = maxZoom;
		}

		/**
		 * The current zoom
		 */
		public function get zoom():Number
		{
			return Math.pow(2, this._zoom);
		}

		/**
		 * @private
		 */
		public function set zoom(zoom:Number):void
		{
			this._zoom = Math.log(zoom) / Math.log(2);
			this.updateZoom();
		}

		/**
		 * The current zoomLevel
		 */
		public function get zoomLevel():Number
		{
			return this._zoom;
		}

		protected function handleEnterFrame(event:Event):void
		{
			this.displayObject.scaleX = this.displayObject.scaleY += (this._newScale - this.displayObject.scaleY) / 5;
			this.displayObject.x += (this._newX - this.displayObject.x) / 5;
			this.displayObject.y += (this._newY - this.displayObject.y) / 5;
			
			this.dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOMING, this.displayObject));
			
			if(Math.abs(this.displayObject.scaleX - this._newScale) < .01)
			{
				this.displayObject.scaleX = this.displayObject.scaleY = this._newScale;
				this.displayObject.x = this._newX;
				this.displayObject.y = this._newY;
				this.stopZoom();
			}
			this.keepInBounds();
		}

		protected function handleMouseWheel(event:MouseEvent):void
		{
			this._zoom += (event.delta / 3) / 4;
			this.updateZoom();
		}

		protected function updateZoom(useCenter:Boolean = false):void
		{
			var rect:Rectangle = this.displayObject.getRect(this.target as DisplayObject);
			var rX:Number = useCenter ? rect.x/rect.width + .5 : (this.displayObject.mouseX * this.displayObject.scaleX) / this.displayObject.width;
			var rY:Number = useCenter ? rect.y/rect.height + .5 : (this.displayObject.mouseY * this.displayObject.scaleY) / this.displayObject.height;
			
			var prevW:Number = this.displayObject.width;
			var prevH:Number = this.displayObject.height;
			
			this._newScale = Math.max(this._minZoom, Math.min(this._maxZoom, Math.pow(2, this._zoom)));
			
			this._zoom = Math.log(this._newScale) / Math.log(2);
			
			this._newX = this.displayObject.x + rX * (prevW - (this.displayObject.width / this.displayObject.scaleX * this._newScale));
			this._newY = this.displayObject.y + rY * (prevH - (this.displayObject.height / this.displayObject.scaleY * this._newScale));
			
			if (this._running == false)
			{
				this._running = true;
				this.displayObject.addEventListener(Event.ENTER_FRAME, this.handleEnterFrame, false, 0, true);
				this.dispatchEvent(new ZoomBehaviorEvent(ZoomBehaviorEvent.ZOOM_START, this.displayObject));
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this.target) this.displayObject.removeEventListener(MouseEvent.MOUSE_WHEEL, this.handleMouseWheel);
			if(this._running) this.stopZoom();
			super.destruct();
		}
	}
}
