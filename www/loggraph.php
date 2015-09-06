<!-- displays graph of logged data -->

<?php session_start(); /* Starts the session */

if(!isset($_SESSION['UserData']['Username'])){
	header("location:login.php");
	exit;
}
        ini_set('display_errors',1);  
        error_reporting(E_ALL);

include 'logsoutsupport.php';
include 'paths.php';
?>
<head>
<link href="site.css" rel="stylesheet" type="text/css">


<html>


<title>Logs</title>

    <!--Load the AJAX API-->
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">

      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['controls','corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChartnsp);


	<?php                                       #check node and load readings
	ini_set('display_errors',1);  
	error_reporting(E_ALL);
	$whichnode = 1;
	$days = 7;

	if(isset($_POST['clear']))
	{
		$whichnode = $_POST["nodenum"];
		clearlogs($whichnode);
		echo "cleared";
	}

	if (isset($_POST['load']))                      #if save button pressed
	{
		$whichnode = $_POST["nodenum"];        #load which node
	}

	$nodlistf = fopen($basepath . "levels" . $whichnode . ".csv", 'r') or die("unable open nodelist");                      # open list of nodes file



	while (!feof($nodlistf) ) {                                                             #load all values 
	$readings[] = fgetcsv($nodlistf,120);
	}
	fclose($nodlistf);
	?>



	function drawChart() {    //draw chart with setpoint                                
		var data= google.visualization.arrayToDataTable([
				['time','level','set point'],
				<?php
				outputdata($whichnode,True,1001);
				?>

				]);

                var dashboard = new google.visualization.Dashboard(
                    document.getElementById('dashboard_div'));



                var rangeslider = new google.visualization.ControlWrapper({
                'controlType':'DateRangeFilter',
                'containerId': 'filter_div',
                'options':{'filterColumnLabel':'time',
			'height':100},
                });

        var chart2 = new google.visualization.ChartWrapper({//set graph display preferenes
        'chartType': 'LineChart',
        'containerId': 'chart_div',
        'options':{
        'width':"100%",
        'height':500,
        series: {0: { color: '#0000FF',lineWidth: 1 },
                 1: { color: '#FF0000',lineDashStyle: [3,2],lineWidth: 1 }},

         viewWindowMode:'explicit',
         vAxis:{viewWindow:{max:45,min:10},ticks: [10, 15, 20, 25, 30, 35, 40, 45]}
        }
        });
        dashboard.bind(rangeslider, chart2);
        dashboard.draw(data);

    	}

        function drawChartnsp() { //draw graph without setpoint data
                var data= google.visualization.arrayToDataTable([
                                ['time','level'],
                                <?php
				outputdata($whichnode,False,1001);
                                ?>

                                ]);
	        var dashboard = new google.visualization.Dashboard(
        	    document.getElementById('dashboard_div'));

		var rangeslider = new google.visualization.ControlWrapper({
		'controlType':'DateRangeFilter',
		'containerId': 'filter_div',
		'options':{'filterColumnLabel':'time',
			'height':100}
		});



	var chart2 = new google.visualization.ChartWrapper({
	'chartType': 'LineChart',
	'containerId': 'chart_div',
	'options':{
	'width':"100%",
	'height':500,
        series: {0: { color: '#0000FF',lineWidth: 1 },
                 1: { color: '#FF0000',lineDashStyle: [3,2],lineWidth: 1 }},
         viewWindowMode:'explicit',
         vAxis:{viewWindow:{max:45,min:10},ticks: [10, 15, 20, 25, 30, 35, 40, 45]}
	}
	});
	dashboard.bind(rangeslider, chart2);
        dashboard.draw(data);

        }

    </script>
  </head>
    <body>
    <div class="table"> <!-- display menu-->
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
		<a href="logsout.php"> Watering logs </a>
	</div>
        <div class="item">
                <a href="errorsout.php">errors log   </a>
        </div> 
       <div class="item">
                <a href="calibration.php" target="_blank">Recalibration   </a>
        </div>    

    </div>
    </div>

<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"><!--postback form-->   
Node: 
 <select name="nodenum" class="nomal" id="nodenum">                                                 
<?php                                                                                   #created selection box  


$nodlistf = fopen($basepath . "nodelist", 'r') or die("unable open nodelist");                      # open list of nodes file



while (!feof($nodlistf) ) {                                                             #load all values 
$nodes[] = fgetcsv($nodlistf,120);
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
<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>"> <!-- form to post back and reload or clear data -->
<input type="submit" class="nomal" name="load" value="load">
<input type="submit" class="nomal" name="clear" onclick="return confirm('Are you sure?')" value="clear">  <!-- javascript used to confirm before resubmission -->
</form>

<!-- divs for the dashboard and graph to be placed in-->
	<div id="dashboard_div">
<div id="filter_div"></div>
    <div id="chart_div" class="chartdiv"></div>
</div>


 
<!-- buttons to run javascript graphing functions-->
<button class="nomal" onclick="drawChartnsp();" value="nsp">Remove set point</button><button class="nomal" onclick="drawChart();" value="nsp">with set point</button>


  </body>
</html>
