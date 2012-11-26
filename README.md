The attached MATLAB code implements Moshe Koppel's et al. improved 
method introduced in his paper indicated below:

Koppel, Moshe, Jonathan Schler, and Shlomo Argamon. "Authorship attribution in the wild." Language Resources and Evaluation 45.1 (2011): 83-94.

The detect_author.m is the main file needed for execution and the
rest of the files are needed from this main function.

Input parameters:
-----------------------------------------------------------------
known_text => Array with text vectors t={fr1,fr2,...}
snippets => Array with unknown text vectors s={fr1,fr2,...}
authors => Array with authors
s_authors => Array with snippet authors
k1 => Iterations
k2 => feature set size
sigma => final decision threshold
distance function => e.g 'cosine' etc

Output:
-----------------------------------------------------------------
Array with Author per snippet
PR Statistics
Table with confusion matrix