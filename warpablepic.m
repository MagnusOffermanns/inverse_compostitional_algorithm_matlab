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
        function obj=warpablepic(image,goal_image)
           obj.picsize=size(image);
           obj.cameramatrix=obj.createcameramatrix(goal_image);
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
            shiftvalue=(max(obj.data(1:2,:),[],2)-min(obj.data(1:2,:),[],2))/2+min(obj.data(1:2,:),[],2);
            obj.data(1:2,:)=bsxfun(@minus,obj.data(1:2,:),shiftvalue);
            obj.data(1:3,:)=obj.cameramatrix*obj.data(1:3,:); %
        end
        
        
        function normalpicture=warpablepic2pic(obj)
            temp_warpablepic=obj.data;
            
            minstartvalue=[-1;-1;1];%+0.5; %gets the minimum size of the picture +0.5 to correct sampling point
            minstopvalue=[1;1;1];%-0.5;    
            
            %startvalue=min([temp_warpablepic(1:2,:),minstartvalue(1:2,:)],[],2);
            %stopvalue=max([temp_warpablepic(1:2,:),minendvalue(1:2,:)],[],2);
            startvalue=obj.cameramatrix\minstartvalue;
            stopvalue=obj.cameramatrix\minstopvalue;
            
            
            %middle=obj.cameramatrix\[0;0;1];
%             sidelength=[max([abs(min([temp_warpablepic(1:1,:),minstartwert(1)])),temp_warpablepic(1:1,:),minendwert(1)]);max([abs(min([temp_warpablepic(2:2,:),minstartwert(2)])),temp_warpablepic(2:2,:),minendwert(2)]);1];
%             sidelength_pix=obj.cameramatrix\sidelength;
%             minstartwert=2*middle-sidelength_pix;
%             minendwert=sidelength_pix;
%             
            %converting from generalised coordinates to pixel
            temp_warpablepic(1:3,:)=obj.cameramatrix\temp_warpablepic(1:3,:);
            
            %eliminate all values that are smaller and bigger than start
            %and stop value
            indices=find(abs(temp_warpablepic(1,:))'>=stopvalue(1)+1);
            temp_warpablepic(:,indices)=[];
           
            indices=find(abs(temp_warpablepic(2,:))'>=stopvalue(2)+1);
            temp_warpablepic(:,indices)=[];
            
            %get the minimum borders of the picture -> if picture got
            %smaller than -1 pad dark pixels
            %minstartwert=(obj.cameramatrix\[-1;-1;1]);%+0.5; %gets the minimum size of the picture +0.5 to correct sampling point
            %minendwert=(obj.cameramatrix\[1;1;1]);%-0.5;    
            
            
            
            %gets the offset out of the picture data. Afterwards the pixels start at
            %0. afterwards 0.5 is added to bring the reference points in the middle of
            %the picture
           
            %alte implementierung
            %x1=mod((max((temp_warpablepic(1:1,:))-min(temp_warpablepic(1:1,:)))/2)+min(temp_warpablepic(1:1,:))+0.5,1);
            %x2=mod(min([temp_warpablepic(1:1,:),minstartwert(1)]),1);
            x1=mod((((startvalue(1)-stopvalue(1)))/2)+startvalue(1)+0.5,1);
            x2=mod(startvalue(1),1);
            startwertx=floor(startvalue(1))+ieround(x2/(x1+x2))+x1;
            
            
            
            %x1=mod((max((temp_warpablepic(2:2,:))-min(temp_warpablepic(2:2,:)))/2)+min(temp_warpablepic(2:2,:))+0.5,1);
            %x2=mod(min([temp_warpablepic(2:2,:),minstartwert(2)]),1);
            x1=mod((((startvalue(2)-stopvalue(2)))/2)+startvalue(2)+0.5,1);
            x2=mod(startvalue(2),1);
            startwerty=floor(startvalue(2))+ieround(x2/(x1+x2))+x1;
            
            
            
            
            endwertx=stopvalue(1);
            endwerty=stopvalue(2);
            
           
            
           

            %stuetzpunkte definieren
            F = scatteredInterpolant(temp_warpablepic(2,:).',temp_warpablepic(1,:).',temp_warpablepic(4,:).');
            F.ExtrapolationMethod='none';
            F.Method='natural';


            %define 
            [xq,yq]=ndgrid(startwerty:1:endwerty,startwertx:1:endwertx); %change applied here
            %apply scattered interpolant
            vq=F(xq,yq);

            

            %it is important that the warped image gets backtransformed first
            vq(isnan(vq))=1000;
            
    
            normalpicture=vq;
            
        end
       
        function cameramatrix=createcameramatrix(obj,Image)
            cameramatrix=eye(3);
            size_image=size(Image);
            
            cameramatrix(1,1)=2/size_image(2);
            cameramatrix(2,2)=2/size_image(1);
            
% 
%             cameramatrix(1,3)=-1;
%             cameramatrix(2,3)=-1;
%             cameramatrix(1,1)=2/size_image(2);
%             cameramatrix(2,2)=2/size_image(1);
            
        end
    end
    
end

