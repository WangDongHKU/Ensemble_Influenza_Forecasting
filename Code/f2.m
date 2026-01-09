function ss = f2(theta,data)

%sum-of-squares function
COUNTRY=1;
time   = data.xdata;%modeling time period
ydata  = data.ydata;%observed data
xdata  = data.xdata;
ymodel = f3(time,theta,ydata);%model results
ymodel(1,:)=ydata(1);
ss =sum((sqrt(ymodel) - sqrt(ydata(1:length(xdata),1:COUNTRY))).^2);%sum-of-squares function
%ss =sum((log(ymodel+1) - log(ydata(1:length(xdata),1:COUNTRY)+1)).^2);%sum-of-squares function