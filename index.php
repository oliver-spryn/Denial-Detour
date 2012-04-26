<?php
	header("Content-type: text/xml");
	
	if (isset($_GET['login'])) {
		echo "<login>true</login>";
		exit;
	}
	
	echo "<IP>true</IP>";
?>