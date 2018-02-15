function [ output_Image ] = markpoint(Image,x,y)
%markpoint paints a dot in the picture for debugging purposes
%   Detailed explanation goes here
dotsize=3;
for xx=1:size(Image,2)
   for yy=1:size(Image,1)
       if abs(xx-x)+abs(yy-y)<dotsize
       Image(yy,xx)=1;
       end
   end
end
output_Image=Image;
end

