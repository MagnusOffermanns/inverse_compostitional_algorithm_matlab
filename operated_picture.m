classdef operated_picture
    %Border is a class defining the border between the whole picture and
    %the picture which is processed
    %   Detailed explanation goes here
    
    properties
        Data
        reference_object_entire
        Data_snippet
        reference_object_snippet
        
    end
    
    methods
        function obj=operated_picture(Image,height_snippet,width_snippet)
        
        obj.Data=Image;
        obj.reference_object_entire=imref2d(size(obj.Data),[-1 1],[-1 1]);
        
        [D_X,D_Y]=obj.reference_object_entire.worldToSubscript(-height_snippet/2,-width_snippet/2);  %x,y
        [C_X,C_Y]=obj.reference_object_entire.worldToSubscript(height_snippet/2,-width_snippet/2);
        [A_X,A_Y]=obj.reference_object_entire.worldToSubscript(-height_snippet/2,width_snippet/2);
        
        obj.Data_snippet=obj.Data(D_X:A_X-1,D_Y:C_Y-1);
        obj.reference_object_snippet=imref2d(size(obj.Data_snippet),[-width_snippet/2 width_snippet/2],[-height_snippet/2 height_snippet/2]);
        
        
        
%          to_origin_transform=[1 0 0;...
%                               0 1 0;...
%                               -displacement(2)-size_picx/2 -displacement(1)-size_picy/2 1];
%                           
%          to_origin_transform=affine2d(to_origin_transform);
%          reference_object=imref2d([size_picy size_picx]);
%          reference_object.XWorldLimits=reference_object.XWorldLimits-(size_picx/2);
%          reference_object.YWorldLimits=reference_object.YWorldLimits-(size_picy/2);
%         
%          [obj.Data,obj.reference_object]=imwarp(Image,to_origin_transform,'cubic','OutputView',reference_object)
%             
%         
        
        
        
        end
        
%         function obj=fill_data_rect(obj,Image,displacement)
%            to_origin_transform=[1 0 0;...
%                                  0 1 0;...
%                                  -displacement(2) -displacement(1) 1];
%             to_origin_transform=affine2d(to_origin_transform);
%             [obj.Data,obj.reference_object]=imwarp(obj.Data,to_origin_transform,'cubic','OutputView',imref2d([obj.size_picy obj.size_picx]))
%             
%             %obj.Data=Image(displacement(1):displacement(1)+obj.size_picy-1,displacement(2):displacement(2)+obj.size_picx-1);
%            %obj.reference_object=imref2d(size(obj.Data));
%         end
        
        function obj=rotate_op(obj,warp_param)
            
        
            %temp_size=size(obj.Data); %saving of the size of the picture before warp
            
             to_origin_transform=[1 0 0;...
                                 0 1 0;...
                                 -mean(obj.reference_object_entire.XWorldLimits) -mean(obj.reference_object_entire.YWorldLimits) 1];
            r_transform =[cos(warp_param(4)) -sin(warp_param(4)) 0; sin(warp_param(4)) cos(warp_param(4)) 0; 0 0 1]; %rotation around the center
             from_origin_transform=[1 0 0; ...
                                    0 1 0;...
                                   mean(obj.reference_object_entire.XWorldLimits) mean(obj.reference_object_entire.YWorldLimits) 1];
             
                             transform=affine2d(to_origin_transform*r_transform*from_origin_transform);
            
                             [obj.Data]=imwarp(obj.Data,transform,'cubic');
                             obj=obj.update_reference_object_rot;
                             
                             
        end
        
        function obj=translate_op(obj,translation_vector) %translationvector ist [x,y,z]
            translation_vector(1)=translation_vector(1)*obj.reference_object_snippet.PixelExtentInWorldX; %steps to small without the multiplication to find a steady minimum  
            translation_vector(2)=translation_vector(2)*obj.reference_object_snippet.PixelExtentInWorldY;
            transform_t=[1 0 0;...
                         0 1 0;...
                         -translation_vector(1) -translation_vector(2) 1];
        
            transform=affine2d(transform_t);
            [obj.Data,obj.reference_object_entire]=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic');
        end
        
        function obj=scale_op(obj,warp_param)
            
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
                             [obj.Data]=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic');
                            obj.reference_object_entire=imref2d(size(obj.Data),[-1 1],[-1 1]);
                             
                          
                             
                             
        end
        
        
        function obj=get_Data_snippet(obj,warp_param) %save
           to_origin_transform=[1 0 0;...
                                 0 1 0;...
                                 -mean(obj.reference_object_entire.XWorldLimits) -mean(obj.reference_object_entire.YWorldLimits) 1];
            
            transform=[1/(1+warp_param(3)) 0 0;...
            0 1/(1+warp_param(3)) 0 ;...
            0 0 1];
        
            from_origin_transform=[1 0 0; ...
                                0 1 0;...
                                mean(obj.reference_object_entire.XWorldLimits) mean(obj.reference_object_entire.YWorldLimits) 1];
                            transform=affine2d(to_origin_transform*transform*from_origin_transform);
           obj.Data_snippet=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic','OutputView',obj.reference_object_snippet);
        end
        
        
        function obj=update_reference_object_rot(obj)
          XWorldLimits_help=[-obj.reference_object_entire.PixelExtentInWorldX*size(obj.Data,2)/2 obj.reference_object_entire.PixelExtentInWorldX*size(obj.Data,2)/2];
          YWorldLimits_help=[-obj.reference_object_entire.PixelExtentInWorldY*size(obj.Data,1)/2 obj.reference_object_entire.PixelExtentInWorldY*size(obj.Data,1)/2];
          obj.reference_object_entire=imref2d(size(obj.Data),XWorldLimits_help,YWorldLimits_help);
        end
        
    end
    
end

