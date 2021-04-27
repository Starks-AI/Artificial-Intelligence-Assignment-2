clc;
close all;
clear all;
a=csvread("2020_ten_bent_coins");
% initial theta
theta=rand(1,10);
b = sum(a,2); t = 100-b;
th(1,:) = theta;
for n=2:500
LH=zeros(size(b));
for m=1:10
  lh(:,m) = (th(n-1,m).^b).*((1-th(n-1,m)).^t);
  LH=LH+lh(:,m);
 end
for m=1:10
  th(n,m)=sum(b.*lh(:,m)./LH)/sum((b+t).*lh(:,m)./LH);
 end
end
disp("Initial Theta");
disp(theta);
disp("New Theta");
final=th(500,:)
disp(final);