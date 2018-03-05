function [pic] = warpablepic2pic( warpablepic,cameramatrix)
%warpablepic2pic converts a pic which can be warped by matrix
%multiplication to a human readable picture
%   Detailed explanation goes here

warpablepic(1:3,:)=cameramatrix\warpablepic(1:3,:);
%gets the offset out of the picture data. Afterwards the pixels start at
%0. afterwards 0.5 is added to bring the reference points in the middle of
%the picture
warpablepic(1:1,:)=warpablepic(1:1,:)-min(warpablepic(1:1,:));%+0.5%+paddingx/2*ones(1,length(warpablepic));
warpablepic(2:2,:)=warpablepic(2:2,:)-min(warpablepic(2:2,:));%+0.5%+paddingy/2*ones(1,length(warpablepic));
startwertx=(warpablepic(1,2)-warpablepic(1,1))/2;
startwerty=(warpablepic(2,2)-warpablepic(2,1))/2;
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



%[xq,yq]=ndgrid(0.5:1:ceil(max(warpablepic(2,:)')),0.5:1:ceil(max(warpablepic(1,:)'))); %change applied here
[xq,yq]=ndgrid(startwerty:1:max(warpablepic(2,:)')+startwerty,startwertx:1:max(warpablepic(1,:)')+startwertx); %change applied here
vq=F(xq,yq);

%warpablepic(1:2,:)=round(warpablepic(1:2,:)+0.5*ones(2,length(warpablepic)));

%it is important that the warped image gets backtransformed first
vq(isnan(vq))=0;
%go on working here %postitive scale works
% if mod(size(vq,1),2)==1
%    vq=[vq ; zeros(1,size(vq,2))];
% end
% 
% if mod(size(vq,2),2)==1
%    vq=[ vq zeros(size(vq,1),1)];
% end    
    
pic=vq;

end

