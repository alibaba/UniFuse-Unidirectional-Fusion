function [n_spots, Scans] =  parse_para_file(para_file)

str = fileread(para_file);
lines = splitlines(str);

line2 = strsplit(lines{2}, ' ');
n_images = str2num(line2{2});
n_spots = n_images/18;

Scans = [];

i = 1;
K = zeros(3,3);
line_idx = 5;
while i <= n_images
    if isempty(lines{line_idx})
        line_idx = line_idx +1;
        continue;
    end
    
    spline = split(lines{line_idx});
    K = cellstr2mat(spline, 1, 3, 3 );
    line_idx = line_idx +1;
    
    for j = 1:6
        
        spline = split(lines{line_idx});
        Scans(i).dep_file = spline{2};
        Scans(i).img_file = spline{3};
        Scans(i).K = K;
        Scans(i).pose = cellstr2mat(spline, 3, 4, 4 );
        line_idx = line_idx +1;
        i = i + 1;
        
    end
    
end


for i = 1:n_spots
    
    centers = zeros(3, 18);
    for j = 1:18
        %Scans( (i-1)*18 + j ).pose(1:2, 1) = -Scans( (i-1)*18 + j ).pose(1:2, 1);
        %Scans( (i-1)*18 + j ).pose(1:2, 3) = -Scans( (i-1)*18 + j ).pose(1:2, 3);
        centers(:, j) = Scans( (i-1)*18 + j ).pose(1:3, 4);
    end
    center = mean(centers, 2);
    x7_c = Scans( (i-1)*18 + 7 ).pose(1:3, 4)-center;
    x7_c = x7_c/norm(x7_c);
    %centers(3, :) = -centers(3, :);
    
    coeff = pca(centers');
    v_y = cross(coeff(:, 1), x7_c);
    v_x = cross(v_y, coeff(:, 1));
    
    pose_C = eye(4);
    pose_C(1:3, 1:3) = [v_x, v_y, coeff(:, 1)];
    pose_C(1:3, 4) = center;
    
    for j = 1:18
        Scans( (i-1)*18 + j ).pose = inv(pose_C)*Scans( (i-1)*18 + j ).pose;
    end
    
end

end


function [mat] =  cellstr2mat(cellstr, start, row, column)
    cellsize = size(cellstr);
    
    if row*column + start  > cellsize(1)
        error("mistaked size!")
    end
    
    mat = zeros(row, column);
    
    for i = 1:row
        for j = 1:column
            mat(i, j) = str2num(cellstr{start+(i-1)*column + j});
        end
    end
    
end

