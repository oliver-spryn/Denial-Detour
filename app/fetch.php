<?php
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

//Import the required classes
	require_once("../system/server/youtube/FetchData.php");
	
//Create a new instance of the FetchData class and pass it the given URL
	if (isset($_GET['URL'])) {
		$fetch = new FetchData($_GET['URL']);
	} else {
		echo "<data><status>false</status></data>";	
	}
?>