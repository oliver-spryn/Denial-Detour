<?php
	class FatalError extends Exception {
		public function __construct($title, $message) {		
		//Display the error message
			echo "<section data-role=\"dialog\" class=\"errorAlert\">
<h1>" . $title . "</h1>
<div class=\"content\">" . $message . "</div>
</section>";

		//Terminate any further processing
			exit;
		}
	}
?>