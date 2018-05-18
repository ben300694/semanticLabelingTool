function handles = drawInference(imgIdx, hObject, handles, withCRF)

% Save current zoom settings
Limits = get(gca,{'xlim','ylim'});

% Reset the Canvas to just show the original image
currentCanvas = imshow(handles.img, 'Parent', handles.myCanvas);
set(currentCanvas, 'HitTest', 'off');
handles.currentlyShownLabels = [];

handles.fullInferencePath = [handles.inferenceDir '/'  handles.imgId '.mat'];

if exist(handles.fullInferencePath, 'file')
      struc = load(handles.fullInferencePath);
      
      if (withCRF == true)
            if isfield(struc,'labels_crf')
                inferenceLabels = struc.labels_crf;
            else
                disp('No Inference with CRF found, generate it first!');
                return
            end
      else
            inferenceLabels = struc.labels;
      end
      handles.currentlyShownLabels = inferenceLabels;
      handles.freeAnnotationLabels = inferenceLabels;
      fullMask = im2bw(int16(inferenceLabels));
      
      hold on
          overlay_final = ind2rgb(inferenceLabels, handles.colors);
          overlay_final = uint8(overlay_final);
          currentCanvas = imshow(overlay_final, 'Parent', handles.myCanvas);
          set(currentCanvas, 'HitTest', 'off');
          alphaMask = double(fullMask)*handles.alphaValue;
          set(currentCanvas, 'AlphaData', alphaMask);   
      hold off
else
    disp('No Inference file found, generate it first!');
end

set(handles.myCanvas, 'Visible', 'on');
set(handles.myCanvas, 'PickableParts', 'all');

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

guidata(hObject, handles);

end