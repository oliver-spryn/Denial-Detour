<?php
//Output this file as XML
	header("Content-type: text/xml");
	
	echo "<login>
<status>true</status>
<info>
  <first>Oliver</first>
  <last>Spryn</last>
</info>
</login>";
?>