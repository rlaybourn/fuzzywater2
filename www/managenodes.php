<?php session_start(); /* Starts the session */

if(!isset($_SESSION['UserData']['Username'])){
	header("location:login.php");
	exit;
}

	ini_set('display_errors',1);  
	error_reporting(E_ALL);

	include "paths.php";
	include "managenodessupport.php";
?>

<link href="site.css" rel="stylesheet" type="text/css">


<html>
<head>
	<title>Manage nodes</title>
</head>
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
    		<a href="loggraph.php">Logs   </a>
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
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
<input type="submit" class="nomal" name="delete" value="Delete">
<input type="submit" class="nomal" name="add" value="Add"> 
<input type="submit" class="nomal" name="update" value="update"> 

<div class="table">
<div class="bar">
<div class="header"> Node ID </div> <div class="header"> Node address </div><div class="header"> Required level </div><div class="header"> Scaling factor </div>
</div>


<?php

if(isset($_POST['update']))                            //update data
{
	updatenodes($basepath);

}

if(isset($_POST['mynodes']) and isset($_POST['delete']) ){                                  #delete selected entry
	deletenodes($basepath);

}

if(isset($_POST['add']) and isset($_POST['newid']) and isset($_POST['newaddress']))
{
	newnode($basepath);
	/*$nodlistf = fopen($basepath . "nodelist", 'a') or die("unable open nodelist"); 
    fwrite($nodlistf, $_POST['newid'] . "," . $_POST['newaddress'] . ",".$_POST['newlevel'] . "," . $_POST['newsize'] . "," . "2.50667954365" . "," . "3.12576620061" . "," . "3.74832969084" . "," . "3.46680266544" . "," . "-1.05709077463" . "\n" );
    fclose($nodlistf);

    $newlevels = fopen($basepath . "levels" . $_POST['newid'] . ".csv","w");
    fwrite($newlevels,"0,0," . $_POST['newlevel'] . "," . $_POST['newlevel']. "," . date("Y,n,j,H,i") . "\n"); 
    //copy("/var/www/baselevels.csv","/var/www/levels" . $_POST['newid'] . ".csv");
    fclose($newlevels);
    chmod($basepath . "levels" . $_POST['newid'] . ".csv",0766);
    copy($basepath . "basesets",$basepath . "node" . $_POST['newid'] . "sets");
    chmod($basepath . "node" . $_POST['newid'] . "sets",766);*/

}

$nodecount = listnodes($basepath);

?>
<div class="row">
<div class="item"><input type="text" name="newid" <?php echo "value='" . $nodecount ."' readonly ='true'"; ?>></div> <div class="item"> <input type="text" name="newaddress"></div>
<div class="item"> <input type="text" name="newlevel"></div>
<div class="item"> <input type="text" name="newsize"></div>
</div>
</div>
</div>
</form>
<?php
echo date("Y,n,j,H,i");
?>
</body>
</html>
