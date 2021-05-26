function stitch(source_dir, target_dir, scene_name)

para_file  = strcat(source_dir, '/undistorted_camera_parameters/', scene_name, '.conf');

img_dir = 'undistorted_color_images';
dep_dir =  'undistorted_depth_images';
skybox_dir  = "matterport_skybox_images";

pano_img_dir = 'pano_color';
pano_dep_dir = 'pano_depth';
pano_skybox_dir = 'pano_skybox_color';

if ~exist(strcat(target_dir, '/', pano_img_dir), 'dir')
    mkdir(strcat(target_dir, '/', pano_img_dir))
end
if ~exist(strcat(target_dir, '/', pano_dep_dir), 'dir')
    mkdir(strcat(target_dir, '/', pano_dep_dir))
end
if ~exist(strcat(target_dir, '/', pano_skybox_dir), 'dir')
    mkdir(strcat(target_dir, '/', pano_skybox_dir))
end

[n_spots, Scans] = parse_para_file(para_file);

theta = 5*pi/6;

parfor (i=1:n_spots, 4)
     
    %% First we stitch 18 views from undistorted_color_images and undistorted_depth_images.
    sepImg = [];
    
    for j = 1:18
        
        img_n = strcat(source_dir, '/', img_dir, '/',  Scans( (i-1)*18 + j ).img_file );
        img = im2double(imread(img_n));
        %sepImg(j).img = img;
        
        dep_n = strcat(source_dir, '/', dep_dir, '/',  Scans( (i-1)*18 + j ).dep_file );
        dep = double(imread(dep_n))/4000;
        %sepImg(j).dep = dep;
        
        %sepImg(j).sz = size(sepImg(j).img);
        sepImg(j).K = Scans( (i-1)*18 + j ).K;
        sepImg(j).pose = Scans( (i-1)*18 + j ).pose;
        
        [h,  w, c]  = size(img);
        K = sepImg(j).K;
        fx = K(1, 1);
        cx = K(1, 3);
        cy = K(2, 3);
        w_cx = w - cx;
        new_w = round(2*min(cx, w_cx));
        if w_cx >= cx
            start_x = 1;
        else
            start_x = w - new_w +1;
        end
        h_cy = h - cy;
            new_h = round(2*min(cy, h_cy));
        if h_cy >= cy
            start_y = 1;
        else
            start_y = h - new_h +1;
        end
        img = img(start_y: start_y+new_h-1, start_x:start_x+new_w-1, :);
        dep = dep(start_y: start_y+new_h-1, start_x:start_x+new_w-1, :);
        
        [X, Y] = meshgrid(1:new_w, 1:new_h);
        X = (X-new_w/2-0.5)/new_w;
        Y = (Y-new_h/2-0.5)/new_h;
        R =  sqrt(X.^2 + Y.^2 + 1);
        dep = dep.*R;

        sepImg(j).img = img;
        sepImg(j).dep = dep;
        sepImg(j).sz = [new_h, new_w];
        sepImg(j).fov  = 2*atan(new_w/fx/2);
        
        v = sepImg(j).pose(1:3, 1:3)*[0; 0; 1];
        sepImg(j).vx = theta+atan2(-v(2), v(1));
        sepImg(j).vy = -asin(v(3));
        
    end
    
    [panocolor, panodepth] = combineViews(sepImg, 2048, 1024, true);
    
    image_name = strsplit(Scans( (i-1)*18 + j ).img_file, '_');
    image_name = image_name{1};
    
    
    imwrite(panocolor, strcat(target_dir, '/', pano_img_dir, '/', image_name,'.jpg') );
    imwrite(uint16(panodepth*4000), strcat(target_dir, '/', pano_dep_dir, '/', image_name,'.png') );
    
    %% This code can also stitch skybox images to panorama, which looks perfect
    sepImg = [];

    vx = [-pi/2 -pi/2 0 pi/2 pi -pi/2];
    vy = [pi/2 0 0 0 0 -pi/2];

    for a = 1:6
        img_name = strcat(source_dir, '/', skybox_dir, '/', image_name, sprintf('_skybox%d_sami.jpg',a-1));
        img_name = img_name{1};
        
        sepImg(a).img = im2double(imread(img_name));
        sepImg(a).vx = vx(a);
        sepImg(a).vy = vy(a);
        sepImg(a).fov = pi/2+0.001;
        sepImg(a).sz = size(sepImg(a).img);
    end

    panoskybox = combineViews(sepImg, 2048, 1024 );
    imwrite(panoskybox, strcat(target_dir, '/', pano_skybox_dir, '/', image_name,'.jpg') );
end



end