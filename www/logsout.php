<?php session_start(); /* Starts the session */

if(!isset($_SESSION['UserData']['Username'])){
	header("location:login.php");
	exit;
}

	ini_set('display_errors',1);  
	error_reporting(E_ALL);
include "paths.php";

function tailFile($filepath, $lines = 1) {
return trim(implode("", array_slice(file($filepath), -$lines)));
} 

?>
<link href="site.css" rel="stylesheet" type="text/css">


<html>
<head><title>log output</title></head>
<body>
    <div class="table">
    <div class=bar>
    	<div class="item">
    		<a href="logout.php">Logout    </a>
    	</div>
    	<div class="item">
    		<a href="fuzzyset.php">node settings   </a>
    	</div>
    	<div class="item">
    		<a href="managenodes.php">manage nodes   </a>
    	</div>  
    	    	<div class="item">
    		<a href="loggraph.php">logs   </a>
    	</div>   
    	    	<div class="item">
    		<a href="errorsout.php">Error log   </a>
    	</div> 
       <div class="item">
                <a href="calibration.php" target="_blank">Recalibration   </a>
        </div> 
    </div>
    </div>

<div class="table">
<?php
//$myfile = fopen("wlog.htm", "r") or die("Unable to open file!");
$filearray = file($basepath . "wlog.htm");
$lastfifteenlines = array_slice($filearray,-15);

//while(!feof($myfile)){
foreach($lastfifteenlines as $line)
{
	//$line = fgets($myfile);
	echo "<div class='row'>";
	echo $line . "<br>";
	echo "</div>";
}
//}

//fclose($myfile);
//echo nl2br( file_get_contents('wlog.htm') );

?>
<div>

</body>
</html>
