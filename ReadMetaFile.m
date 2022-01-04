% This script just gets the acquition frame rate from the metadata text
% file by scanning for the 'D3Step' line that is followed by the fps in ms

function [fps,xPixelSize] = ReadMetaFile(folderPath,fileName)

try
    %Metafile have the same two letters (e.g. F5) as the corresponding
    %tif, so it´s rather easy to find it.
    metaFile = fullfile(folderPath,[strtok(fileName,'_'),'_metadata.txt']);
    metaFileOpen = fopen(metaFile) ;
    metaText = textscan(metaFileOpen,'%s') ;
    metaText = metaText{:};
    fclose(metaFileOpen);
    
    %The way the metaText file is read, every space starts a new row. So
    %"D3Step : xxx" are 3 different row. Upon identifying D3Step we have
    %to look for the value in the next but one field.
    % In older versions of MES the format was "D3Step: xxx", in those cases
    % the catch statement should help out as it will be triggered by the
    % ":" not being convertible to a number
    try
        D3Step = (str2double(metaText{find(strcmp(metaText,'D3Step'))+2}))/1000;
    catch
        D3Step = (str2double(metaText{find(strcmp(metaText,'D3Step:'))+1}))/1000;
    end
    fps = 1/D3Step;
    
    try
        xPixelSize = str2double(metaText{find(strcmp(metaText,'WidthStep'))+2});
    catch
        xPixelSize = str2double(metaText{find(strcmp(metaText,'WidthStep:'))+1});
    end
    
catch
    fps = inputdlg('Metadata file not found or information not accessible. Please check if metafile is present, e.g. for files names F10_UGpLG and F10_URpLR, metafile must be named "F10_metadata" and be present in the same folder');
end