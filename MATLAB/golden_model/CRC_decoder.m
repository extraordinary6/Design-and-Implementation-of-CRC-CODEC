%清空工作区和命令行
clear;
clc;

%读入文件 数据
fid = fopen('CRC_encoder_o.txt', 'r');
data1 = zeros(100, 16);
for i = 1:100
    line = fgetl(fid);
    for j = 1:16
        data1(i, j) = str2double(line(j));
    end
end
fclose(fid);

fid = fopen('CRC_decoder_o.txt', 'r');
data2 = zeros(100, 16);
for i = 1:100
    line = fgetl(fid);
    for j = 1:16
        data2(i, j) = str2double(line(j));
    end
end
fclose(fid);

isEqual = all(data1(:) == data2(:));


