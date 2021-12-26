%% 2ptBatchProcessing_Ver0
%   =======================================================================================
%   =======================================================================================
clear,clc;
mainPath = 'C:\Users\linji\Desktop\ljh'; % scan target folder
hasCh2 =true;       % whether has channel 2

TargetLabel = 'ch2'; % the target images folder
ch2Lable = 'follow'; % channel 2 images folder

TargetType = 1; % only support folder
filetype = 'tif';% the target image type
%% 
cd(mainPath);
TargetList = scanDir(mainPath,TargetLabel,TargetType);
TargetList = TargetList';
save TargetList;
len = size(TargetList,1);
for i = 1:len
    TargetFolder = TargetList{i};
    disp(['Exporting ',TargetFolder]);
    cd(TargetFolder);
    targetPack = dir(['*.',filetype]);
    filesNO = size(targetPack,1);
    TargetNum(i) = filesNO;
    for j = 1:filesNO
        IMsingle = imread(targetPack(j).name);
        imwrite(IMsingle,[TargetFolder,'.tif'],'WriteMode','append');
    end
end
disp('Exporting finished!');
%% Motion_correction
if ~exist('TargetList')
    cd(mainPath);
    load('TargetList.mat');
end
SettingsMatName = 'C:\Users\linji\Desktop\EZcalcium\ez_settings.mat'; % the location of ez_settings.mat
load(SettingsMatName);

j = 0;
for i = 1:len
    if(~isempty(strfind(TargetList{i},ch2Lable)))
        continue;
    end
    j = j + 1;
    TargetFiles{j,1} = [TargetList{i},'.tif'];
end
motcor_settings.to_process_list = TargetFiles;
motcor_settings.has_channel2 = hasCh2;
save(SettingsMatName, 'motcor_settings');
cd('C:\Users\linji\Desktop\EZcalcium'); % the loacation of EZcalcium
Mfiledir = pwd;
packDir = fileparts(Mfiledir);
addpath(genpath(Mfiledir));%add path for searching functions
% cd([Mfiledir,'\EZcalcium-master']);
disp('Motion orrection...');
% ezcalcium;
ez_motion_correction;
beep;
pause(1);
beep;

% for i = 1:len
%     TargetFiles{i,1} = [TargetList{i},'.tif'];
%     delete([TargetFolder,'.tif']);
% end
%%   =======================================================================================
function TargetList = scanDir(CurrentPath,TargetLabel,TargetType)
files = dir(CurrentPath);
len = length(files);
TargetList = {};
index = 1;
for i = 1 : len
    if (strcmp(files(i).name, '.') == 1) ...
            || (strcmp(files(i).name, '..') == 1)
        continue;
    end
    if files(i).isdir == 1
        CurrentPath1 = [CurrentPath, '\', files(i).name];
        disp(CurrentPath1);
        tmpName = scanDir(CurrentPath1,TargetLabel,TargetType);
        for j = 1 : length(tmpName)
            TargetList{index} = tmpName{j};
            index = index + 1;
        end
    end
    switch TargetType
        case 1
            if files(i).isdir == 1 && ~isempty(strfind(files(i).name,TargetLabel))
                TargetList{index} = fullfile(CurrentPath, '\', files(i).name);
                index = index + 1;
            end
        case 2
            if files(i).isdir == 0 && ~isempty(strfind(files(i).name,TargetLabel))
                TargetList{index} = fullfile(CurrentPath, '\', files(i).name);
                index = index + 1;
            end
        case 3
            if ~isempty(strfind(files(i).name,TargetLabel))
                TargetList{index} = fullfile(CurrentPath, '\', files(i).name);
                index = index + 1;
            end
    end 
end
end


function[dessert] = confirm_follow_process(question)
answer = questdlg(question, 'confirm dialog', 'Yes', 'No', 'Yes');

% Handle response
dessert = 1;
switch answer
    case 'Yes'
        dessert = true;
    case 'No'
        dessert = false;
end
end