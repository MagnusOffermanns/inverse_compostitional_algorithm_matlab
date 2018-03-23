classdef operated_picture
    %Border is a class defining the border between the whole picture and
    %the picture which is processed
    %   Detailed explanation goes here
    
    properties
        Data
        reference_object_entire
        Data_snippet
        reference_object_snippet
        stepsize_multiplier
        interpolation_degree
        
    end
    
    methods
        function obj=operated_picture(Image,height_snippet,width_snippet,interpolation_degree)
          
        obj.Data=Image;
        obj.interpolation_degree=interpolation_degree;
        obj.reference_object_entire=imref2d(size(obj.Data),[-1 1],[-1 1]);
        
        [D_X,D_Y]=obj.reference_object_entire.worldToSubscript(-height_snippet/2,-width_snippet/2);  %x,y
        [C_X,C_Y]=obj.reference_object_entire.worldToSubscript(height_snippet/2,-width_snippet/2);
        [A_X,A_Y]=obj.reference_object_entire.worldToSubscript(-height_snippet/2,width_snippet/2);
        
        obj.Data_snippet=obj.Data(D_X:A_X-1,D_Y:C_Y-1);
        obj.reference_object_snippet=imref2d(size(obj.Data_snippet),[-width_snippet/2 width_snippet/2],[-height_snippet/2 height_snippet/2]);
        obj.stepsize_multiplier=[1,1,1,1,1,1]; %step multiplier to alter stepsize and to get more accurate to the minimum
        %im final build eliminieren
        global stepsize_multiplier
        stepsize_multiplier=obj.stepsize_multiplier;        
        
        
        end
        
        function obj=warptzrotxyz(obj,warp_param)
           %[xtrans,ytrans,scale,rotx,roty,rotz]
           warp_param=warp_param.*obj.stepsize_multiplier;
           
           %generate matrixes to later transform
            %roation matrix z
             rz_transform =[cos(warp_param(6)) -sin(warp_param(6)) 0;...
                            sin(warp_param(6)) cos(warp_param(6)) 0;...
                            0 0 1]; %rotation around the center
            %roation x
            rx_transform=[1 0 0;
                          0 cos(warp_param(4)) -sin(warp_param(4));
                          0 sin(warp_param(4)) cos(warp_param(4))];
            %rotation y         
            ry_transform=[cos(warp_param(5)) 0 sin(warp_param(5));
                          0 1 0;
                          -sin(warp_param(5)) 0 cos(warp_param(5))];
            %scale matrix
            s_transform=[(1+warp_param(3)) 0 0;...
                            0 (1+warp_param(3)) 0 ;...
                            0 0 1];

            
            %convert the 2x2 picture into a 4xnumber of pixels vector (x coord,y coord,z coord,pixel intensity)
            warpablepicobj=warpablepic(obj.Data,obj.Data);
            
            %correction of the translation inflicted by the rotation by x
            %and y rot
            %xyrot_translationvector=rx_transform*ry_transform*[0;0;1];
            %xyrot_translationvector=xyrot_translationvector./xyrot_translationvector(3)
            %warpablepicobj.data=frame_creator(warpablepicobj.data,xyrot_translationvector)
            
            

            
        
            %apply the four transforms first rotation (r_transform) then scale (s_transform) then rotation in x (rotx) and
            %then rotation in y roty
            warpablepicobj.data(1:3,:)=rz_transform*ry_transform*rx_transform*warpablepicobj.data(1:3,:);
            
            %translation
            translationvector=warpablepicobj.cameramatrix*[warp_param(1);warp_param(2);0];
            translationvector(3)=warp_param(3);
            warpablepicobj.data(1:3,:)=bsxfun(@minus,warpablepicobj.data(1:3,:),translationvector);
            
            % scatter(warpablepicobj.data(2,:),warpablepicobj.data(1,:))
           % axis ij
           
            
            
            warpablepicobj.data(1,:)=warpablepicobj.data(1,:)./warpablepicobj.data(3,:);
            warpablepicobj.data(2,:)=warpablepicobj.data(2,:)./warpablepicobj.data(3,:);
            warpablepicobj.data(3,:)=1;
            
            
            
            
            
            %xyrot_translationvector=xyrot_translationvector./xyrot_translationvector(3)
            
            %warpablepicobj.data=frame_creator(warpablepicobj.data,[0;0;0])
            
            
            
           
            %plots the points created by the warp and altered by the frame
            %creator
            %scatter(warpablepicobj.data(1,:),warpablepicobj.data(2,:))
            %axis ij
            
            
            
            obj.Data=warpablepicobj.warpablepic2pic(); %man koennte interpolation points so aendern sodass sie immer von -1 bis 1 interpolieren
            obj=obj.update_reference_object_rot;
            
            %translation from the xrot and y rot
%             xyrot_translationvector=rx_transform*ry_transform*[0;0;1];
%             xyrot_translationvector=xyrot_translationvector/xyrot_translationvector(3);
%             xyrot_translationvector=warpablepicobj.cameramatrix*[xyrot_translationvector(1);xyrot_translationvector(2);0];
%             obj.reference_object_entire.XWorldLimits=obj.reference_object_entire.XWorldLimits-[xyrot_translationvector(1),xyrot_translationvector(1)];
%             obj.reference_object_entire.YWorldLimits=obj.reference_object_entire.YWorldLimits-[xyrot_translationvector(2),xyrot_translationvector(2)];
%             
%             obj.reference_object_snippet.XWorldLimits=obj.reference_object_snippet.XWorldLimits-[xyrot_translationvector(1),xyrot_translationvector(1)];
%             obj.reference_object_snippet.YWorldLimits=obj.reference_object_snippet.YWorldLimits-[xyrot_translationvector(2),xyrot_translationvector(2)];
             
            %translation
%             translationvector=warpablepicobj.cameramatrix*[warp_param(1);warp_param(2);0];
%             obj.reference_object_entire.XWorldLimits=obj.reference_object_entire.XWorldLimits-[translationvector(1),translationvector(1)];
%             obj.reference_object_entire.YWorldLimits=obj.reference_object_entire.YWorldLimits-[translationvector(2),translationvector(2)];
%             
            %[obj.Data]=imwarp(obj.Data,obj.reference_object_entire,affine2d(eye(3)),'cubic','OutputView',imref2d([1,2],[-1 1],[-1 1]));
            %obj.reference_object_entire=imref2d(size(obj.Data),[-1 1],[-1 1]);

            
            
        end
        
        
        function obj=rotate_op(obj,warp_param)
        
            %warp_param=warp_param.*obj.stepsize_multiplier;
        
            %temp_size=size(obj.Data); %saving of the size of the picture before warp
            
             to_origin_transform=[1 0 0;...
                                 0 1 0;...
                                 -mean(obj.reference_object_entire.XWorldLimits) -mean(obj.reference_object_entire.YWorldLimits) 1];
            r_transform =[cos(warp_param(4)) -sin(warp_param(4)) 0; sin(warp_param(4)) cos(warp_param(4)) 0; 0 0 1]; %rotation around the center
             from_origin_transform=[1 0 0; ...
                                    0 1 0;...
                                   mean(obj.reference_object_entire.XWorldLimits) mean(obj.reference_object_entire.YWorldLimits) 1];
             
                             transform=affine2d(to_origin_transform*r_transform*from_origin_transform);
            
                             [obj.Data]=imwarp(obj.Data,transform,obj.interpolation_degree);
                             obj=obj.update_reference_object_rot;
                             
                             
        end
        
        function obj=translate_op(obj,warp_param)
            %warp_param=warp_param.*obj.stepsize_multiplier;
            %warp_param=warp_param.*obj.stepsize_multiplier;
            warp_param(1)=warp_param(1)*obj.reference_object_snippet.PixelExtentInWorldX; %steps to small without the multiplication to find a steady minimum  
            warp_param(2)=warp_param(2)*obj.reference_object_snippet.PixelExtentInWorldY;
            
            transform_t=[1 0 0;...
                         0 1 0;...
                         -warp_param(1) -warp_param(2) 1];
        
            transform=affine2d(transform_t);
            [obj.Data,obj.reference_object_entire]=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic');
        end
        
        function obj=scale_op(obj,warp_param)
             warp_param=warp_param.*obj.stepsize_multiplier;
             
            to_origin_transform=[1 0 0;...
                                 0 1 0;...
                                 -mean(obj.reference_object_entire.XWorldLimits) -mean(obj.reference_object_entire.YWorldLimits) 1];
            
            s_transform=[(1+warp_param(3)) 0 0;...
            0 (1+warp_param(3)) 0 ;...
            0 0 1];
            
         from_origin_transform=[1 0 0; ...
                                0 1 0;...
                                mean(obj.reference_object_entire.XWorldLimits) mean(obj.reference_object_entire.YWorldLimits) 1];
                            
          transform=affine2d(to_origin_transform*s_transform*from_origin_transform);
                             [obj.Data]=imwarp(obj.Data,obj.reference_object_entire,transform,obj.interpolation_degree);
                            obj.reference_object_entire=imref2d(size(obj.Data),[-1 1],[-1 1]);
                             
                          
                             
                             
        end
        
        
        function obj=get_Data_snippet(obj,warp_param)
            warp_param=warp_param.*obj.stepsize_multiplier;
            to_origin_transform=[1 0 0;...
                                 0 1 0;...
                                 -mean(obj.reference_object_entire.XWorldLimits) -mean(obj.reference_object_entire.YWorldLimits) 1];
%             
%              transform=[1/(1+warp_param(3)) 0 0;...
%              0 1/(1+warp_param(3)) 0 ;...
%              0 0 1];
         
         transform=eye(3);
         from_origin_transform=[1 0 0; ...
                                0 1 0;...
                                mean(obj.reference_object_entire.XWorldLimits) mean(obj.reference_object_entire.YWorldLimits) 1];
                            transform=affine2d(to_origin_transform*transform*from_origin_transform);
           obj.Data_snippet=imwarp(obj.Data,obj.reference_object_entire,transform,obj.interpolation_degree,'OutputView',obj.reference_object_snippet);
        end
        
        
        function obj=update_reference_object_rot(obj)
          XWorldLimits_help=[-obj.reference_object_entire.PixelExtentInWorldX*size(obj.Data,2)/2 obj.reference_object_entire.PixelExtentInWorldX*size(obj.Data,2)/2];
          YWorldLimits_help=[-obj.reference_object_entire.PixelExtentInWorldY*size(obj.Data,1)/2 obj.reference_object_entire.PixelExtentInWorldY*size(obj.Data,1)/2];
          obj.reference_object_entire=imref2d(size(obj.Data),XWorldLimits_help,YWorldLimits_help);
        end
        
    end
    
end

