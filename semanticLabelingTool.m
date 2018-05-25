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

% Last Modified by GUIDE v2.5 24-May-2018 19:35:33

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

% Load yamlmatlab and read in the configuration file

%%%%%%%%%%
% Change this path to the correct configuration file in
% the tensorflow-deeplab-resnet repository
%%%%%%%%%%
handles.yaml_file = '/media/remote_home/bruppik/git-source/ben300694/tensorflow-deeplab-resnet/config.yml';
handles.YamlStruct = ReadYaml(handles.yaml_file);
% disp(YamlStruct.directories.annotations.ANNO_FREE_DIRECTORY)

%%%%%%%%%%
% Change these paths to the correct:
% - python binary in a virtual environment where you have installed all the dependencies
%   (such as tensorflow, ...)
% - script for inference
%%%%%%%%%%
pathToPythonBinary = '/media/remote_home/bruppik/anaconda2/envs/tensorflow/bin/python';
pathToPythonScript = '/media/remote_home/bruppik/git-source/ben300694/tensorflow-deeplab-resnet/my_inference.py';


% Set the path to all the data directories

handles.imgDir = handles.YamlStruct.directories.IMAGE_DIR;

% Set this manually to load the entire filelist even when experimenting
% with different filelists in Python
% Uncomment the next line to load from the configuration file:
% handles.filelistFile = handles.YamlStruct.directories.lists.DATA_FILELIST_PATH;
handles.filelistFile = '/media/data/bruppik/cvg11/deeplab_resnet_test_dataset/filelist.txt';

handles.trainFile = handles.YamlStruct.directories.lists.DATA_TRAIN_LIST_PATH;

handles.annoFreeDir = handles.YamlStruct.directories.annotations.ANNO_FREE_DIRECTORY;
handles.annoPNGDir = handles.YamlStruct.directories.annotations.ANNO_PNG_DIRECTORY;
handles.annoSuperpixelsDir = handles.YamlStruct.directories.annotations.ANNO_SUPERPIXELS_DIRECTORY;

handles.inferenceDir = handles.YamlStruct.directories.inference.MATLAB_SAVE_DIRECTORY;
handles.snapshotDir = handles.YamlStruct.directories.training.SNAPSHOT_DIRECTORY;
handles.ckptFile = handles.YamlStruct.RESTORE_FROM;

handles.pathToPythonBinary = pathToPythonBinary;
handles.pathToPythonScript = pathToPythonScript;

% Left this here so that you can set a path manually for debugging
%
% handles.imgDir = '/media/data/bruppik/deeplab_resnet_test_dataset/images';
% handles.filelistFile = '/media/data/bruppik/deeplab_resnet_test_dataset/filelist.txt';
% handles.trainFile = '/media/data/bruppik/deeplab_resnet_test_dataset/train.txt';
% 
% handles.annoFreeDir = '/media/data/bruppik/deeplab_resnet_test_dataset/annotations_Free';
% handles.annoPNGDir = '/media/data/bruppik/deeplab_resnet_test_dataset/annotations_PNG';
% handles.annoSuperpixelsDir = '/media/data/bruppik/deeplab_resnet_test_dataset/annotations_Superpixels';
% 
% handles.inferenceDir = '/media/data/bruppik/deeplab_resnet_test_dataset/inference';
% handles.snapshotDir = '/media/data/bruppik/deeplab_resnet_test_dataset/snapshots_finetune';
% handles.ckptFile = '/media/data/bruppik/deeplab_resnet_test_dataset/snapshots_finetune/model_finetuned.ckpt-350';

% disp(handles)

% Initialize the variables to the correct values
% at the start of the program
handles.imgName = '';
handles.imgId = '';

handles.fullImgPath = '';
handles.fullAnnoFreePath = '';
handles.fullAnnoSuperpixelPath = '';
handles.fullInferencePath = '';

handles.img = [];
handles.imgIdx = [];
handles.filelist = [];
handles.numImgs = [];
handles.regionSize = get(handles.sliderRegionSize,'Value');
handles.regularizer = get(handles.sliderRegularizer,'Value');
handles.alphaValue = 0.45;
handles.superPixels = [];
handles.freeAnnotationLabels = [];
handles.databaseLoaded = false;
handles.readyToLabel = false;
handles.isSaved = false;
% DO NOT set 'handles.myCanvas' = [] !

handles.currentlyShownLabels = [];
handles.useCRF = true;

% Load the colormap
if ~exist('colormap.mat', 'file')
    error('Please create a colormap.mat file in the current folder')
end

colMap = load('colormap.mat');
handles.colorNames = colMap.colorNames;
handles.colors = colMap.colorRGBValues;

% Get parameters for calculation of superpixels
set(handles.etRegionSize,'String',num2str(get(handles.sliderRegionSize,'Value')));
set(handles.etRegularizer,'String',num2str(get(handles.sliderRegularizer,'Value')));

% Initialize TableLabels with the labels 
handles = updateTableLabels(handles);

% Set default currently selected label to '1'
handles.selectedLabel = 1;

% Update the text in the edit textboxes
set(handles.etImagePath, 'String', handles.imgDir);
set(handles.etAnnotationsPath, 'String', handles.annoSuperpixelsDir);
set(handles.etFilelist, 'String', handles.filelistFile);
set(handles.etCkptFile, 'String', handles.ckptFile);

set(handles.etAlphaValue, 'String', handles.alphaValue);

% Open the imageMetadata GUI Window
handles.GUI_imageMetadataHandle = imageMetadata;


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

%% Callbacks for Iterating through images

% --- Executes on button press in btnPrevious.
function btnPrevious_Callback(hObject, eventdata, handles)
% Load previous image
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


%% Parameters for Superpixel Calculation

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
handles.annoSuperpixelsDir = uigetdir(handles.annoSuperpixelsDir);
set(handles.etAnnotationsPath,'String',handles.annoSuperpixelsDir);
guidata(hObject, handles); 
end

% --- Executes on button press in btnLoadDatabase.
function btnLoadDatabase_Callback(hObject, eventdata, handles)

if (exist(handles.filelistFile,'file') && exist(handles.annoSuperpixelsDir,'dir') && exist(handles.imgDir,'dir'))
    disp('All files exist --> Load imagelist.')
    set(handles.stStatusDatabase,'String','Loading successful');
    filelist = getVideoNamesFromAsciiFile(handles.filelistFile);
    handles.filelist = filelist;
    handles.numImgs = size(filelist,1);
    handles.imgIdx = 1;
    
    handles = updateImg(handles.imgIdx, hObject, handles);
    
    set(handles.TableFilelist, 'Data', filelist);
    set(handles.TableFilelist, 'ColumnWidth', {200});
    
    set(handles.etImagePath, 'String', handles.imgDir);
    set(handles.etAnnotationsPath, 'String', handles.annoSuperpixelsDir);
    set(handles.etFilelist, 'String', handles.filelistFile);
    
    handles.databaseLoaded = true;
else
    set(handles.stStatusDatabase,'String','Could not load database');
    handles.databaseLoaded = true;
end

guidata(hObject, handles);

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

%% Callbacks for Tables

% --- Executes when selected cell(s) is changed in TableFilelist.
function TableFilelist_CellSelectionCallback(hObject, eventdata, handles)
handles.imgIdx = eventdata.Indices(1);
handles = updateImg(handles.imgIdx,hObject,handles);
guidata(hObject, handles);
end

% --- Executes when selected cell(s) is changed in TableLabels.
function TableLabels_CellSelectionCallback(hObject, eventdata, handles)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds

% Set currently selected label
handles.selectedLabel = eventdata.Indices(1);
disp(['Currently selected label: ', num2str(handles.selectedLabel), ...
        ' with name: ', handles.colorNames{handles.selectedLabel}]);

guidata(hObject, handles);
end

%% Superpixels and Annotation tools
 
% --- Executes on button press in btnComputeSegments.
function btnComputeSegments_Callback(hObject, eventdata, handles)
computeSegments(hObject,eventdata,handles)
end

% --- Executes on button press in btnDrawSuperpixelPolygon.
function btnDrawSuperpixelPolygon_Callback(hObject, eventdata, handles)
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
    
    labelImg(overlayMask) = handles.selectedLabel ; % Colorize selected polygon
    handles.superPixels.labelImg = labelImg; % Update the overlay
    handles.isSaved = false; % Prompt user to save image
    
    handles = drawSuperpixelOverlay(hObject,handles);
    msg = {'Please hit ''Save''' 'to store modifications'};
    set(handles.stStatus,'String',msg);
    
else 
    msg = {'Image not ready to' 'label yet. Compute' 'super pixels first'};
    set(handles.stStatus,'String',msg);
end

guidata(hObject, handles); 

end

% --- Executes on button press in btnDrawFreePolygon.
function btnDrawFreePolygon_Callback(hObject, eventdata, handles)

labelImg = handles.freeAnnotationLabels;
[m, n] = size(handles.img);

% TODO Fix the bug that this in not correctly set
if isempty(handles.freeAnnotationLabels)
    handles.freeAnnotationLabels = zeros(m, n);
end

% Draw polygon
[xi, yi] = getline;
disp([xi, yi])

% Get Pixels in polygon
overlayMask = poly2mask(xi, yi, m, n);
% imagesc(overlayMask)

% Change label of these Pixels
labelImg(overlayMask) = handles.selectedLabel ; % Colorize selected polygon

% Update the overlay
handles.freeAnnotationLabels = labelImg;
handles.isSaved = false; % Prompt user to save image
handles = drawAnnotationOverlay(hObject, handles, handles.freeAnnotationLabels);

msg = {'Please hit ''Save''' 'to store modifications'};
set(handles.stStatus, 'String', msg);

guidata(hObject, handles); 

end

% --- Executes on button press in btnSelectSuperpixels.
function btnSelectSuperpixels_Callback(hObject, eventdata, handles)
% Select an arbitrary number of points
% After selecting a point, get the corresponding superpixel ID
% Paint superpixel with the color selected

set(handles.myCanvas, 'Visible', 'on');
set(handles.myCanvas, 'PickableParts', 'all');
% disp(handles.myCanvas);

if ~isempty(handles.myCanvas)
    set(handles.myCanvas, 'ButtonDownFcn', @(src,eventdata)changeSuperpixelLabel(src,eventdata,hObject));
else
    msg = {'handles.myCanvas' 'is empty'};
    set(handles.stStatus,'String',msg);
end

end

% --- Executes on button press in btnChangePixel.
function btnChangePixel_Callback(hObject, eventdata, handles)

% Select an arbitrary single point
% After selecting a point, get the corresponding coordinates
% Label single pixel with the class selected

set(handles.myCanvas, 'Visible', 'on');
set(handles.myCanvas, 'PickableParts', 'all');
% disp(handles.myCanvas);

if ~isempty(handles.myCanvas)
    set(handles.myCanvas, 'ButtonDownFcn', @(src,eventdata)changePixelLabel(src,eventdata,hObject));
else
    msg = {'handles.myCanvas' 'is empty'};
    set(handles.stStatus,'String',msg);
end

end


%% Tools for pixel info

% --- Executes on button press in btnGetInfo.
function btnGetInfo_Callback(hObject, eventdata, handles)
% hObject    handle to btnGetInfo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.myCanvas, 'Visible', 'on');
set(handles.myCanvas, 'PickableParts', 'all');
% disp(handles.myCanvas);

if ~isempty(handles.myCanvas)
    set(handles.myCanvas, 'ButtonDownFcn', @(src,eventdata)printPixelLabel(src, eventdata, hObject));
    % set(gcf, 'WindowButtonDownFcn', @(src,eventdata)printPixelLabel(src, eventdata, hObject));
else
    msg = {'handles.myCanvas' 'is empty'};
    set(handles.stStatus, 'String', msg);
end

end

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
% save([handles.annoSuperpixelsDir '/'  handles.imgId '.mat'], 'anno' );
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
imshow(handles.img, 'Parent', handles.myCanvas);
handles.currentlyShownLabels = [];
guidata(hObject, handles);
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

%% Annotations

% --------------------------------------------------------------------
function menuLoadAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function menuSaveAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function menuLoadSuperpixelAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadSuperpixelAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = loadAndDrawSuperpixelsAnnotation(handles.imgIdx, hObject, handles);
guidata(hObject, handles);
end

% --------------------------------------------------------------------
function menuSaveSuperpixelAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveSuperpixelAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
annotationSuperpixelsToMat(handles);
end

% --------------------------------------------------------------------
function menuLoadFreeAnnotation_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadFreeAnnotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = loadAndDrawFreeAnnotation(handles.imgIdx, hObject, handles);
guidata(hObject, handles);
end

% --------------------------------------------------------------------
function menuSaveCurrentAsMat_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveCurrentAsMat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
annotationFreeToMat(handles);
end

% --------------------------------------------------------------------
function menuSaveCurrentAsPNG_Callback(hObject, eventdata, handles)
% hObject    handle to menuSaveCurrentAsPNG (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
annotationToPNG(handles.imgIdx, hObject, handles);
end

%% Inference

% --------------------------------------------------------------------
function menuInference_Callback(hObject, eventdata, handles)
% hObject    handle to menuInference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function menuLoadInference_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadInference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawInference(handles.imgIdx, hObject, handles, false);
end


% --------------------------------------------------------------------
function menuLoadInferenceCRF_Callback(hObject, eventdata, handles)
% hObject    handle to menuLoadInferenceCRF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawInference(handles.imgIdx, hObject, handles, true);
end

%% Add New Label

function etNewLabelName_Callback(hObject, eventdata, handles)
% hObject    handle to etNewLabelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etNewLabelName as text
%        str2double(get(hObject,'String')) returns contents of etNewLabelName as a double
end

% --- Executes during object creation, after setting all properties.
function etNewLabelName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etNewLabelName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end

function etNewRGBValues_Callback(hObject, eventdata, handles)
% hObject    handle to etNewRGBValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of etNewRGBValues as text
%        str2double(get(hObject,'String')) returns contents of etNewRGBValues as a double
end

% --- Executes during object creation, after setting all properties.
function etNewRGBValues_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etNewRGBValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

end


% --- Executes on button press in btnAddNewLabel.
function btnAddNewLabel_Callback(hObject, eventdata, handles)
% hObject    handle to btnAddNewLabel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newLabelName = get(handles.etNewLabelName, 'String');
% disp(newLabelName);
newRGBValuesCommaSeparated = get(handles.etNewRGBValues, 'String');
newRGBValues = str2num(newRGBValuesCommaSeparated);

% Check format of RGB Value input
if isempty(newRGBValues) || ~(length(newRGBValues) == 3) || ~all(newRGBValues >= 0 & newRGBValues <=255)
   disp('Invalid RGB-Values entered!');
   disp(newRGBValues);
   return;
end

% Remember: Have initialized
% handles.colorNames = colMap.colorNames;
% handles.colors = colMap.colorRGBValues;

handles.colorNames{end+1} = newLabelName;
handles.colors = [handles.colors; double(newRGBValues)]; 

% disp(handles.colors);

% Update the TableLabels with the new label
handles = updateTableLabels(handles);

% Save new values to 'colormap.mat'
colorNames = handles.colorNames;
colorRGBValues = handles.colors;
save('colormap.mat', 'colorNames', 'colorRGBValues');

% TODO Change NUM_CLASSES in config.yml

handles.YamlStruct.NUM_CLASSES = handles.YamlStruct.NUM_CLASSES + 1;
WriteYaml(handles.yaml_file, handles.YamlStruct);

guidata(hObject, handles);

end

%% Keyboard shortcuts

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% determine the key that was pressed 
keyPressed = eventdata.Key;

if strcmpi(keyPressed, 'f')
    % set focus to the button
    % uicontrol(handles.btnDrawFreePolygon);
    % call the callback
    btnDrawFreePolygon_Callback(handles.btnDrawFreePolygon, [], handles);
elseif strcmpi(keyPressed, 'i')
    btnGetInfo_Callback(handles.btnGetInfo, [], handles);
end

end
