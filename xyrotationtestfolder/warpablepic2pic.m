function [pic] = warpablepic2pic( warpablepic,cameramatrix,xmax,ymax )
%warpablepic2pic converts a pic which can be warped by matrix
%multiplication to a human readable picture
%   Detailed explanation goes here

warpablepic(1:3,:)=cameramatrix\warpablepic(1:3,:);

%it is important that the warped image gets backtransformed first
xmax=max([warpablepic(1,1:end),xmax]); %gets the size of the new image
ymax=max([warpablepic(2,1:end),ymax]);

pic=zeros(int64(ymax),int64(xmax),2);
%prealocates the necessary picture

for i=1:length(warpablepic)
   pic(warpablepic(2,i),warpablepic(1,i),1)=pic(warpablepic(2,i),warpablepic(1,i),1)+warpablepic(4,i);
   pic(warpablepic(2,i),warpablepic(1,i),2)=pic(warpablepic(2,i),warpablepic(1,i),2)+1;
end



end

