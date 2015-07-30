<?php
function listnodes($basepath)
{
	$nodlistf = fopen($basepath . "nodelist", 'r') or die("unable open nodelist");                      # open list of nodes file
	while (!feof($nodlistf) ) {                                                             #load all values 
	$nodes[] = fgetcsv($nodlistf,120);
	}
	array_pop($nodes);
	foreach($nodes as $it){
	echo "<div class='row'>";
	echo "<div class='item'>";
	echo "<input type='checkbox' name='mynodes[]' value='" . $it[0] . "'>" . $it[0]; "</div><div class='item'><input type='text' name='addr" . $it[0] ."' value='" . $it[1] . "'>" ;
	echo "</div><div class='item'><input type='text' name='addr" . $it[0] ."' value='" . $it[1] . "'>";
	echo "<input type='hidden' name='id" . $it[0] . "' value='" . $it[0] . "'>";
	echo "</div>";

	echo "<div class='item'>";
	echo "<input type='text' name='lev" . $it[0] ."' value='" . $it[2] . "'>\n" ;
	echo "</div>";
	echo "<div class='item'><input type='text' name='size" . $it[0] . "' value='" . $it[3] . "'> </div>";

	echo "</div>";
	echo "<input type ='hidden' name='t0" . $it[0] . "' value='" . $it[4] . "'>";
	echo "<input type ='hidden' name='t1" . $it[0] . "' value='" . $it[5] . "'>";
	echo "<input type ='hidden' name='t2" . $it[0] . "' value='" . $it[6] . "'>";
	echo "<input type ='hidden' name='t3" . $it[0] . "' value='" . $it[7] . "'>";
	echo "<input type ='hidden' name='t4" . $it[0] . "' value='" . $it[8] . "'>";

	}
	echo "<input type='hidden' name='totalnodes' value='" . count($nodes) . "'>";   //write total number of nodes for use by update

	fclose($nodlistf);
	return (count($nodes) +1);

}

function updatenodes($basepath)
{

	$nodlistf = fopen($basepath . "nodelist", 'w') or die("unable open nodelist");
	for($i = 1;$i <= intval($_POST['totalnodes']) ;$i++ )                       //for every entry
	{
		fwrite($nodlistf, $_POST['id'. $i] . "," . $_POST["addr".$i] . "," . $_POST["lev".$i] . "," . $_POST["size".$i] . "," . $_POST["t0".$i] . "," . $_POST["t1".$i] . "," . $_POST["t2".$i] . "," . $_POST["t3".$i] . "," . $_POST["t4".$i] . "\n");    //write csv line
	}
	fclose($nodlistf);
}

function deletenodes($basepath)
{
	$nodlistf = fopen($basepath . "nodelist", 'r') or die("unable open nodelist");                      # open list of nodes file
	while (!feof($nodlistf) ) {                                                             #load all values 
	$delnodes[] = fgetcsv($nodlistf,120);
	}

	array_pop($delnodes);
	fclose($nodlistf);

	$nodlistf = fopen($basepath . "nodelist", 'w') or die("unable open nodelist");
	foreach ($delnodes as $it) {
		$flag = TRUE;
		    foreach($_POST['mynodes'] as $thisone){
        		if($thisone == $it[0])
        		{
        			$flag = FALSE;
        		}
    		}
	    	if($flag == TRUE)
	    	{
	    		fwrite($nodlistf,$it[0] . "," . $it[1] . "," . $it[2] . "," . $it[3] ."," . $it[4] ."," . $it[5] ."," . $it[6] ."," . $it[7] ."," . $it[8] . "\n");
	    	}	


	}
	fclose($nodlistf);
}

function newnode($basepath)
{

	$nodlistf = fopen($basepath . "nodelist", 'a') or die("unable open nodelist"); 
    fwrite($nodlistf, $_POST['newid'] . "," . $_POST['newaddress'] . ",".$_POST['newlevel'] . "," . $_POST['newsize'] . "," . "2.50667954365" . "," . "3.12576620061" . "," . "3.74832969084" . "," . "3.46680266544" . "," . "-1.05709077463" . "\n" );
    fclose($nodlistf);

    $newlevels = fopen($basepath . "levels" . $_POST['newid'] . ".csv","w");
    fwrite($newlevels,"0,0," . $_POST['newlevel'] . "," . $_POST['newlevel']. "," . date("Y,n,j,H,i") . "\n"); 
    //copy("/var/www/baselevels.csv","/var/www/levels" . $_POST['newid'] . ".csv");
    fclose($newlevels);
    chmod($basepath . "levels" . $_POST['newid'] . ".csv",0766);
    copy($basepath . "basesets",$basepath . "node" . $_POST['newid'] . "sets");
    chmod($basepath . "node" . $_POST['newid'] . "sets",766);
}

?>
