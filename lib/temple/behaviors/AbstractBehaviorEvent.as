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
 
package temple.behaviors 
{
	import temple.debug.getClassName;
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Abstract implementation of a BehaviorEvent. This class is used as super class for other BehaviorEvents.
	 * This class will never be instantiated directly but will always be derived. So therefore this class is an 'Abstract' class.
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractBehaviorEvent extends Event implements IBehaviorEvent
	{
		private var _target:DisplayObject;

		/**
		 * Creates a new AbstractBehaviorEvent
		 * @param type The type of event.
		 * @param target The target of the behavior (not of the event). This value will be the behaviorTarget
		 */
		public function AbstractBehaviorEvent(type:String, target:DisplayObject)
		{
			super(type);
			
			this._target = target;
		}

		/**
		 * @inheritDoc
		 */
		public function get behaviorTarget():DisplayObject
		{
			return this._target;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return getClassName(this) + " type:" + this.type + " target:" + this._target;
		}
	}
}
