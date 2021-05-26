
# Evaluation  

#### Pre-trained models

The pre-trained models of UniFuse for 4 datasets are available, [Matterport3D](https://drive.google.com/drive/folders/1Dx7QR4ypujgLbyOo1zu4vIYXbqf95ToE?usp=sharing), [Stanford2D3D](https://drive.google.com/drive/folders/1q3LP9tyWi18yJwmhdjVn7dGUOsU3AH9G?usp=sharing), [3D60](https://drive.google.com/drive/folders/1B79FX_LoJ6GrcqyP1PIh2jqsiYs30V6P?usp=sharing) and [PanoSUNCG](https://drive.google.com/drive/folders/1trwQ7orixAjxWVK8rFLAtaaAqIjRB6va?usp=sharing).

#### Test on a pre-trained model

```
python evaluate.py  --data_path $DATA_PATH --dataset matterport3d --load_weights_folder $MODEL_PATH 
```


