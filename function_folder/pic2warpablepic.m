function [ warpablepic ] = pic2warpablepic( I, kameramatrix )
%pic2warpablepic converts the picture to a matrix which can be easily
%manipulated by matrix multiplication
% 
counter=1;
warpablepic=zeros(4,size(I,1)*size(I,2));
for y=0.5:1:size(I,1)-0.5
   for x=0.5:1:size(I,2)-0.5
    warpablepic(1,counter)=x;
    warpablepic(2,counter)=y;
    warpablepic(3,counter)=1;
    warpablepic(4,counter)=I(y+0.5,x+0.5);
    counter=counter+1;
   end
end
warpablepic(1:3,:)=kameramatrix*warpablepic(1:3,:);
 
end

