function varargout = imageMetadata(varargin)
% IMAGEMETADATA MATLAB code for imageMetadata.fig
%      IMAGEMETADATA, by itself, creates a new IMAGEMETADATA or raises the existing
%      singleton*.
%
%      H = IMAGEMETADATA returns the handle to a new IMAGEMETADATA or the handle to
%      the existing singleton*.
%
%      IMAGEMETADATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMAGEMETADATA.M with the given input arguments.
%
%      IMAGEMETADATA('Property','Value',...) creates a new IMAGEMETADATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before imageMetadata_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to imageMetadata_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help imageMetadata

% Last Modified by GUIDE v2.5 16-May-2018 21:14:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageMetadata_OpeningFcn, ...
                   'gui_OutputFcn',  @imageMetadata_OutputFcn, ...
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
% End initialization code - DO NOT EDIT
end


% --- Executes just before imageMetadata is made visible.
function imageMetadata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to imageMetadata (see VARARGIN)

% Choose default command line output for imageMetadata
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageMetadata wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = imageMetadata_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes when selected cell(s) is changed in TableMetadata.
function TableMetadata_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TableMetadata (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
end
