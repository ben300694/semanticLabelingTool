function saveInference(imgIdx, hObject, handles)

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId, ~] = fileparts(handles.imgName);

set(handles.stImgName, 'String', handles.imgId);
fullImgPath = [handles.imgDir, handles.imgName];
fullInferencePath = [handles.inferenceDir, handles.imgId, '.mat'];

% The python script calls a forward pass through the Deeplab Resnet
callPythonInferenceScript(handles.pathToPythonBinary, ...
                          handles.pathToPythonScript, ...
                          fullImgPath, ...
                          fullInferencePath, ...
                          handles.ckptFile, ...
                          handles.useCRF, ...
                          false)

guidata(hObject, handles);

end