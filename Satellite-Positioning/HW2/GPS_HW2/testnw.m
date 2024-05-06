clear all
close all
fid = fopen('EXAM1.OUT');

count = 0;
while 1
    line = fgetl(fid);
    if ~ischar(line), break, end
    count = count + 1;
    ddnw(count) = str2double(line(35:end));
end
n = max(size(ddnw));
figure(1);
plot(1:n,ddnw,'-');
ylabel(' Double Difference N1- N2 (cycles)')
xlabel(' epochs ')

%% end