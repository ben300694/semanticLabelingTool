function callPythonInferenceScript(imgPath, savePath)

% imgPath = '/media/data/bruppik/deeplab_resnet_test_dataset/images/img00003.png'
% savePath = '/media/data/bruppik/deeplab_resnet_test_dataset/matlab_files/labels3.mat'
pathToPythonScript = '/media/remote_home/bruppik/git-source/ben300694/tensorflow-deeplab-resnet/my_inference.py';

systemCommand = ['python ', pathToPythonScript, ' ', imgPath, ' ', savePath];
system(systemCommand)

end