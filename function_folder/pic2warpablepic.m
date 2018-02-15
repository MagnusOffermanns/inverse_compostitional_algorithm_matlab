function [ warpablepic ] = pic2warpablepic( I, cameramatrix )
%pic2warpablepic converts the picture to a 4X1 matrix which can be easily
%manipulated by matrix multiplication
 
counter=1; %necessary to 
warpablepic=zeros(4,size(I,1)*size(I,2)); %reserve memory for the array

%save the information from the picture
for y=0.5:1:size(I,1)-0.5
   for x=0.5:1:size(I,2)-0.5
    warpablepic(1,counter)=x;   %x coordinate
    warpablepic(2,counter)=y;   %y coordinate
    warpablepic(3,counter)=1;   %z coordinate
    warpablepic(4,counter)=I(y+0.5,x+0.5); %pixel intensity
    counter=counter+1;
   end
end


warpablepic(1:3,:)=cameramatrix*warpablepic(1:3,:); %transform the coordinates from [-1 1]
 
end

