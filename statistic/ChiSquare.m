function Z = ChiSquare (img,filename)

% function for the computation of the Chi square distribution
%
%----------------------------------
% input:
% - input       - 3D matrix (rowXcolsXbands)
% - filename
% 
% output: 
% - Z           - Chi square distribution of the data 
%----------------------------------
% Nicola Falco 
% nicolafalco@ieee.org
% 
% Prashanth Reddy Marpu
% prashanthmarpu@ieee.org
% 
% Signal Processing Lab, University of Iceland
% 11/10/2014% ---------------------------------

%%%% Data Reading %%%%
rows = size(img,1);
cols = size(img,2);
bands = size(img,3);

%%%% Function %%%%
Z = zeros(rows,cols);
idx = randi([1 rows*cols],1,min(50000,rows*cols));
% Random Samples Selection from max_diff %%%%%
for b = 1 : bands
    fprintf('\nBand %d: ',b);
    a = img(:,:,b);
    a = a(:);
    a = a(idx);

% EM_GM Algorithm %
    disp('EM_GM Algorithm in progress . . . ');
    [W,M,V] = EM_GM(a,3,[],2,[],[]);
    [n,indi] = min(abs(M));

    std1(b)=sqrt(V(indi));
    Z = Z + (img(:,:,b)/std1(b)).^2;
end
matlabToEnvi(Z,filename,'bip');
save(filename, 'Z');

