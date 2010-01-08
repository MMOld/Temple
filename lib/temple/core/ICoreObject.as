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

package temple.core 
{
	import temple.destruction.IDestructable;

	/**
	 * Interface for all core classes of the Temple. The Temple’s core classes are 
	 * extensions on the native (base) classes of Flash enhanced with the basic features 
	 * of the Temple, like memory registration and event listener registration.
	 * 
	 * <p>Temple’s core classes are designed for easy destruction. ICoreObject extends 
	 * IDestructable. Therefore are all objects enhanced with a destruction method.</p>
	 * 
	 * <p>Since all core objects are registered in memory (if that feature is enabled) 
	 * they can be tracked. After destructing the object and a garbage collection the 
	 * object should be disappeared from Memory. If the object is still exists in Memory, 
	 * you have to check your code.</p>
	 * 
	 * @see temple.Temple
	 * @see temple.debug.Registry
	 * @see temple.debug.Memory
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreObject extends IDestructable
	{
		/**
		 * The unique identifier of the object. The id is generated and registered by the Registry class
		 * @see temple.debug.Registry#add()
		 */
		function get registryId():uint;
	}
}
