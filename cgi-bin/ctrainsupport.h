int collectdata(double *x,double *y,double *rate);
double Htheta(double *thetas, double x,int size);
double toerr(double *thetas,double *x, double *y,int sizeth,int sizex);
double fitto(double *thetas,double *x, double *y,int sizeth,int sizex,double lrate);