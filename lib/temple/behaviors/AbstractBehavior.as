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
	import temple.core.CoreEventDispatcher;
	import temple.debug.errors.TempleArgumentError;
	import temple.debug.errors.throwError;
	import temple.destruction.DestructEvent;

	import flash.events.IEventDispatcher;

	/**
	 * Abstract implementation of a Behavior. This class is used as super class 
	 * for other Behaviors.
	 * 
	 * <p>This class will never be instantiated directly but will always be derived. 
	 * So therefore this class is an 'Abstract' class.</p>
	 * 
	 * <p>This class watches his target. When the target is destructed, the behavior 
	 * will also be destructed (auto destruction). Since this class is useless 
	 * without its target</p>
	 * 
	 * @author Thijs Broerse
	 */
	public class AbstractBehavior extends CoreEventDispatcher implements IBehavior 
	{
		private namespace temple;
		
		protected var _target:Object;
		
		/**
		 * Creates a new AbstractBehavior
		 * @param target The target of this behavior, preferable an IEventDispatcher so 
		 * the behavior will be destructed when the target is destructed
		 */
		public function AbstractBehavior(target:Object)
		{
			if (target == null) throwError(new TempleArgumentError(this, "target cannot be null"));
			
			this._target = target;
			if (this._target is IEventDispatcher)
			{
				(this._target as IEventDispatcher).addEventListener(DestructEvent.DESTRUCT, temple::handleTargetDestructed);
			}
			else
			{
				this.logWarn("This object is not an IEventDispatcher, so it will not be auto-destructed");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public final function get target():Object
		{
			return this._target;
		}
		
		temple function handleTargetDestructed(event:DestructEvent):void
		{
			this.destruct();
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String 
		{
			return super.toString() + " : " + this._target;
		}

		/**
		 * @inheritDoc
		 */
		override public function destruct():void
		{
			if (this._target)
			{
				if (this._target is IEventDispatcher) (this._target as IEventDispatcher).removeEventListener(DestructEvent.DESTRUCT, temple::handleTargetDestructed);
				this._target = null;
			}
			super.destruct();
		}
	}
}
