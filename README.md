# Global-Electrical-Heterogeneity

## Table of Content
  - GEH Calculation
  - GEH MATLAB Code
  - Test file (XYZ signal)
  - Test file for Kors transformation (12 lead ECG signal)
  - Kors transformation MATLAB Code
  
### Authors
GEH calculation code V.1
Erick Andres Perez Alday, PhD, <perezald@ohsu.edu>
Annabel Li-Pershing, BS, <lipershi@ohsu.edu>
Muammar Kabir, PhD, <muammar.kabir@gmail.com>
Larisa Tereshchenko, MD, PhD, <tereshch@ohsu.edu>
Last update: February 20th, 2018
  
### GEH Calculation
See pdf file in the repository for GEH parameter calculation methods.

### GEH MATLAB Code
See GEH_analysis_git.m file in the repository for GEH parameter calculation. Test file is provided (90757.mat) for algorithm testing.
Kors_git.m file is a code for Kors transformation (transforms 12-lead ECG to XYZ (Frank) ECG)

### Test files
One test file (90757.mat) is provided for GEH calculation testing. Sampling rate 500 Hz. Amplitude resolution 1 µV.
Raw 12-lead ECG file (12LECG.mat) is provided to illustrate Kors transformation from 12-lead to XYZ (Frank) ECG

### Manuscript to reference:
Waks JW, Sitlani CM, Soliman EZ, Kabir M, Ghafoori E, Biggs ML, Henrikson CA, Sotoodehnia N, Biering-Sorensen T, Agarwal SK, Siscovick DS, Post WS, Solomon SD, Buxton AE, Josephson ME and Tereshchenko LG. Global Electric Heterogeneity Risk Score for Prediction of Sudden Cardiac Death in the General Population: The Atherosclerosis Risk in Communities (ARIC) and Cardiovascular Health (CHS) Studies. Circulation. 2016;133:2222-2234.
