function handles = updateTableLabels(handles)

% Load the label names handles.colorNames into
% the LabelTable
set(handles.TableLabels, 'Data', handles.colorNames);
set(handles.TableLabels, 'ColumnWidth', {150});

% Change the background in the TableLabels
% Need to convert the RGB-values in handles.colors
% because 'BackgroundColor' expects values between 
% 0.0 and 1.0
% The multiplication with the factor >1 and addition of the delta
% is to make the colors lighter so that the text in the table is still readable
colorsScaled = (1/255)*handles.colors;
colorsDelta = 0.7*(1.0 - colorsScaled);
colorsScaled = colorsScaled + colorsDelta;
% disp(colorsScaled);
set(handles.TableLabels, 'BackgroundColor', colorsScaled);

end