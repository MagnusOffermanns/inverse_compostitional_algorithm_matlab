function [ warpablepic ] = pic2warpablepic( I )
%pic2warpablepic converts the picture to a matrix which can be easily
%manipulated by matrix multiplication
% 

warpablepic=zeros(4,size(I,1)*size(I,2));
counter=1
for y=1:size(I,1)
   for x=1:size(I,2)
    warpablepic(1,counter)=x;
    warpablepic(2,counter)=y;
    warpablepic(3,counter)=1;
    warpablepic(4,counter)=I(y,x);
    counter=counter+1;
   end
end

%cameramatrix setting the middle of the picture to zero
mean_x=(min(warpablepic(1,:))+max(warpablepic(1,:)))/2;
mean_y=(min(warpablepic(2,:))+max(warpablepic(2,:)))/2;
warpablepic(1,:)=warpablepic(1,:)-mean_x;
warpablepic(2,:)=warpablepic(2,:)-mean_y;
end

