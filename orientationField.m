function theta = orientationField(img_seg)
%Takes in a normalized and segmented image

[m, n] = size(img_seg);
% Calculate gradient
Gx = zeros(m, n);
Gy = zeros(m, n);

x = img_seg;
for i=2:m-1
    for j=2:n-1
        Gx(i, j) = (x(i + 1, j) -x(i - 1, j))/2;
        Gy(i, j) = (x(i, j + 1) - x(i, j - 1))/2;
    end
end

% Metrics for computing theta
Gsx = zeros(m, n);
Gsy = zeros(m, n);

% For calculating theta
for i=2:m-1
    for j=2:n-1
        Gsx(i, j) = Gx(i,j)^2 - Gy(i,j)^2;
        Gsy(i,j) = 2*Gx(i, j)*Gy(i, j);
    end
end

Gmsx = zeros(M, N);
Gmsy = zeros(M, N);

% block sum
for i=1:M
    for j=1:N
        for xx=1 + (i-1)*w:i*w
            for yy=1 + (j-1)*w:j*w
                Gmsx(i, j) = Gmsx(i, j) + Gsx(xx, yy);
                Gmsy(i, j) = Gmsy(i, j) + Gsy(xx, yy);
            end
        end
    end
end

% Get the orientations
theta = zeros(M, N);
for i=1:M
    for j=1:N
        k = Gmsy(i, j)/Gmsx(i, j);
        
        if Gmsx(i, j)>0
            theta(i,j) = pi/2 + atan(k)/2;
        end
        
        if Gmsx(i, j)<0 && Gmsy(i,j)>=0
            theta(i,j) = pi/2 + (atan(k) + pi)/2;
        end
        
        if Gmsx(i, j)<0 && Gmsy(i, j) <0
            theta(i,j) = pi/2 + (atan(k) - pi)/2;
        end
    end
end

end