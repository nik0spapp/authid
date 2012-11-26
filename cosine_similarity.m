function [ similarity ] = cosine_similarity(known_text_vector, snippet);
% Cosine similarity distance function between text vectors
    similarity = (known_text_vector * snippet') / (norm(known_text_vector) * (norm(snippet)));
end

