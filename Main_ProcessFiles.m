%save single traces every FileInAGroup groups
clc
clear
close all
tic
                    %%%%%%%设置参数%%%%%
FileInAGroup = 30       %how many group per save
n_bins = 300;           %固定值

logG_start = -8;        %电导（y轴）的取值范围，低导
logG_end = -2;          %电导（y轴）的取值范围，高导
GateV_start = -1;       %gate电压（x轴）扫描的区间开始
GateV_end = 1;          %gate电压（x轴）扫描的区间结束
                    
                    %%%%%筛选条件%%%%%
m_begin = -4.5;         %开始的10个点需要大于这个电导
m_end = -5.5;           %结束的最后10个点需要大于这个电导

 

[filename,filepath] = uigetfile('*.tdms','Select data files','MultiSelect','on');
if iscell(filename)
    filename1=filename;
else
    filename1{1}=filename;
end

num_file = length(filename1);  %number of files selected

% data_bias=cell(1,100);


if num_file >= FileInAGroup
    %every FileInAGroup groups
    for i = 1 : num_file/FileInAGroup
        logG_rest = [];
        bias_rest = [];
        MatrixData = zeros(n_bins);
        
        for j = FileInAGroup*(i-1) + 1 : FileInAGroup*i
            test = TDMS_readTDMSFile(filename1{j});
            data_bias = test.data{1,3};
            data_logG = test.data{1,5};
            [TempBias, TempLogG] = CutAndSelect(data_bias,data_logG,m_begin,m_end);
            
            logG_rest=[logG_rest,TempLogG];
            bias_rest = [bias_rest, TempBias];
            clear test data_bias data_logG TempBias TempLogG
            fprintf('File: %s\n',filename1{j}); % Present the number
        end
        
        Matrix = GenerateHist(bias_rest, logG_rest, GateV_start, GateV_end, logG_start, logG_end);
        
        MatrixData = MatrixData + Matrix;
        clear bias_rest logG_rest Matrix
        
        NameSave = ['MatrixData_' num2str(i) '.mat'];
        save(NameSave, 'MatrixData')
        fprintf('Save: %s\n',NameSave);
    end
    
    %if it is not the intergrate of FileInAGroup, save remaining files
    if rem(num_file, FileInAGroup) ~= 0  
        logG_rest = [];
        bias_rest = [];
        MatrixData = zeros(n_bins);
        for k = FileInAGroup*i + 1 : num_file 
            test=TDMS_readTDMSFile(filename1{k});
            data_bias=test.data{1,3};
            data_logG=test.data{1,5};
            [TempBias, TempLogG] = CutAndSelect(data_bias,data_logG,m_begin,m_end);
           
            logG_rest=[logG_rest,TempLogG];
            bias_rest = [bias_rest, TempBias];
            clear test data_bias data_logG TempBias TempLogG
            fprintf('File: %s\n',filename1{k}); % Present the number
        end
        %矩阵
        Matrix = GenerateHist(bias_rest, logG_rest, GateV_start, GateV_end, logG_start, logG_end);
        
        MatrixData = MatrixData + Matrix;
        clear bias_rest logG_rest Matrix
        
        NameSave = ['MatrixData_' num2str(i+1) '.mat']; 
        save(NameSave, 'MatrixData')
        fprintf('Save: %s\n',NameSave);
    end
else
    %if the number of the file is below FileInAGroup, just save *.mat
    logG_rest = [];
    bias_rest = [];
    MatrixData = zeros(n_bins);
    for i = 1 : num_file
        test=TDMS_readTDMSFile(filename1{i});
        data_bias=test.data{1,3};
        data_logG=test.data{1,5};
        [TempBias, TempLogG] = CutAndSelect(data_bias,data_logG,m_begin,m_end);
           
        logG_rest=[logG_rest,TempLogG];
        bias_rest = [bias_rest, TempBias];
        clear test data_bias data_logG TempBias TempLogG
        fprintf('File: %s\n',filename1{i}); % Present the number
    end
        
    Matrix = GenerateHist(bias_rest, logG_rest, GateV_start, GateV_end, logG_start, logG_end);
        
    MatrixData = MatrixData + Matrix;
    clear bias_rest logG_rest Matrix
        
    NameSave = ['MatrixData_1.mat'];
    save(NameSave, 'MatrixData')
    disp('Save: MatrixData_1.mat\n');
    
end





toc