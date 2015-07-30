#include <stdio.h>
#include <stdlib.h>
#include <math.h>

double Htheta(double *thetas, double x,int size)
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

double toerr(double *thetas,double *x, double *y,int sizeth,int sizex)
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

void fitto(double *thetas,double *x, double *y,int sizeth,int sizex)
{
	double newth[sizeth]; //temporary thetas
	double rate = 1 * pow(10,(sizeth * -1)); //learning rate
	double error = 100;
	int i =0;
	int j = 0;
	int counter = 0;
	for(i=0;i<sizeth;i++) //clear temp thetas
	{
		newth[i] = 0.0;
	}

	while(fabs(error) > 0.01)
	{
		for(j=0;j<sizeth;j++)
		{
			//printf("%d ",j);
			for(i=0;i<sizex;i++)
			{

				newth[j] += rate * ((y[i] - Htheta(thetas,x[i],sizeth)) * pow(x[i],(double)j));
			//	printf("%f ",newth[j]);
			}
			//printf("\n");
		}

		for(j=0;j<sizeth;j++)
		{
			thetas[j] = thetas[j] + newth[j];
			newth[j] = 0;

		}
		//printf("%f %f %f %f %f\n",thetas[0],thetas[1],thetas[2],thetas[3],thetas[4]);
		if(counter % 10000 == 0)
			printf("%f\n",toerr(thetas,x,y,sizeth,sizex));
		counter++;
		error = toerr(thetas,x,y,sizeth,sizex);
	}


	printf("%f\n",rate);

}

void main()
{
	double thetas[] = {1,1,1,1,1};
	double x[] = {0.82,1.1,1.42,1.58,2.0,2.19,2.3,2.5,2.7};
	double y[] = {8.3,13.5,20.0,23.5,35.0,40.0,43.0,46.0,50.0};
	int size = sizeof(thetas)/sizeof(double);
	int sizex = sizeof(x)/sizeof(double);
	int i= 0;
	printf("%f\n",Htheta(thetas,1,size));
	printf("%f\n",toerr(thetas,x,y,size,sizex));
	fitto(thetas,x,y,size,sizex);
	printf("%f\n",toerr(thetas,x,y,size,sizex));
	printf("%f %f %f %f %f \n",thetas[0],thetas[1],thetas[2],thetas[3],thetas[4]);
	for(i=0;i<sizex;i++)
	{
		printf("%f  %f\n",x[i],Htheta(thetas,x[i],size));
	}
}