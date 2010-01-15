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
	import temple.behaviors.AbstractBehaviorEvent;
	import flash.display.DisplayObject;

	/**
	 * Event dispached by the BoundsBehavior.
	 * 
	 * @see temple.ui.behaviors.BoundsBehavior
	 * 
	 * @author Thijs Broerse
	 */
	public class BoundsBehaviorEvent extends AbstractBehaviorEvent 
	{
		/**
		 * Dispatched when the objects bounces the bounds
		 */
		public static const BOUNCED:String = "BoundsBehaviorEvent.bounced";

		private var _direction:String;

		/**
		 * Creates a new BoundsBehaviorEvent
		 * @param type The type of event.
		 * @param target The target of the behavior (not of the event). This value will be the behaviorTarget
		 * @param direction The direction of the bounce. Valid values are 'top', 'right', 'bottom' and 'left'
		 */
		public function BoundsBehaviorEvent(type:String, target:DisplayObject, direction:String)
		{
			super(type, target);
			
			this._direction = direction;
		}
		
		/**
		 * The direction of the bounds.
		 */
		public function get direction():String
		{
			return this._direction;
		}
	}
}
