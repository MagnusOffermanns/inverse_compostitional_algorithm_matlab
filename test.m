close all
clear all
x1dg=pi/8
y1dg=pi/4

            x=[1 0 0;
              0 cos(x1dg) -sin(x1dg);
              0 sin(x1dg) cos(x1dg)];
          
          y=[cos(pi/4),0,sin(pi/4);0,1,0;-sin(pi/4),0,cos(pi/4)]
          z=[cos(pi/16),-sin(pi/16),0;sin(pi/16),cos(pi/16),0;0,0,1]
          p=[1;1;1]

p1=x*p;
p2=y*p1;
p3=z*p2;

p3=p3./p3(3);

p3+[2;1;0.1]

p3=p3./p3(3);

%algorithm side
p4=p3-[2;1;0.1]

%p4=p4./p4(3)


%p4=p4./p4(3)


p4=inv(z*y*x)*p3

p4=p4./p4(3)


