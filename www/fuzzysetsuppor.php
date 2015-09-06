<?php //functions to support  fuzzy sets manipulation

	function checkform()
	{
			$OK = True;

	    for($y = 0; $y <=3 ; $y++)                                # read all boxes
	    {
	    	if(!is_numeric($_POST["vlow".$y]))
	    	{
	    		$OK = False;
	    		echo "vlow".$y . " not numeric<br>";
	    	}
	    	 if(!is_numeric($_POST["low".$y]))
	    	{
	    		$OK = False;
	    		echo "low".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["ok".$y]))
	    	{
	    		$OK = False;
	    		echo "ok".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["bitwet".$y]))
	    	{
	    		$OK = False;
	    		echo "bitwet".$y . " not numeric<br>";
	    	}    
	    	if(!is_numeric($_POST["verywet".$y]))
	    	{
	    		$OK = False;
	    		echo "verywet".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["drier".$y]))
	    	{
	    		$OK = False;
	    		echo "drier".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["stable".$y]))
	    	{
	    		$OK = False;
	    		echo "stable".$y . " not numeric<br>";
	    	}    	    	    		
	    	if(!is_numeric($_POST["wetter".$y]))
	    	{
	    		$OK = False;
	    		echo "wetter".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["superdry".$y]))
	    	{
	    		$OK = False;
	    		echo "superdry".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["none".$y]))
	    	{
	    		$OK = False;
	    		echo "none".$y . " not numeric<br>";
	    	}   
	    	if(!is_numeric($_POST["alittle".$y]))
	    	{
	    		$OK = False;
	    		echo "alittle".$y . " not numeric<br>";
	    	}
	    	if(!is_numeric($_POST["medium".$y]))
	    	{
	    		$OK = False;
	    		echo "medium".$y . " not numeric<br>";
	    	}    	    	 	    	    	
	    	if(!is_numeric($_POST["alot".$y]))
	    	{
	    		$OK = False;
	    		echo "alot".$y . " not numeric<br>";
	    	}    	
	    }

	    if(!$OK)
	    {
	    	return False;

	    }
	    else
	    {
	    	return True;
	    }

	}



	function savesets($whichnode)
	{
			$myfile = fopen("node" . $whichnode . "sets", "w") or die("Unable to open file!"); #open settings file for saving
    



	for($y = 0; $y <=3 ; $y++)                                # read all boxes
	{
		$vlow[$y] = $_POST["vlow".$y];	
		$low[$y] = $_POST["low".$y];
		$ok[$y] = $_POST["ok".$y];
		$bitwet[$y] = $_POST["bitwet".$y];
		$verywet[$y] = $_POST["verywet".$y];
		$drier[$y] = $_POST["drier".$y];
		$stable[$y] = $_POST["stable".$y];
		$wetter[$y] = $_POST["wetter".$y];
		$superdry[$y] = $_POST["superdry".$y];
		$none[$y] = $_POST["none".$y];
		$alittle[$y] = $_POST["alittle".$y];
		$medium[$y] = $_POST["medium".$y];
		$alot[$y] = $_POST["alot".$y];
	}


	for($y = 0; $y <=2 ; $y++)                                 #write boxes to file as csv
	{
		fwrite($myfile, $vlow[$y] . ',');
	}
	fwrite($myfile, $vlow[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $low[$y] . ',');
	}
	fwrite($myfile, $low[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $ok[$y] . ',');
	}
	fwrite($myfile, $ok[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $bitwet[$y] . ',');
	}
	fwrite($myfile, $bitwet[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $verywet[$y] . ',');
	}
	fwrite($myfile, $verywet[$y] . "\n");
	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $drier[$y] . ',');
	}
	fwrite($myfile, $drier[$y] . "\n");
	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $stable[$y] . ',');
	}
	fwrite($myfile, $stable[$y] . "\n");
	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $wetter[$y] . ',');
	}
	fwrite($myfile, $wetter[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $superdry[$y] . ',');
	}
	fwrite($myfile, $superdry[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $none[$y] . ',');
	}
	fwrite($myfile, $none[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $alittle[$y] . ',');
	}
	fwrite($myfile, $alittle[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $medium[$y] . ',');
	}
	fwrite($myfile, $medium[$y] . "\n");

	for($y = 0; $y <=2 ; $y++)
	{
		fwrite($myfile, $alot[$y] . ',');
	}
	fwrite($myfile, $alot[$y] . "\n");
	fclose($myfile);
	}


function readnodesets($basepath,$whichnode)
{
	$myfile = fopen($basepath . "node" . $whichnode . "sets", "r") or die("Unable to open file!");    #open setting file for loading
	$data[1] = fgetcsv($myfile,1024);                                                   #load all lines
	$data[2] = fgetcsv($myfile,1024);
	$data[3] = fgetcsv($myfile,1024);
	$data[4] = fgetcsv($myfile,1024);
	$data[5] = fgetcsv($myfile,1024);
	$data[6] = fgetcsv($myfile,1024);
	$data[7] = fgetcsv($myfile,1024);
	$data[8] = fgetcsv($myfile,1024);
	$data[9] = fgetcsv($myfile,1024);
	$data[10] = fgetcsv($myfile,1024);
	$data[11] = fgetcsv($myfile,1024);
	$data[12] = fgetcsv($myfile,1024);
	$data[13] = fgetcsv($myfile,1024);
	fclose($myfile);
	return $data;
}

function displaymoisturesets($data)
{
	echo "<td>vlow</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='vlow" . $x ."' ID='vlow" . $x . "' value='" . $data[1][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>low</td>    ";
	for($x = 0; $x <=3 ; $x++)
	{

		
		echo "<td><input type='text' name='low" . $x . "' ID='low" . $x . "' value='" . $data[2][$x] . "'></td>";

	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>ok :</td>    ";
	for($x = 0; $x <=3 ; $x++)
	{

		
		echo "<td><input type='text' name='ok" . $x ."' ID='ok" . $x . "' value='" . $data[3][$x] . "'></td>";

	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>bitwet:</td> ";
	for($x = 0; $x <=3 ; $x++)
	{

		
		echo "<td><input type='text' name='bitwet" . $x ."' ID='bitwet" . $x . "' value='" . $data[4][$x] . "'></td>";

	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>verywet:</td>";
	for($x = 0; $x <=3 ; $x++)
	{

		
		echo "<td><input type='text' name='verywet" . $x ."' ID='verywet" . $x . "' value='" . $data[5][$x] . "'></td>";

	}

}

function displaydiffsets($data)
{
	echo "<td>drier</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='drier" . $x ."' ID='drier" . $x . "' value='" . $data[6][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>stable</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='stable" . $x ."' ID='stable" . $x . "' value='" . $data[7][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>wetter</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='wetter" . $x ."' ID='wetter" . $x . "' value='" . $data[8][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>superdry</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='superdry" . $x ."' ID='superdry" . $x . "' value='" . $data[9][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";

}

function displayoutputsets($data)
{
	echo "<td>none</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='none" . $x ."' ID='none" . $x . "' value='" . $data[10][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>alittle</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='alittle" . $x ."' ID='alittle" . $x . "' value='" . $data[11][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>medium</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='medium" . $x ."' ID='medium" . $x . "' value='" . $data[12][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
	echo "<td>alot</td>   ";                                                          #write table fill values
	for($x = 0; $x <=3 ; $x++)
	{
		
		echo "<td><input type='text' name='alot" . $x ."' ID='alot" . $x . "' value='" . $data[13][$x] . "'></td>";
		


	}
	echo "</tr>";
	echo "<tr>";
}
?>
	
