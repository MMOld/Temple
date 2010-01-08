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

package temple.destruction 
{

	/**
	 * Interface for objects that can be destructed.
	 * 
	 * <p>When creating stable and maintainable code, you should always make sure the object can be completely destructed.
	 * Since Flash player 9 has a huge problem with removing unnecessary objects, it's really hard to remove object from
	 * Memory. Destructing objects is one of the key-features of the Temple. If you enabled object registration in the main
	 * Temple class. You can track your objects in Memory. If you destruct the objects they should disappear after a garbage
	 * collection.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public interface IDestructable 
	{
		/**
		 * Destroys the objects, all intern listeners will be removed
		 * 
		 * <p>When overriding this method, always call super.destruct() at last!</p>
		 * 
		 * If you want the object be available for garbage collection make sure you:
		 * <ul>
		 * 	<li>Remove all event listeners on this object (use removeAllEventListeners on Temple objects)</li>
		 * 	<li>Remove all event listeners from this object</li>
		 * 	<li>Set all non-primitive variables to null</li>
		 * 	<li>Set all references to this object to null in other objects</li>
		 * </ul>
		 * 
		 * When a Temple object is destructed an DestructEvent.DESTRUCT is dispatched from the object (if the object implements IDestructableEventDispatcher)
		 * 
		 * @see temple.destruction.DestructEvent
		 */
		function destruct():void;
		
		/**
		 * If an object is destructed, this property is set to true.
		 * 
		 * <p>After a garbage collection the object should be disappeared from Memory (if Temple.registerObjectsInMemory is set to true).
		 * If the object still exists, you should check your code.</p>
		 * 
		 * @see temple.Temple
		 * @see temple.debug.Registry
		 * @see temple.debug.Memory
		 */
		function get isDestructed():Boolean
	}
}
