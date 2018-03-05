classdef warpablepic
    %warpablepic is a non human readable by multiplication warpable pic
    %  data 4XN structure containing [xcoordinate; y coordinate; z
    %  coordinate;pixel value]
    %  lengthx -> arraysize in x of picture
    %  lenghty -> arraysize in y of picture
    
    properties
        data
        picsize
        cameramatrix
    end
    
    methods
        function obj=warpablepic(image)
           obj.picsize=size(image);
           obj.cameramatrix=obj.createcameramatrix(image);
           counter=1;
           obj.data=zeros(4,size(image,1)*size(image,2));
            for y=0.5:1:size(image,1)-0.5
                for x=0.5:1:size(image,2)-0.5
                    obj.data(1,counter)=x;   %x coordinate
                    obj.data(2,counter)=y;   %y coordinate
                    obj.data(3,counter)=1;   %z coordinate
                    obj.data(4,counter)=image(y+0.5,x+0.5); %pixel intensity
                    counter=counter+1;
                end
            end
            obj.data(1:3,:)=obj.cameramatrix*obj.data(1:3,:); %
        end
        
        
        function normalpicture=warpablepic2pic(obj)
            temp_warpablepic=obj.data;
            temp_warpablepic(1:3,:)=obj.cameramatrix\temp_warpablepic(1:3,:);
            
            %get the minimum borders of the picture -> if picture got
            %smaller than -1 padd dark pixels
            minstartwert=(obj.cameramatrix\[-1;-1;1]);%-[min(temp_warpablepic(1:2,:)'),0.5]'+ones(3,1)*0.5;
            minendwert=(obj.cameramatrix\[1;1;1]);    %-[min(temp_warpablepic(1:2,:)'),0.5]'+ones(3,1)*0.5;
            
            %gets the offset out of the picture data. Afterwards the pixels start at
            %0. afterwards 0.5 is added to bring the reference points in the middle of
            %the picture
            temp_warpablepic(1:1,:)=temp_warpablepic(1:1,:);%-min(temp_warpablepic(1:1,:))+0.5;%+paddingx/2*ones(1,length(temp_warpablepic));
            temp_warpablepic(2:2,:)=temp_warpablepic(2:2,:);%-min(temp_warpablepic(2:2,:))+0.5;%+paddingy/2*ones(1,length(temp_warpablepic));
            %startwertx=(temp_warpablepic(1,2)-temp_warpablepic(1,1))/2;
            %startwerty=(temp_warpablepic(2,obj.picsize(2)+1)-temp_warpablepic(2,1))/2;
            %startwertx=min([temp_warpablepic(1:1,:),minstartwert(1)])+mod((max((temp_warpablepic(1:1,:))-min(temp_warpablepic(1:1,:)))/2),1);
            
            x1=mod((max((temp_warpablepic(1:1,:))-min(temp_warpablepic(1:1,:)))/2)+min(temp_warpablepic(1:1,:))+0.5,1);
            x2=mod(min([temp_warpablepic(1:1,:),minstartwert(1)]),1);
            startwertx=floor(min([temp_warpablepic(1:1,:),minstartwert(1)]))+ieround(x2/(x1+x2))+x1;
            
            
            %startwerty=min([temp_warpablepic(2:2,:),minstartwert(2)])+mod((max((temp_warpablepic(2:2,:))-min(temp_warpablepic(2:2,:)))/2),1);
            x1=mod((max((temp_warpablepic(2:2,:))-min(temp_warpablepic(2:2,:)))/2)+min(temp_warpablepic(2:2,:))+0.5,1);
            x2=mod(min([temp_warpablepic(2:2,:),minstartwert(2)]),1);
            startwerty=floor(min([temp_warpablepic(2:2,:),minstartwert(2)]))+ieround(x2/(x1+x2))+x1;
            %go on working here
            
            
            
            endwertx=max([temp_warpablepic(1,:),minendwert(1)]');
            endwerty=max([temp_warpablepic(2,:),minendwert(2)]');
            
            %%next challenge to fix uneven scale shifts
            
            
            %interpolation
            %[ndgridx,ndgridy,ndgridz]=temp_warpablepic2ngrid(temp_warpablepic,cameramatrix);
            %ndgridx=ndgridx+(paddingx/2)*ones(size(ndgridy));
            %ndgridy=ndgridy+(paddingy/2)*ones(size(ndgridy));

            %stuetzpunkte definieren
            F = scatteredInterpolant(temp_warpablepic(2,:).',temp_warpablepic(1,:).',temp_warpablepic(4,:).');
            F.ExtrapolationMethod='none';

            %[xq,yq]=ndgrid(0:1:cameramatrix(1,1)^-1*2+paddingx,0:1:cameramatrix(2,2)^-1*2+paddingy);
            %max(temp_warpablepic,2)(1)
            %cameramatrix(1,1)^-1*2
            %max(temp_warpablepic,2)(2)
            %cameramatrix(2,2)^-1*2
            %[xq,yq]=ndgrid(0:1:cameramatrix(1,1)^(-1)*2+paddingx,0:1:cameramatrix(2,2)^(-1)*2+paddingy);



            %[xq,yq]=ndgrid(0.5:1:ceil(max(temp_warpablepic(2,:)')),0.5:1:ceil(max(temp_warpablepic(1,:)'))); %change applied here
            [xq,yq]=ndgrid(startwerty:1:endwerty,startwertx:1:endwertx); %change applied here
            vq=F(xq,yq);

            %temp_warpablepic(1:2,:)=round(temp_warpablepic(1:2,:)+0.5*ones(2,length(temp_warpablepic)));

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
    
            normalpicture=vq;
            
        end
       
        function cameramatrix=createcameramatrix(obj,Image)
            cameramatrix=eye(3);
            size_image=size(Image);


            cameramatrix(1,3)=-1;
            cameramatrix(2,3)=-1;
            cameramatrix(1,1)=2/size_image(2);
            cameramatrix(2,2)=2/size_image(1);
            
        end
    end
    
end

