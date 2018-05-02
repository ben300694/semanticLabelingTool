function varargout = semanticLabelingTool(varargin)
% SEMANTICLABELINGTOOL MATLAB code for semanticLabelingTool.fig
%      SEMANTICLABELINGTOOL, by itself, creates a new SEMANTICLABELINGTOOL or raises the existing
%      singleton*.
%
%      H = SEMANTICLABELINGTOOL returns the handle to a new SEMANTICLABELINGTOOL or the handle to
%      the existing singleton*.
%
%      SEMANTICLABELINGTOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEMANTICLABELINGTOOL.M with the given input arguments.
%
%      SEMANTICLABELINGTOOL('Property','Value',...) creates a new SEMANTICLABELINGTOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before semanticLabelingTool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to semanticLabelingTool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help semanticLabelingTool

% Last Modified by GUIDE v2.5 27-Apr-2018 16:38:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @semanticLabelingTool_OpeningFcn, ...
                   'gui_OutputFcn',  @semanticLabelingTool_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

end
% End initialization code - DO NOT EDIT

% --- Executes just before semanticLabelingTool is made visible.
function semanticLabelingTool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to semanticLabelingTool (see VARARGIN)
clc;


folder = fileparts(which(mfilename)); 
addpath(genpath(folder));

% Choose default command line output for semanticLabelingTool
handles.output = hObject;

% Set the path to all the data directories
handles.imgDir = '/media/data/bruppik/deeplab_resnet_test_dataset/images';
handles.filelistFile = '/media/data/bruppik/deeplab_resnet_test_dataset/filelist.txt';
handles.trainFile = '/media/data/bruppik/deeplab_resnet_test_dataset/train.txt';

handles.annoDir = '/media/data/bruppik/deeplab_resnet_test_dataset/annotations';
handles.annoPNGDir = '/media/data/bruppik/deeplab_resnet_test_dataset/annotations_PNG';

handles.inferenceDir = '/media/data/bruppik/deeplab_resnet_test_dataset/inference';
handles.snapshotDir = '/media/data/bruppik/deeplab_resnet_test_dataset/snapshots_finetune';
handles.ckptFile = '/media/data/bruppik/deeplab_resnet_test_dataset/snapshots_finetune/model_finetuned.ckpt-350';

handles.imgName = '';
handles.imgId = '';
handles.img = [];
handles.imgIdx = [];
handles.filelist = [];
handles.numImgs = [];
handles.regionSize = get(handles.sliderRegionSize,'Value');
handles.regularizer = get(handles.sliderRegularizer,'Value');
handles.alphaValue = 0.45;
handles.superPixels = [];
handles.readyToLabel = false;
handles.isSaved = false;
handles.myCanvas = [];

handles.currentlyShownLabels = [];
handles.useCRF = true;

% Load the colormap
if ~exist('colormap.mat')
    error('Please create a colormap file in the current folder')
end

colMap = load('colormap.mat');
handles.colorNames = colMap.colorNames;
handles.colors= colMap.colorRGBValues;

% Get parameters for calculation of superpixels
set(handles.etRegionSize,'String',num2str(get(handles.sliderRegionSize,'Value')));
set(handles.etRegularizer,'String',num2str(get(handles.sliderRegularizer,'Value')));

% Get current selected label
indName = get(get(handles.Labels ,'SelectedObject'),'String'); 
ind = find(ismember(handles.colorNames,indName)); % Get ind corresponding to color / label
handles.selectedLabel = ind;

% Update the text in the edit textboxes
set(handles.etImagePath, 'String', handles.imgDir);
set(handles.etAnnotationsPath, 'String', handles.annoDir);
set(handles.etFilelist, 'String', handles.filelistFile);
set(handles.etCkptFile, 'String', handles.ckptFile);

set(handles.etAlphaValue, 'String', handles.alphaValue);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes semanticLabelingTool wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = semanticLabelingTool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

%% Callbacks for Iterate through images

% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
% Load previous imgage
imgIdx = handles.imgIdx;
if imgIdx > 1 
    imgIdx = imgIdx - 1;
    updateImg(imgIdx, hObject, handles);    
end
end

% --- Executes on button press in btnNext.
function btnNext_Callback(hObject, eventdata, handles)
% Load next image
imgIdx = handles.imgIdx;
if imgIdx < handles.numImgs
    imgIdx = imgIdx + 1;
    updateImg(imgIdx, hObject, handles);
end
end


%%

% --- Executes on slider movement.
function sliderRegionSize_Callback(hObject, eventdata, handles)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderRegionSizeValue = get(hObject,'Value');
set(handles.etRegionSize,'String',num2str(sliderRegionSizeValue));
handles.regionSize = sliderRegionSizeValue;
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function sliderRegionSize_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


% --- Executes on slider movement.
function sliderRegularizer_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
sliderRegularizerValue = get(hObject,'Value');
set(handles.etRegularizer,'String',num2str(sliderRegularizerValue));
handles.regularizer = sliderRegularizerValue;
guidata(hObject, handles); 
end


% --- Executes during object creation, after setting all properties.
function sliderRegularizer_CreateFcn(hObject, eventdata, handles)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
end


%% Set paths for database

function etImagePath_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of etImagePath as text
%        str2double(get(hObject,'String')) returns contents of etImagePath as a double
end

% --- Executes during object creation, after setting all properties.
function etImagePath_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function etAnnotationsPath_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of etAnnotationsPath as text
%        str2double(get(hObject,'String')) returns contents of etAnnotationsPath as a double
end


% --- Executes during object creation, after setting all properties.
function etAnnotationsPath_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnImgPath.
function btnImgPath_Callback(hObject, eventdata, handles)
handles.imgDir = uigetdir(handles.imgDir);
set(handles.etImagePath, 'String', handles.imgDir);
guidata(hObject, handles); 
end

% --- Executes on button press in btnAnnPath.
function btnAnnPath_Callback(hObject, eventdata, handles)
handles.annoDir = uigetdir(handles.annoDir);
set(handles.etAnnotationsPath,'String',handles.annoDir);
guidata(hObject, handles); 
end

% --- Executes on button press in btnLoadDatabase.
function btnLoadDatabase_Callback(hObject, eventdata, handles)
if (exist(handles.filelistFile,'file') && exist(handles.annoDir,'dir') && exist(handles.imgDir,'dir'))
    disp('All files exist --> Load imagelist.')
    set(handles.stStatusDatabase,'String','Loading successful');
    filelist = getVideoNamesFromAsciiFile(handles.filelistFile);
    handles.filelist = filelist;
    handles.numImgs = size(filelist,1);
    handles.imgIdx = 1;
    
    updateImg(handles.imgIdx,hObject,handles);
    
    set(handles.TableFilelist,'Data',filelist);
    set(handles.TableFilelist,'ColumnWidth',{200});
    
    set(handles.etImagePath, 'String', handles.imgDir);
    set(handles.etAnnotationsPath, 'String', handles.annoDir);
    set(handles.etFilelist, 'String', handles.filelistFile);
else
    set(handles.stStatusDatabase,'String','Could not load database');
end
end



function etFilelist_Callback(hObject, eventdata, handles)
% Hints: get(hObject,'String') returns contents of etFilelist as text
%        str2double(get(hObject,'String')) returns contents of etFilelist as a double
end


% --- Executes during object creation, after setting all properties.
function etFilelist_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in btnLoadImgFilelist.
function btnLoadImgFilelist_Callback(hObject, eventdata, handles)
filelistFile = uigetfile(handles.filelistFile);
set(handles.etFilelist,'String',filelistFile);
handles.filelistFile = filelistFile;
guidata(hObject, handles); 
end

% --- Executes when selected cell(s) is changed in TableFilelist.
function TableFilelist_CellSelectionCallback(hObject, eventdata, handles)
handles.imgIdx = eventdata.Indices(1);
disp(['handles.imgIdx changed to ', int2str(handles.imgIdx)])
% disp(handles.filelist)
handles = updateImg(handles.imgIdx,hObject,handles);
guidata(hObject, handles);
end

%% Superpixels and Annotation tools
 
% --- Executes on button press in btnComputeSegments.
function btnComputeSegments_Callback(hObject, eventdata, handles)
    computeSegments(hObject,eventdata,handles)
end


% --- Executes on button press in btnDrawPolygon.
function btnDrawPolygon_Callback(hObject, eventdata, handles)
% Draw polygon
% Get Centroids in polygon
% Get Inliers

if (handles.readyToLabel);
    superPixels = handles.superPixels;
    labelImg = superPixels.labelImg;
    line = getline;
    inside = getSuperpixelsInPolygon(line,superPixels.Centroid);
    superPixelImg = superPixels.superPixelImg;
    overlayMask = paintSuperpixels(inside,superPixelImg);

    indName = get(get(handles.Labels ,'SelectedObject'),'String');
    ind = find(ismember(handles.colorNames,indName)); % Get ind corresponding to color / label
    handles.selectedLabel = ind;
    
    labelImg(overlayMask) = handles.selectedLabel ; % Colorize selected polygon
    handles.superPixels.labelImg = labelImg; % Update the overlay
    handles.isSaved = false; % Prompt user to save image
    
    handles = drawOverlay(hObject,handles);
    msg = {'Please hit ''Save''' 'to store modifications'};
    set(handles.stStatus,'String',msg);
    
else 
    msg = {'Image not ready to' 'label yet. Compute' 'super pixels first'};
    set(handles.stStatus,'String',msg);
end

guidata(hObject, handles); 

end

function computeSegments(hObject,eventdata,handles)
imgIdx = handles.imgIdx;
handles.imgName = handles.filelist{imgIdx};

fullImgPath = [handles.imgDir '/'  handles.imgName];
fullAnnoPath = [handles.annoDir '/'  handles.imgId '.mat'];

if exist(fullAnnoPath,'file')
    warning('Existing Annotation will be overwritten')
end
if exist(fullImgPath,'file')
    handles.img = imread(fullImgPath);
    
    % Compute superPixels
    set(handles.stStatus,'String','Wait...');
    drawnow;
    regionSize = handles.regionSize;
    regularizer = handles.regularizer;
    superPixels = getAllSuperpixels(handles.img,regionSize,regularizer);
    handles.myCanvas = imshow(superPixels.oversegImage);
    handles.superPixels = superPixels;
    set(handles.stStatus,'String','Done');
    handles.readyToLabel = true; % Set flag that image can be labels
    guidata(hObject, handles);  
else
    disp('No img found');
end

end


% --- Executes on button press in btnSelectSuperpixels.
function btnSelectSuperpixels_Callback(hObject, eventdata, handles)
% Select an arbitrary number of points
% After selecting a point, get the corresponding superpixel ID
% Paint superpixel with the color selected

h = handles.myCanvas;
disp(h);
if ~isempty(h)
    set(h, 'ButtonDownFcn', @(src,eventdata)position_and_button(src,eventdata,hObject));
else
    msg = {'myCanvas handle' 'is empty'};
    set(handles.stStatus,'String',msg);
end


end

function position_and_button(src, eventdata, hObject)

Position = get( ancestor(src,'axes'), 'CurrentPoint' );
Button = get( ancestor(src,'figure'), 'SelectionType' );
% hObject
% src
hfig = ancestor(src, 'figure'); % Get the handle to the figure
handles = guidata(hfig); % Get the handles struct

% hold on 
Position = int32(Position);
Point = Position(end,:);
% plot(Point(1),Point(2),'r+');
% hold off

indName = get(get(handles.Labels ,'SelectedObject'),'String');
ind = find(ismember(handles.colorNames,indName)); % Get ind corresponding to color / label
handles.selectedLabel = ind;
Position = int32(Position);

if ~isempty(Position)

    Point = Position(end,:); % Only take first point (not sure why output argument consists of 2 points)

    spImg = handles.superPixels.superPixelImg;
    superPixelId = spImg(Point(2),Point(1));
    labelImg = handles.superPixels.labelImg;
    overlayMask = (spImg == superPixelId);

    labelImg(overlayMask) = handles.selectedLabel; % Colorize selected polygon
    handles.superPixels.labelImg = labelImg; % Update the overlay
    handles.isSaved = false; % Prompt user to save image

    % Plot new Overlay
    handles = drawOverlay(hObject, handles);

    % Have to set the ButtonDownFcn again 
    % because a plot clears the objects properties
    set(handles.myCanvas, 'ButtonDownFcn', @(src,eventdata)position_and_button(src,eventdata,hObject));    
        
    msg = {'Please hit ''Save''' 'to store modifications'};
    set(handles.stStatus, 'String', msg);

else 
    msg = {'Point is empty' 'try again'};
    set(handles.stStatus, 'String', msg);
end

guidata(hObject, handles)

end


%% Tools for pixel info

% --- Executes on button press in btnGetInfo.
function btnGetInfo_Callback(hObject, eventdata, handles)
% hObject    handle to btnGetInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = handles.myCanvas;
if ~isempty(h)
    set(h, 'ButtonDownFcn', @(src,eventdata)printPixelLabel(src, eventdata, hObject));
else
    msg = {'myCanvas handle' 'is empty'};
    set(handles.stStatus, 'String', msg);
end

end

function printPixelLabel(src, eventdata, hObject)
Position = get( ancestor(src,'axes'), 'CurrentPoint' );
Button = get( ancestor(src,'figure'), 'SelectionType' );
% hObject
% src
hfig = ancestor(src, 'figure'); % Get the handle to the figure
handles = guidata(hfig); % Get the handles struct

% hold on 
Position = int32(Position);
Point = Position(end,:);
% plot(Point(1),Point(2),'r+');
% hold off

Position = int32(Position);

if ~isempty(Position)

    Point = Position(end,:); % Only take first point (not sure why output argument consists of 2 points)

    if ~isempty(handles.currentlyShownLabels)
        pixelLabel = handles.currentlyShownLabels(Point(2),Point(1));
    
        if pixelLabel == 0
            pixelLabelClass = 'undefined'
        else
            pixelLabelClass = handles.colorNames{pixelLabel}
        end
        
        msg = {['Label of pixel at point ', ...
               '(', int2str(Point(2)), ', ', int2str(Point(1)), ')', ...
               ' is ', int2str(pixelLabel)], ...
               ['Class ', int2str(pixelLabel), ' is ', pixelLabelClass]
               }
        set(handles.stInfoStatus,'String',msg);
    else
        msg = {['Pixel at point ', ...
               '(', int2str(Point(2)), ', ', int2str(Point(1)), ')',...
               ' selected'], ...
               ['No labels are currently shown']};
        set(handles.stInfoStatus,'String',msg);
    end

else 
    msg = {'Point is empty' 'try again'};
    set(handles.stStatus,'String',msg);
end

end
      
% function superPixelId = paintSuperPixel(Position,label,hObject,handles)
% 
% Position = int32(Position);
% 
% if ~isempty(Position)
% 
%     Point = Position(end,:); % Only take first point ( not sure why output argument consists of 2 points)
% 
%     spImg = handles.superPixels.superPixelImg;
%     superPixelId = spImg(Point(2),Point(1));
%     labelImg = handles.superPixels.labelImg;
%     overlayMask = (spImg == superPixelId);
% 
% 
% 
%     labelImg(overlayMask) = label; % Colorize selected polygon
%     handles.superPixels.labelImg = labelImg; % Update the overlay
%     handles.isSaved = false; % Prompt user to save image
% 
%     guidata(hObject, handles); 
%     drawOverlay(hObject,handles)
%     msg = {'Please hit ''Save''' 'to store modifications'};
%     set(handles.stStatus,'String',msg);
% 
%     guidata(hObject, handles); 
% 
% else 
%     msg = {'Point is empty' 'try again'};
%     set(handles.stStatus,'String',msg);
%    
% 
% end

%% Annotations Paths

function etCkptFile_Callback(hObject, eventdata, handles)
% hObject    handle to etCkptFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etCkptFile as text
%        str2double(get(hObject,'String')) returns contents of etCkptFile as a double
handles.ckptFile = get(hObject, 'String');
guidata(hObject, handles); 
end


% --- Executes during object creation, after setting all properties.
function etCkptFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etCkptFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in btnCkptPath.
function btnCkptPath_Callback(hObject, eventdata, handles)
% hObject    handle to btnCkptPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*', 'Select a file with network weights', handles.snapshotDir);
handles.ckptFile = fullfile(path,file);
set(handles.etCkptFile, 'String', handles.ckptFile);

guidata(hObject, handles); 
end

% %% Load and Save Annotations via Buttons
% 
% % --- Executes on button press in btnSaveAnnotation.
% function btnSaveAnnotation_Callback(hObject, eventdata, handles)
% anno = handles.superPixels;
% save([handles.annoDir '/'  handles.imgId '.mat'], 'anno' );
% end
% 
% % --- Executes on button press in btnLoadAnnotation.
% function btnLoadAnnotation_Callback(hObject, eventdata, handles)
% % Check if Annotation exists
% % If yes load it
% % Else compute superPixels and save them
% % Store superPixels along with Annotations
% updateImg(handles.imgIdx,hObject,handles)
% loadAndDrawAnnotation(handles.imgIdx,hObject,handles)
% end
% 
% % --- Executes on button press in btnSaveAnnotationAsPNG.
% function btnSaveAnnotationAsPNG_Callback(hObject, eventdata, handles)
% % hObject    handle to btnSaveAnnotationAsPNG (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% annotationToPNG(handles.imgIdx, hObject, handles)
% end


%% Inference

% --- Executes on button press in btnCallDeeplab.
% hObject    handle to btnCallDeeplab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function btnCallDeeplab_Callback(hObject, eventdata, handles)

imgIdx = handles.imgIdx;
saveInference(imgIdx, hObject, handles)
% drawInference(imgIdx, hObject, handles, false);

end

% --- Executes on button press in checkboxCRF.
function checkboxCRF_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxCRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxCRF

handles.useCRF = get(hObject,'Value');

guidata(hObject, handles);

end

%% View

% --- Executes on button press in btnReload.
function btnReload_Callback(hObject, eventdata, handles)
% Reload the image in the canvas
handles.myCanvas = imshow(handles.img);
handles.currentlyShownLabels = [];
guidata(hObject, handles);
end

% --- Executes on button press in btnLoadInference.
function btnLoadInference_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadInference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

drawInference(handles.imgIdx, hObject, handles, false);

end

% --- Executes on button press in btnLoadInferenceCRF.
function btnLoadInferenceCRF_Callback(hObject, eventdata, handles)
% hObject    handle to btnLoadInferenceCRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

drawInference(handles.imgIdx, hObject, handles, true);

end

% Alpha Value for Overlays

function etAlphaValue_Callback(hObject, eventdata, handles)
% hObject    handle to etAlphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etAlphaValue as text
%        str2double(get(hObject,'String')) returns contents of etAlphaValue as a double
handles.alphaValue = str2double(get(hObject,'String'));
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function etAlphaValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etAlphaValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

%% Menues

% Annotations

% --------------------------------------------------------------------
function menuAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function menuLoadAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = loadAndDrawAnnotation(handles.imgIdx, hObject, handles);
guidata(hObject, handles);
end


% --------------------------------------------------------------------
function menuSaveAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
anno = handles.superPixels;
save([handles.annoDir '/'  handles.imgId '.mat'], 'anno');
end


% --------------------------------------------------------------------
function menuSaveAsPNG_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAsPNG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
annotationToPNG(handles.imgIdx, hObject, handles);
end
