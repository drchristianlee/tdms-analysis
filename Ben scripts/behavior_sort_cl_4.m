% djm modified
% reads behavior .txt file recorded by labview and converts to .mat file
%note that this routine does not deal with auto rewards. It includes them
%as Gos. 9.16.14 crl. This was repaired 9.24.14 by crl

clear;
[file, path] = uigetfile('*.txt');
cd(path);
namelength = length(file);
keeplength = namelength - 4;
filename = file(1:keeplength);
mouseID = file(1:(keeplength-10));   %JW added mouseID to be saved later
session_date = [file((keeplength-7):keeplength),file((keeplength-9):(keeplength-8))];   %JW added this to save the session date, ending in am or pm
%filename = 'gcamp120130113ca';
%filename = 'markedpm20140207';

% mouse = 'D:\DATA\textureDiscrim\thintrin1_2\thin01\';
% session = 'thin01-4';

% mouse = 'D:\DATA\textureDiscrim\gcamp_1_2_3_4\gcamp01\';
% session = 'gcamp01-13ca\';
% 
% cd([mouse session]); % start in session directory, e.g. thin01-17


tdfread([filename '.txt']);
%Date = cellstr(Date);
Event = cellstr(Event);
Time = cellstr(Time);

a = size(Event);
a = a(1);

digitsTime = length(Time{1,1}); %% 13
digitsFromEnd = 6;

decision_log =[];
item = {'id' 'Trial' 'Time' 'Texture' 'Decision' 'Go' 'No Go' 'Miss' 'False Alarm'};
item = {'id' 'Trial' 'Time' 'Texture' 'Decision' 'GoTime' 'Go' 'No Go' 'Miss' 'False Alarm' 'FAtime' 'Auto'}; %crl added extra headings
decision_log = [decision_log, item];
id = 1;

for i = 1:a
    if strcmp(Event(i),'Begin Trial + Recording') || strcmp(Event(i),'Begin Trial w/o Recording') || strcmp(Event(i),'Begin Trial / Recording')
        item = {num2str(id) num2str(Trial(i)) '' '' '' '' '' '' '' '' '' ''}; %% djm added extra field, crl added extra fields
        decision_log = [decision_log; item];
        id = id + 1;
    elseif strcmp(Event(i),'End Trial')     %% djm was 'End Trial / Recording' 
        time = Time{i};
        time = char(time);
        time = time(1:8);
        decision_log{id,3} = time;
    elseif strfind(Event{i}, 'Te') == 1     %% findstr('Te', Event{i}) == 1
        decision_log{id,4} = Event{i};
    elseif findstr('Go', Event{i}) == 1
        if findstr('Auto Reward', Event{i-2}) == 1
            decision_log{id, 12} = '1';
            decision_log{id, 5} = Event{i-2};
        else
        decision_log{id,5} = Event{i};
        decision_log{id,7} = '1';   %% djm was 6
        %%% djm get time from stimulus to go response
        tGo = Time{i,1};
        tGo = str2num(tGo(digitsTime-digitsFromEnd:digitsTime));
        for j=i-4:i
            if strfind(Event{j}, 'Stimulus') == 1
                tStim = Time{j,1};
                break
            end
        end
        tStim = str2num(tStim(digitsTime-digitsFromEnd:digitsTime));
        GoTime = tGo-tStim;
        %%% to account for early minute 0-60 s problem
        if GoTime < 0
            tStim = 60-tStim;
            GoTime = tGo+tStim;
        end
        %%%
        decision_log{id,6} = num2str(GoTime);   
        end
    elseif findstr('Re', Event{i}) == 4
        decision_log{id,5} = Event{i};
        decision_log{id,9} = '1';   %% djm was 8
    elseif findstr('No', Event{i}) == 1
        decision_log{id,5} = Event{i};
        decision_log{id,8} = '1';   %% djm was 7
    elseif findstr('In', Event{i}) == 1
        decision_log{id,5} = Event{i};
        decision_log{id,10} = '1';   %% djm was 9
         %%% crl get time from stimulus to go response
        tFA = Time{i,1};
        tFA = str2num(tFA(digitsTime-digitsFromEnd:digitsTime));
        for j=i-3:i
            if strfind(Event{j}, 'Stimulus') == 1
                tStim = Time{j,1};
                break
            end
        end
        tStim = str2num(tStim(digitsTime-digitsFromEnd:digitsTime));
        FAtime = tFA-tStim;
        %%% to account for early minute 0-60 s problem
        if FAtime < 0
            tStim = 60-tStim;
            FAtime = tFA+tStim;
        end
         decision_log{id,11} = num2str(FAtime);
    end
end

% djm get list of trials for each type

Gos = [];
NoGos = [];
Misses = [];
FAs = [];
GoTimes = [];
FAtimes = [];

Go_col = 7;
NoGo_col = 8; 
Miss_col = 9;
FA_col = 10;
GoTimes_col = 6;

for i = 2:length(decision_log)
    if decision_log{i,Go_col} == '1'
        ind = length(Gos) + 1;
        Gos(ind) = str2double(decision_log{i,1});
        GoTimes(ind) = str2double(decision_log{i,6});
    elseif decision_log{i,NoGo_col} == '1'
        ind = length(NoGos) + 1; 
        NoGos(ind) = str2double(decision_log{i,1});
    elseif decision_log{i,Miss_col} == '1'
        ind = length(Misses) + 1; 
        Misses(ind) = str2double(decision_log{i,1});
    elseif decision_log{i,FA_col} == '1'
        ind = length(FAs) + 1; 
        FAs(ind) = str2double(decision_log{i,1}); 
        FAtimes(ind) = str2double(decision_log{i, 11});
    
    end      
end
%cd ..
save ('decision_log_v4', 'decision_log', 'Gos', 'NoGos', 'Misses', 'FAs', 'GoTimes', 'FAtimes', 'mouseID', 'session_date');
%xlswrite(['dec_' filename '.xls'],decision_log);