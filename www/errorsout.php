<?php session_start(); /* Starts the session */

if(!isset($_SESSION['UserData']['Username'])){
	header("location:login.php");
	exit;
}

include "paths.php";
?>

<link href="site.css" rel="stylesheet" type="text/css">

</style>


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
    		<a href="loggraph.php"> logs   </a>
    	</div>   
    	    	<div class="item">
    		<a href="logsout.php">Watering log   </a>
    	</div> 
       <div class="item">
                <a href="calibration.php" target="_blank">Recalibration   </a>
        </div> 
    </div>
    </div>
<div class="table">
<?php
$myfile = fopen($basepath . "errors.htm", "r") or die("Unable to open file!");
while(!feof($myfile)){
        $line = fgets($myfile);
        echo "<div class='row'>";
        echo $line . "<br>";
        echo "</div>";
}

fclose($myfile);
//echo nl2br( file_get_contents('errors.htm') );

?>
</div>


</body>
</html>
