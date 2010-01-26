/*
Copyright 2009 Stephan Bezoen, http://stephan.acidcats.nl

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

package nl.acidcats.yalog 
{
	import nl.acidcats.yalog.common.Functions;
	import nl.acidcats.yalog.common.Levels;
	import nl.acidcats.yalog.common.MessageData;

	import temple.debug.getClassName;

	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import flash.utils.getTimer;

	public class Yalog 
	{
		private static const BUFFER_SIZE:Number = 250;

		private static var _instance:Yalog;
		private static var _bufferSize:Number = Yalog.BUFFER_SIZE;
		private static var _showTrace:Boolean = true;

		private var _sender:LocalConnection;
		private var _senderConnected:Boolean = false;

		private var _receiver:PongConnection;

		private var _buffer:Array;
		private var _writePointer:Number;
		private var _fullCircle:Boolean = false;
		
		/**
		 * The instance of this class is only used in static functions, so not accessible from the outside
		 * @return singleton instance of yalog.Yalog
		 */
		private static function getInstance():Yalog 
		{
			if (Yalog._instance == null) Yalog._instance = new Yalog();
			return Yalog._instance;
		}

		/*
		 * Constructor; private not allowed in AS3
		 */
		function Yalog() 
		{
			// create send connection
			this._sender = new LocalConnection();
			this._sender.addEventListener(StatusEvent.STATUS, this.handleSenderStatus, false, 0, true);

			// create buffer for buffering messages while not connected
			this._buffer = new Array(Yalog._bufferSize);
			this._writePointer = 0;

			// send a "ping" on the main channel to check for availability of any viewer application		
			ping();
		}

		/**
		 *	Send a "ping" on the main channel if a free receive channel is available
		 */
		private function ping():void 
		{
			if (createReceiver()) 
			{
				try 
				{
					this._sender.send(Functions.CHANNEL, Functions.FUNC_PING, this._receiver.getReceiverChannel());
				}
				catch (e:ArgumentError) 
				{
				}
			}
		}

		/**
		 *	Create receiver local connection to handle pong from viewer application
		 */
		private function createReceiver():Boolean 
		{
			this._receiver = new PongConnection();
			this._receiver.addEventListener(StatusEvent.STATUS, this.handleReceiverStatus, false, 0, true);
			this._receiver.addEventListener(PongConnection.EVENT_PONG_RECEIVED, this.handlePong, false, 0, true);
			
			return this._receiver.start();
		}

		/**
		 *	Handle event from receiver connection that a pong was received
		 */
		private function handlePong(e:Event):void 
		{
			// flag we're connected to viewer
			this._senderConnected = true;
			
			// dump any buffered messages to the viewer
			this.dumpData();
		}

		/**
		 *	Set the number of messages to be kept as history.
		 *	Note: this will clear the current buffer, so make sure this is the first thing you do!
		 */
		public static function setBufferSize(inSize:Number):void 
		{
			Yalog.getInstance().setBufSize(inSize);
		}

		/**
		 *	Send a debug message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function debug(inText:String, inSender:String):void 
		{
			sendToConsole(inText, Levels.DEBUG, inSender);
		}

		/**
		 *	Send an informational message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function info(inText:String, inSender:String):void 
		{
			Yalog.sendToConsole(inText, Levels.INFO, inSender);
		}

		/**
		 *	Send an error message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function error(inText:String, inSender:String):void 
		{
			Yalog.sendToConsole(inText, Levels.ERROR, inSender);
		}

		/**
		 *	Send a warning message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function warn(inText:String, inSender:String):void 
		{
			Yalog.sendToConsole(inText, Levels.WARN, inSender);
		}

		/**
		 *	Send a fatal message to Yala
		 *	@param inText: the message
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		public static function fatal(inText:String, inSender:String):void 
		{
			Yalog.sendToConsole(inText, Levels.FATAL, inSender);
		}

		/**
		 *	Send a text to Yala with a certain level of importance
		 *	@param inText: the message
		 *	@param inLevel: the level of importance
		 *	@param inSender: a String denoting the sender (p.e. the classname)
		 */
		private static function sendToConsole(text:String, level:Number, sender:String):void 
		{
			var md:MessageData = new MessageData(text, level, getTimer(), sender);
			
			if(Yalog._showTrace) trace(md.toString());

			Yalog.getInstance().handleData(md);
		}

		/**
		 *	Set whether log messages should be output as a trace
		 *	@param show if true, log messages are output as a trace
		 *	Set this to false if a log listener also outputs as a trace.
		 *	@use
		 *	<code>
		 *	Yalog.showTrace = false;
		 *	<code>
		 */
		public static function get showTrace():Boolean 
		{
			return Yalog._showTrace;
		}

		/**
		 * @private
		 */
		public static function set showTrace(value:Boolean):void 
		{
			Yalog._showTrace = value;
		}

		/**
		 *	Process message data
		 */
		private function handleData(data:MessageData):void 
		{
			if (!_senderConnected) 
			{
				this.storeData(data);
			} 
			else 
			{
				this.sendData(data);
			}
		}

		/**
		 *	Send out message on the local connection
		 */
		private function sendData(data:MessageData):void 
		{
			data.channelID = _receiver.getReceiverChannelID();
			this._sender.send(Functions.CHANNEL, Functions.FUNC_WRITELOG, data);
		}

		/**
		 *	Store message
		 */
		private function storeData(inData:MessageData):void 
		{
			this._buffer[_writePointer++] = inData;
			
			if (this._writePointer >= BUFFER_SIZE) 
			{
				this._fullCircle = true;
				this._writePointer = 0;
			}
		}

		/**
		 *	Send out all stored messages
		 */
		private function dumpData():void 
		{
			if (!_fullCircle && (_writePointer == 0)) return;
			
			this.sendData(new MessageData("-- START DUMP --", Levels.STATUS, getTimer(), toString()));
			
			if (_fullCircle) 
			{
				this.dumpRange(_writePointer, BUFFER_SIZE - 1);
			}
			this.dumpRange(0, _writePointer - 1);

			this.sendData(new MessageData("-- END DUMP --", Levels.STATUS, getTimer(), toString()));
			
			this._writePointer = 0;
			this._fullCircle = false;
		}

		/**
		 *	Send out messages in a consecutive range
		 */
		private function dumpRange(start:Number, end:Number):void 
		{
			for (var i:Number = start;i <= end;i++) 
			{
				this.sendData(MessageData(_buffer[i]));
			}
		}

		/**
		 *	Set the buffer size for storing messages
		 */
		private function setBufSize(size:Number):void 
		{
			Yalog._bufferSize = size;
			
			this._buffer = new Array(Yalog._bufferSize);
			this._writePointer = 0;
			this._fullCircle = false;
		}

		private function handleReceiverStatus(e:StatusEvent):void 
		{
		}

		private function handleSenderStatus(e:StatusEvent):void 
		{
		}

		public function toString():String 
		{
			return getClassName(Yalog);
		}
	}
}

import nl.acidcats.yalog.common.Functions;

import flash.events.Event;
import flash.net.LocalConnection;

/**-------------------------------------------------------
 * Private class for handling "pong" call on local connection from viewer application
 */






dynamic class PongConnection extends LocalConnection 
{
	public static var EVENT_PONG_RECEIVED:String = "onPongReceived";

	private var _channelID:Number;
	private var _receiverChannel:String;

	/**
	 * Constructor
	 */
	public function PongConnection() 
	{
		// allow connection from anywhere
		allowDomain("*");
		allowInsecureDomain("*");
	}

	/**
	 * Start the connection by finding a free channel and connecting on in
	 * @return true if a free channel was found and connecting was successful, otherwise false
	 */
	public function start():Boolean 
	{
		var receiverConnected:Boolean = false;
		this._channelID = 0;

		// loop available channels, try to connect
		do 
		{
			this._channelID++;
			this._receiverChannel = Functions.CHANNEL_PING + _channelID;
			
			try 
			{
				receiverConnected = true;
				this.connect(this._receiverChannel);
			}
			catch (e:ArgumentError) 
			{
				receiverConnected = false;
			}
		}
		while (!receiverConnected && (_channelID < Functions.MAX_CHANNEL_COUNT));
		
		if (receiverConnected) 
		{
			this[Functions.FUNC_PONG] = handlePong;
		}
		
		return receiverConnected;
	}

	/**
	 * @return the full name of the receiver channel
	 */
	public function getReceiverChannel():String 
	{
		return this._receiverChannel;
	}

	/**
	 * @return the ID of the receiver channel
	 */
	public function getReceiverChannelID():Number 
	{
		return this._channelID;
	}

	/**
	 * Handle call from a viewer application via local connection 
	 */
	private function handlePong():void 
	{
		this.close();
		
		this.dispatchEvent(new Event(EVENT_PONG_RECEIVED));
	}
}
