close all
clear all
% x1dg=pi/8
% y1dg=pi/4
% 
%             x=[1 0 0;
%               0 cos(x1dg) -sin(x1dg);
%               0 sin(x1dg) cos(x1dg)];
%           
%           y=[cos(pi/4),0,sin(pi/4);0,1,0;-sin(pi/4),0,cos(pi/4)]
%           z=[cos(pi/16),-sin(pi/16),0;sin(pi/16),cos(pi/16),0;0,0,1]
%           p=[1;1;1]
% 
% p1=x*p;
% p2=y*p1;
% p3=z*p2;
% 
% p3=p3./p3(3);
% 
% p3+[2;1;0.1]
% 
% p3=p3./p3(3);
% 
% algorithm side
% p4=p3-[2;1;0.1]
% 
% p4=p4./p4(3)
% 
% 
% p4=p4./p4(3)
% 
% 
% p4=inv(z*y*x)*p3
% 
% p4=p4./p4(3)
%p4=(2*pi/360)*5;
%p5=(2*pi/360)*5;
%p6=0;

%rotationmatrix=[1,0,-4608/2;0,1,-3456/2;0,0,1];
%rotationmatrix=[1,0,0;0,cos(p4),-sin(p4);0,sin(p4),cos(p4)]*rotationmatrix; %rotationmatrix x
%rotationmatrix=[cos(p5),0,sin(p5);0,1,0;-sin(p5),0,cos(p5)]*rotationmatrix; %rotationmatrix y
%rotationmatrix=[cos(p6),-sin(p6),0;sin(p6),cos(p6),0;0,0,1]*rotationmatrix %rotation z
%rotationmatrix=[1,0,4608/2;0,1,3456/2;0,0,1]*rotationmatrix;
 global jacobianchooser
 jacobianchooser=bi2de([1 1 1 1 1 1]);
 test_Image=rgb2gray(imread('/home/magnus_offermanns/Desktop/test_pic.JPG'));
 T=operated_picture(test_Image,1,1,'linear');
 T.Data=double(T.Data)/255.0;
 I=T;
 I.Data(1,1)=100.0/255.0;
 [Gx,Gy]=gradientcalc(T.Data);
 jacobian_times_gradient=calcjacobiantimesgradient(Gx,Gy,T);
 hessian=calc_hessian(jacobian_times_gradient);
 [ delta_p_value,~ ] = calc_delta_p(T,I,hessian,jacobian_times_gradient,0);
 
 
 
 
   