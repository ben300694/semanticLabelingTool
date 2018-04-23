function updateImg(imgIdx,hObject,handles)
% if (~handles.isSaved) % Check if previous modifications have been saved
% %    selection = questdlg('Save new Annotations?',...
% %                         'Save new Annotations?',...
% %                         'Yes','No','Yes');
% 
% %    switch selection,
% %       case 'Yes',
% %          %...
% %       case 'No'
% %          %...
% %    end
% end

handles.imgIdx = imgIdx;
handles.imgName = handles.filelist{imgIdx};
[~, handles.imgId,~] = fileparts(handles.imgName);

set(handles.stImgName,'String',handles.imgId);
fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file') && exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    a = load(fullAnnoPath,'anno');
    anno = a.anno;
    handles.superPixels = anno;
    handles.readyToLabel = true;
    guidata(hObject, handles);
    drawOverlay(hObject,handles)
    
elseif exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    handles.myCanvas = imshow(handles.img);
    handles.readyToLabel = false;
    msg = {'No annotation found,' 'please compute segments'};
    set(handles.stStatus,'String',msg);
    guidata(hObject, handles);
else
    disp('No image found');
end

guidata(hObject, handles);

end