function [i_end,j_end] = FindEndpoints(name, img, empty_blocks, w, print)
name = char(name);

endpoints = bwmorph(img, 'endpoints');
[i_end,j_end] = find(endpoints);
s = round(w/2);

for idx = 1:length(i_end)
    i = i_end(idx);
    j = j_end(idx);
    
    %not close to the edge
    if i <= s || i >= size(img,1)-s || j <= s || j >= size(img,2)-s
        nsum = 0;
    else
        nsum = img(i-1,j) + img(i+1,j) + img(i,j+1) + img(i,j-1)+ img(i-1,j-1) + img(i+1,j+1) + img(i-1,j+1) + img(i+1,j-1);
    end
    if nsum > 3 || nsum == 0
        endpoints(i,j) = 0;
    end
end

[i_end,j_end] = find(endpoints);

if print
    fig_end = figure;
    imshow(img)
    hold on
    plot(j_end, i_end, 'r o')
    name = char(name);
    db = name(1:10);
    loc = strcat(db, '/Images/');
    str = strcat(loc, name(12:end), '_end.png');
    saveas(fig_end, str);
end

X = length(i_end);

for x1 = 1:X
    for x2 = 1:X
        if x1 == x2
        elseif sqrt((i_end(x1)-i_end(x2))^2+(j_end(x1)-j_end(x2))^2) <= 5
            endpoints(i_end(x1),j_end(x1)) = 0;
            endpoints(i_end(x2),j_end(x2)) = 0;
        end
    end
    
    [me, ne] = size(empty_blocks);
    if me > 1 && ne > 1
        for e = 1:length(empty_blocks)
            xv = w*(empty_blocks(e,1)-1)+1;
            yv = w*(empty_blocks(e,2)-1)+1;
            p1 = [xv, yv];
            p2 = [xv+(w - 1), yv];
            p3 = [xv, yv+(w - 1)];
            p4 = [xv+(w - 1), yv+(w - 1)];
            p5 = [xv, yv+round(w/2)];
            p6 = [xv+(w - 1), yv+round(w/2)];
            p7 = [xv+round(w/2), yv];
            p8 = [xv+round(w/2), yv+(w - 1)];
            
            if sqrt((i_end(x1)-p1(1))^2+(j_end(x1)-p1(2))^2) <= 20 || sqrt((i_end(x1)-p2(1))^2+(j_end(x1)-p2(2))^2) <= 20 || sqrt((i_end(x1)-p3(1))^2+(j_end(x1)-p3(2))^2) <= 20 || sqrt((i_end(x1)-p4(1))^2+(j_end(x1)-p4(2))^2) <= 20
                endpoints(i_end(x1),j_end(x1)) = 0;
            end
            if sqrt((i_end(x1)-p5(1))^2+(j_end(x1)-p5(2))^2) <= 20 || sqrt((i_end(x1)-p6(1))^2+(j_end(x1)-p6(2))^2) <= 20 || sqrt((i_end(x1)-p7(1))^2+(j_end(x1)-p7(2))^2) <= 20 || sqrt((i_end(x1)-p8(1))^2+(j_end(x1)-p8(2))^2) <= 20
                endpoints(i_end(x1),j_end(x1)) = 0;
            end
        end
    end
end

[i_end,j_end] = find(endpoints);

if print
    fig_end = figure;
    imshow(img)
    hold on
    plot(j_end, i_end, 'r o')
    name = char(name);
    db = name(1:10);
    loc = strcat(db, '/Images/');
    str = strcat(loc, name(12:end), '_end2.png');
    saveas(fig_end, str);
end

close all

end