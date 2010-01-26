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
	import flash.geom.Rectangle;

	/**
	 * @eventType temple.ui.behaviors.BoundsBehaviorEvent.BOUNCED
	 */
	[Event(name = "BoundsBehaviorEvent.bounced", type = "temple.ui.behaviors.BoundsBehaviorEvent")]

	/**
	 * Behavior the keep DisplayObject within a bounds. Used as base class for other Behaviors like DragBehavior
	 * 
	 * @includeExample BoundsBehaviorExample.as
	 * 
	 * @author Arjan (arjan at mediamonks dot com)
	 */
	public class BoundsBehavior extends AbstractDisplayObjectBehavior 
	{
		public static const TOP:String = "top"; 
		public static const RIGHT:String = "right"; 
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		
		protected var _bounds:Rectangle;

		public function BoundsBehavior(target:DisplayObject, bounds:Rectangle = null)
		{
			super(target);
			
			if(bounds) this.bounds = bounds;
		}
		
		/**
		 * The bounds limits the dragging. The object can only be dragged with this area
		 */
		public function get bounds():Rectangle
		{
			return this._bounds;
		}

		/**
		 * @private
		 */
		public function set bounds(value:Rectangle):void
		{
			this._bounds = value;
			
			this.keepInBounds();
		}

		/**
		 * Checks if the DisplayObject is still in bounds, if not if will be moved to put it in bounds
		 */
		public function keepInBounds():void
		{
			// Keep in bounds, checking for parent is allowed, since this is in a mouse event
			if(this._bounds)
			{
				var target:DisplayObject = this.displayObject;
				
				var objectbounds:Rectangle = target.getBounds(target.parent);
				
				// check x
				// check smaller
				if (this._bounds.width >= target.width)
				{
					
					if(objectbounds.left < this._bounds.left)
					{
						target.x += this._bounds.left - objectbounds.left;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.LEFT));
					}
				
					else if(objectbounds.right > this._bounds.right)
					{
						target.x -= objectbounds.right - this._bounds.right;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.RIGHT));
					}
				}
				// check larger
				else
				{
					if(objectbounds.left > this._bounds.left)
					{
						target.x += this._bounds.left - objectbounds.left;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.LEFT));
					}
					else if(objectbounds.right < this._bounds.right)
					{
						target.x -= objectbounds.right - this._bounds.right;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.RIGHT));
					}
				}
				
				// check y
				// check smaller
				if (this._bounds.height >= target.height)
				{
					if(objectbounds.top < this._bounds.top)
					{
						target.y += this._bounds.top - objectbounds.top;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.TOP));
					}
					else if(objectbounds.bottom > this._bounds.bottom)
					{
						target.y -= objectbounds.bottom - this._bounds.bottom;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.BOTTOM));
					}
				}
				// check larger
				else
				{
					if(objectbounds.top > this._bounds.top)
					{
						target.y += this._bounds.top - objectbounds.top;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.TOP));
					}
					else if(objectbounds.bottom < this._bounds.bottom)
					{
						target.y -= objectbounds.bottom - this._bounds.bottom;
						this.dispatchEvent(new BoundsBehaviorEvent(BoundsBehaviorEvent.BOUNCED, target, BoundsBehavior.BOTTOM));
					}
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			this._bounds = null;
			super.destruct();
		}
	}
}
