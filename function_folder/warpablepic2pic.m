function [pic] = warpablepic2pic( warpablepic,cameramatrix)
%warpablepic2pic converts a pic which can be warped by matrix
%multiplication to a human readable picture
%   Detailed explanation goes here

warpablepic(1:3,:)=cameramatrix\warpablepic(1:3,:);
warpablepic(1:1,:)=warpablepic(1:1,:)-min(warpablepic(1:1,:))+0.5;%+paddingx/2*ones(1,length(warpablepic));
warpablepic(2:2,:)=warpablepic(2:2,:)-min(warpablepic(2:2,:))+0.5;%+paddingy/2*ones(1,length(warpablepic));


%interpolation
%[ndgridx,ndgridy,ndgridz]=warpablepic2ngrid(warpablepic,cameramatrix);
%ndgridx=ndgridx+(paddingx/2)*ones(size(ndgridy));
%ndgridy=ndgridy+(paddingy/2)*ones(size(ndgridy));

%stuetzpunkte definieren
F = scatteredInterpolant(warpablepic(2,:).',warpablepic(1,:).',warpablepic(4,:).');
F.ExtrapolationMethod='none';

%[xq,yq]=ndgrid(0:1:cameramatrix(1,1)^-1*2+paddingx,0:1:cameramatrix(2,2)^-1*2+paddingy);
%max(warpablepic,2)(1)
%cameramatrix(1,1)^-1*2
%max(warpablepic,2)(2)
%cameramatrix(2,2)^-1*2
%[xq,yq]=ndgrid(0:1:cameramatrix(1,1)^(-1)*2+paddingx,0:1:cameramatrix(2,2)^(-1)*2+paddingy);

[xq,yq]=ndgrid(0.5:1:ceil(max(warpablepic(2,:)')),0.5:1:ceil(max(warpablepic(1,:)')));
vq=F(xq,yq);

%warpablepic(1:2,:)=round(warpablepic(1:2,:)+0.5*ones(2,length(warpablepic)));

%it is important that the warped image gets backtransformed first
vq(isnan(vq))=0;
pic=vq;

end

