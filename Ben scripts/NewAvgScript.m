%This script averages sessions of mice 

clc 
clear
%----------------------------------------------------------------
%This snipit selects the folder you wish to run on 
[newfolder] = uigetdir;
cd(newfolder)
filePattern1 = fullfile(newfolder);
% p = genpath(filePattern1);
% rr=[strfind(p, ';')];
%-------------------------------------------------------------------
%this line turns filepattern1 into a structure containing its subfolders
matfiles = dir(filePattern1); 
%-----------------------------------------------------------
%This block traverses the structure and loads each mat file iterativly, and
%stores the important info as a cumulative vectors which represent the
%licks above and below the threshold for across all sessions
item1=[];
count_mat = length(matfiles);
num_ses= count_mat-2; 
%prealocatin space for matrix storing Lick_logs, Lick_logs will be stored
%one after the othe and traversed sequentially. (from left to right. 
tLick_log= [];%zeros(5000,(count-2)*2);

%maximum stores the lenght of the longest length Lick_log file so that i
%can cut down the size of the matrix later. (if possible or nessesary)

freq=zeros(127*num_ses,100);
% cumulative_count=zeros(1,127);
 for num = 3:count_mat
     item = matfiles(num).name;
     load(item, '-mat');
     item1=[item];
     %here we want to create a large matrix with unique index instead of repeated 1-127 
     for i =1:length(Lick_log)
         for j = 1
             Lick_log(i,j)=(num-3)*127+Lick_log(i,j); %generates unique index
         end
     end
                 
     
     tLick_log=[tLick_log; Lick_log];
 end
     %-----------
     
     [row, col] = size(tLick_log);
     counts = []; %keeps track of the number of licks in each trial
     %new_thing=[]; %stores all times for trials in incereasing order...
     for i = 1  
         for k = 1:127*num_ses %keeps track of trial number
             new_thing=[]; %stores all times for trials in incereasing order...
             count = 0; % keeps track of number of licks per trial number
             for j = 1:row
                 if tLick_log(j,i)==k
                     count = count +1;
                     %new_thing=[new_thing;tLick_log(j,2)];
                 end
             end
             counts=[counts,count];
%              for v=1:length(counts)
%                  cumulative_count(v)=cumulative_count(v)+counts(v); %this is so we can place frequencies 
%              end
             
         end
         %frequency calculations begin here for each lick_log variable 
         for b=1:length(counts)%1-127 since there are 127 trials per session  
             if counts(b)==1 || counts(b)==0%cant calculate frequency when there are 0 or 1 lick since you need at least 2
                 continue
             else
                 skip=0;
                 temp=find(tLick_log==b,1,'first'); %finds first item of that type in the matrix and saves its index
                 for c=temp:temp+ counts(b)-2%-2 since you want add the number of items that have trial number of that type, then subtract 1 because you want n-1 iterations of this loop\
                     if skip == 1
                         skip = 0; 
                     else
                         period=tLick_log(c+1,2)-tLick_log(c,2);
                         if period >= 0.8
                             freq_calc=1/period;
                             freq(b,c-temp+1)=freq_calc; %b represents trial# and a represents frequency number
                         elseif period<0.8 && c+2<=temp+ counts(b)-2 % if the distance between licks is too small to be possible, we shall skip over the later one and calculate period using the later adjacent one 
                             period2=tLick_log(c+2,2)-tLick_log(c,2);
                             freq_calc=1/period2;
                             freq(b,c-temp+1)=freq_calc;
                             skip=1; %skip allows you to skip over the lick time you are not counting ( we are doing this because if licks are too close together they are not possible 
                         elseif period<0.8 && c+2>temp+ counts(b)-2
                         end
                     end
                 end
             end
         end
     end
                         
     %issues: each iteration of this for loop will overwrite the data from the previous iteration,
     %also (find function is yielding impossible values 
                     
                     
                     
                     
         
         
         
         
         
         
         
%              for g=1:length(new_thing)
%             
%                  if length(new_thing) >=2
%                      for u= 2:length(new_thing)
%                          freq=1/(new_thing(u)
%                     
%                          counts=[counts,count];
%                      end
%                  end
%      if count == 1
%          tLick_log=[Lick_log];
%      else
%      stLick_log=size(tLick_log);
%      sLick_log=size(Lick_log);
%      a=max(stLick_log(1),sLick_log(1));
%      %this line concatonates matrices of different sizes 
%      tLick_log=[[tLick_log;zeros(abs([a,0]-stLick_log))],[Lick_log;zeros(abs([a,0]-sLick_log))]];
%      end
     
     
 
%-----------------------------------------------------------------------


%now this block should traverse tLick_log
%it will count the number of licks in each trial there are and will also
%generate a new matrix called new_thing which has the times - the trials in
%order grouped together by trial.
% [row, col] = size(tLick_log);
% counts = []; %keeps track of the number of licks in each trial across all sessions for the mouse
% %new_thing=[]; %stores all times for trials in incereasing order...
% freqeuncies=[];
% for i = 1  
%     for k = 1:127 %keeps track of trial number
%         new_thing=[]; %stores all times for trials in incereasing order...
%         count = 0; % keeps track of number of licks per trial number
%         for j = 1:row
%             if tLick_log(j,i)==k
%                 count = count +1;
%                 new_thing=[new_thing;tLick_log(j,2)];
%             end     
%         end
%         for g=1:length(new_thing)
%             
%         if length(new_thing) >=2
%                 for u= 2:length(new_thing)
%                     freq=1/(new_thing(u)
%                     
%         counts=[counts,count];
%     end
% end
% 
% 
%------------------------------------------------------------------------------
%this block of code will find the frequencies for each trial (note this
%program makes the assumption that all sessions, since they are at the
%expert level, all should be similar enough to take them as one set



            
            
    
    

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 