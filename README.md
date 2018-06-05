# Clustering-Missing-Features
K-Means or HAC clustering with Missing Features using Feature Weighted Penalty based Dissimilarity measure

LICENSE:

1. This software is provided free of charge to the research community as an academic software package with no commitment in terms of support or maintenance.
2. Users interested in commercial applications should contact Shounak Datta (shounak.jaduniv@gmail.com) or Dr. Swagatam Das (swagatamdas19@yahoo.co.in). 
3. Any copy shall bear an appropriate copyright notice specifying the above-mentioned authors.
4. Licensee acknowledges that this software is a research tool, still in the development stage. Hence, it is not presented as error–free, accurate, complete, useful, suitable for any specific application or free from any infringement of any rights. The Software is licensed AS IS, entirely at the Licensee's own risk.
5. The Researchers and/or ISI Kolkata shall not be liable for any damage, claim, demand, cost or expense of whatsoever kind or nature directly or indirectly arising out of or resulting from or encountered in connection with the use of this software.

INSTRUCTIONS:

1. Load the required data (specified as comments in KMCode or HierCode; see 'sampleWorkspace.mat' for an example) in the MATLAB workspace before running 'KMCode.m' for KMeans-FWPD or 'HierCode.m' for HAC-FWPD.
2. The resulting cluster assignments can be found in the array 'assignNew_miss'.
3. To only artificially generate missingness, without clustering the data, use the function 'missGenerator.m'.
