function [La] = expandE6(La,index1,index2)
% index1 : 指引利用何種Galileo頻率產生E6
% index2 : 產生Galileo頻率E6與La{index2}
La{index2} = [];
La{index2} = La{index1};
La{index2}.name = 'E6';
La{index2}.lamda = 0.2344418049 ;
La{index2}.PHASE = La{index1}.PHASE*La{index1}.lamda/La{index2}.lamda;

