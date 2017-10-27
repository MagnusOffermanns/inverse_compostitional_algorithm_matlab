function [pic] = warpablepic2pic( warpablepic,xmax,ymax )
%warpablepic2pic converts a pic which can be warped by matrix
%multiplication to a human readable picture
%   Detailed explanation goes here

%it is important that the warped image gets backtransformed first
xmax=max([warpablepic(1,1:end),xmax]); %gets the size of the new image
ymax=max([warpablepic(2,1:end),ymax]);

pic=zeros(ymax,xmax);
%prealocates the necessary picture

for i=1:length(warpablepic)
   pic(warpablepic(2,i),warpablepic(1,i))=warpablepic(4,i);
end



end

