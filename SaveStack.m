function stackInfo = SaveStack(dataPath, fileName, stack, stackInfo)
% SaveStack saves the .mat file with all experimental data and the
% information about the stack. This functions ensures the stackInfo fits
% the current situation of the stack, e.g. after cropping

if ~isfolder(dataPath)
    mkdir(dataPath)
end

stackPath = [dataPath, fileName, '_stack.mat'];
stackInfoPath = [dataPath, fileName, '_stackInfo.mat'];

% Whenever we save the stack, some properties will have changed and
% those values are re-evaluated here to be sure
% cMin and cMax values are already in the stackInfo and don´t have to
% be recomputed here
stackInfo.Width   = size(stack,2);
stackInfo.Height  = size(stack,1);
stackInfo.nFrames = size(stack,3);

stackInfo.mean   = mean(stack,3);
stackInfo.median = median(stack,3);
%std only works on single/double
stackInfo.std    = std(single(stack),0,3);

save(stackPath, 'stack');
save(stackInfoPath, 'stackInfo');
    
end

