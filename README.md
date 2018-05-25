# semanticLabelingTool
Tool to create ground truth semantic segmentation masks using super pixels
and at the same time training a network to suggest labels that have to
be corrected by the annotator. 

The goal is to finetune a network to perform the semantic segmentation for you,
using [tensorflow-deeplab](https://github.com/DrSleep/tensorflow-deeplab-resnet).

[Here](https://youtu.be/oycY0ZMMszI) is some demo video of the tool

## Setup:
 - Download and extract [vl_feat library](http://www.vlfeat.org/) 
   including the function to compute superpixels `vl_slic`
 - Add the all extracted folders to your
   Matlab path
   (a sample `startup.m` is included in the repository under
   `examples/startup_example.m`)
 - Install tensorflow (preferably tensorflow-gpu)
 - Clone the [modified version](https://github.com/ben300694/tensorflow-deeplab-resnet)
   of Deeplab Resnet
   (this also contains necessary configuration files for the matlab script)
   In case that this does not work
   there is also an example configuration file under
   `examples/config_example.yml`.
 - Edit the following variables in `semanticLabelingTool.m`:
    - `yaml_file` has to point to the `config.yml` in the tensorflow-deeplab-resnet repository
    - `pathToPythonBinary` has to point to your python binary, preferably one
      in a virtual environment where you installed tensorflow
    - `pathToPythonScript` has to point to the `my_inference.py` script in the
      tensorflow-deeplab-resnet repository
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
+-- color_mask_output
+-- images
|   +-- img00001.png
|   +-- img00002.png
|   +-- ...
|
+-- matlab_files
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
 - [x] Use predictions from Deeplab as a basis for labeling to reduce the
       amount of work required for labeling,
       for this add the posibility to change the labels on a pixel by pixel
       level (and inside of a polygon without relying on superpixels)
 - [x] Implement adding new labels classes in the interface
 - [ ] Look into Pix4D and evaluate if it is possible to get ground truth data
       for the geometry of a scene from there
 - [ ] Label more training data
 - [ ] Find good metaparameters for finetuning the model
 - [ ] Include inference of geometry of the scene (depth, surface normals, ...)
 - [ ] Higher level semantics, e.g. classification if landing is possible on surface or not