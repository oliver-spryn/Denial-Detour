/**
 * Denial Detour
 * 
 * LICENSE
 * 
 * By viewing, using, or actively developing this application in any way, you are
 * henceforth bound the license agreement, and all of its changes, set forth by
 * ForwardFour Innovations. The license can be found, in its entirety, at this 
 * address: http://forwardfour.com/license.
 * 
 * Copyright (c) 2012 and Onwards, ForwardFour Innovations
 * http://forwardfour.com/license    [Proprietary/Closed Source]  
 */

package com.forwardfour {
/**
 * Config is a class which will be imported and instantiated within the main 
 * application and will contain all of the application configuration options and
 * provide a single location for which common values can easily be changed, should
 * it be needed.
*/
	
	final public class Config {
		public var appName:String = "Denial Detour";
		public var minHeight:int = 600;
		public var minWidth:int = 900;
		
		public function Config() {
		//Nothing to do!
		}
	}
}