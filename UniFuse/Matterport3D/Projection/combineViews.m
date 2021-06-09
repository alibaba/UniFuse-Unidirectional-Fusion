function [panoout,  panodepth] = combineViews( Imgs, width, height, depth)
%COMBINEVIEWS Combine multiple perspective views to panorama
%   Imgs: same format as separatePano
%   width,height: size of panorama

if nargin < 4, depth = false; end

panoout = zeros(height, width, size(Imgs(1).img,3));
panowei = zeros(height, width, size(Imgs(1).img,3));
imgNum = length(Imgs);
for i = 1:imgNum
    [sphereImg validMap] = ...
        im2Sphere( Imgs(i).img, Imgs(i).fov, width, height, Imgs(i).vx, Imgs(i).vy,  '*linear');
    sphereImg(~validMap) = 0;   
    panoout = panoout + sphereImg;
    panowei = panowei + validMap;
end
panoout(panowei==0) = 0;
panowei(panowei==0) = 1;
panoout = panoout./double(panowei);

if (depth)
    panodepth = zeros(height, width);
    panowei = zeros(height, width);
    for i = 1:imgNum
        [sphereImg validMap] = ...
            im2Sphere( Imgs(i).dep, Imgs(i).fov, width, height, Imgs(i).vx, Imgs(i).vy,  'nearest');
        sphereImg(~validMap) = 0;   
        panodepth = panodepth + sphereImg;
        panowei = panowei + validMap;
    end
    panodepth(panowei==0) = 0;
    panowei(panowei==0) = 1;
    panodepth = panodepth./double(panowei);
else
    panodepth = 0;
end

end

