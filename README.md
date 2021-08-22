# Replication files for [_On the Measurement of the Elasticity of Labour_](https://arnau.eu/MeasureElasticity.pdf)

[This repository](https://github.com/drarnau/MeasureElasticity) contains all files necessary to replicate the results in [_On the Measurement of the Elasticity of Labour_](https://arnau.eu/MeasureElasticity.pdf) by [Charles Gottlieb](https://sites.google.com/site/gottliebcharles/Charles-Gottlieb), Joern Onken, and [Arnau Valladares-Esteban](https://arnau.eu).

Proceed as follows to replicate all the tables and figures in the paper.
  1. Execute the STATA do-file `01_ComputeDataInputs.do`. The do-file:
    - Reads all the necessary raw data from the CSV files in `/RawData/`.
    - Creates Tables 1 and 4 of the paper in latex format.
    - Create a CSV file named `DataInputs.csv` with all the parametrisation inputs.
  2. Execute the Matlab file `02_GenerateOutputs.m`. The m-file:
    - Reads the data in `DataInputs.csv`.
    - Produces all plots in Figures 1 and 2 in `.eps` format.
    - Produces Tables 2 and 3 of the paper in latex format.

Both codes store all tables in folder `Tables/` and all plots in folder `Figures/`.  
Below we detail all the files in `RawData/`.
We provide the URLs from which we have downloaded the files.

## Files in `/RawData/`
- [OECD Employment by activities and status (ALFS)](https://stats.oecd.org/Index.aspx?DataSetCode=ALFS_EMP), `OECD_ALFS_EMP.csv`.
- [OECD Population and Labour Force](https://stats.oecd.org/Index.aspx?DataSetCode=ALFS_POP_LABOUR#), `OECD_ALFS_POP_LABOUR.csv`.
- [OECD National Accounts at a Glance](https://stats.oecd.org/Index.aspx?DataSetCode=NAAG#), `OECD_TABLE2.csv`.
- [UNdata Table 1.1 Gross domestic product by expenditures at current prices](http://data.un.org/Data.aspx?d=SNA&f=group_code%3a101), `UN_TABLE1.1.csv`.
- [UNdata Table 1.3 Relations among product, income, savings, and net lending aggregates](http://data.un.org/Data.aspx?d=SNA&f=group_code%3a103), `UN_TABLE1.3.csv`.
- [UNdata Table 4.5 General Government (S.13)](http://data.un.org/Data.aspx?d=SNA&f=group_code%3a405), `UN_TABLE4.5.csv`.
- [UNdata Table 4.9 Combined Sectors: Households and NPISH (S.14 + S.15)](http://data.un.org/Data.aspx?d=SNA&f=group_code%3a409), `UN_TABLE4.9.csv`.
- [The World Bank DataBank - Armed forces personnel, total](https://databank.worldbank.org/reports.aspx?source=2&series=MS.MIL.TOTL.P1&country=), `World_Bank_Armed_Forces_Personnel.csv`.

Last check on all URLs was on 22nd August 2021.
