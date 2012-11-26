The attached MATLAB code implements Moshe Koppel's et al. improved method introduced in his paper indicated below. The code was developed during my master studies in the University of the Aegean under 
the scope of a semester project for the Machine Learning and Knowledge Discovery course.

Koppel, Moshe, Jonathan Schler, and Shlomo Argamon. "Authorship attribution in the wild." Language Resources and Evaluation 45.1 (2011): 83-94.
<b>URL</b>: http://link.springer.com/article/10.1007%2Fs10579-009-9111-2?LI=true


The detect_author.m is the main file needed for execution and the rest of the files are dependencies for the former.

Input parameters:
-----------------------------------------------------------------
<table>
<tr><td><b>Variable</b></td><td><b>Description</b></td><td><b>Example</b></td></tr>
<tr><td>known_text</td><td>Array with text vectors</td><td>[t1, t2, ..., tn]</td></tr>
<tr><td>snippets</td><td>Array with unknown text vectors</td><td>[s1, s2, ..., sn]</td></tr>
<tr><td>authors</td><td>Array with author names</td><td>['Author 1', 'Author 2', ..., 'Author n']</td></tr>
<tr><td>s_authors</td><td>Array with author snippets</td><td>[s1, s2, ..., sn]</td></tr>
<tr><td>k1</td><td>Number of iterations</td><td>10</td></tr>
<tr><td>sigma</td><td>Final decision threshold (0-100)</td><td>80</td></tr>
<tr><td>distance_function</td><td>The desired distance function</td><td>cosine</td></tr>
</table>

Output:
-----------------------------------------------------------------
<table>
<tr><td><b>Variable</b></td><td><b>Description</b></td></tr>
<tr><td>snippet_results</td><td>Array with Author per snippet</td></tr>
<tr><td>precision</td><td>Precision scores</td></tr>
<tr><td>recall</td><td>Recall scores</td></tr>
<tr><td>confusion_matrix</td><td>Table with confusion matrix</td></tr>
</table>