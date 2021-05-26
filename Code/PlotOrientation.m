function [] = PlotOrientation(img_seg,theta, w, M, N, rw, cw)

C = mat2cell(img_seg, rw, cw);

imshow(uint8(img_seg));
title('Orientation field')
hold on
for i=1:M
    for j=1:N
        %if mean(C{i,j}(:)) == 0
        %else
            T = theta(i, j);
            x_s = round(w/2) + (i - 1)*w;
            y_s = round(w/2) + (j - 1)*w;
            len = 10;
            x_e = x_s + len*cos(T);
            y_e = y_s + len*sin(T);
            plot([y_s, y_e], [x_s, x_e], '-r')
       %end
    end
end
hold off

end