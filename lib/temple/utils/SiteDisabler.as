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

package temple.utils 
{
	import temple.core.CoreObject;
	import temple.debug.DebugManager;
	import temple.debug.IDebuggable;
	import temple.debug.errors.TempleError;
	import temple.debug.errors.throwError;
	import temple.debug.getClassName;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * The SiteDisabler can prefend all DisplayObject to receive MouseEvents.
	 * 
	 * <p><strong>What does it do</strong></p>
	 * <p>After calling SiteDisabler.disableSite() all MouseEvents are blocked.</p>
	 * 
	 * <p><strong>Why should you use it</strong></p>
	 * <p>If you do not want the user to click on anything. For instance when the application is busy and clicking
	 * buttons could cause errors.</p>
	 * 
	 * <p><strong>How should you use it</strong></p>
	 * <p>Call SiteDisabler.disableSite() to disable all MouseEvents. Call SiteDisabler.enableSite() to enable the MouseEvents</p>
	 *
	 * @example
	 * <listing version="3.0">
	 * SiteDisabler.disableSite(); // all MouseEvents are now disabled
	 * 
	 * SiteDisabler.enableSite(); // all MouseEvents are now enabled
	 * </listing> 
	 * 
	 * @author Thijs Broerse
	 */
	public class SiteDisabler extends CoreObject implements IDebuggable
	{
		private static var _instance:SiteDisabler;
		
		private var _overlay:Sprite;
		private var _siteEnabled:Boolean = true;
		private var _debug:Boolean;

		public function SiteDisabler() 
		{
			if (_instance) throwError(new TempleError(this, "Singleton, use SiteDisabler.getInstance()"));
			
			DebugManager.add(this);
		}

		public static function getInstance():SiteDisabler 
		{
			if(SiteDisabler._instance == null)
			{
				SiteDisabler._instance = new SiteDisabler();
			}
			
			return SiteDisabler._instance;
		}

		public static function set stage(value:Stage):void 
		{
			SiteDisabler.getInstance()._setStage(value);
		}

		/**
		 * Disables the site (not the SiteDisabler)
		 */
		public static function disableSite():void 
		{
			if (SiteDisabler.getInstance()._overlay)
			{
				SiteDisabler.getInstance()._overlay.visible = true;
				
				if (SiteDisabler.getInstance()._debug) SiteDisabler.getInstance().logDebug("disableSite");
			}
			else
			{
				SiteDisabler.getInstance().logError("disable: stage is not set yet!");
			}
		}

		/**
		 * Enables the site (not the SiteDisabler)
		 */
		public static function enableSite():void 
		{
			if (SiteDisabler.getInstance()._overlay)
			{
				SiteDisabler.getInstance()._overlay.visible = false;
				
				if (SiteDisabler.getInstance()._debug) SiteDisabler.getInstance().logDebug("enableSite");
			}
			else
			{
				SiteDisabler.getInstance().logError("disable: stage is not set jet!");
			}
		}

		public static function isSiteEnabled():Boolean
		{
			return SiteDisabler.getInstance()._siteEnabled;
		}

		/**
		 * Gives the Disabler a color, handy for debugging
		 */
		public function set debug(value:Boolean):void
		{
			this._debug = value;
			
			if (this._overlay == null)
			{
				this.logError("debug: stage is not set yet");
				return;
			}
			
			if (this._debug)
			{
				this._overlay.graphics.beginFill(0xFFFF00, .5);
				this._overlay.graphics.drawRect(0, 0, _overlay.width, _overlay.height);
				this._overlay.graphics.endFill();
			}
			else
			{
				this._overlay.graphics.beginFill(0x000000, 0);
				this._overlay.graphics.drawRect(0, 0, _overlay.width, _overlay.height);
				this._overlay.graphics.endFill();
			}
		}
		
		public function get debug():Boolean
		{
			return this._debug;
		}
		
		private function _setStage(stage:Stage):void 
		{
			if (!this._overlay) 
			{
				// create a clip
				this._overlay = new MovieClip();
				this._overlay.name = "SiteDisabler";
				this._overlay.graphics.beginFill(0x000000, 0);
				this._overlay.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				this._overlay.graphics.endFill();
			}
			
			stage.addChild(SiteDisabler.getInstance()._overlay);
			stage.addEventListener(Event.RESIZE, this.handleStageResized, false, 0, true);
			
			if (SiteDisabler.isSiteEnabled())
			{
				SiteDisabler.enableSite();
			}
			else
			{
				SiteDisabler.disableSite();
			}
		}
		
		private function handleStageResized(event:Event):void
		{
			this._overlay.width = Stage(event.target).stageWidth;
			this._overlay.height = Stage(event.target).stageHeight;
		}

		public static function toString():String 
		{
			return getClassName(SiteDisabler);
		}
	}
}
