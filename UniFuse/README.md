

# UniFuse (RAL+ICRA2021)

Office source code of paper **UniFuse: Unidirectional Fusion for 360$^\circ$ Panorama Depth Estimation**, [arXiv](https://arxiv.org/abs/2102.03550), [Demo](https://youtu.be/9vm9OMksvrc)



# Preparation

#### Installation

Environments


* python 3.6
* Pytorch >= 1.0.0
* CUDA >= 9.0


Install requirements

```bash
pip install -r requirements.txt
```

#### Datasets 

Please download the preferred datasets,  i.e., [Matterport3D](https://niessner.github.io/Matterport/), [Stanford2D3D](http://3dsemantics.stanford.edu/), [3D60](https://vcl3d.github.io/3D60/) and [PanoSUNCG](https://fuenwang.ml/project/360-depth/). For Matterport3D, please preprocess it following [M3D-README.md](UniFuse/Matterport3D/README.md).



# Training 

#### UniFuse on Matterport3D

```
python train.py --data_path $DATA_PATH \
-dataset matterport3d \
--model_name Matterport3D_UniFuse \
--batch_size 6 \
--num_epochs 100 \
--height 512 \
--width 1024 \
--imagenet_pretrained \
--net UniFuse 
```

#### Equirectangular baseline on Matterport3D

```
python train.py --data_path $DATA_PATH \
-dataset matterport3d \
--model_name Matterport3D_Equi \
--batch_size 6 \
--num_epochs 100 \
--height 512 \
--width 1024 \
--imagenet_pretrained \
--net Equi 
```

It is similar for other datasets. 


# Evaluation  

#### Pre-trained models

The pre-trained models of UniFuse for 4 datasets are available, [Matterport3D](PretrainedModels/Matterport3D_UniFuse_cee_se_b), [Stanford2D3D](PretrainedModels/Stanford2D3D_UniFuse_cee_se_b), [3D60](PretrainedModels/3D60_UniFuse_cee_se) and [PanoSUNCG](PretrainedModels/PanoSunCG_UniFuse_cee_se).

#### Test on a pre-trained model

```
python evaluate.py  --data_path $DATA_PATH --dataset matterport3d --load_weights_folder $MODEL_PATH 
```



## Citation

Please cite our paper if you find our work useful in your research.

```
@article{jiang2021unifuse,
      title={UniFuse: Unidirectional Fusion for 360$^{\circ}$ Panorama Depth Estimation}, 
      author={Hualie Jiang and Zhe Sheng and Siyu Zhu and Zilong Dong and Rui Huang},
	  journal={IEEE Robotics and Automation Letters},
	  year={2021},
	  publisher={IEEE}
}
```

