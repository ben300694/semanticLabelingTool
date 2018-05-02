function handles = drawInference(imgIdx, hObject, handles, withCRF)

% Save current zoom settings
Limits = get(gca,{'xlim','ylim'});

% Reset the Canvas to just show the original image
handles.myCanvas = imshow(handles.img);
handles.currentlyShownLabels = [];

fullInferencePath = [handles.inferenceDir '/'  handles.imgId '.mat'];

if exist(fullInferencePath, 'file')
      struc = load(fullInferencePath);
      
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
      fullMask = im2bw(int16(inferenceLabels));
      
      hold on
          overlay_final = ind2rgb(inferenceLabels, handles.colors);
          overlay_final = uint8(overlay_final);
          handles.myCanvas = imshow(overlay_final);
          alphaMask = double(fullMask)*handles.alphaValue;
          set(handles.myCanvas, 'AlphaData', alphaMask);   
      hold off
      
else
    disp('No Inference file found, generate it first!');
end

% Restore old zoom settings
zoom reset
set(gca, {'xlim','ylim'}, Limits)

guidata(hObject, handles);

end