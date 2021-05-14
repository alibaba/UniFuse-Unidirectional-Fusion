from __future__ import absolute_import, division, print_function
import os
import argparse

from trainer import Trainer

parser = argparse.ArgumentParser(description="360 Degree Panorama Depth Estimation Training")

# dataset
parser.add_argument("--data_path", default="/home/wolian/disk1/Matterport3D/", type=str, help="path to the dataset.")
parser.add_argument("--dataset", default="matterport3d", choices=["3d60", "panosuncg", "stanford2d3d", "matterport3d"],
                    type=str, help="dataset to train on.")

# system settings
parser.add_argument("--num_workers", type=int, default=4, help="number of dataloader workers")
parser.add_argument("--gpu_devices", type=int, nargs="+", default=[0], help="available gpus")

# model settings
parser.add_argument("--model_name", type=str, default="panodepth", help="folder to save the model in")
parser.add_argument("--num_layers", type=int, default=18, choices=[2, 18, 34, 50, 101],
                    help="number of resnet layers; if 2, use mobilenetv2")
parser.add_argument("--height", type=int, default=256, help="input image height")
parser.add_argument("--width", type=int, default=512, help="input image width")

# optimization settings
parser.add_argument("--learning_rate", type=float, default=1e-4, help="learning rate")
parser.add_argument("--batch_size", type=int, default=4, help="batch size")
parser.add_argument("--num_epochs", type=int, default=30, help="number of epochs")
parser.add_argument("--imagenet_pretrained", action="store_true", help="if set, use imagenet pretrained parameters")

# loading and logging settings
parser.add_argument("--load_weights_dir", type=str, help="folder of model to load")
parser.add_argument("--log_dir", type=str, default=os.path.join(os.path.dirname(__file__), "tmp"), help="log directory")
parser.add_argument("--log_frequency", type=int, default=200, help="number of batches between each tensorboard log")
parser.add_argument("--save_frequency", type=int, default=1, help="number of epochs between each save")

# data augmentation settings
parser.add_argument("--disable_color_augmentation", action="store_true", help="if set, do not use color augmentation")
parser.add_argument("--disable_LR_filp_augmentation", action="store_true",
                    help="if set, do not use left-right flipping augmentation")
parser.add_argument("--disable_yaw_rotation_augmentation", action="store_true",
                    help="if set, do not use yaw rotation augmentation")

# ablation settings
parser.add_argument("--net", type=str, default="UniFuse", choices=["UniFuse", "Equi"], help="model to use")
parser.add_argument("--fusion", type=str, default="cee", choices=["cee", "cat", "biproj"],
                    help="the method to fuse cubemap features to equirectangular features")
parser.add_argument("--se_in_fusion", action="store_true",
                    help="if set, use the squeeze-and-excitation module in the fusion")

args = parser.parse_args()


def main():
    trainer = Trainer(args)
    trainer.train()


if __name__ == "__main__":
    main()
