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
	require_once("system/server/exceptions/PsuedoException.php");

/**
 * FetchData is a class which reads a standard YouTube video URL and parses it
 * in order to fetch all revalent data about a given video from the YouTube data
 * API.
*/
	class FetchData {
		private $videoID = 0;
		
		public function __construct($URL) {
		//Use PHP's native capabilites to capture and parse the URL
			$URLFragments = parse_url($URL);
			
		//Check and see if a URL was provided
			if (empty($URL)) {
				new PsuedoException("No Link Provided", "You did not provide us with a link! Please go back and enter the link of the video you wish to watch, or search <a href=\"http://youtube.com/\" target=\"_blank\">YouTube</a> for a one.");
			}
			
		//Parse $URLFragments['query'] for the video ID
			if (!empty($URLFragments['query'])) {
			//Break up each of the parameters, which are deliminated by the ampersand
				$parameters = explode("&", $URLFragments['query']);
				
			//Then look for the attribute named "v", which contains the video ID
				foreach($parameters as $param) {
					$paramSegment = explode("=", $param);
					
					if (strtolower($paramSegment['0']) == "v") {
						$this->videoID = $paramSegment['1'];
						break;
					}
				}
			}
			
		//Check and see if the URL is in the format youtube.com/watch?v=XXXXXXXXXXX and that the video ID was found
		//The video ID will be 10 if the URL query was invalid or unparsable
			if ($this->videoID != "0") {
			//Now that all of the tests have been passed, fetch the data URL
				echo $this->fetch($this->videoID);
			} else {
				new PsuedoException("Invalid Link Provided", "We could not understand the link that you gave us. Although it does link to <a href=\"http://youtube.com/\" target=\"_blank\">youtube.com</a>, it does not appear to link to any video. A typical video link from YouTube looks like this: www.youtube.com/watch?v=XXXXXXXXXXX, where the list of Xs can be any combination of letters or numbers. Try finding a link that looks similar to this an try again.");
			}
		}
		
		private function fetch($ID) {
		//Build the API URL from the given data
			$URL = "http://youtube.com/get_video_info?video_id=" . $ID;
			
		//Fetch the contents of the requested page
			return file_get_contents($URL);
		}
	}
?>