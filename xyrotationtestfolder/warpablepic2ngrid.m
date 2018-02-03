function [ ngridx,ngridy,ngridz ] = warpablepic2ngrid( warpablepic,cameramatrix )
width=cameramatrix(1,1)^-1*2;
heigth=cameramatrix(2,2)^-1*2;
ngridx= zeros(heigth,width);
ngridy= zeros(heigth,width);
ngridz= zeros(heigth,width);
for yy=1:heigth
    
   for xx=1:width
       ngridx(yy,xx)=warpablepic(1,(yy-1)*width+xx);
       ngridy(yy,xx)=warpablepic(2,(yy-1)*width+xx);
       ngridz(yy,xx)=warpablepic(4,(yy-1)*width+xx);
   end
end

end