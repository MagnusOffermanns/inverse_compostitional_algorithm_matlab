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
        
        obj.Data=Image
        obj.reference_object_entire=imref2d(size(obj.Data),[-1 1],[-1 1]);
        
        [D_X,D_Y]=obj.reference_object_entire.worldToSubscript(-height_snippet/2,-width_snippet/2)  %x,y
        [C_X,C_Y]=obj.reference_object_entire.worldToSubscript(height_snippet/2,-width_snippet/2)
        [A_X,A_Y]=obj.reference_object_entire.worldToSubscript(-height_snippet/2,width_snippet/2)
        
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
        
        function obj=rotate_op(obj,alpha)
            
        
            %temp_size=size(obj.Data); %saving of the size of the picture before warp
            to_origin_transform=[1 0 0;...
                                 0 1 0;...
                                 mean(obj.reference_object.XWorldLimits) mean(obj.reference_object.YWorldLimits) 1];
            r_transform =[cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1]; %rotation around the center
            from_origin_transform=[1 0 0; ...
                                 0 1 0;...
                                 -mean(obj.reference_object.XWorldLimits) -mean(obj.reference_object.YWorldLimits) 1];
            
                             transform=affine2d(to_origin_transform*r_transform*from_origin_transform);
            
                             [obj.Data,obj.reference_data_entire]=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic');
                
        end
        
        function obj=translate_op(obj,translation_vector) %translationvector ist [x,y,z]
            translation_vector(1)=translation_vector(1)*obj.reference_object_snippet.PixelExtentInWorldX;
            translation_vector(2)=translation_vector(2)*obj.reference_object_snippet.PixelExtentInWorldY;
            transform_t=[1 0 0;...
                         0 1 0;...
                         -translation_vector(1) -translation_vector(2) 1];
        
            transform=affine2d(transform_t);
            [obj.Data,obj.reference_object_entire]=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic');
        end
        
        
        function obj=get_Data_snippet(obj) %save
           transform=affine2d(eye(3));
           obj.Data_snippet=imwarp(obj.Data,obj.reference_object_entire,transform,'cubic','OutputView',obj.reference_object_snippet);
        end
%             % temp_size=ceil((size(obj.Data)-temp_size)/2); %coordinate difference between old and new picture
%             %obj=obj.translate_camera([-temp_size.';0]); %
%            % obj.plot_camera_pos();
%             
%         
%         function obj=rotate_camera(obj,alpha)
%             
%         rotation_matrix=[cos(alpha) -sin(alpha);...
%             sin(alpha) cos(alpha)];
%         
%         temp_D=obj.D_W-obj.center_W;
%         temp_C=obj.C_W-obj.center_W;
%         temp_B=obj.B_W-obj.center_W;
%         temp_A=obj.A_W-obj.center_W;
%         
%         temp_D=rotation_matrix*temp_D;
%         temp_C=rotation_matrix*temp_C;
%         temp_B=rotation_matrix*temp_B;
%         temp_A=rotation_matrix*temp_A;
%         
%         obj.D_W=temp_D+obj.center_W;
%         obj.C_W=temp_C+obj.center_W;
%         obj.B_W=temp_B+obj.center_W;
%         obj.A_W=temp_A+obj.center_W;
%         
%         %
%         
%         end
%         
%         
%         function obj=translate_camera(obj,translation_vector)
%             %also fit for scaling
%             
% % 
% %             obj.D_C=floor(obj.D_C/(1+translation_vector(3))); %postive zahl -> kleinere werte -> rein zoomen
% %             obj.C_C=floor(obj.C_C/(1+translation_vector(3)));
% %             obj.B_C=floor(obj.B_C/(1+translation_vector(3)));
% %             obj.A_C=floor(obj.A_C/(1+translation_vector(3)));
% %             obj.size_camera=[abs(obj.D_C(1))+abs(obj.A_C(1));abs(obj.D_C(2))+abs(obj.C_C(2))];
% %             
% %             obj.D_W=obj.center_W+[-obj.D_C(1);obj.D_C(2)];
% %             obj.C_W=obj.center_W+[-obj.C_C(1);obj.C_C(2)];
% %             obj.B_W=obj.center_W+[-obj.B_C(1);obj.B_C(2)];
% %             obj.A_W=obj.center_W+[-obj.A_C(1);obj.A_C(2)];
% %             
%             
%             
%             obj.center_W=obj.center_W+translation_vector(1:2);
%             obj.D_W=obj.D_W+translation_vector(1:2);
%             obj.C_W=obj.C_W+translation_vector(1:2);
%             obj.B_W=obj.B_W+translation_vector(1:2);
%             obj.A_W=obj.A_W+translation_vector(1:2);
%             %code for upscaling to come
%             %=imwarp(warped_image,transform,'OutputView', imref2d( size(T.Data) ));
%             
%             
%         end
%         
%         function obj=set_camera(obj,coordinates)
%            obj.center_W=coordinates;
%            obj.D_W=obj.center_W+[-obj.D_C(1);obj.D_C(2)];
%            obj.C_W=obj.center_W+[-obj.C_C(1);obj.C_C(2)];
%            obj.B_W=obj.center_W+[-obj.B_C(1);obj.B_C(2)];
%            obj.A_W=obj.center_W+[-obj.A_C(1);obj.A_C(2)];
%             
%         end
%         
%         function plot_camera_pos(obj)
%         X_corners=[obj.D_W(2),obj.C_W(2),obj.B_W(2),obj.A_W(2)];
%         Y_corners=[obj.D_W(1),obj.C_W(1),obj.B_W(1),obj.A_W(1)];
%         if(isempty(findall(0,'Type','Figure')))
%            figure
%         end
%         hold on
%         plot(obj.center_W(2),obj.center_W(1),'x'); 
%         plot(X_corners,Y_corners,'o');
%         end
%         
%         function snapshot=snap(obj,scale,reference_picture)
%            %returns the current pixel in the snap scaled to the 
%            %current wanted pixel size
%            if scale~=0
%            transform =affine2d([(1+scale) ,0 ,0;0 ,(1+scale), 0; 0 0 1]);
%            snapshot=imwarp(obj.Data(uint64(obj.D_W(1)):uint64(obj.A_W(1)-1),uint64(obj.D_W(2))-1:uint64(obj.C_W(2)-1)),transform);%,transform,'OutputView', imref2d( size(reference_picture)));
%            else
%            snapshot=obj.Data(uint64(obj.D_W(1)):uint64(obj.A_W(1)),uint64(obj.D_W(2)):uint64(obj.C_W(2)+1));
%            end
% 
% 
%         end
%         
        
    end
    
end

