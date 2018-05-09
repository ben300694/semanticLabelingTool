# semanticLabelingTool
Tool to create ground truth semantic segmentation masks using super pixels. 

The goal is to finetune a network to perform the semantic segmentation for you,
using [tensorflow-deeplab](https://github.com/DrSleep/tensorflow-deeplab-resnet).

[Here](https://youtu.be/oycY0ZMMszI) is some demo video of the tool

## Setup:
 - Download and extract [vl_feat library](http://www.vlfeat.org/) 
   including the function to compute superpixels `vl_slic`
 - Download and extract [yamlmatlab](https://code.google.com/archive/p/yamlmatlab/)
   (this is a module for reading configuration files in the
   yaml format)
 - Add the all extracted folders to your
   Matlab path (a sample `startup.m` is included in the repository)
 - Install tensorflow (preferably tensorflow-gpu)
 - Clone the [modified version](https://github.com/ben300694/tensorflow-deeplab-resnet) of Deeplab Resnet
   (this also contains necessary configuration files for the matlab script)
 - Edit the path to the configuration file in `semanticLabelingTool.m`
 - Set up the folder structure of your dataset in the following way:
```

.
+-- annotations_Free
|   +-- img00001.mat
|   +-- img00002.mat
|   +-- ...
|
+-- annotations_PNG
|   +-- anno_img00001.png
|   +-- anno_img00009.png
|   +-- ...
|
+-- annotations_Superpixels
|   +-- img00001.mat
|   +-- img00002.mat
|   +-- ...
|
+-- images
|   +-- img00001.png
|   +-- img00002.png
|   +-- ...
|
+-- inference
+-- output
+-- snapshots_finetune
+-- filelist.txt
+-- train.txt
+-- val.txt

```

You need the following Matlab functions:
 - regionprops
 - bwperim


## TODOs:
 - [x] Replace system [call to caffe-deeplab](https://github.com/mgarbade/semanticLabelingTool/blob/43cbde95bf7fbd802e0f25f773517d2a3956cb82/getSematicLabels.m#L1-L41) by some easier-to-install NN library, eg [tensorflow-deeplab](https://github.com/DrSleep/tensorflow-deeplab-resnet)
 - [x] Postprocessing of the inference with a CRF
 - [x] Finetune Deeplab with the training data
 - [x] Add a function for seeing the class label when clicking on a pixel in the image
 - [ ] Use predictions from Deeplab as a basis for labeling to remove the amount of work required for labeling,
       for this add the posibility to change the labels on a pixel by pixel level (or inside of a polygon)
 - [ ] Label more training data
 - [ ] Find good metaparameters for finetuning the model
 - [ ] Allow adding and removing classes in the interface