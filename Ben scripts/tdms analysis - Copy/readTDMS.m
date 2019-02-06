%By CRL. Uses TDMS functions downloaded from matlab central. 
%data is acquired at 100 Hz in LabView

% clc
% clear
% 
% [newfolder] = uigetdir;
% cd(newfolder)
% filePattern = fullfile(newfolder, '*.tdms');
% tdmsfiles = dir(filePattern);
count = length(tdmsfiles);

for num = 1:count;
    
    my_tdms_struct = TDMS_getStruct(tdmsfiles(num, 1).name);
    
    fulldata = my_tdms_struct.Untitled.Untitled.data; %This is a cell structure pathway
    
    for step = 1:size(fulldata, 2)
        if step == 1;
            Ch_1(1,1) = fulldata(1, step);
        elseif step == 2;
            Ch_2(1,2) = fulldata(1, step);
        elseif mod(step, 2) == 1;
            Ch_1 = [Ch_1, fulldata(1, step)];
        else mod(step, 2) == 0;
            Ch_2 = [Ch_2, fulldata(1, step)];
        end
    end
    
    if num == 1;
        lick_data = Ch_1;
    else
        for col = 1:size(Ch_1, 2);
            lick_data(num, col) = Ch_1(1, col);
        end
    end
    clear Ch_1 Ch_2
end

lick_data(find(lick_data == 0)) = NaN;

display('Data extraction has completed successfully');

save('lick_data.mat' , 'lick_data')