function callPythonInferenceScript(pathToPythonBinary, ... 
                                   pathToPythonScript, ...
                                   imgPath, savePath, modelWeightsPath, ...
                                   useCRF)

% imgPath = '/media/data/bruppik/deeplab_resnet_test_dataset/images/img00003.png'
% savePath = '/media/data/bruppik/deeplab_resnet_test_dataset/matlab_files/labels3.mat'

systemCommand = [pathToPythonBinary, ...
                    ' ', pathToPythonScript, ...
                    ' ', imgPath, ...
                    ' ', savePath, ...
                    ' ', '--model_weights', ' ', modelWeightsPath];
                
if useCRF == true
    systemCommand = [systemCommand, ' ', '--use_crf'];
end

disp(['Calling ', systemCommand])
system(systemCommand)

end