function [Bias_rest, LogG_rest] = CutAndSelect(data_bias, data_logG, beginLogG, endLogG)

%scanrange = -1V ~ +1V 



bias_swipe = data_bias(data_bias ~= 0);
logG_swipe = data_logG(data_bias ~= 0);


ForwardBias = [];
ForwardLogG = [];
points = length(bias_swipe);
for i = 2 : points-1
%     if (bias_swipe(i) - bias_swipe(i-1) > 0) && (bias_swipe(i+1) - bias_swipe(i) > 0)
%     if bias_swipe(i+1) - bias_swipe(i) > 0

    if bias_swipe(i) - bias_swipe(i-1) > 0    
        ForwardBias = [ForwardBias, bias_swipe(i)];
        ForwardLogG = [ForwardLogG, logG_swipe(i)];
    end
end

%分曲线
Diff = abs(diff(ForwardBias));
TraceIndex_temp = find(Diff > 0.5);
if ~isempty(TraceIndex_temp) && TraceIndex_temp(1) ~= 1 
    
    TraceIndex = [0 TraceIndex_temp length(ForwardBias)];%加上头加上尾
    LenTraceIndex = length(TraceIndex);
    TraceNum = 1;

    if max(Diff) < 1.5
        for j = 1: 2: LenTraceIndex - 1 
            Bias_slice{TraceNum} = ForwardBias(TraceIndex(j)+1 : TraceIndex(j+1));
            LogG_slice{TraceNum} = ForwardLogG(TraceIndex(j)+1 : TraceIndex(j+1));
            TraceNum = TraceNum + 1;
        end
    else
        for j = 1: 1: LenTraceIndex - 1 
            Bias_slice{TraceNum} = ForwardBias(TraceIndex(j)+1 : TraceIndex(j+1));
            LogG_slice{TraceNum} = ForwardLogG(TraceIndex(j)+1 : TraceIndex(j+1));
            TraceNum = TraceNum + 1;
        end
    end
else
    TraceIndex = [0 TraceIndex_temp(2:end) length(ForwardBias)];%加上头加上尾
    LenTraceIndex = length(TraceIndex);
    TraceNum = 1;
    for j = 1: 2: LenTraceIndex - 1 
        Bias_slice{TraceNum} = ForwardBias(TraceIndex(j)+1 : TraceIndex(j+1));
        LogG_slice{TraceNum} = ForwardLogG(TraceIndex(j)+1 : TraceIndex(j+1));
        TraceNum = TraceNum + 1;
    end
end
    

TraceNum = length(LogG_slice);
%筛曲线
m = 1;
Bias_rest = {};
LogG_rest = {};

flag = 1;
groupNUM = length(Bias_slice);
if ~isempty(Bias_slice{1})
    
    
    for group = 1:groupNUM
        if length(Bias_slice{group}) <= 100
            
            flag = 0;
            break
        end
    end
else
    flag = 0;
    
end




if flag == 1 

    for k = 1:TraceNum
        m_begin = mean(LogG_slice{k}(1:10));
        m_end = mean(LogG_slice{k}(end-9:end));
        
        if (m_begin > beginLogG) && (m_end > endLogG)
            Bias_rest{m} = Bias_slice{k};
            LogG_rest{m} = LogG_slice{k};
            m = m + 1;
        end
    end
end

fprintf('Num of trace:%d  ',length(Bias_rest));


    