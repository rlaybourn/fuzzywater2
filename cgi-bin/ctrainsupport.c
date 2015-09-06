//------------------------------------------------------------------------------------------
// Author: Richard Laybourn
// Date  : July 20th 2015
// summary: supporting functions for ctrain to implement collection of data and polynomial
//          fitting
//---------------------------------------------------------------------------------------------

int collectdata(double *x,double *y,double *rate) // collects posted data and writes into x and y arrays
{
	int count = 1;
	int datapointer = 0;
	char namex[30],namey[30];
	double readit[2];
	cgiFormDouble("lrate",rate,1);
	for(count=1;count<=10;count++)  //up to 10 x and y values may be posted
	{
		sprintf(namex,"x%d",count); //construct posted variable name from the count number
		sprintf(namey,"y%d",count);
		cgiFormDouble(namex,&readit[0],0);
		cgiFormDouble(namey,&readit[1],0);
		if((readit[0] > 0) && (readit[1] > 0)) 
		{
			x[datapointer] = readit[0];
			y[datapointer] = readit[1];
			datapointer++;
		}
	}
	return datapointer;  //return number of points read

}

double Htheta(double *thetas, double x,int size) //evaluate polynomial given value and coeffs
{
	double total = 0;
	double px = x;

	int i;
	for(i = 1;i<size;i++)
	{
		//printf("%f\n",thetas[i]);
		total = total + (thetas[i] * px);
		px = px * x;
	}
	total = total + thetas[0];
	return total;
}

double toerr(double *thetas,double *x, double *y,int sizeth,int sizex) //find total error for given coeffs
{
	double total = 0;
	int counter = 0;
	int i = 0;
	for(i=0;i<sizex;i++)
	{
		total = total + y[i] - Htheta(thetas,x[i],sizeth);
	}
	return total;
}

double fitto(double *thetas,double *x, double *y,int sizeth,int sizex,double lrate) //perform fitting of polynomial to data
{
	double newth[sizeth]; //temporary thetas
	double rate = lrate * pow(10,(sizeth * -1)); //learning rate
	double error = 100;
	int i =0;
	int j = 0;
	int counter = 0;
	for(i=0;i<sizeth;i++) //clear temp thetas
	{
		newth[i] = 0.0;
	}

	while((fabs(error) > 0.01) && (counter < 1000000)) //carry on unitl error is less than 0.01 or 1 million interations have been carried out
	{
		for(j=0;j<sizeth;j++) //for each coeff
		{
			for(i=0;i<sizex;i++) //for each data point
			{

				newth[j] += rate * ((y[i] - Htheta(thetas,x[i],sizeth)) * pow(x[i],(double)j)); //find update value
			}
		}

		for(j=0;j<sizeth;j++) //update coeffs 
		{
			thetas[j] = thetas[j] + newth[j];
			newth[j] = 0;

		}

		counter++;
		error = toerr(thetas,x,y,sizeth,sizex);
	}

	return error;
}