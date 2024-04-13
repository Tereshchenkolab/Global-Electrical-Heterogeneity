# Global-Electrical-Heterogeneity

## Table of Content
  - GEH Calculation
  - GEH MATLAB Code
  - MATLAB Code to calculate RR' interval for median beat cardiac cycle
  - Test file (XYZ signal)
  - Test file for Kors transformation (12 lead ECG signal)
  - Kors transformation MATLAB Code
  
### Authors
GEH calculation code V.1
Kazi Haq <haqk@ohsu.edu> 
Erick Andres Perez Alday, PhD, <perezald@ohsu.edu>
Annabel Li-Pershing, BS, <lipershi@ohsu.edu>
Muammar Kabir, PhD, <muammar.kabir@gmail.com>
Larisa Tereshchenko, MD, PhD, <tereshch@ohsu.edu>
Last update: February 20th, 2018. RR' interval calculation added December,18th, 2020
  
### GEH Calculation
See pdf file in the repository for GEH parameter calculation methods.

### GEH MATLAB Code
See GEH_analysis_git.m file in the repository for GEH parameter calculation. Test file is provided (90757.mat) for algorithm testing.
Kors_git.m file is a code for Kors transformation (transforms 12-lead ECG to XYZ (Frank) ECG). See "RR__..." files for calculation of represented cardiac cycle.

### Test files
One test file (90757.mat) is provided for GEH calculation testing. Sampling rate 500 Hz. Amplitude resolution 1 µV.
Raw 12-lead ECG file (12LECG.mat) is provided to illustrate Kors transformation from 12-lead to XYZ (Frank) ECG

### Manuscripts to reference:
Waks JW, Sitlani CM, Soliman EZ, Kabir M, Ghafoori E, Biggs ML, Henrikson CA, Sotoodehnia N, Biering-Sorensen T, Agarwal SK, Siscovick DS, Post WS, Solomon SD, Buxton AE, Josephson ME and Tereshchenko LG. Global Electric Heterogeneity Risk Score for Prediction of Sudden Cardiac Death in the General Population: The Atherosclerosis Risk in Communities (ARIC) and Cardiovascular Health (CHS) Studies. Circulation. 2016;133:2222-2234.

Thomas JA, A Perez-Alday E, Junell A, Newton K, Hamilton C, Li-Pershing Y, German D, Bender A, Tereshchenko LG. Vectorcardiogram in athletes: The Sun Valley Ski Study. Ann Noninvasive Electrocardiol. 2019 May;24(3):e12614. doi: 10.1111/anec.12614. Epub 2018 Nov 7. PubMed PMID: 30403442; PubMed Central PMCID: PMC6476648.

Perez-Alday EA, Bender A, German D, Mukundan SV, Hamilton C, Thomas JA, Li-Pershing Y, Tereshchenko LG. Dynamic predictive accuracy of electrocardiographic biomarkers of sudden cardiac death within a survival framework: the Atherosclerosis Risk in Communities (ARIC) study. BMC Cardiovasc Disord. 2019 Nov 14;19(1):255. doi: 10.1186/s12872-019-1234-9. PubMed PMID: 31726979; PubMed Central PMCID: PMC6854807

### Relationships between SAIQRST and VMQTi (Vector magnitude QT integral):
#### VMQTi = 0.68*SAIQRST (GEHCO data) = 0.62*SAIQRST (HCHS/SOL data)
#### SAIQRST = 1.43*VMQTi (GEHCO data) = 1.59*VMQTi (HCHS/SOL data) 

