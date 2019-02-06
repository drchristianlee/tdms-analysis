%first make matrix called the_matrix where you store all pathways that you
%want to process, only use 1 col... make another matrix called
%per_mouse_avg where you put names of mice in order they are stored in in
%folders

%need to account for the various thresholds cuz at the moment i cant 
y=input('input an upper thrshold');
z=input('input a lower theshold'); 
avg_matrix=[];
tot_avg=[];

    [newfolder]=uigetdir;
    cd(newfolder)
    FilePattern=fullfile(newfolder);
    p=genpath(FilePattern);
    sepPath=[strfind(p,';')];
    if mod(length(sepPath),2)~=0
        matrix=[];
        for i=2:2:length(sepPath)
            matrix=[matrix, p(sepPath(i)+1:sepPath(i+1)-1)];
        end
        the=[strfind(matrix, 'R:')];
    else
        matrix=[];
        for i=2:2:length(sepPath)-1
            matrix=[matrix, p(sepPath(i)+1:sepPath(i+1)-1)];
        end
        matrix=[matrix,  p(sepPath(length(sepPath)-1):sepPath(length(sepPath)))];
        the=[strfind(matrix, 'R:')];  
    end
    
    
    for yyy=1:length(the-1)
    %THIS SEPERATES OUT THE DIFFERENT TDMS PATHWAYS STORED IN MATRIX FOR
    %THE PURPOSE OF CHANGIN THE DIRECTORY
    if length(the)<8 
        if yyy~=length(the)
            gh=[matrix(the(yyy):the(yyy+1)-1)];
        else
           gh=[matrix(the(yyy):length(matrix))];
        end
            
    elseif length(the)==8
        if yyy~=8
        gh=[matrix(the(yyy):the(yyy+1)-1)]; 
        else
            gh=[matrix(the(yyy):length(matrix))];
        end
    end
    cd(gh)
    filePattern = fullfile(gh, '*.tdms');
    tdmsfiles = dir(filePattern);
    readTDMS
    
    lData=lick_data;
    [m,n]=size(lick_data);
    avg_matrix_baseline=[];
    for i=1:50
        for j=1:n
            if lData(i,j)>y
                time=j.*0.01;
                avg_matrix_baseline=[avg_matrix_baseline; i,time,lick_data(i,j)];
            elseif lData(i,j)<z
                time=j.*0.01;
                avg_matrix_baseline=[avg_matrix_baseline; i,time,lick_data(i,j)];
            end
        end
    end
    avg_matrix_nbaseline=[];
    for i=51:m
        for j=1:n
            if lData(i,j)>y
                time=j.*0.01;
                avg_matrix_nbaseline=[avg_matrix_nbaseline; i,time,lick_data(i,j)];
            elseif lData(i,j)<z
                time=j.*0.01;
                avg_matrix_nbaseline=[avg_matrix_nbaseline; i,time,lick_data(i,j)];
            end
        end
    end
    avg_below=mean(avg_matrix_baseline(:,2));
    avg_above=mean(avg_matrix_nbaseline(:,2));
    
    %in future make it on a per mouse basis, for now it is total across all
    %mice differentiating between m1 and s1
    if length(the-1)<8 && yyy<3
        avg_matrix=[avg_matrix;avg_below,avg_above,0,0];
    elseif length(the-1)<8 && yyy>2
        avg_matrix=[avg_matrix;0,0,avg_below,avg_above];
    end
    if length(the-1)>=8 && yyy<5
        avg_matrix=[avg_matrix;avg_below,avg_above,0,0];
    elseif length(the-1)>=8 && yyy>4
        avg_matrix=[avg_matrix;0,0,avg_below,avg_above];
    end
    end
    
    
    
[A,B]=size(avg_matrix);
if A>4
    sum1=avg_matrix(1,1)+avg_matrix(2,1)+avg_matrix(3,1)+avg_matrix(4,1);
    sum1=sum1/4;
    sum2=avg_matrix(1,2)+avg_matrix(2,2)+avg_matrix(3,2)+avg_matrix(4,2);
    sum2=sum2/4;
    sum3=avg_matrix(5,3)+avg_matrix(6,3)+avg_matrix(7,3)+avg_matrix(8,3);
    sum3=sum3/4;
    sum4=avg_matrix(5,4)+avg_matrix(6,4)+avg_matrix(7,4)+avg_matrix(8,4);
    sum4=sum4/4;
    disp(sum1)
    disp(sum2)
    disp(sum3)
    disp(sum4)
end
  
if A<5
    sum1=avg_matrix(1,1)+avg_matrix(2,1);
    sum1=sum1/2;
    sum2=avg_matrix(1,2)+avg_matrix(2,2);
    sum2=sum2/2;
    sum3=avg_matrix(3,3)+avg_matrix(4,3);
    sum3=sum3/2;
    sum4=avg_matrix(3,4)+avg_matrix(4,4);
    sum4=sum4/2;
end
%wrong should be calculating not time but number of licks 

    
    
    
    