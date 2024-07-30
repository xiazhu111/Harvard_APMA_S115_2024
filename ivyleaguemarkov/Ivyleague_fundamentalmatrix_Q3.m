clc 
clear all

%HY MM YM HM - columns for R, B, and Q
I = [1 0 0 0;0 1 0 0;0 0 1 0;0 0 0 1];
Q = [0 1/8 0 0;1 1/4 1/4 1/4;0 1/4 1/2 0;0 1/4 0 1/2];

N = inv(I-Q);
R = [0 1/16 0 1/4; 0 1/16 1/4 0];
B = R*N; %matrix multiplication, not element-wise 