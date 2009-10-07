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

/*
Copyright 2007 by the authors of asaplibrary, http://asaplibrary.org
Copyright 2005-2007 by the authors of asapframework, http://asapframework.org

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
 */

package temple.debug.log 
{
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	[Event(name="onEvent", type="temple.debug.log.LogEvent")]
	
	/**
	 * @author stephan.bezoen
	 * This class implements a simple logging functionality that dispatches an event whenever a log message is received.
	 * The object sent with the event is of type LogEvent. The LogEvent class contains public properties for the text of the message, 
	 * a String denoting the sender of the message, and the level of importance of the message.
	 * By default, log messages are also output as traces to the Flash IDE output window. This behavior can be changed.
	 * @example
	 * <listing version="3.0">
	 * Log.addEventListener(handleLogEvent);	// handle events locally
	 * Log.showTrace(false);	// don't output log messages as traces
	 * 
	 * Log.debug("This is a debug message", this);
	 * Log.error("This is an error message", this);
	 * Log.info("This is an info message", this);
	 * 
	 * private function handleLogEvent (event:LogEvent)
	 * {
	 * 	// handle the event by showing the message as a trace
	 * 	trace(event.text);
	 * }
	 * 
	 * public function toString () : String {
	 * return getQualifiedClassName(this);
	 * }
	 * </listing>
	 * This will show the following output in the Flash IDE output window:
	 * 
	 * This is a debug message
	 * This is an error message
	 * This is an info message
	 * 
	 * The standard trace output of the Log class looks as follows:
	 * 
	 * 13	debug: This is a debug message -- TestClass
	 * 13	error: This is an error message -- TestClass
	 * 13	info: This is an info message -- TestClass
	 * 
	 * The number "13" is the time at which the log message was generated. This time is not kept in the LogEvent class.
	 */
	public class Log extends EventDispatcher 
	{
		private static var _instance:Log;

		private var _showTrace:Boolean = true;

		
		/**
		 *	Log a message with debug level
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message; 
		 *			toString() is called on this object internally
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 *			this param is only used for objects that are stored in the Registry
		 *	@example
		 *	<listing version="3.0">
		 *	Log.debug("This is a debug message", this);
		 *	</listing>
		 */
		public static function debug(data:*, sender:*, objectId:uint = 0):void 
		{
			Log.getInstance().send(data, sender, LogLevels.DEBUG, objectId);
		}

		/**
		 *	Log a message with info level
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message; 
		 *			toString() is called on this object internally
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 *			this param is only used for objects that are stored in the Registry
		 *	@example
		 *	<listing version="3.0">
		 *	Log.info("This is an info message", this);
		 *	</listing>
		 */
		public static function info(data:*, sender:*, objectId:uint = 0):void 
		{
			Log.getInstance().send(data, sender, LogLevels.INFO, objectId);
		}

		/**
		 *	Log a message with error level
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message; 
		 *			toString() is called on this object internally
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 *			this param is only used for objects that are stored in the Registry
		 *	@example
		 *	<listing version="3.0">
		 *	Log.error("This is an error message", this);
		 *	</listing>
		 */
		public static function error(data:*, sender:*, objectId:uint = 0):void 
		{
			Log.getInstance().send(data, sender, LogLevels.ERROR, objectId);
		}

		/**
		 *	Log a message with warning level
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message; 
		 *			toString() is called on this object internally
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 *			this param is only used for objects that are stored in the Registry
		 *	@example
		 *	<listing version="3.0">
		 *	Log.warn("This is a warning message", this);
		 *	</listing>
		 */
		public static function warn(data:*, sender:*, objectId:uint = 0):void 
		{
			Log.getInstance().send(data, sender, LogLevels.WARN, objectId);
		}

		/**
		 *	Log a message with fatal level
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message; 
		 *			toString() is called on this object internally
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 *			this param is only used for objects that are stored in the Registry
		 *	@example
		 *	<listing version="3.0">
		 *	Log.fatal("This is a fatal message", this);
		 *	</listing>
		 */
		public static function fatal(data:*, sender:*, objectId:uint = 0):void 
		{
			Log.getInstance().send(data, sender, LogLevels.FATAL, objectId);
		}

		/**
		 *	Log a message with status level
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message; 
		 *			toString() is called on this object internally
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 *			this param is only used for objects that are stored in the Registry
		 *	@example
		 *	<listing version="3.0">
		 *	Log.status("This is a status message", this);
		 *	</listing>
		 */
		public static function status(data:*, sender:*, objectId:uint = 0):void 
		{
			Log.getInstance().send(data, sender, LogLevels.STATUS, objectId);
		}

		/**
		 *	Dispatch a LogEvent with the input parameters; trace if flag is set to do so
		 *	@param text the message
		 *	@param sender a reference denoting the source of the message
		 *	@param level the level of the message
		 *	@param objectId the Registry objectId that is stored in Core Objects;
		 */
		private function send(data:*, sender:String, level:*, objectId:uint = 0):void 
		{
			if (this._showTrace) 
			{
				trace(getTimer() + "\t" + level + ": " + data.toString() + " -- " + (sender ? sender.toString() : 'null') + (objectId == 0 ? '' : " #" + objectId + "#"));
			}
			this.dispatchEvent(new LogEvent(level, data, sender ? sender.toString() : 'null', objectId));
		}

		/**
		 *	Add a function as listener to LogEvent events
		 *	@param handler the function to handle LogEvents
		 *	@example
		 *	<listing version="3.0">
		 *	Log.addLogListener(onLog);
		 *	
		 *	private function onLog (e:LogEvent) {
		 *	}
		 *	</listing>
		 */
		public static function addLogListener(handler:Function):void 
		{
			Log.getInstance().addListener(handler);
		}

		/**
		 *	Remove a function as listener to LogEvent events
		 *	@param handler the function that handles LogEvents
		 */
		public static function removeLogListener(handler:Function):void 
		{
			Log.getInstance().removeListener(handler);
		}

		/**
		 *	Set whether log messages should be output as a trace
		 *	@param show if true, log messages are output as a trace
		 *	Set this to false if a log listener also outputs as a trace.
		 *	@example
		 *	<listing version="3.0">
		 *	Log.showTrace = false;
		 *	</listing>
		 */
		public static function get showTrace():Boolean 
		{
			return Log.getInstance()._showTrace;
		}
		
		/**
		 * @private
		 */
		public static function set showTrace(value:Boolean):void 
		{
			Log.getInstance()._showTrace = value;
		}

		/**
		 * @return singleton instance of Logger
		 */
		private static function getInstance():Log 
		{
			if (Log._instance == null) Log._instance = new Log();
			return Log._instance;
		}

		/**
		 *	Add a function to the event listeners
		 */
		private function addListener(handler:Function):void 
		{
			this.addEventListener(LogEvent.EVENT, handler);
		}

		/**
		 *	Remove a function from the event listeners
		 */
		private function removeListener(handler:Function):void 
		{
			this.removeEventListener(LogEvent.EVENT, handler);
		}

		/**
		 * @inheritDoc
		 */
		public static function destruct():void
		{
			Log._instance = null;
		}
	}
}