% 子函数：适应度函数同时也是目标函数,函数存储名称为ConstAndFit.m
% 将上次进化结束后得到的最终种群作为下次输入的初始种群
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% Modified by 石鹏

function f=ConstAndFit(x)
g1=1.5+x(1)*x(2)-x(1)-x(2);  %第一约束函数
g2=-x(1)*x(2);  %第二约束函数，可逐次增加约束函数
if(g1>0|g2>10)
    f=100;
else
    f=exp(x(1))*(4*x(1)^2+2*x(2)^2+4*x(1)*x(2)+2*x(2)+1);  %此处为求解最小值问题，适应度函数同时为目标函数。若求最大值，则f=-目标函数,同时主函数中BestFval=-fval
end

%单变量单约束最大值问题求解测试（P94），主函数中ga函数的变量个数需改为1。经测试，工具箱计算结果与自制遗传算法吻合良好
%g1=x;
%if(x<-2|x>2)
%    f=100;
%else
%    f=-200*exp(-0.05*x)*sin(x);
%end

%数据相关性模型测试（P100），与geatbx工具箱对比，测试存在问题，运行结果不正确
%function f=ConstAndFit(x)
%g1=x(1)+x(2)+x(3);  %第一约束函数
%g2=x(1);  %第二约束函数，可逐次增加约束函数
%g3=x(2);
%g4=x(3);
%if(g1==1|g2<0|g2>1|g3<0|g3>1|g4<0|g4>1)   
%    f=100;
%else
%    f=-(180143985094819840. * 10. ^(1. /2).* ((3711483. * x(2))./5000000 - (3992207. * x(1))./5000000 + (103017. * x(3))./1000000))./(168601836138377. * (8192121. * x(1).^2 -...
%        17636608. * x(1).* x(2) - 24820. * x(1).* x(3) + 15084416. * x(2).^2 + 1273280. * x(2).* x(3) + 6723500. * x(3).^2).^(1. /2));
%end