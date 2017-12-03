function [ gradient_times_jacobian ] = calcjacobiantimesgradient(Gx,Gy,T)
% calcjacobiantimesgradient mulitplies the gradient times the jacobian for
% later use
%  gradientimage is the x gradient horizontally concatinated with the y
% gradient
%needs finetuning

calculated_jacobian=zeros(2,4);
%jacobian=[1,0,-cos(0)*xx-sin(0)*yy,-sin(0)*xx+cos(0)*yy;
 %           0,1,sin(0)*xx-cos(0)*yy,-cos(0)*xx-sin(0)*yy];

%gradient=[Gx,Gy];
gradient_times_jacobian=zeros(T.reference_object_snippet.ImageSize(1)*T.reference_object_snippet.ImageSize(2),size(calculated_jacobian,2));
%counter=1;

for yy=1:T.reference_object_snippet.ImageSize(1)
   for xx=1:T.reference_object_snippet.ImageSize(2)
 %full jacobian
       %    calculated_jacobian=[1,0,-(xx/(1+0)^2)*cos(0)+(yy/(1+0)^2)*sin(0),-sin(0)*(xx/(1+0))-cos(0)*(yy/(1+0));...
       %                  0,1,-(xx/(1+0))*sin(0)-(yy/(1+0))*cos(0),cos(0)*(xx/(1+0))-sin(0)*(yy/1+0)];
  %translation jacobian
 % calculated_jacobian=[1,0,0,0;0,1,0,0];
 %scaling jacobian
%calculated_jacobian=[0,0,-xx/(1+0)^2,0;0,1,-yy/(1+0)^2,0];
 calculated_jacobian=[0,0,xx,0;0,0,yy,0];
%rotation jacobian and translation jacobian
 %calculated_jacobian=[1,0,0,1*(-sin(0)*xx-cos(0)*yy);0,1,0,1*(cos(0)*xx-sin(0)*yy)];
 
 
 gradient_times_jacobian((yy-1)*T.reference_object_snippet.ImageSize(2)+xx,:)=[Gx(yy,xx),Gy(yy,xx)]*calculated_jacobian;
   end
end






end

