
      // Load the Visualization API and the piechart package.
      google.load('visualization', '1.0', {'packages':['corechart']});

      // Set a callback to run when the Google Visualization API is loaded.
      google.setOnLoadCallback(drawChartdiffs);

      // Callback that creates and populates a data table,
      // instantiates the pie chart, passes in the data and
      // draws it.
      function drawChart() {

        // Create the data table.
          //document.getElementById('t1').value
	var drier = [];
	var stable = [];
	var wetter = [];
	var superdry = [];

	for(i=0;i<=3;i++) //read boxes
	{
		drier[i] = document.getElementById('drier'+i).value;
		stable[i] = document.getElementById('stable'+i).value;
		wetter[i] = document.getElementById('wetter'+i).value;
		superdry[i] = document.getElementById('superdry'+i).value;

	}
        var data2 = google.visualization.arrayToDataTable([
          ['Year', 'drier', 'stable','wetter','superdry'],
	[Number(drier[0]), 0,  null,null,null],
	[Number(drier[1]), 1, null,null,null],
	[Number(drier[2]), 1, null,null,null],
	[Number(drier[3]), 0 ,null,null,null],	
	[Number(stable[0]), null,  0,null,null],
	[Number(stable[1]), null, 1,null,null],
	[Number(stable[2]), null, 1,null,null],
	[Number(stable[3]), null ,0,null,null],
	[Number(wetter[0]), null ,null,0,null],
	[Number(wetter[1]), null ,null,1,null],
	[Number(wetter[2]), null ,null,1,null],
	[Number(wetter[3]), null ,null,0,null],
	[Number(superdry[1]), null ,null,null,0],
	[Number(superdry[1]), null ,null,null,1],
	[Number(superdry[2]), null ,null,null,1],
	[Number(superdry[3]), null ,null,null,0],

        ]);

        // Set chart options


        var options2 = {
          title: 'Moisture memberships',
          interpolateNulls: true,
          legend: { position: 'bottom' },
	'width':900,
        'height':300	
        };

	var chart2 = new google.visualization.LineChart(document.getElementById('curve_chart'));
	chart2.draw(data2, options2);
 }






function drawChartdiffs() {

        // Create the data table.
          //document.getElementById('t1').value
	var verylow = [];
	var low = [];
	var ok = [];
	var bitwet = [];
	var verywet = [];
	for(i=0;i<=3;i++) //read boxes
	{
		verylow[i] = document.getElementById('vlow'+i).value;
		low[i] = document.getElementById('low'+i).value;
		ok[i] = document.getElementById('ok'+i).value;
		bitwet[i] = document.getElementById('bitwet'+i).value;
		verywet[i] = document.getElementById('verywet'+i).value;
	}
        var data2 = google.visualization.arrayToDataTable([
          ['Year', 'Verylow', 'low','ok','bitwet','verywet'],
	[Number(verylow[0]), 0,  null,null,null,null],
	[Number(verylow[1]), 1, null,null,null,null],
	[Number(verylow[2]), 1, null,null,null,null],
	[Number(verylow[3]), 0 ,null,null,null,null],	
	[Number(low[0]), null,  0,null,null,null],
	[Number(low[1]), null, 1,null,null,null],
	[Number(low[2]), null, 1,null,null,null],
	[Number(low[3]), null ,0,null,null,null],
	[Number(ok[0]), null ,null,0,null,null],
	[Number(ok[1]), null ,null,1,null,null],
	[Number(ok[2]), null ,null,1,null,null],
	[Number(ok[3]), null ,null,0,null,null],
	[Number(bitwet[0]), null ,null,null,0,null],
	[Number(bitwet[1]), null ,null,null,1,null],
	[Number(bitwet[2]), null ,null,null,1,null],
	[Number(bitwet[3]), null ,null,null,0,null],
	[Number(verywet[0]), null ,null,null,null,0],
	[Number(verywet[1]), null ,null,null,null,1],
	[Number(verywet[2]), null ,null,null,null,1],
	[Number(verywet[3]), null ,null,null,null,0]
        ]);

        // Set chart options


        var options2 = {
          title: 'Moisture memberships',
          interpolateNulls: true,
          legend: { position: 'bottom' },
	'width':900,
        'height':300	
        };

	var chart2 = new google.visualization.LineChart(document.getElementById('curve_chart'));
	chart2.draw(data2, options2);
 }



      function drawChartouts() {

        // Create the data table.
          //document.getElementById('t1').value
	var none = [];
	var alittle = [];
	var medium = [];
	var alot = [];

	for(i=0;i<=3;i++) //read boxes
	{
		none[i] = document.getElementById('none'+i).value;
		alittle[i] = document.getElementById('alittle'+i).value;
		medium[i] = document.getElementById('medium'+i).value;
		alot[i] = document.getElementById('alot'+i).value;

	}
        var data2 = google.visualization.arrayToDataTable([
          ['Year', 'none', 'alittle','medium','alot'],
	[Number(none[0]), 0,  null,null,null],
	[Number(none[1]), 1, null,null,null],
	[Number(none[2]), 1, null,null,null],
	[Number(none[3]), 0 ,null,null,null],	
	[Number(alittle[0]), null,  0,null,null],
	[Number(alittle[1]), null, 1,null,null],
	[Number(alittle[2]), null, 1,null,null],
	[Number(alittle[3]), null ,0,null,null],
	[Number(medium[0]), null ,null,0,null],
	[Number(medium[1]), null ,null,1,null],
	[Number(medium[2]), null ,null,1,null],
	[Number(medium[3]), null ,null,0,null],
	[Number(alot[0]), null ,null,null,0],
	[Number(alot[1]), null ,null,null,1],
	[Number(alot[2]), null ,null,null,1],
	[Number(alot[3]), null ,null,null,0],
        ]);

        // Set chart options


        var options2 = {
          title: 'Moisture memberships',
          interpolateNulls: true,
          legend: { position: 'bottom' },
	'width':900,
        'height':300	
        };

	var chart2 = new google.visualization.LineChart(document.getElementById('curve_chart'));
	chart2.draw(data2, options2);
 }