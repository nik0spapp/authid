The attached MATLAB code implements Moshe Koppel's et al. improved method introduced in his paper indicated below. The code was developed during my master studies in the University of the Aegean under 
the scope of a semester project for the Machine Learning and Knowledge Discovery course.

Koppel, Moshe, Jonathan Schler, and Shlomo Argamon. "Authorship attribution in the wild." Language Resources and Evaluation 45.1 (2011): 83-94.
<b>URL</b>: http://link.springer.com/article/10.1007%2Fs10579-009-9111-2?LI=true


The detect_author.m is the main file needed for execution and the rest of the files are dependencies for the former.

Input parameters:
-----------------------------------------------------------------
known_text => Array with text vectors t={fr1,fr2,...}<br/>
snippets => Array with unknown text vectors s={fr1,fr2,...}<br/>
authors => Array with authors<br/>
s_authors => Array with snippet authors<br/>
k1 => Iterations<br/>
k2 => feature set size<br/>
sigma => final decision threshold<br/>
distance function => e.g 'cosine'<br/>

Output:
-----------------------------------------------------------------
Array with Author per snippet<br/>
Precision and Recall Metrics<br/>
Table with confusion matrix<br/>