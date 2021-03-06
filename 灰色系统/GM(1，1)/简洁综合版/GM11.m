% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 4
% modified by 石鹏

% 在程序的所有节骨眼都进行了详尽的注释
clc;
clear all;

% 以下数据背景：银行各种理财金融衍生品，客户在购买某种理财产品的时候
% 一般会有10天的“犹豫期”，在这10天可以自由退买
% 我们分析客户购买行为数据发现，在当天（姑且称之为第0天）购买之后
% 在第1天没有发生退买（保有量）的比率大概是92.81%，在第2天没有退买的比率大概是97.66%
% 以此类推
% 这里取前8天的数据：
x0 = [92.810 	97.660 	98.800 	99.281 	99.537 	99.537 	99.817 	100.000];

n = length(x0);
% 做级比判断，看看是否适合用GM(1，1)建模
lamda = x0(1:n-1)./x0(2:n);  %级比
range = minmax(lamda);  %输出级比向量lamda的最值
% 判定是否适合用一阶灰色模型建模
if range(1,1) < exp(-(2/(n+1))) | range(1,2) > exp(2/(n+1))  %更正了原程序中级比界限的错误
    error('级比没有落入灰色模型的范围内');  %输出错误信息
else
   % 空行输出
    disp('              ');
    disp('可用G(1，1)建模');
end

% 做AGO累加处理
x1 = cumsum(x0);  % Returns a vector containing the cumulative sum of the elements of x0.
for i = 2:n
    % 计算紧邻均值，也就是白化背景值
    z(i) = 0.5*(x1(i)+x1(i-1));
end
B = [-z(2:n)',ones(n-1,1)];
Y = x0(2:n)';

% 矩阵做除法，计算发展系数a和灰色作用量b
% 千万注意：这里是右除，不是左除
u = B\Y;  %注意此处并不等效于inv(B)*Y，因为inv函数的输入必须为方阵
forecast1 = (x1(1)-u(2)./u(1)).*exp(-u(1).*([0:n-1]))+u(2)./u(1) ;

% 把AGO输出值进行累减
% diff用于对符号表达式进行求导
% 但是如果输入的是向量，则表示计算原向量相邻元素的差
exchange = diff(forecast1);  %通过模型预测得到的为x1序列，需对预测数列进行IAGO处理才可得到x0序列
forecast = [x0(1),exchange]  % 输出灰色模型预测的值

epsilon = x0 - forecast;  % 计算残差
delta = abs(epsilon./x0);  % 计算相对误差

% 检验模型的误差
% 检验方法一：相对误差Q检验法，Q越小模型越精确
Q = mean(delta)

% 检验方法二：方差比C检验法
% 计算标准差函数为std（x,a）
% 如果后面一个参数a取0表示的是除以n－1，如果是1就是最后除以n
C = std(epsilon,1)/std(x0,1)

% 检验方法三：小误差概率P检验法
S1 = std(x0,1);
S1_new = S1*0.6745;
temp_P = find(abs(epsilon-mean(epsilon)) < S1_new);
P = length(temp_P)/n

% 绘制原始数列与灰色模型预测得出的数列差异折线图
plot(1:n,x0,'h','markersize',11);
hold on
plot(1:n,forecast,'k-','linewidth',2.5);
grid on;
axis tight;
xlabel('x');
ylabel('y');
title('保有量比例与时间序列的关系');
legend('原始数列','灰色模型预测数列');
