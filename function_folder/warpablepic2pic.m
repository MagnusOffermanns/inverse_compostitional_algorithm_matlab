function [pic] = warpablepic2pic( warpablepic,cameramatrix,paddingy,paddingx)
%warpablepic2pic converts a pic which can be warped by matrix
%multiplication to a human readable picture
%   Detailed explanation goes here

warpablepic(1:3,:)=inv(cameramatrix)*warpablepic(1:3,:);
warpablepic(1:1,:)=warpablepic(1:1,:)+paddingx/2*ones(1,length(warpablepic));
warpablepic(2:2,:)=warpablepic(2:2,:)+paddingy/2*ones(1,length(warpablepic));
%interpolation
%[ndgridx,ndgridy,ndgridz]=warpablepic2ngrid(warpablepic,cameramatrix);
%ndgridx=ndgridx+(paddingx/2)*ones(size(ndgridy));
%ndgridy=ndgridy+(paddingy/2)*ones(size(ndgridy));
F = scatteredInterpolant(warpablepic(2,:).',warpablepic(1,:).',warpablepic(4,:).');
F.ExtrapolationMethod='none';
[xq,yq]=ndgrid(0:1:cameramatrix(1,1)^-1*2+paddingx,0:1:cameramatrix(2,2)^-1*2+paddingy);
vq=F(xq,yq);

%warpablepic(1:2,:)=round(warpablepic(1:2,:)+0.5*ones(2,length(warpablepic)));

%it is important that the warped image gets backtransformed first
pic=vq;


end

