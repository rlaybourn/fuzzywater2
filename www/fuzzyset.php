<!DOCTYPE html>

<?php session_start(); /* Starts the session */

if(!isset($_SESSION['UserData']['Username'])){
	header("location:login.php");
	exit;
}

	ini_set('display_errors',1);  
	error_reporting(E_ALL);

include 'fuzzysetsuppor.php';	
include 'paths.php'
?>
<link href="site.css" rel="stylesheet" type="text/css">

</style>

<html>
<body>

 <head>


<title>Node details</title>

<!--Load the AJAX API-->
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script src="graphs.js" type="text/javascript" ></script>
 </head>



<?php
$name = "";
$whichnode = "1";



if (isset($_POST['save']))                      #if save button pressed
{
	$whichnode = $_POST["nodenum"];        #load which node
        $OK = checkform();
	echo $OK;
	if($OK)
	{
		savesets($whichnode);
	}
}

if (isset($_POST['load']))                              #if load button pressed
{
$whichnode = $_POST["nodenum"];                        #load which node selected 

}

?>


<div class="table">                                      <!-- navigation bar -->
   <div class=bar>
    	<div class="item">
    		<a href="logout.php">Logout    </a>
    	</div>
    	<div class="item">
    		<a href="loggraph.php">Logs   </a>
    	</div>
    	<div class="item">
    		<a href="managenodes.php">manage nodes   </a>
    	</div>     
        <div class="item">
                <a href="logsout.php">Watering logs   </a>
        </div> 
        <div class="item">
                <a href="errorsout.php">Errors log   </a>
        </div> 
       <div class="item">
                <a href="calibration.php" target="_blank">Recalibration   </a>
        </div> 
    </div>
</div>

<div id = 'moisture' class="table">
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">   
 <select name="nodenum" class="nomal" id="nodenum">                                                 
<?php                                                                                   #created selection box     
$nodlistf = fopen($basepath . "nodelist", 'r') or die("unable open nodelist");                      # open list of nodes file



while (!feof($nodlistf) ) {                                                             #load all values 
$nodes[] = fgetcsv($nodlistf,100);
}
array_pop($nodes);                                                                     #remove last empty entry
foreach($nodes as $it){                                                                 #write out to select box
if($it[0] == $whichnode)
{
	echo "<option selected>" . $it[0] . "</option>";
}
else
{
	echo "<option>" . $it[0] . "</option>";
}

}

echo "<br>";
echo count($nodes); 
echo "<br>";
fclose($nodlistf);
?>
</select>
<input type="submit" class="nomal" name="save" value="save">             <!-- save and load settings buttons -->
<input type="submit" class="nomal" name="load" value="load">
<table><tr><H2>Moisture levels</H2></tr><tr>

<?php 

$data = readnodesets($basepath,$whichnode);  //read in membership function data

displaymoisturesets($data); // write out boxes for moisture membership function data

?>

</tr>

</table>
<br>
<H2>Differentials</H2>
<table>
<tr>

<?php

displaydiffsets($data); // write out boxes for differential membership function data

?>

</tr>
</table>


<H2>Outputs</H2>
<table>
<tr>
<?php

displayoutputsets($data); // write out boxes for output membership function data

?>
</tr>
</table>


</form>
<div id="curve_chart"></div>
<button class="nomal" onclick="drawChartdiffs();">Moisture</button><button class="nomal" onclick="drawChart();">Diferentials</button><button class="nomal" onclick="drawChartouts();">outputs</button>
</div>
</body>
</html>
