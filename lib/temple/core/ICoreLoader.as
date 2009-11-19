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
 
package temple.core 
{
	import temple.data.loader.ILoader;
	import temple.data.loader.IPreloadable;
	import temple.destruction.IDestructableEventDispatcher;

	/**
	 * Implemented by all core-loader objects like CoreNetStream, CoreURLLoader, CoreURLStream and CoreLoader.
	 * <p>ICoreLoader add some basic properies to the loader like the url. ICoreLoader objects listens to error-events and can log error when those occur. Since ICoreLoaders listen to there own ErrorEvent "unhandle ErrorEvents"-errors won't occur.</p>
	 * 
	 * @author Thijs Broerse
	 */
	public interface ICoreLoader extends IPreloadable, ILoader, IDestructableEventDispatcher, ICoreObject
	{
		/**
		 * The URL that is currently loaded or being loaded
		 */
		function get url():String
		
		/**
		 * If set to true an error message wil be logged on an Error (IOError or SecurityError)
		 * Error events are always handled by the loader so an "unhandle ErrorEvents"-errors won't occur.
		 */
		function get logErrors():Boolean
		
		/**
		 * @private
		 */
		function set logErrors(value:Boolean):void
	}
}
