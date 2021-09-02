%% stitching Matterport3D panorama images and depth  maps
clear; close all;
add_path;

source_dir = '/home/hljiang/disk8t/datasets/Matterport3D/v1/scans/';
target_dir = '/home/hljiang/disk8t/processed/Matterport3D/';

listing = dir(source_dir);
listing(ismember( {listing.name}, {'.', '..'})) = [];

for i = 1:length(listing)
    
    if exist(strcat(target_dir, '/', listing(i).name), 'dir') || ~listing(i).dir
        continue
    else
        mkdir(strcat(strcat(target_dir, '/', listing(i).name)))
    end
    
    stitch(strcat(source_dir, '/', listing(i).name), strcat(target_dir, '/', listing(i).name), listing(i).name);
    
end
