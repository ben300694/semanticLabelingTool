# semanticLabelingTool
Tool to create ground truth semantic segmentation masks using super pixels. 
The goal is to finetune a network to perform the semantic segmentation for you,
using [tensorflow-deeplab](https://github.com/DrSleep/tensorflow-deeplab-resnet).

[Here](https://youtu.be/oycY0ZMMszI) is some demo video of the tool

Prerequisites:  
 - Download and extract [vl_feat library](http://www.vlfeat.org/) including the function to compute superpixels `vl_slic`
 - Add the all extracted folders to your Matlab path
 - Install tensorflow
 - Clone the modified version of Deeplab Resnet (https://github.com/ben300694/tensorflow-deeplab-resnet)

You need the following Matlab functions:
 - regionprops
 - bwperim


TODOs:
 - [x] Replace system [call to caffe-deeplab](https://github.com/mgarbade/semanticLabelingTool/blob/43cbde95bf7fbd802e0f25f773517d2a3956cb82/getSematicLabels.m#L1-L41) by some easier-to-install NN library, eg [tensorflow-deeplab](https://github.com/DrSleep/tensorflow-deeplab-resnet)
 - [ ] Finetune Deeplab with the training data
 - [ ] Allow adding and removing classes in the interface
