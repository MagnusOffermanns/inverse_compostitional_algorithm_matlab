function [ gradient_times_jacobian ] = calcjacobiantimesgradient(Gx,Gy,T)
% calcjacobiantimesgradient mulitplies the gradient times the jacobian for
% later use
%  gradientimage is the x gradient horizontally concatinated with the y
% gradient
%needs finetuning
global jacobianchooser

calculated_jacobian=zeros(2,6);
%jacobian=[1,0,-cos(0)*xx-sin(0)*yy,-sin(0)*xx+cos(0)*yy;
 %           0,1,sin(0)*xx-cos(0)*yy,-cos(0)*xx-sin(0)*yy];

%gradient=[Gx,Gy];
gradient_times_jacobian=zeros(T.reference_object_entire.ImageSize(1)*T.reference_object_entire.ImageSize(2),size(calculated_jacobian,2));
%counter=1;
%important values should not go from 1 to imagesize but from 0.5 till
%imagesize-0.5
for yy=1:T.reference_object_entire.ImageSize(1)
   for xx=1:T.reference_object_entire.ImageSize(2)
%for yy=(0.5*(2/T.reference_object_entire.ImageSize(2)))-1:1:(((T.reference_object_entire.ImageSize(1)-0.5)*(2/T.reference_object_entire.ImageSize(1)))-1)
%    for xx=(0.5*(2/T.reference_object_entire.ImageSize(2)))-1:1:(((T.reference_object_entire.ImageSize(2)-0.5)*(2/T.reference_object_entire.ImageSize(2)))-1)
x_coord=((xx-0.5)*(2/T.reference_object_entire.ImageSize(2)))-1;
y_coord=((yy-0.5)*(2/T.reference_object_entire.ImageSize(1)))-1;
 switch jacobianchooser
     case bi2de([1 1 1 1 1 1])  
        %full jacobian
        calculated_jacobian=[-1,0,x_coord,x_coord*y_coord,-x_coord^2-1,y_coord;
                             0,-1,y_coord,y_coord^2+1,-x_coord*y_coord,-x_coord];
     case bi2de([1 1 1 1 1 0])
        %jacobian x translation y translation x rotation y rotation
        calculated_jacobian=[1,0,-x_coord,x_coord*y_coord,-x_coord^2-1, 0;... %correct
                            0,1,-y_coord,y_coord^2+1,-x_coord*y_coord,0];                    
     case bi2de([1 1 0 1 1 0])
        %jacobian x translation y translation x rotation y rotation
        calculated_jacobian=[1,0,0,x_coord*y_coord,-x_coord^2-1, 0;...
                            0,1,0,y_coord^2+1,-x_coord*y_coord,0];
     case bi2de([0 0 1 1 1 1])
          calculated_jacobian=[0,0,x_coord,x_coord*y_coord,-x_coord^2-1, y_coord;...
                            0,0,y_coord,y_coord^2+1,-x_coord*y_coord,-x_coord];
     
     case bi2de([1 1 1 0 0 1])
        %jacobian x translation y translation z translation z rotation
        calculated_jacobian=[-1,0,x_coord,0,0,y_coord;0,-1,y_coord,0,0,-x_coord]; %correct
     case bi2de([1 1 1 0 0 0])
        %jacobian x,y,z translation
         calculated_jacobian=[-1,0,x_coord,0,0,0;0,-1,y_coord,0,0,0]; %correct 
     case bi2de([1 1 0 0 0 1])
        %rotation z and translation x y jacobian
        calculated_jacobian=[1,0,0,0,0,y_coord;0,1,0,0,0,-x_coord]; % correct
     case bi2de([0 0 0 1 1 0])
          calculated_jacobian=[0,0,0,-x_coord*y_coord,-x_coord^2-1, 0;0,0,0,y_coord^2-1,-x_coord*y_coord,0];
     case bi2de([1 1 0 0 0 0])
        %translation x y jacobian
        calculated_jacobian=[-1,0,0,0,0,0;0,-1,0,0,0,0]; %correct
     case bi2de([1 0 0 0 0 0])
        %translation x jacobian
        calculated_jacobian=[1,0,0,0,0,0;0,0,0,0,0,0];  %correct
     case bi2de([0 1 0 0 0 0])
        %translation y jacobian
        calculated_jacobian=[0,0,0,0,0,0;0,1,0,0,0,0]; %correct
     case bi2de([0 0 0 0 0 1])
         %rotation jacobian
         calculated_jacobian=[0,0,0,0,0,y_coord;0,0,0,0,0,-x_coord];   %correct
     case bi2de([0 0 1 0 0 0])
        %scaling jacobian
        calculated_jacobian=[0,0,-x_coord,0,0,0;0,0,-y_coord,0,0,0]; % correct 
     case bi2de([0 0 0 0 1 0])
        %rotation y jacobian
        calculated_jacobian=[0,0,0,0,-x_coord^2-1, 0;...
                             0,0,0,0,-x_coord*y_coord,0];   
     case  bi2de([0 0 0 1 0 0])
        %rotation x jacobian
        calculated_jacobian=[0,0,0,x_coord*y_coord,0, 0;...
                             0,0,0,y_coord^2+1,0,0];
     otherwise
        error('no valid jacobian choosen')
 end
 
 %gradient_times_jacobian((yy-1)*T.reference_object_snippet.ImageSize(2)+xx,:)=[Gx(yy,xx),Gy(yy,xx)]*calculated_jacobian;
  gradient_times_jacobian((yy-1)*T.reference_object_entire.ImageSize(2)+xx,:)=[Gx(yy,xx),Gy(yy,xx)]*calculated_jacobian;
   
   end
end

 


end

