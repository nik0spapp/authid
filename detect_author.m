function [ snippet_results, precision, recall, confusion_matrix ] = detect_author( known_text, snippets, authors, s_authors , k1, k2, sigma, distance_function)
% ================================================
% Student: Pappas Nikolaos (icsdm09031)
% Supervisor: Dr. Stamatatos Eustathios
% Lesson: Machine Learning and Knowledge Discovery
% ================================================
%
% The below function implements Moshe Koppel's et al. improved method
% introduced in his paper 'Authorship attribution in the wild'.
%
% Input parameters:
% -----------------
% known_text => Array with text vectors t={fr1,fr2,...}
% snippets => Array with unknown text vectors s={fr1,fr2,...}
% authors => Array with authors
% s_authors => Array with snippet authors
% k1 => Iterations
% k2 => feature set size
% sigma => final decision threshold
% distance function => e.g 'cosine' etc
%
% Output:
% ------
% Array with Author per snippet
% PR Statistics
% Table with confusion matrix
%
    
    % CHECK INPUT PARAMETERS
    disp('[NOTICE:] Parsing parameters...');
    if(length(known_text) > 0 && length(snippets) > 0 && k1 > 0 && k2 > 0 && sigma > 0)
        disp('[NOTICE:] Initializing data structures...');
        [L1, s_cols] = size(snippets);
        [L2, k_cols]=size(known_text);
        C = length(unique(authors)); 
        true_predicted = zeros(C+1,1);
        false_predicted = zeros(C+1,1);
        false_predicted_as = zeros(C+1,C+1);
        total_predicted = zeros(C+1,1);
        actual_per_class = zeros(C+1,1);
        unknown_author = 0;
        for i = 1 : length(s_authors)   
            if numel(find(unique(authors) == s_authors(i))) > 0
                actual_per_class(s_authors(i)) = actual_per_class(s_authors(i)) + 1;
            else
                actual_per_class(C+1) = actual_per_class(C+1) + 1;
            end
        end  
        scores = zeros(L2,1);
        snippet_results = {zeros(L1,1)};
       
        if strcmp(distance_function,'') 
            disp('[NOTICE:] Setting default distance function to Cosine');
            distance_function = 'cosine';
        end
    else 
        disp('USAGE:');
        disp('known_text => Array with text vectors t={fr1,fr2,...}');
        disp('snippets => Array with unknown text vectors s={fr1,fr2,...}');
        disp('authors => Array with authors');
        disp('s_authors => Array with snippet authors');
        disp('k1 => Iterations');
        disp('k2 => feature set size');
        disp('sigma => final decision threshold'); 
        disp('distance function => e.g `cosine` etc');  
        return;
    end
    tic
    positions = [1:k_cols];
    % FIND AUTHOR FOR ALL SNIPPETS
    disp('[NOTICE:] Detecting author for each snippet...');
    for s = 1 : L1
        % MAIN LOOP
        scores = zeros(L2,1);
        
        %disp(['[NOTICE:] Running authorship algorithm...']);
        for i = 1 : k1
            % RANDOMLY SELECT SOME FRACTION K2 FROM FEATURE SET
             
            fraction = randperm(k_cols); %superfast
            fraction = fraction(1:k2);
            
            max_similarity = -1.0;
            max_similarity_pos = 0;
            % FIND TOP MATCH USING DISTANCE FUNCTION
            for j = 1 : L2
                known_text_vector = known_text(j,:);
                known_text_vector = known_text_vector(fraction);
                snippet = snippets(s,:);
                snippet = snippet(fraction);
                if(strcmp(distance_function,'cosine'))
                    cur_similarity = cosine_similarity(known_text_vector, snippet);
                elseif true % another distance function
                    break;
                end
                
                if(max_similarity <= cur_similarity)
                   max_similarity = cur_similarity;
                   max_similarity_pos = j;
                end
            end 
            % INCREASE SCORE FOR TOP MATCH TEXT
            if max_similarity_pos > 0
                scores(max_similarity_pos) = scores(max_similarity_pos) + 1;
            end
        end
        
        % FIND TEXT WITH MAX SCORE
        [max_score,pos] = max((scores/sum(scores))*100); 
        % FIND AUTHOR FOR MAX SCORE TEXT
        author = find_author(authors,pos);
        true_author = find_author(s_authors,s);
        pos = find(unique(authors) == author);
        tpos = find(unique(authors) == true_author);
        if numel(tpos) == 0
            tpos = C + 1;
        end
        % TAKE FINAL DESICION BASED ON THE SIGMA THRESHOLD
        if(max_score > sigma && author ~= 0)
            disp(['[SUCCESS:] Found author ',num2str(author),' for snippet ',num2str(s),'!']); 
            snippet_results{s} = {author};
            
            % STORE PRECISION RECALL METRICS 
            
            % Successfully predicted author (TP)
            if author == true_author            
                total_predicted(pos) = total_predicted(pos) + 1; 
                true_predicted(pos) = true_predicted(pos) + 1;
            else 
                % False predicted uknown author (FP)
                if sum(find(authors == true_author)) > 0
                   total_predicted(tpos) = total_predicted(tpos) + 1; 
                   false_predicted(tpos) = false_predicted(tpos) + 1;
                   false_predicted_as(pos,tpos) = false_predicted_as(pos,tpos) + 1;
                % False predicted uknown author
                else
                   total_predicted(pos) = total_predicted(pos) + 1;
                   false_predicted(C+1) = false_predicted(C+1) + 1;
                   false_predicted_as(C+1,pos) = false_predicted_as(C+1,pos) + 1;
                end 
            end 
        else
            disp(['[WARNING:] Uknown author for snippet ',num2str(s),'!']);
            snippet_results{s} = {'Uknown author'}; 
            % STORE PRECISION RECALL METRICS
            total_predicted(C+1) = total_predicted(C+1) + 1; 
                
            % Successfully predicted uknown author (TN)
            if author >= 0 && sum(find(unique(authors) == true_author)) == 0
                unknown_author = 1;
                true_predicted(C+1) = true_predicted(C+1) + 1;
            % False predicted uknown author (FN)
            elseif author >= 0 && sum(find(authors == true_author)) > 0% 
                false_predicted(tpos) = false_predicted(tpos) + 1;
                false_predicted_as(C+1,tpos) = false_predicted_as(C+1,tpos) + 1;
            end
        end
    end 
    toc
    % actual_per_class
    % false_predicted_as
    disp('[NOTICE:] Finished!');
    disp(' ');
    disp('---------------------------------------------');
    disp(' ');
    disp('[INPUT:]');
    disp('========');
    disp(['L1(Snippet length)=',num2str(L1)]);
    disp(['L2(Known-text length)=',num2str(L2)]);
    disp(['k1=',num2str(k1)]);
    disp(['k2=',num2str(k2)]);
    disp(['sigma=',num2str(sigma)]);
    disp(['C=',num2str(C)]);
    disp(['C=',num2str(C)]);
    disp(' ');
    disp('[RESULTS:]');
    disp('==========');
    precision = 0;
    recall = 0;
    if sum(total_predicted) > 0
        if unknown_author
            precision = sum(true_predicted)/sum(total_predicted);
            tnr = sum(false_predicted)/sum(total_predicted);
        else
            precision = sum(true_predicted)/sum(total_predicted(1:length(total_predicted)-1));
            tnr = sum(false_predicted)/sum(total_predicted); 
        end
    end
    if sum(actual_per_class)
        recall = sum(true_predicted)/sum(actual_per_class);
    end
    disp(['Total precision: ', num2str(precision)]);
    disp(['Total recall: ', num2str(recall)]);
    disp(['True negative rate: ', num2str(tnr)]);
    f = figure('Position',[200 200 1100 400]);
    dat = false_predicted_as;
    pr = zeros(C + 3,2);
    for i = 1: C + 1
        for j = 1: length(total_predicted)
            if j == i
                dat(i,j) = true_predicted(i);
                pr(i,1) = 0;
                pr(i,2) = 0;
                if total_predicted(i) > 0
                    pr(i,1) = true_predicted(i) / total_predicted(i);
                end
                if actual_per_class(i) > 0
                    pr(i,2) = true_predicted(i) / actual_per_class(i);
                end
            else
                dat(i,j) = false_predicted_as(i,j); 
            end
        end
    end     
    dat = [dat;total_predicted'];
    dat = [dat;actual_per_class'];
    pr(C+2,1) = precision;
    pr(C+2,2) = recall;
    pr(C+3,1) = precision;
    pr(C+3,2) = recall;
    dat = cat(2,pr,dat);
    confusion_matrix = dat;
    cnames = {'P','R',unique(authors),'Other'};
    rnames = {unique(authors),'Other','Total','Real'};
    uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[20 20 1050 350]);
        
        
end

