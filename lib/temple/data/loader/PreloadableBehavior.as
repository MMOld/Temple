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

package temple.data.loader 
{
	import temple.core.CoreURLLoader;
	import temple.core.CoreURLStream;
	import temple.behaviors.AbstractBehavior;

	import flash.display.LoaderInfo;
	import flash.events.ProgressEvent;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLStream;
	import flash.utils.Dictionary;

	/**
	 * Decorates a class with Preloadable functionality.
	 * <p>The target class should implement the IPreloadable interface
	 * to wrap the preloader set/getter methods,
	 * and call the 'onLoadStart', 'onLoadProgress' and 'onLoadComplete' methods</p>
	 * <p>When multiple instances of this class use the same preloader, the loading progress is shared</p>
	 * 
	 * @date 28 aug 2009 15:25:13
	 * @author Arjan van Wijk (arjan at mediamonks dot com)
	 */
	public class PreloadableBehavior extends AbstractBehavior
	{
		private static var _loadingList:Dictionary;
		private static var _completedList:Dictionary;
		
		private var _preloader:IPreloader;
		
		/**
		 * @param target The IPreloadable target that wraps this class
		 */
		public function PreloadableBehavior(target:IPreloadable)
		{
			super(target);
			
			if (!PreloadableBehavior._loadingList) PreloadableBehavior._loadingList = new Dictionary(true);
			if (!PreloadableBehavior._completedList) PreloadableBehavior._completedList = new Dictionary(true);
		}
		
		/**
		 * Get or set the IPreloader
		 */
		public function get preloader():IPreloader
		{
			return this._preloader;
		}
		
		/**
		 * @private
		 */
		public function set preloader(value:IPreloader):void
		{
			this._preloader = value;
			
			if (!PreloadableBehavior._loadingList[this._preloader])
			{
				PreloadableBehavior._loadingList[this._preloader] = new Array();
				PreloadableBehavior._completedList[this._preloader] = new Array();
			}
		}
		
		/**
		 * Call this method when the loading starts.
		 * 
		 * @param event The Event.OPEN event
		 * @param url The url of the loaded media, only nessasery when the target is a Loader
		 */
		public function onLoadStart(target:Object, url:String = ''):void
		{
			if (this._preloader)
			{
				if (PreloadableBehavior._loadingList[this._preloader].indexOf(target) == -1) PreloadableBehavior._loadingList[this._preloader].push(target);
				
				if (PreloadableBehavior._loadingList[this._preloader].length == 1) this._preloader.onLoadStart(url == '' ? getUrlForTarget(target) : url);
			}
		}
		
		/**
		 * Call this method when the loading is progressing.
		 * <p>When multiple instances of this class use the same preloader, the loading progress is shared</p>
		 * 
		 * @param event The ProgressEvent.PROGRESS event
		 */
		public function onLoadProgress(event:ProgressEvent):void
		{
			if (this._preloader)
			{
				var total:Number = 0;
				var loaded:Number = 0;
				var target:*;
				
				for each (target in PreloadableBehavior._completedList[this._preloader])
				{
					var t:Number = this.getBytesTotalForTarget(target);
					total += t;
					loaded += t;
				}
				
				for each (target in PreloadableBehavior._loadingList[this._preloader])
				{
					total += this.getBytesTotalForTarget(target);
					loaded += this.getBytesLoadedForTarget(target);
				}
				
				this._preloader.onLoadProgress(loaded / total);
			}
		}
		
		/**
		 * Call this method when the loading is done (complete or error)
		 * 
		 * @param event The Event.COMPLETE, IOErrorEvent.IO_ERROR or SecurityErrorEvent.SECURITY_ERROR event
		 */
		public function onLoadComplete(target:Object):void
		{
			this.onComplete(target);
		}
		
		/**
		 * Handles the load completion.
		 * Checks of all preloaders are done loading.
		 */
		private function onComplete(target:Object):void
		{
			if (this._preloader)
			{
				if (PreloadableBehavior._loadingList[this._preloader].length == 1) this._preloader.onLoadComplete();
				
				var len:uint = PreloadableBehavior._loadingList[this._preloader].length;
				for(var i:Number = len;i > -1; i--)
				{
					if (PreloadableBehavior._loadingList[this._preloader][i] === target)
					{
						PreloadableBehavior._completedList[this._preloader].push(PreloadableBehavior._loadingList[this._preloader].splice(i, 1)[0]);
					}
				}
				
				// all loading is done
				if (PreloadableBehavior._loadingList[this._preloader].length == 0)
				{
					PreloadableBehavior._loadingList[this._preloader] = new Array();
					PreloadableBehavior._completedList[this._preloader] = new Array();
				}
			}
		}
		
		/**
		 * Gets the bytes total of the target based on the targets type
		 */
		private function getBytesTotalForTarget(target:*):Number
		{
			var total:Number;
			
			switch (true)
			{
				case target is URLLoader:
				{
					total = (target as URLLoader).bytesTotal;
					break;
				}
				case target is LoaderInfo:
				{
					total = (target as LoaderInfo).bytesTotal;
					break;
				}
				case target is URLStream:
				{
					total = 1; 
					break;
				}
				case target is NetStream:
				{
					total = (target as NetStream).bytesTotal;
					break;
				}
			}
			
			return total;
		}
		
		/**
		 * Gets the bytes loaded of the target based on the targets type
		 */
		private function getBytesLoadedForTarget(target:*):Number
		{
			var total:Number;
			
			switch (true)
			{
				case target is URLLoader:
				{
					total = (target as URLLoader).bytesLoaded;
					break;
				}
				case target is LoaderInfo:
				{
					total = (target as LoaderInfo).bytesLoaded;
					break;
				}
				case target is URLStream:
				{
					total = 0;
					break;
				}
				case target is NetStream:
				{
					total = (target as NetStream).bytesLoaded;
					break;
				}
			}
			
			return total;
		}
		
		/**
		 * Gets the url of the target based on the targets type
		 */
		private function getUrlForTarget(target:*):String
		{
			var url:String = '';
			
			switch (true)
			{
				case target is CoreURLLoader:
				{
					url = (target as CoreURLLoader).url;
					break;
				}
				case target is LoaderInfo:
				{
					url = (target as LoaderInfo).url;
					break;
				}
				case target is CoreURLStream:
				{
					url = (target as CoreURLStream).url; 
					break;
				}
				
				default:
				{
					// unknown target
				}
			}
			
			return url ? url : '';
		}

		override public function destruct():void
		{
			if (this._preloader)
			{
				if (PreloadableBehavior._loadingList[this._preloader].length == 0) PreloadableBehavior._loadingList[this._preloader] = null;
				if (PreloadableBehavior._completedList[this._preloader].length == 0) PreloadableBehavior._completedList[this._preloader] = null;
				
				this._preloader = null;
			}
			
			super.destruct();
		}
	}
}