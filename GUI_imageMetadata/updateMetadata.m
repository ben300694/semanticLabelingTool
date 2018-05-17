function updateMetadata(fullImgPath, hObject, handles)

% Get values in GUI_imageMetadata
GUI_imageMetadataData = guidata(handles.GUI_imageMetadataHandle);
% disp(handles.GUI_imageMetadataHandle);

% Prepare the table that is being displayed in the table
tableMetadata = cell(3,2);

tableMetadata{1,1} = 'imgIdx';
tableMetadata{1,2} = handles.imgIdx;

tableMetadata{2,1} = 'imgId';
tableMetadata{2,2} = handles.imgId;

tableMetadata{3,1} = 'fullImgPath';
tableMetadata{3,2} = fullImgPath;

% Set values in the table
set(GUI_imageMetadataData.TableMetadata, 'ColumnWidth', {50,200});
set(GUI_imageMetadataData.TableMetadata, 'Data', tableMetadata);

% Update the GUI
guidata(handles.GUI_imageMetadataHandle, GUI_imageMetadataData);

end