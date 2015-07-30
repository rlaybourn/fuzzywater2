<?php
function outputdata($whichnode,$long,$samples)
{
	include "paths.php";
        $nodlistf = fopen($basepath . "levels" . $whichnode . ".csv", 'r') or die("unable open nodelist");                      # open list of nodes file



        while (!feof($nodlistf) ) {                                                             #load all values 
        $readings[] = fgetcsv($nodlistf,100);
        }
        fclose($nodlistf);
	$readings = array_slice($readings,(-1 * $samples));

	$counter = 0;
	foreach($readings as $it){
	if($it[2] !="")
	{
		if($counter > 0){
			echo ",\n";
		}
	if($long)
	{
		echo "[" . "new Date(" . $it[4] ."," . strval(intval($it[5])-1) ."," . $it[6] . "," . $it[7] . "," . $it[8] .  ")"  . "," . $it[2] . "," . $it[3] . "]" ;
	}
	else
	{
		echo "[" . "new Date(" . $it[4] ."," . strval(intval($it[5])-1) ."," . $it[6] . "," . $it[7] . "," . $it[8] .  ")"  . "," . $it[2] . "]" ;

	}
	$counter = $counter + 1;
	}
	}

}

function clearlogs($whichnode)
{
	include "paths.php";
        $nodlistf = fopen($basepath . "levels" . $whichnode . ".csv", 'r') or die("unable open nodelist");                      # open list of nodes file
        while (!feof($nodlistf) ) {                                                             #load all values 
        $readings[] = fgetcsv($nodlistf,100);
        }
        fclose($nodlistf);
	$readings = array_slice($readings,-15);

        $nodlistf = fopen("/var/www/levels" . $whichnode . ".csv", 'w') or die("unable open nodelist");                      # open list of nodes file
	foreach($readings as $line)
	{
	//	fwrite($nodlistf,$line,200);
		//echo $line[0] . "\n";
		if(!empty($line))
		{
			fputcsv($nodlistf, $line);
		}
	}
	fclose($nodlistf);


}
?>
