function combClut = CombineCluts(planeClut, layout)combClutSize = 2^length(planeClut);combClutEntries = (1:combClutSize) - 1;combClut = zeros(combClutSize,3);% showing plane 1ind = find(layout == 1); ind = ind(1);planeCluttmp = floor(combClutEntries/(2^(ind-1)));tmp = rem(tmp,2);inds0 = find(tmp == 0);inds1 = find(tmp == 1);for n = 1:3    combClut(inds0,n) = planeClut{ind}(1,n);    combClut(inds1,n) = planeClut{ind}(2,n);end% showing plane 2 upon plane 1ind = find(layout == 2); ind = ind(1);tmp = floor(combClutEntries/(2^(ind-1)));tmp = rem(tmp,2);inds1 = find(tmp == 1);for n = 1:3    combClut(inds1,n) = planeClut{ind}(2,n);end