

clc 
clear
x=input('input a grace period');
y=input('input an upper thrshold');
z=input('input a lower theshold'); 
led=input('if led session input 1 else input 0');

            
if led == 1
    ap= input('if only am is led input 1, if only pm is led input 2, if both are led then input 3');
    Norm_baseline_bottom= input('What is the bottom value for the typical baseline for this date?');
    Norm_baseline_top=input('What is the top value for the typical baseline for this date?');
    Num_of_diff_baslines = input('How many of the mice have atypical baselines');
    if Num_of_diff_baslines==0
    else
        urn=0;
        urn_bottom=[];
        urn_top=[];
        for i=1: Num_of_diff_baslines
            urn=[urn, input('Input the name of an atypical trial as you would see it in the computerfile ex. M1chr2-36am Must match this form exactly!!', 's')];
            urn_bottom=[urn_bottom, input('Input the bottom value for the baseline for this atypical trial')];
            urn_top=[urn_top, input('Input the top value for the baseline for this atypical trial')];
        end
    end
end

cnt4graph=[];
cnt4graph1=[];
% if led == 0
%      ax= input('if only am is led input 1, if only pm is led input 2, if both are led then input 3');
% end
% pos=[strfind(filePattern, '\')];
% location= [filePattern(1:pos(6)+11)]; 



% TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT
% [newfolder] = uigetdir;
% cd(newfolder)
% filePattern = fullfile(newfolder, '*.tdms');
% tdmsfiles = dir(filePattern);

[newfolder] = uigetdir;
cd(newfolder)
filePattern1 = fullfile(newfolder);
p = genpath(filePattern1);
rr=[strfind(p, ';')];

%THIS AA STEP IS SIGNIFIGANT FOR NAMING THE GRAPHS, CAPTURES EVERYTHING
%BEFORE TDMS BUT NOT INCLUDING TDMS
aa = [];
for i=1:2:length(rr)-1
    aa=[aa, p(rr(i)+1:rr(i+1)-1)];
end
ee=[strfind(aa, 'R:')];
%MATRIX DOES THE SAME THING AS AA BUT CAPTURES TDMS 
if mod(length(rr),2)~=0
matrix=[];
for i=2:2:length(rr)
    matrix=[matrix, p(rr(i)+1:rr(i+1)-1)];
end
vv=[strfind(matrix, 'R:')];
else
    matrix=[];
for i=2:2:length(rr)-1
    matrix=[matrix, p(rr(i)+1:rr(i+1)-1)];
end
matrix=[matrix,  p(rr(length(rr)-1):rr(length(rr)))];
vv=[strfind(matrix, 'R:')]; 
end
    
globalcount=0;    
for yyy=8 %1:length(vv-1)
    %if on_button==1 than the program should produce 
    on_button=0;
    globalcount=globalcount+1;
    %THIS SEPERATES OUT THE DIFFERENT TDMS PATHWAYS STORED IN MATRIX FOR
    %THE PURPOSE OF CHANGIN THE DIRECTORY
    if length(vv)<8 
        if yyy~=length(vv)
            gh=[matrix(vv(yyy):vv(yyy+1)-1)];
        else
           gh=[matrix(vv(yyy):length(matrix))];
        end
            
    elseif length(vv)==8
        if yyy~=8
        gh=[matrix(vv(yyy):vv(yyy+1)-1)]; 
        else
            gh=[matrix(vv(yyy):length(matrix))];
        end
    end
    
    %meant to make special baselines for the histogram generateration 
    if led ~=0
    temp_lower=0;
    temp_upper=0;
    for i=1:Num_of_diff_baslines
        vect=[strfind(gh, urn(i))]; 
        if ~(isempty(vect))
            on_button=1;
            temp_lower= urn_bottom(i);
            temp_upper= urn_top(i);
            break
        end
    end
    end
%     [U,Q]=size(lick_data);
%     LEDon_lower= U-temp_upper;
%     LEDon_upper= U;
    
    
    cd(gh)
    filePattern = fullfile(gh, '*.tdms');
    tdmsfiles = dir(filePattern);
    %USED FOR NAMING ....
    if length(vv)<8
        if yyy~= length(vv)
            mm= [aa(ee(yyy):ee(yyy+1)-1)];
        else
             mm=[aa(ee(yyy):length(aa))];
        end
    elseif length(vv)==8
        if yyy~=8
            mm= [aa(ee(yyy):ee(yyy+1)-1)];
        else
            mm=[aa(ee(yyy):length(aa))];
        end
    end
    readTDMS
    [U,Q]=size(lick_data);
    if led~=0
    LEDon_lower= U-temp_upper;
    LEDon_upper= U;
    end
    %make odd case 
    % subdir_info = dir(newfolder);
    % subdir_info(~[subdir_info.isdir]) = [];         %get rid of non folders
    % subdir_info(ismember({subdir_info.name}, {'.', '..'})) = [];  %get rid of . and ..
    % subdir_names = fullfile(newfolder, {subdir_info.name});    %construct list of names
    % 
% for i=1:length(subdir_names)
%     tt = {subdir_names(1,i) '\tdms files'};
%    
%     
%     
%     
% end
% x=input('input a grace period');
% y=input('input an upper thrshold');
% z=input('input a lower theshold');
% pos=[strfind(filePattern, '\')];
% location= [filePattern(1:pos(6)+11)];


b=lick_data;
[m,n]=size(lick_data);
peaks_and_vallies_above_and_below_noise=[];
Lick_log=[];
Times=[];%intended for use as a global time tracker
%B=zeros(m,1);
C=zeros(1,4);
for i=1:m 
    Times_per_trial=[];
    for j=1:n
        if b(i,j)>y       %slightly above the noise reading... meant to weed out background noise when finding the peaks and other stuff.
            %there might be an issue with the time calculation 
            time=j.*0.01;%-3.15;%422;
            Times_per_trial=[Times_per_trial;time];
            Times=[Times;time];
            peaks_and_vallies_above_and_below_noise=[peaks_and_vallies_above_and_below_noise;i,time,lick_data(i,j)]; 
        elseif b(i,j)<z  %2.48   %2.5
            time=j.*0.01;%-3.15;%422; 
            Times_per_trial=[Times_per_trial;time];
            Times=[Times;time];
            peaks_and_vallies_above_and_below_noise=[peaks_and_vallies_above_and_below_noise;i,time,lick_data(i,j)]; 
            
        end
    end
end
B=zeros(length(Times),1);

%THIS CREATES THE 4TH COL IN PEAKS AND VALLIES SO WE CAN DETECT LICKS 

count=1;
countodd=1;

if mod(length(Times),2)~=0 
    for k=2:2:(length(Times-1))
        if Times(k)-Times(k-1)<=0.5 
            B(k)=1;
            B(k-1)=1;
        else
            B(k)=0;
            count=count+1;
            
            
            %B(k-1)=0;
            
        end
      
    end
    for g=3:2:length(Times)
        if Times(g)-Times(g-1)<=0.5
            B(g)=1;
            B(g-1)=1;
        else
            B(g)=0;
            count=countodd+1;
            
            %B(g-1)=0;
        end
    end
% %         if k>2 && Times(k-1)-Times(k-2)<=0.1%0.160
% %             B(k-1)=1;
% %         else
% %             B(k-1)=0;
% %         end
% % %         if k>2 && Times(k)-Times(k-2)<=0.320
% % %             B(k)=1;
% % %             B(k-1)=1;
% % %         else
% % %             B(k)=0;
% % %         end
% % % %begin
% %         if Times(length(Times))-Times(length(Times)-1)<=0.1
% %             B(length(Times))=1;
% %             B(length(Times)-1)=1;
% %         else
% %             B(length(Times))=0;
% %             B(length(Times)-1)=0;
% %         end
% %         if Times(length(Times))-Times(length(Times)-2)<=0.320
% %             B(length(Times))=1;
% %             B(length(Times)-1)=1;
% %         else
% %             B(length(Times))=0;
% %         end
        %end 
elseif mod(length(Times),2)==0
    for p=2:2:length(Times)
        if Times(p)-Times(p-1)<=0.5
            B(p)=1;
            B(p-1)=1;
        else
            B(p)=0;
            count=count+1;
            
            %B(p-1)=0;
            
        end
        for j=3:2:length(Times-1)
            if Times(j)-Times(j-1)<=0.5
                B(j)=1;
                B(j-1)=1;
            else
                B(j)=0;
                count=countodd+1;
                
            end
        end
    end
end

    
    

%THIS BLOCK TAKES INTO ACCOUNT THE GRACE PERIOD WHEN REPRESENTING LICK_LOG
%NEGATE THIS PART IF IT IS A LICK TRIAL !!!

for i=2:2:length(B)
    for j=1
        if Times(i,j)<= x%0.7%for tests 0.5
            B(i,j)=0;
        end
    end
end

% end 
peaks_and_vallies_above_and_below_noise=[peaks_and_vallies_above_and_below_noise,B];
[m,n]=size(peaks_and_vallies_above_and_below_noise);

%IF THE DIFFERENCE BETWEEN ADJACENT TIMES IS LESS THAN A CERTAIN VALUE THEY
%ARE PART OF THE SAME LICK???

if mod(length(peaks_and_vallies_above_and_below_noise),2)~=0 
    for k=2:2:length(peaks_and_vallies_above_and_below_noise-1)%+(count)
        for i=2
            if peaks_and_vallies_above_and_below_noise(k,i)-peaks_and_vallies_above_and_below_noise(k-1,i)<=0.5 && peaks_and_vallies_above_and_below_noise(k,i)>=.5
                peaks_and_vallies_above_and_below_noise= [peaks_and_vallies_above_and_below_noise(1:k-1,:); C; peaks_and_vallies_above_and_below_noise(k,:); C; peaks_and_vallies_above_and_below_noise(k+1:end,:)];
            end
            for g=3:2:length(peaks_and_vallies_above_and_below_noise-1)%+(countodd)
                if peaks_and_vallies_above_and_below_noise(g,i)-peaks_and_vallies_above_and_below_noise(g-1,i)<=0.5 && peaks_and_vallies_above_and_below_noise(g,i)>=.5
                    peaks_and_vallies_above_and_below_noise= [peaks_and_vallies_above_and_below_noise(1:g-1,:); C; peaks_and_vallies_above_and_below_noise(g,:); C; peaks_and_vallies_above_and_below_noise(g+1:end,:)];
                end
            end
        end
    end
end
if mod(length(peaks_and_vallies_above_and_below_noise),2)==0 
    for k=2:2:length(peaks_and_vallies_above_and_below_noise)%+(count)
        for i=2
            if peaks_and_vallies_above_and_below_noise(k,i)-peaks_and_vallies_above_and_below_noise(k-1,i)<=0.5 && peaks_and_vallies_above_and_below_noise(k,i)>=.5
                peaks_and_vallies_above_and_below_noise= [peaks_and_vallies_above_and_below_noise(1:k-1,:); C; peaks_and_vallies_above_and_below_noise(k,:); C; peaks_and_vallies_above_and_below_noise(k+1:end,:)];
            end
            for g=3:2:length(peaks_and_vallies_above_and_below_noise-1)%+(countodd)
                if peaks_and_vallies_above_and_below_noise(g,i)-peaks_and_vallies_above_and_below_noise(g-1,i)<=0.5 && peaks_and_vallies_above_and_below_noise(g,i)>=.5
                    peaks_and_vallies_above_and_below_noise= [peaks_and_vallies_above_and_below_noise(1:g-1,:); C; peaks_and_vallies_above_and_below_noise(g,:); C; peaks_and_vallies_above_and_below_noise(g+1:end,:)];
                end
            end
        end
    end
end

%second grace period thingy 
[m,n]=size(peaks_and_vallies_above_and_below_noise);
for i=1:m
    for j=2
        if peaks_and_vallies_above_and_below_noise(i,j)<= x%0.7%for tests0.5 
            peaks_and_vallies_above_and_below_noise(k,4)=0;
        end
    end
end





%below block removes 010 pattern to isolate real licks and eradicate false
%readings

% if mod(m,2)~=0
%     for i=3:2:m
%         for j=4
%             if peaks_and_vallies_above_and_below_noise(i,j)==0 && peaks_and_vallies_above_and_below_noise(i-2,j)==0
%                 peaks_and_vallies_above_and_below_noise(i-1,j)=0;
%             end
%         end
%         for O=4:2:m-1
%             for Y=4
%                 if peaks_and_vallies_above_and_below_noise(O,Y)==0 && peaks_and_vallies_above_and_below_noise(O-2,Y)==0
%                     peaks_and_vallies_above_and_below_noise(O-1,Y)=0;
%                 end
%             end
%         end
%     end
% elseif mod(m,2)==0
%     for i=3:2:m-1
%         for j=4
%             if peaks_and_vallies_above_and_below_noise(i,j)==0 && peaks_and_vallies_above_and_below_noise(i-2,j)==0
%                 peaks_and_vallies_above_and_below_noise(i-1,j)=0;
%             end
%         end
%         for O=4:2:m
%             for Y=4
%                 if peaks_and_vallies_above_and_below_noise(O,Y)==0 && peaks_and_vallies_above_and_below_noise(O-2,Y)==0
%                     peaks_and_vallies_above_and_below_noise(O-1,Y)=0;
%                 end
%             end
%         end
%     end
% end


[U,Q]=size(lick_data);


%This next block of code attempts to add a row of zeros after last item in
%each trial in peaks_and_vallies_above_and... For reasons pertaining to the

count=1;
for v=1:m %+(U-1)
    for h=1
        [m,n]=size(peaks_and_vallies_above_and_below_noise);
        if count==1 && peaks_and_vallies_above_and_below_noise(v,h)~= count
            count=count+1;
            peaks_and_vallies_above_and_below_noise= [peaks_and_vallies_above_and_below_noise(1:v-1,:); C; peaks_and_vallies_above_and_below_noise(v:end,:)];
        elseif peaks_and_vallies_above_and_below_noise(v,h)~= count && peaks_and_vallies_above_and_below_noise(v,h)>count
            count=count+1;
            peaks_and_vallies_above_and_below_noise= [peaks_and_vallies_above_and_below_noise(1:v-1,:); C; peaks_and_vallies_above_and_below_noise(v:end,:)];
        end
    end
end


for g=2:m%+(U-1)
    for e=n:n
        [m,n]=size(peaks_and_vallies_above_and_below_noise);
        if g==2 && peaks_and_vallies_above_and_below_noise(g-1,e)==1 
            Lick_log=[Lick_log;peaks_and_vallies_above_and_below_noise(g-1,1),peaks_and_vallies_above_and_below_noise(g-1,2)];
            
        elseif peaks_and_vallies_above_and_below_noise(g,e)==1 && peaks_and_vallies_above_and_below_noise(g-1,e)==0
            Lick_log=[Lick_log;peaks_and_vallies_above_and_below_noise(g,1),peaks_and_vallies_above_and_below_noise(g,2)];
        end
    end
end
%for quantitiative analysis kinda
[A,B]=size(Lick_log);
count11=0;
count12=0;
for i=1:A
    for j=1
        if Lick_log(i,j)<=50 && Lick_log(i,2)>=3.15 && Lick_log(i,2)<=5.15
            count11=count11+1;
        elseif Lick_log(i,j)>50 && Lick_log(i,2)>=3.15 && Lick_log(i,2)<=5.15
            count12=count12+1;
        end
    end
end

if strfind(gh,'M1')~=0
    cnt4graph=[cnt4graph;count11,count12];
elseif strfind(gh,'S1')~=0
    cnt4graph1=[cnt4graph1;count11,count12];
end

            

% %HERE FOR GRACE PERIOD 
% [p,q]=size(Lick_log);
% count=1;
% for i=1:p
%     for j=2
%         if Lick_log(i,j)<=x || Lick_log(i,j)>=2.0 %0.7 and 2 respectivly 
%             count=count+1;
%         end
%     end
% end
% 
% for i=1:p-count
%     for j=2
%         if Lick_log(i,j)<=x || Lick_log(i,j)>=2 %0.7 and 2 respectivly 
%             Lick_log=[Lick_log(1:i-1,:); Lick_log(i+1:end,:)];
%         end
%     end
% end


disp ('the') 



%FIRST HISTOGRAM OPTION IS HERE 111111111111111111
if led==0%THE ERROR !!!!!!!
    [B,G]=size(Lick_log);
    Z=[Lick_log(:,2,:)];
    Z=transpose(Z);
    T=[Lick_log(:,1,:)];
    T=transpose(T);
    grtime=0;
    for i=1:length(Z)
        if Z(i) > grtime
            grtime=Z(i);
        end
    end
    
   %THIS STEP GENERATES PART OF THE NAME OF EACH GRAPH  
    a=[strfind(filePattern,'\')];
    first=[filePattern(a(5)+1:a(6)-1)];
    second=[filePattern(a(6)+1:a(7)-1)];
    name=[second ' ' first];
    
%     a=[strfind(filePattern, '20180')];
%     b=[strfind(filePattern, '20170')];
%     c=[strfind(filePattern, '20171')];
%     if ~isempty(a)
%         first = [filePattern(a(1):a(1)+7)];
%         second = [filePattern(a(1)+9:a(1)+19)];
%         name = [second ' ' first];
%     elseif ~isempty(b)
%         first = [filePattern(b(1):b(1)+7)];
%         name = [second ' ' first];
%     elseif ~isempty(c)
%         first = [filePattern(c(1):c(1)+7)];
%         second = [filePattern(c(1)+9:c(1)+10)];
%         name = [second ' ' first]; 
%     end


if led==1 && ap==1
    if strfind(mm, 'am') ~= 0
        name=[name 'LED'];
    elseif strfind(mm, 'pm')~=0
        name = [name 'No LED'];
    end
elseif led==1 && ap==2 
    if strfind(mm, 'pm')~= 0 
        name = [name 'LED'];
    elseif strfind(mm, 'am')~=0
        name = [name 'No LED'];
    end
elseif led ==1 && ap==3 
    %if strfind(mm, 'pm') || strfind(mm, 'am')
        name = [name 'LED'];
   %end
end

if led==0
    name=[name 'No LED'];
end

% if led==0 && ax==1
%     if strfind(mm, 'am') ~= 0
%     name=[name 'No LED'];
%     end
% elseif led==1 && ax==2
%     if strfind(mm, 'pm')~= 0 
%     name = [name 'No LED'];
%     end
% elseif led ==1 && ax==3 
%     if strfind(mm, 'pm') || strfind(mm, 'am')
%     name = [name 'No LED'];
%     end
%end

%HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

p4 = mode(Z);
ptest= p4*100;
if mod(ptest, 5)==0 && mod(ptest,10)==0
    lowerBound= p4-0.1;
    upperBound= p4+0.1;
else
lowerBound= floor(p4*10)/10;
upperBound= ceil(p4*10)/10;
end
countz=0;
for i = 1:length(Z)
    if Z(i) >=lowerBound && Z(i)<=upperBound
        countz = countz +1;
    end 
end 


name2= name;
num=1;
hold on
rectangle('position',[0 countz+2 grtime 2.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5
rectangle('position',[0 countz+2 5.15 2.5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 countz+2 3.15 2.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);
% for i = 1:40
% y=line([0,7],[i,i]) ; 
% y.Color = 'black';
% end
histogram(Z,'BinWidth',0.1,'EdgeColor',[0 0 0], 'FaceColor', [0 0 1 ],'FaceAlpha',1);

% [N,bincntr] = hist(Z);
% Dz = mean(diff(bincntr));


% pos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
% width = pos(3);
% height = pos(4);



%ledgend generation included here 

title('Reaction Times Over Time');
xlabel('Time');
ylabel('Number of Trials');
h = zeros(2, 1);
h(1) = plot(0,0,'r', 'visible', 'off');
h(2) = plot(0,0,'g', 'visible', 'off');
legend(h, 'Non-Presentation Window','Presentation Window');
hold off

% Large=0;
% [N,edges] = histcounts(Z);
% for i=1:length(N)
%     if N(i) > Large
%         Large = N(i);
%     end
% end

if num==1
    name = [name 'Histogram.png'];
end
saveas(gcf,fullfile(mm, name))
close all
num=2;
hold on
rectangle('position',[0 U+5 grtime 5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);%135
rectangle('position',[0 U+5 5.15 5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 U+5 3.15 5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);
sz = linspace(1,7,1);
scatter(Z,T,sz,'b','filled')
title('Times of Licks Occuring Per Trial');
xlabel('Time');
ylabel('Trial');
h = zeros(2, 1);
h(1) = plot(0,0,'r', 'visible', 'off');
h(2) = plot(0,0,'g', 'visible', 'off');
legend(h, 'Non-Presentation Window','Presentation Window', 'location', 'southwest');
hold off
if num==2 
    name2 = [name2 'Scatter Plot.png'];
end
saveas(gcf,fullfile(mm, name2),'png')
close all




elseif led==1 && on_button==0 && (ap==1 || ap==2 || ap==3)
    [B,G]=size(Lick_log);
    Z=[Lick_log(:,2,:)];
    counting=0;
    Z2=[];
    Z3=[];
    for i = 1:B
        for j=1
            if Lick_log(i,j)<=Norm_baseline_top
                Z2=[Z2, Lick_log(i,2)];
            else
                Z3=[Z3, Lick_log(i,2)];
            end
        end
    end
    
    T=[Lick_log(:,1,:)];
%     T2=[T(temp_lower:temp_upper)];
%     T3=[T(LEDon_lower:LEDon_upper)];
%     T2=transpose(T2);
%     T3=transpose(T3);
    

    grtime=0;
    for i=1:length(Z)
        if Z(i) > grtime
            grtime=Z(i);
        end
    end
%make this find the most common number and the number of times it was
%present so i can adjust the vertical hight of the color bars
  
a=[strfind(filePattern,'\')];
    first=[filePattern(a(5)+1:a(6)-1)];
    second=[filePattern(a(6)+1:a(7)-1)];
    name=[second ' ' first];

% a=[strfind(filePattern, '20180')];
% b=[strfind(filePattern, '20170')];
% c=[strfind(filePattern, '20171')];
% if ~isempty(a)
%     first = [filePattern(a(1):a(1)+7)];
%     second = [filePattern(a(1)+9:a(1)+19)];
%     name = [second ' ' first];
% elseif ~isempty(b)
%     first = [filePattern(b(1):b(1)+7)];
%     second = [filePattern(b(1)+9:b(1)+10)];
%     name = [second ' ' first];
% elseif ~isempty(c)
%     first = [filePattern(c(1):c(1)+7)];
%     second = [filePattern(c(1)+9:c(1)+10)];
%     name = [second ' ' first]; 
% end


%shorten this!!!!!!!!!!

if ap==1
        if strfind(mm, 'am') ~= 0
            name=[name 'LED'];
        end
elseif ap==2
        if strfind(mm, 'pm')~= 0 
            name = [name 'LED'];
        end
elseif ap==3
        name = [name 'LED'];
        %end
end
    


%HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
p4 = mode(Z);
ptest= p4*100;
if mod(ptest, 5)==0 && mod(ptest,10)==0
    lowerBound= p4-0.1;
    upperBound= p4+0.1;
else
lowerBound= floor(p4*10)/10;
upperBound= ceil(p4*10)/10;
end
countz3=0;
for i = 1:length(Z)
    if Z(i) >=lowerBound && Z(i)<=upperBound
        countz3 = countz3 +1;
    end 
end 


p2 = mode(Z2);
ptest= p2*100;
if mod(ptest, 5)==0 && mod(ptest,10)==0
    lowerBound= p2-0.1;
    upperBound= p2+0.1;
else
lowerBound= floor(p2*10)/10;
upperBound= ceil(p2*10)/10;
end
countz=0;
for i = 1:length(Z2)
    if Z2(i) >=lowerBound && Z2(i)<=upperBound
        countz = countz +1;
    end 
end 

p1 = mode(Z3);
ptest= p1*100;
if mod(ptest, 5)==0 && mod(ptest,10)==0
    lowerBound= p1-0.1;
    upperBound= p1+0.1;
else
lowerBound= floor(p1*10)/10;
upperBound= ceil(p1*10)/10;
end
countz1=0;
for i = 1:length(Z3)
    if Z3(i) >=lowerBound && Z3(i)<=upperBound
        countz1 = countz1 +1;
    end 
end 

sub=ceil(countz3/4);
replace=countz3-sub;
name2= name;
num=1;
set(gca,'DefaultTextFontSize',18)
hold on
rectangle('position',[0 replace grtime .75], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5 countz3+2
rectangle('position',[0 replace 5.15 .75], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);%countz3+2
rectangle('position',[0 replace 3.15 .75], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);%countz3+2
% for i = 1:40
% y=line([0,7],[i,i]) ; 
% y.Color = 'black';
% end
histogram(Z2,'BinWidth',0.1,'EdgeColor',[1 1 1], 'FaceColor', [0 0 0 ],'FaceAlpha',1);
xlim([0,7])
% [N,bincntr] = hist(Z);
% Dz = mean(diff(bincntr));


% pos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
% width = pos(3);
% height = pos(4);
title('Reaction Times Over Time - Baseline','FontSize',20);
xlabel('Time','FontSize',16);
ylabel('Number of Trials','FontSize',16);
set(gca,'linewidth',2);
%CHANGE BACK LATER UNCOMMENT 
% h = zeros(2, 1);
% h(1) = plot(0,0,'r', 'visible', 'off');
% h(2) = plot(0,0,'g', 'visible', 'off');
% legend(h, 'Non-Presentation Window','Presentation Window');
hold off
% Large=0;
% [N,edges] = histcounts(Z);
% for i=1:length(N)
%     if N(i) > Large
%         Large = N(i);
%     end
% end
nameb=[];
if num==1
    nameb = [name 'Histogram Baseline.png'];
end
saveas(gcf,fullfile(mm, nameb), 'png')
close all


%HIST 2 BEGINS HERE 1111111111111111111111
set(gca,'DefaultTextFontSize',18)
hold on
rectangle('position',[0 replace grtime 1.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5 countz1+2
rectangle('position',[0 replace 5.15 1.5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);%countz1+2
rectangle('position',[0 replace 3.15 1.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);%countz1+2

histogram(Z3,'BinWidth',0.1,'EdgeColor',[1 1 1], 'FaceColor', [0 0 0],'FaceAlpha',1);
xlim([0,7])
title('Reaction Times Over Time - Non-Baseline','FontSize',20);
xlabel('Time','FontSize',16);
ylabel('Number of Trials','FontSize',16);
set(gca,'linewidth',2);
% h = zeros(2, 1);
% h(1) = plot(0,0,'r', 'visible', 'off');
% h(2) = plot(0,0,'g', 'visible', 'off');
% legend(h, 'Non-Presentation Window','Presentation Window');
hold off

namea=[];
if num==1
    namea = [name 'Histogram non-Baseline.png'];
end
saveas(gcf,fullfile(mm, namea))
close all

%HIST3 BIGINS HERE11111111111111111111111
hold on
set(gca,'DefaultTextFontSize',18)
rectangle('position',[0 replace grtime 2.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5countz3+2
rectangle('position',[0 replace 5.15 2.5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);%countz3+2
rectangle('position',[0 replace 3.15 2.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);%countz3+2

histogram(Z,'BinWidth',0.1,'EdgeColor',[1 1 1], 'FaceColor', [0 0 0],'FaceAlpha',1);
xlim([0,7])
title('Reaction Times Over Time - Total','FontSize',16);
xlabel('Time','FontSize',16);
ylabel('Number of Trials','FontSize',16);
set(gca,'linewidth',2);
% h = zeros(2, 1);
% h(1) = plot(0,0,'r', 'visible', 'off');
% h(2) = plot(0,0,'g', 'visible', 'off');
% legend(h, 'Non-Presentation Window','Presentation Window');
hold off

namea=[];
if num==1
    namea = [name 'Histogram Total.png'];
end
saveas(gcf,fullfile(mm, namea))
close all


%SCATTER PLOT BEGINS HERE1111111111111111111111111
set(gca,'DefaultTextFontSize',18)
num=2;
hold on
rectangle('position',[0 U+5 grtime 5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);%135
rectangle('position',[0 U+5 5.15 5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 U+5 3.15 5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);

y=line([0,grtime],[50,50]) ; 
y.Color = 'black'; 

sz = linspace(1,7,1);
scatter(Z,T,sz,'k','filled')
xlim([0,7])
title('Times of Licks Occuring Per Trial','FontSize',20);
xlabel('Time','FontSize',16);
ylabel('Trial','FontSize',16);
set(gca,'linewidth',2);
% h = zeros(2, 1);
% h(1) = plot(0,0,'r', 'visible', 'off');
% h(2) = plot(0,0,'g', 'visible', 'off');
% legend(h, 'Non-Presentation Window','Presentation Window', 'location', 'southwest');
hold off
if num==2 
    name = [name2 'Scatter Plot.png'];
end
saveas(gcf,fullfile(mm, name2),'png')
close all
%end




elseif on_button==1
    [B,G]=size(Lick_log);
    Z=[Lick_log(:,2,:)];
    counting=0;
    Z2=[];
    Z3=[];
    for i = 1:B
        for j=1
            if Lick_log(i,j)<=urn_top
                Z2=[Z2, Lick_log(i,2)];
            else
                Z3=[Z3, Lick_log(i,2)];
            end
        end
    end
    
    T=[Lick_log(:,1,:)];
%     T2=[T(temp_lower:temp_upper)];
%     T3=[T(LEDon_lower:LEDon_upper)];
%     T2=transpose(T2);
%     T3=transpose(T3);
    

    grtime=0;
    for i=1:length(Z)
        if Z(i) > grtime
            grtime=Z(i);
        end
    end
%make this find the most common number and the number of times it was
%present so i can adjust the vertical hight of the color bars


a=[strfind(filePattern,'\')];
    first=[filePattern(a(5)+1:a(6)-1)];
    second=[filePattern(a(6)+1:a(7)-1)];
    name=[second ' ' first];
     
% a=[strfind(filePattern, '20180')];
% b=[strfind(filePattern, '20170')];
% c=[strfind(filePattern, '20171')];
% if ~isempty(a)
%     first = [filePattern(a(1):a(1)+7)];
%     second = [filePattern(a(1)+9:a(1)+19)];
%     name = [second ' ' first];
% elseif ~isempty(b)
%     first = [filePattern(b(1):b(1)+7)];
%     second = [filePattern(b(1)+9:b(1)+10)];
%     name = [second ' ' first];
% elseif ~isempty(c)
%     first = [filePattern(c(1):c(1)+7)];
%     second = [filePattern(c(1)+9:c(1)+10)];
%     name = [second ' ' first]; 
% end


%shorten this!!!!!!!!!!
trigger=0;
trigger1=0;
trigger2=0;
if ap==1
        if strfind(mm, 'am') ~= 0
            name=[name 'LED'];
            trigger=1;
        end
elseif ap==2
        if strfind(mm, 'pm')~= 0 
            name = [name 'LED'];
            trigger1=1;
        end
elseif ap==3
        name = [name 'LED'];
        trigger2=1;
        %end
end
    
% if led==0 && ax==1
%     if strfind(mm, 'am') ~= 0
%     name=[name 'No LED'];
%     end
% elseif led==1 && ax==2
%     if strfind(mm, 'pm')~= 0 
%     name = [name 'No LED'];
%     end
% elseif led ==1 && ax==3 
%     if strfind(mm, 'pm') || strfind(mm, 'am')
%     name = [name 'No LED'];
%     end
%end

%HERE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
p4 = mode(Z);
ptest= p4*100;
if mod(ptest, 5)==0 && mod(ptest,10)==0
    lowerBound= p4-0.1;
    upperBound= p4+0.1;
else
lowerBound= floor(p4*10)/10;
upperBound= ceil(p4*10)/10;
end
countz3=0;
for i = 1:length(Z)
    if Z(i) >=lowerBound && Z(i)<=upperBound
        countz3 = countz3 +1;
    end 
end 


p2 = mode(Z2);
ptest= p2*100;
if mod(ptest, 5)==0 && mod(ptest,10)==0
    lowerBound= p2-0.1;
    upperBound= p2+0.1;
else
lowerBound= floor(p2*10)/10;
upperBound= ceil(p2*10)/10;
end
countz=0;
for i = 1:length(Z2)
    if Z2(i) >=lowerBound && Z2(i)<=upperBound
        countz = countz +1;
    end 
end 

p1 = mode(Z3);
ptest1= p1*100;
if mod(ptest1, 5)==0 && mod(ptest1,10)==0 
    lowerBound= p1-0.1;
    upperBound= p1+0.1;
else
lowerBound= floor(p1*10)/10;
upperBound= ceil(p1*10)/10;
end
countz1=0;
for i = 1:length(Z3)
    if Z3(i) >=lowerBound && Z3(i)<=upperBound
        countz1 = countz1 +1;
    end 
end 


name2= name;
num=1;
hold on
rectangle('position',[0 countz+2 grtime .75], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5
rectangle('position',[0 countz+2 5.15 .75], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 countz+2 3.15 .75], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);
% for i = 1:40
% y=line([0,7],[i,i]) ; 
% y.Color = 'black';
% end
histogram(Z2,'BinWidth',0.1,'EdgeColor',[0 0 0], 'FaceColor', [0 0 1 ],'FaceAlpha',1);

% [N,bincntr] = hist(Z);
% Dz = mean(diff(bincntr));


% pos = get(gcf, 'Position'); %// gives x left, y bottom, width, height
% width = pos(3);
% height = pos(4);





title('Reaction Times Over Time - Baseline');
xlabel('Time');
ylabel('Number of Trials');
h = zeros(2, 1);
h(1) = plot(0,0,'r', 'visible', 'off');
h(2) = plot(0,0,'g', 'visible', 'off');
legend(h, 'Non-Presentation Window','Presentation Window');
hold off

% Large=0;
% [N,edges] = histcounts(Z);
% for i=1:length(N)
%     if N(i) > Large
%         Large = N(i);
%     end
% end
namec=[];
if num==1
    namec = [name 'Histogram Baseline.png'];
end
saveas(gcf,fullfile(mm, namec))
close all


%HIST 2 BEGINS HERE 1111111111111111111111
hold on
rectangle('position',[0 countz1+2 grtime 1.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5
rectangle('position',[0 countz1+2 5.15 1.5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 countz1+2 3.15 1.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);

histogram(Z3,'BinWidth',0.1,'EdgeColor',[0 0 0], 'FaceColor', [0 0 1 ],'FaceAlpha',1);

title('Reaction Times Over Time - Non-Baseline');
xlabel('Time');
ylabel('Number of Trials');
h = zeros(2, 1);
h(1) = plot(0,0,'r', 'visible', 'off');
h(2) = plot(0,0,'g', 'visible', 'off');
legend(h, 'Non-Presentation Window','Presentation Window');
hold off

named=[];
if num==1
    named = [name 'Histogram Non-Baseline.png'];
end
saveas(gcf,fullfile(mm, named))
close all

%HIST 3 BEGINS HERE1111111111111111

hold on
rectangle('position',[0 countz3+2 grtime 2.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]); %37.5
rectangle('position',[0 countz3+2 5.15 2.5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 countz3+2 3.15 2.5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);

histogram(Z,'BinWidth',0.1,'EdgeColor',[0 0 0], 'FaceColor', [0 0 1 ],'FaceAlpha',1);

title('Reaction Times Over Time - Total ');
xlabel('Time');
ylabel('Number of Trials');
h = zeros(2, 1);
h(1) = plot(0,0,'r', 'visible', 'off');
h(2) = plot(0,0,'g', 'visible', 'off');
legend(h, 'Non-Presentation Window','Presentation Window');
hold off

namea=[];
if num==1
    namea = [name 'Histogram Total.png'];
end
saveas(gcf,fullfile(mm, namea))
close all



%SCATTER PLOT BEGINS HERE1111111111111111111111111
num=2;
hold on
rectangle('position',[0 U+5 grtime 5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);%135
rectangle('position',[0 U+5 5.15 5], 'EdgeColor',[0 1 0], 'FaceColor', [0 1 0 ]);
rectangle('position',[0 U+5 3.15 5], 'EdgeColor',[1 0 0], 'FaceColor', [1 0 0 ]);
sz = linspace(1,7,1);
scatter(Z,T,sz,'b','filled')
title('Times of Licks Occuring Per Trial');
xlabel('Time');
ylabel('Trial');
h = zeros(2, 1);
h(1) = plot(0,0,'r', 'visible', 'off');
h(2) = plot(0,0,'g', 'visible', 'off');
legend(h, 'Non-Presentation Window','Presentation Window', 'location', 'southwest');
hold off

if num==2 
    name = [name2 'Scatter Plot.jpg'];
end
saveas(gcf,fullfile(mm, name2),'png')
close all
end

    
end

if globalcount >= 4

test_keeper=[];
[A,B]=size(cnt4graph);
sum1=0;
sum2=0;
for i=1:A/2
    for j=1:B
        if j==1
          sum1=sum1+cnt4graph(i,j);
        else
            sum2=sum2+cnt4graph(i,j);
        end
    end
end
Sum1=0;
Sum2=0;
for i=A/2:A
    for j=1:B
        if j==1
          Sum1=Sum1+cnt4graph(i,j);
        else
            Sum2=Sum2+cnt4graph(i,j);
        end
    end
end

avg_bslinem11=sum1/50;
% M1='M1 average licks before baseline';
% disp(M1)
% disp(avg_bslinem11)
avg_nbslinem12=sum2/77;
% M1A='M1 average licks after baseline';
% disp(M1A)
% disp(avg_nbslinem12)
test_keeper=[test_keeper;avg_bslinem11,avg_nbslinem12];
avg_bslinem111=Sum1/50;
avg_nbslinem112=sum2/77;
test_keeper=[test_keeper;avg_bslinem111,avg_nbslinem112];

%beginning of general_bar_graphs script 
barkeeper(1,1) = nanmean(test_keeper(:,1));
barkeeper(1,2) = nanmean(test_keeper(:, 2));
nanfinder = isnan(test_keeper);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_keeper(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_keeper(:, 2), 1)) - nanvals(1, 2));
barkeeper(2,1) = nanstd(test_keeper(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_keeper(:,2))/denominator2;

figure
bar(barkeeper(1,:), 'b');
hold on;
errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');
hold on;

for points = 1:size(test_keeper, 1);
    plot(test_keeper(points, 1:2) , '-o', 'color' , 'black', 'MarkerFaceColor', 'black')
    hold on
end

 axis([0 3 0 10])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 160 210])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 [h p ci stats] = ttest(test_keeper(:, 1), test_keeper(:, 2))
 
 saveas(gcf,fullfile(mm, 'bargraph of licks M1'),'png')
 hold off 
 close all 

 %end of bar graph script 

 

test_keeper=[];
[AA,BB]=size(cnt4graph1);
sum11=0;
sum12=0;
for i=1:AA/2
    for j=1:BB
        if j==1
          sum11=sum11+cnt4graph1(i,j);
        else
            sum12=sum12+cnt4graph1(i,j);
        end
    end
end
Sum11=0;
Sum12=0;
for i=AA/2:AA
    for j=1:BB
        if j==1
          Sum11=Sum11+cnt4graph1(i,j);
        else
            Sum12=Sum12+cnt4graph1(i,j);
        end
    end
end
avg_bslines1=sum11/50;
% S1='S1 average licks below baseline';
% disp(S1)
% disp(avg_bslines1)
avg_nbslines1=sum12/77;
% S1A='S1 average licks above baseline';
% disp(S1A)
% disp(avg_nbslines1)
test_keeper=[test_keeper;avg_bslines1,avg_nbslines1];
avg_bslines1111=Sum11/50;
avg_nbslines1112=Sum12/77;
test_keeper=[test_keeper;avg_bslines1111,avg_nbslines1112];
%beginning of general_bar_graphs script 
barkeeper(1,1) = nanmean(test_keeper(:,1));
barkeeper(1,2) = nanmean(test_keeper(:, 2));
nanfinder = isnan(test_keeper);
nanvals = sum(nanfinder, 1);
denominator1 = sqrt((size(test_keeper(:, 1), 1)) - nanvals(1, 1));
denominator2 = sqrt((size(test_keeper(:, 2), 1)) - nanvals(1, 2));
barkeeper(2,1) = nanstd(test_keeper(:,1))/denominator1;
barkeeper(2,2) = nanstd(test_keeper(:,2))/denominator2;

figure
bar(barkeeper(1,:), 'b');
hold on;
errorbar(barkeeper(1,:), barkeeper(2,:), '.', 'color', 'k', 'marker', 'none');
hold on;

for points = 1:size(test_keeper, 1);
    plot(test_keeper(points, 1:2) , '-o', 'color' , 'black', 'MarkerFaceColor', 'black')
    hold on
end

 axis([0 3 0 10])
 set(gca,'TickDir','out')
 set(gca, 'box', 'off')
 set(gcf,'position',[680 558 160 210])
 set(gca, 'TickLength', [0.025 0.025]);
 set(gca,'FontSize',9);
 
 [h p ci stats] = ttest(test_keeper(:, 1), test_keeper(:, 2))
 
 saveas(gcf,fullfile(mm, 'bargraph of licks S1'),'png')
 hold off 
 close all 
end

 %end of bar graph script 




% %Fix this up later for M1 
% set(gca,'DefaultTextFontSize',18)        
% hold on
% x=[1,2];
% d=[avg_bslinem1,avg_nbslinem1];
% bar(x,d)
% set(gca,'XTick',(1:2))
% set(gca,'xticklabel',{'Before Baseline','After Baseline'},'FontSize',12);
% ylabel('Average Number of Licks','FontSize',12);
% set(gca,'linewidth',2);
% title('Average Number of Lick Per Trial Before and After Stimulation','FontSize',13);
% hold off
% saveas(gcf,fullfile(mm, 'bargraph of licks M1'),'png')
% close all
% 
% 
% %Fix this up later for s1 
% set(gca,'DefaultTextFontSize',18)        
% hold on
% x=[1,2];
% d=[avg_bslines1,avg_nbslines1];
% bar(x,d)
% set(gca,'XTick',(1:2))
% set(gca,'xticklabel',{'Before Baseline','After Baseline'},'FontSize',12);
% ylabel('Average Number of Licks','FontSize',12);
% set(gca,'linewidth',2);
% title('Average Number of Lick Before and After Stimulation','FontSize',13);
% hold off
% saveas(gcf,fullfile(mm, 'bargraph of licks S1'),'png')
% close all

