%清空工作区和命令行
clear;
clc;

%读入文件 数据
fid = fopen('CRC_encoder_i.txt', 'r');
data = zeros(100, 16);
for i = 1:100
    line = fgetl(fid);
    for j = 1:16
        data(i, j) = str2double(line(j));
    end
end
fclose(fid);

% 除数多项式的系数向量，a = x^8 + x^2 + x + 1
b = gf([1 0 0 0 0 0 1 1 1], 1); 

for i = 1:100
    row = [data(i, 1:8), zeros(1, 8)];
    a = gf(row, 1);  %被除数多项式的系数  
    [q, r] = deconv(a, b);
    data(i, 9:16) = r.x(9:16);
end

fid = fopen('CRC_encoder_o.txt', 'w');
for i = 1:size(data, 1)
    fprintf(fid, '%d', data(i, :));
    fprintf(fid, '\n');
end
fclose(fid);

fid = fopen('D:/Modelsim_files/vlsi/lab3/CRC_encoder_o.txt', 'r');
data2 = zeros(100, 16);
for i = 1:100
    line = fgetl(fid);
    for j = 1:16
        data2(i, j) = str2double(line(j));
    end
end
fclose(fid);

isEqual = all(data(:) == data2(:));
