A = importdata('output_01_03_2022_14_35_09.txt');
X = A.data(:,1);
Y = A.data(:,2);
Z = A.data(:,3);

time = linspace(0,length(X)*0.1,length(X));

figure
plot(time,X,time,Y,time,Z)

sum = sqrt(X.^2+Y.^2+Z.^2);

figure
plot(time,sum)