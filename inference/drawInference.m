function drawInference(imgIdx, hObject, handles, withCRF)

% Reset the Canvas to just show the original image
handles.myCanvas = imshow(handles.img);

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
      fullMask = im2bw(int16(inferenceLabels));
      
      hold on
      overlay_final = ind2rgb(inferenceLabels, handles.colors);
      overlay_final = uint8(overlay_final);
      handles.myCanvas = imshow(overlay_final);
      alphaMask = double(fullMask)*0.5;
      set(handles.myCanvas, 'AlphaData', alphaMask);   
      hold off
      
      guidata(hObject, handles);
else
    disp('No Inference file found, generate it first!');
end

end