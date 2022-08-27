%适用于电化学。
% 用于粗筛,记录记录的AO2 bias output，RT current， RT Conductance LogG


clc
clear 
close all
tic



[filename,filepath]=uigetfile('*.tdms','Select data files','MultiSelect','on');
if iscell(filename)
    filename1=filename;
else 
    filename1{1}=filename;
end

num_files = length(filename1)
%%
%记录的AO2 bias output，RT current， RT Conductance LogG


for n = 1:num_files
    struc=TDMS_readTDMSFile(filename1{n});
    data_bias=struc.data{1,3}; %A02 output Bias
    RT_Current=struc.data{1,4}; %current
    data_logG = struc.data{1,5};%logG


    subplot(num_files,1,n)
    
    x = 1:length(data_logG);
    yyaxis left
    %conductance
    plot(x, data_logG)
    title(filename1{n},'FontSize',15)
    ylabel('Conductance / log (\itG/\itG\rm_0)', 'Interpreter', 'tex','FontSize',10)
    xlabel({'Points'},'Interpreter','tex','FontSize',10)
    ylim([-9 5])
    
    yyaxis right
    %bias
    plot2 = plot(x, data_bias, 'LineWidth', 2, 'LineStyle','-');
    plot2.Color(4) = 0.6; %调节Color(4)这个参数可以设置不同的透明度
%     ylabel('Bias / V', 'FontSize' ,25)
    ylim([-1.5 3])
    
    
    %     clear test data_s
end




toc