<link href="site.css" rel="stylesheet" type="text/css">

<html>
<head>
    <meta http-equiv="content-type" content="text/html;charset=UTF-8">
    <title>Node Calibration</title>
    <script src="http://code.jquery.com/jquery-2.0.3.js"></script>
    <script>

        function getdata()
         { 
         	document.getElementById("div").innerHTML = "processing";
            $.ajax({
                url: "http://<?php echo htmlspecialchars($_SERVER["SERVER_NAME"]);?>/cgi-bin/ctrain",
                type: "post",
                datatype: "html",
                data: { x1: document.getElementById('1x').value,
            			x2: document.getElementById('2x').value,
            			x3: document.getElementById('3x').value,
            			x4: document.getElementById('4x').value,
            			x5: document.getElementById('5x').value,
            			x6: document.getElementById('6x').value,
            			x7: document.getElementById('7x').value,
            			x8: document.getElementById('8x').value,
            			x9: document.getElementById('9x').value,
            			x10: document.getElementById('10x').value,
            			 y1: document.getElementById('1y').value,
            			y2: document.getElementById('2y').value,
            			y3: document.getElementById('3y').value,
            			y4: document.getElementById('4y').value,
            			y5: document.getElementById('5y').value,
            			y6: document.getElementById('6y').value,
            			y7: document.getElementById('7y').value,
            			y8: document.getElementById('8y').value,
            			y9: document.getElementById('9y').value,
            			y10: document.getElementById('10y').value,
            			node: document.getElementById('nodenum').value,
            			lrate: document.getElementById('learnrate').value,
            		},
                success: function(response){
                        $("#div").html(response);
                        console.log("got calibration"); 
                }
            });
        };

        function writedata()
        {
            $.ajax({
                url: "http://<?php echo htmlspecialchars($_SERVER["SERVER_NAME"]);?>/cgi-bin/write.py",
                type: "post",
                datatype: "html",
                data: {node: document.getElementById('nodenum').value,
                		t0: document.getElementById('t0').value,
						t1: document.getElementById('t1').value,
						t2: document.getElementById('t2').value,
						t3: document.getElementById('t3').value,
						t4: document.getElementById('t4').value

            },
                success: function(response){
                        $("#div").html(response);
                        console.log("writedata ran"); 
                }
            });	
        }       

    </script>
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
                <a href="managenodes.php">manage nodes   </a>
        </div>    

        <div class="item">
                <a href="logsout.php">Watering logs   </a>
        </div> 
        <div class="item">
                <a href="errorsout.php">Errors log   </a>
        </div> 
    </div>
    </div>


<form method="post" action="/cgi-bin/train.py">
Samples: <br> 
<div class="table">
<div class="bar">
<div class="item"> Volts </div>                 <div class="item"> Level </div>
</div>
<div class="row"><div class="item"> 1)<input type="text" name="name" Id="1x"></div><div class="item"> <input type="text" name="name" Id="1y"></div></div>
<div class="row"><div class="item"> 2)<input type="text" name="name" Id="2x"></div><div class="item"> <input type="text" name="name" Id="2y"></div></div>
<div class="row"><div class="item"> 3)<input type="text" name="name" Id="3x"></div><div class="item"> <input type="text" name="name" Id="3y"></div></div>
<div class="row"><div class="item"> 4)<input type="text" name="name" Id="4x"></div><div class="item"> <input type="text" name="name" Id="4y"></div></div>
<div class="row"><div class="item"> 5)<input type="text" name="name" Id="5x"></div><div class="item"> <input type="text" name="name" Id="5y"></div></div>
<div class="row"><div class="item"> 6)<input type="text" name="name" Id="6x"></div><div class="item"> <input type="text" name="name" Id="6y"></div></div>
<div class="row"><div class="item"> 7)<input type="text" name="name" Id="7x"></div><div class="item"> <input type="text" name="name" Id="7y"></div></div>
<div class="row"><div class="item"> 8)<input type="text" name="name" Id="8x"></div><div class="item"> <input type="text" name="name" Id="8y"></div></div>
<div class="row"><div class="item"> 9)<input type="text" name="name" Id="9x"></div><div class="item"> <input type="text" name="name" Id="9y"></div></div>
<div class="row"><div class="item"> 10)<input type="text" name="name" Id="10x"></div><div class="item"> <input type="text" name="name" Id="10y"></div></div>

<br>
</div>
 Which node<select name="nodenum" class="nomal" id="nodenum">                                                 
<?php                                                                                   #created selection box  
include "paths.php";

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

Learning rate <input type="text" name="name" Id="learnrate" value="1.0">


</form>
<div class="report" id="div">Default Stuff</div>
<button class="nomal" onclick="getdata();" value="nsp">Calibrate</button>
</body></html>
