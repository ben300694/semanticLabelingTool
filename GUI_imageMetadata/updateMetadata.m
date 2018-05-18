function handles = updateMetadata(hObject, handles)

% Get values in GUI_imageMetadata
GUI_imageMetadataData = guidata(handles.GUI_imageMetadataHandle);
% disp(handles.GUI_imageMetadataHandle);

%% Metadata

% Prepare the table for Image Metadata that is being displayed
tableMetadata = cell(3,2);

tableMetadata{1,1} = 'imgIdx';
tableMetadata{1,2} = num2str(handles.imgIdx); % convert number to string to have it left-aligned in table

tableMetadata{2,1} = 'imgId';
tableMetadata{2,2} = handles.imgId;

tableMetadata{3,1} = 'fullImgPath';
tableMetadata{3,2} = handles.fullImgPath;

% Set values in the table
set(GUI_imageMetadataData.tableMetadata, 'ColumnWidth', {100,800});
set(GUI_imageMetadataData.tableMetadata, 'Data', tableMetadata);

%% Annotations

handles.fullAnnoFreePath = [handles.annoFreeDir, 'anno_free_', handles.imgId, '.mat'];
handles.fullAnnoSuperpixelPath = [handles.annoSuperpixelsDir, handles.imgId, '.mat'];

% Prepare the table for information about Annotations that is being displayed
tableAnnotations = cell(2, 2);

tableAnnotations{1,1} = 'fullAnnoFreePath';
if exist(handles.fullAnnoFreePath, 'file')
   tableAnnotations{1,2} = handles.fullAnnoFreePath;
else
   tableAnnotations{1,2} = 'N/A';
end

tableAnnotations{2,1} = 'fullAnnoSuperpixelPath';
if exist(handles.fullAnnoSuperpixelPath, 'file')
   tableAnnotations{2,2} = handles.fullAnnoSuperpixelPath;
else
   tableAnnotations{2,2} = 'N/A';
end

% Set values in the table
set(GUI_imageMetadataData.tableAnnotations, 'ColumnWidth', {200,800});
set(GUI_imageMetadataData.tableAnnotations, 'Data', tableAnnotations);

%% Inference

handles.fullInferencePath = [handles.inferenceDir, handles.imgId, '.mat'];

% Prepare the table for information about Inference that is being displayed
tableInference = cell(2, 2);

tableInference{1,1} = 'fullInferencePath';
if exist(handles.fullInferencePath, 'file')
    tableInference{1,2} = handles.fullInferencePath;
else
    tableInference{1,2} = 'N/A';
end

tableInference{2,1} = 'With CRF available?';
if exist(handles.fullInferencePath, 'file')
    struc = load(handles.fullInferencePath);
    if isfield(struc,'labels_crf')
        tableInference{2,2} = 'True';
    else
        tableInference{2,2} = 'False';
    end
end

% Set values in the table
set(GUI_imageMetadataData.tableInference, 'ColumnWidth', {200,800});
set(GUI_imageMetadataData.tableInference, 'Data', tableInference);

% TODO Insert a field which shows with which model_weights file
% the inference was performed


%% Update the GUI
guidata(handles.GUI_imageMetadataHandle, GUI_imageMetadataData);

end