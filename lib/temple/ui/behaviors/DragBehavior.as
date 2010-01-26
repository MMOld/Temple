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
	import temple.ui.IEnableable;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @eventType temple.ui.behaviors.DragBehaviorEvent.DRAGGING
	 */
	[Event(name = "DragBehaviorEvent.dragging", type = "temple.ui.behaviors.DragBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.DragBehaviorEvent.DRAG_START
	 */
	[Event(name = "DragBehaviorEvent.dragStart", type = "temple.ui.behaviors.DragBehaviorEvent")]
	
	/**
	 * @eventType temple.ui.behaviors.DragBehaviorEvent.DRAG_STOP
	 */
	[Event(name = "DragBehaviorEvent.dragStop", type = "temple.ui.behaviors.DragBehaviorEvent")]
	
	/**
	 * The DragBehavior makes a DisplayObject draggable. The DragBehavior uses the decorator pattern,
	 * so you won't have to change the code of the DisplayObject.
	 * 
	 * <p>If you have a MovieClip called 'mcClip' add DragBehavior like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new DragBehavior(mcClip);
	 * </listing> 
	 * 
	 * <p>If you want to limit the dragging to a specific bounds, you can add a Rectangle. By adding the
	 * Reactangle you won't be able to drag the DisplayObject outside the Rectangle:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new DragBehavior(mcClip, new Reactangle(100, 100, 200, 200);
	 * </listing>
	 *
	 * <p>It's also possible to define a child object as a 'DragButton'. A DragButton is a DisplayObject
	 * that is used to drag the target.</p>
	 * 
	 * <p>If you have a MovieClip called 'mcClip' with a child called 'mcDragButton' add DragBehavior like:</p>
	 * 
	 * @example
	 * <listing version="3.0">
	 * new DragBehavior(mcClip, null, mcClip.mcDragButton);
	 * </listing> 
	 * 
	 * <p>It is not nessessary to store a reference to the DragBehavior since the DragBehavior is automaticly destructed
	 * if the DisplayObject is destructed.</p>
	 * 
	 * @includeExample DragBehaviorExample.as
	 * 
	 * @author Thijs Broerse
	 */
	public class DragBehavior extends BoundsBehavior implements IEnableable
	{
		protected var _dragButton:DisplayObject;
		protected var _startDragObjectPoint:Point;
		protected var _startDragMousePoint:Point;
		protected var _isDragging:Boolean;
		protected var _enabled:Boolean;
		protected var _dragVertical:Boolean = true;
		protected var _dragHorizontal:Boolean = true;

		/**
		 * Create the possibility to drag an object
		 * @param target: The DisplayObject to be dragged
		 * @param bounds (optional): limits the dragging
		 * @param dragButton (optional): a DisplayObject that does the dragging, if there is no dragButton, the dragObject does the dragging
		 */
		public function DragBehavior(target:DisplayObject, bounds:Rectangle = null, dragButton:DisplayObject = null, dragHorizontal:Boolean = true, dragVertical:Boolean = true) 
		{
			super(target, bounds);
			
			if(dragButton)
			{
				this._dragButton = dragButton;
			}
			else
			{
				this._dragButton = target;
			}
			this.enabled = true;
			this.dragHorizontal = dragHorizontal;
			this.dragVertical = dragVertical;
		}

		/**
		 * Indicates if the DragBehavior is currently dragging
		 */
		public function get isDragging():Boolean
		{
			return this._isDragging;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return this._enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			this._enabled = value;
			if (value)
			{
				this._dragButton.addEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			}
			else
			{
				this._dragButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
			}
		}

		/**
		 * Get or set horizontal dragging on (true) or off (false)
		 */
		public function get dragHorizontal():Boolean
		{
			return this._dragHorizontal;
		}
		
		/**
		 * @private
		 */
		public function set dragHorizontal(value:Boolean):void
		{
			this._dragHorizontal = value;
		}

		/**
		 * Get or set vertical dragging on (true) or off (false)
		 */
		public function get dragVertical():Boolean
		{
			return this._dragVertical;
		}
		
		/**
		 * @private
		 */
		public function set dragVertical(value:Boolean):void
		{
			this._dragVertical = value;
		}
		
		protected function handleMouseDown(event:MouseEvent):void 
		{
			this._isDragging = true;
			
			this._startDragMousePoint = new Point(this.displayObject.parent.mouseX, this.displayObject.parent.mouseY);
			this._startDragObjectPoint = new Point(this.displayObject.x, this.displayObject.y);
			
			this.displayObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove, false, 0, true);
			this.displayObject.stage.addEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp, false, 0, true);
			this.displayObject.stage.addEventListener(Event.MOUSE_LEAVE, this.handleMouseLeave, false, 0, true);
			
			this.dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_START, this.displayObject as DisplayObject));
		}

		protected function handleMouseMove(event:MouseEvent):void 
		{
			if(this._dragHorizontal)
			{
				this.displayObject.x = this._startDragObjectPoint.x + this.displayObject.parent.mouseX - this._startDragMousePoint.x;
			}
			
			if(this.dragVertical)
			{
				this.displayObject.y = this._startDragObjectPoint.y + this.displayObject.parent.mouseY - this._startDragMousePoint.y;
			}
			
			this.keepInBounds();
			
			this.dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAGGING, this.displayObject as DisplayObject));
		}

		protected function handleMouseUp(event:MouseEvent):void 
		{
			this.stopDrag();
		}

		private function stopDrag():void
		{
			this._isDragging = false;
			
			this.displayObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.handleMouseMove);
			this.displayObject.stage.removeEventListener(MouseEvent.MOUSE_UP, this.handleMouseUp);
			this.displayObject.stage.removeEventListener(Event.MOUSE_LEAVE, this.handleMouseLeave);
			
			this.dispatchEvent(new DragBehaviorEvent(DragBehaviorEvent.DRAG_STOP, this.displayObject as DisplayObject));
		}

		private function handleMouseLeave(event:Event):void
		{
			this.stopDrag();
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if(this.isDragging) this.stopDrag();
			if(this._dragButton)
			{
				this._dragButton.removeEventListener(MouseEvent.MOUSE_DOWN, this.handleMouseDown);
				this._dragButton = null;
			}
			this._startDragObjectPoint = null;
			this._startDragMousePoint = null;
			super.destruct();
		}
		
	}
}
