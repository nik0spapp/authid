function [ author ] = find_author( authors, pos )
% Finds author for specified position of text
% from authors structure array
    author = 0;
    for i = 1 : length(authors)
        %range = authors(i).range;
        %lower_bound = range(1);
        %upper_bound = range(2);
        if(pos == i)
            author = authors(i);
            break;
        end
    end
end

