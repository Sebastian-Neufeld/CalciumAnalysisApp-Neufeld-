function [stack,stackInfo] = ReadTif(filePath)
% This script read the tif stack and puts it into a variable for later
% handling and saves this variable into the same folder as the tif. SAving
% takes about 10x more time than reading, but subsequent loading adn
% storing of the data is better in .mat than in .tif format.
% A "Batch convert to .mat" option should be included

tic
[path,file,~] = fileparts(filePath);

stackInfo = imfinfo(filePath);
nFrames = length(stackInfo); 
stackInfo = stackInfo(1);
stackInfo.nFrames = nFrames;

% Preallocating the array made it approximately 30% faster
% The files have uint16 format anyway and it is sufficient. Double would
% take about 4 times as much memory and also longer computation time
% Using the Tiff object, to then 'read' was not really faster than using
% imread (about 5%), but it feels more fitting.
stack = zeros(stackInfo(1).Height, stackInfo(1).Width, nFrames,'uint16');
t = Tiff(filePath,'r');
for n = 1:nFrames
    t.setDirectory(n);
    stack(:,:,n) = read(t);
end
close(t);

[stackInfo.fps,stackInfo.xPixelSize] = ReadMetaFile(path,file);
if or(isempty(stackInfo.fps), isnan(stackInfo.fps))
    errordlg('Could not read Metadata File, please check if a metadata text file is present and is named like "F[number]_metadata" for files like "F[number]_something" - without further underscores')
    return
end

% Those three could be calculated here, but after preprocession their value
% will change anyway
stackInfo.mean = 0;
stackInfo.median = 0;
stackInfo.std = 0;
% Defining the fields here prevents other functions to throw error (empty
% fields will act fine)
stackInfo.cMin = 0;
stackInfo.cMax = 1;
stackInfo.substitutedFrames = [];


% tic
% for i = 1:100
%     stack = zeros(stackInfo(1).Height, stackInfo(1).Width, nFrames,'uint16');
%     t = Tiff(filePath,'r');
%     for n = 1:nFrames
%         t.setDirectory(n);
%         stack(:,:,n) = read(t);
%     end
%     close(t);
% end
% toc


% stack = zeros(stackInfo(1).Height, stackInfo(1).Width, nFrames,'uint16');
% tic
% for i = 1:100
%     for n = 1:nFrames
%         stack(:,:,n) = imread(filePath,n);
%     end
% end
% toc
