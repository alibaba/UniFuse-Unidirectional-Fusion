# Matterport3D Preprocessing for 360$^\circ$ Depth Estimation



# Steps

* Download the Matterport3D dataset

* Copy *extract.sh* to the folder of Matterport3D

* Open a terminal on the folder of Matterport3D and execute 

  ```bash
  chmod u+x extract.sh && ./extract.sh
  ```

* Download [PanoBasic](https://github.com/yindaz/PanoBasic)

* Copy all *.m* files and folder *Projection* to PanoBasic

* Modify the directories in *stitching_Matterport3D.m*,  i.e., changing **source_dir** to the folder of Matterport3D and changing **target_dir** as the output folder of panorama images and depth maps. 

* Execute  *stitching_Matterport3D.m* using Matlab.


