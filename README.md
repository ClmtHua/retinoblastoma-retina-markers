# retinoblastoma-retina-markers
This repository contains the source codes of the following R-shiny app : https://retinoblastoma-retina-markers.curie.fr/

This visualization tool takes advantage of the single-cell RNA-seq (scRNA-seq) analyses of the developing human retina published by Lu et al. (2020) [1]. The authors performed scRNA-seq analysis on 16 time points from developing retina and four different maturation stages of retinal organoids. They identified the developmental trajectories and transcriptional profiles of the different retinal cell populations. This tool makes it possible to visualize the expression of markers of retina cell populations, of markers of the two subtypes of retinoblastoma and other genes of interest cited in the manuscript by Liu et al. (in this report) at various time points during retina development [2]. The expression of these markers can also be visualized for the retinoblastoma subtype 2 tumor analyzed in [2] by scRNAseq.



# Initialisation
## Install required packages
In your console:
```{r}
R -e "source("Source/install_packages.R", chdir = TRUE)"
```

## Get data related to developing retina (from Lu _et al._ 2020) 
1. Download Lu et al. (2020) datasets 

On your console run:
```{shell}
cd Source
bash Source/GetData_GSE138002.sh  
```
Or you can directly download in the folder "Source/data/" the following files from GEO Omnibus database [GSE138002](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE138002) : 
* 'GSE138002_genes.csv.gz'
* 'GSE138002_Final_matrix.mtx.gz'
* 'GSE138002_Final_barcodes.csv.gz'


2. Run the script "Source/DataGeneration.R"
In your console:
```{r}
R -e "source("Source/DataGeneration.R", chdir = TRUE)"
```


## Generate data related to the retinoblastoma sample
1. Get retinoblastoma sample dataset
You can ask for the raw single-cell transcriptome data from the [EGA archive (EGAS00001005178)](https://ega-archive.org/studies/EGAS00001005178).

Then, process the data as described in Liu _et al._ [2] in order to get the as log-normalized. Scripts to process the count matrix are made available [here](https://github.com/irisjingliu/RBsubtyping). 

Finally, save the expression matrix in the folder "Source/data/" as "df_NormExp.tsv".

2. Run the script "Source/DataGeneration_LiuRB.R"
In your console:
```{r}
R -e "source("Source/DataGeneration_LiuRB.R", chdir = TRUE)"
```


# Run the app 
## With your console
In your console:

```{shell}
R -e "shiny::runApp()"
```
Then copy-paste the provided address (e.g. "Listening on http://...") in your web-browser. 

## Within R-studio 
Open the file "app.R" in R-Studio.
Click on the button "Run App" (top right corner of the source pane).

___
<p style="font-size:x-small;">
[1] Lu, Y., Shiau, F., Yi, W., Lu, S., Wu, Q., Pearson, J. D., Kallman, A., Zhong, S., Hoang, T., Zuo, Z., Zhao, F., Zhang, M., Tsai, N., Zhuo, Y., He, S., Zhang, J., Stein-O’Brien, G. L., Sherman, T. D., Duan, X., Fertig, E. J., Goff, L. A., Zack, D. J., Handa, J. T., Xue, T., Bremner, R., Blackshaw, S., Wang, X., & Clark, B. S. (2020). Single-cell analysis of human retina identifies evolutionarily conserved and species-specific mechanisms controlling development. Developmental cell, 53, 473-491.   

[2] Liu, J., Ottaviani, D., Sefta, M., Desbrousses, C., Chapeaublanc, E., Aschero, R., Sirab, N., Lubieniecki, F., Lamas, G., Tonon, L., Dehainault, C., Fréneaux, P., Reichman, S., Hua, C., Karbou, N., Biton, A., Mirabal-Ortega, L., Larcher, M., Brulard, C., Arrufat, S., Nicolas, A., Elarouci, N., Popova, T., Némati, F., Decaudin, D., Gentien, D., Baulande, S., Mariani, O., Dufour, F., Guibert, S., Vallot, C., Lumbroso-Le Rouic, L., Desjardins, L., Pascual-Pasto, G., Suñol, M., Catala-Mora, J., Correa Llano, G., Couturier, J., Barillot, E., Schaiquevich, P., Gauthier-Villars, M., Stoppa-Lyonnet, D., Golmard, L., Houdayer, C., Brisse, H., Bernard-Pierrot, I., Letouzé, E., Viari, A., Saule, S., Sastre-Garau, X., Doz, F., Carcaboso, A. M., Cassoux, N., Pouponnot, C., Goureau, O., Chantada, G., De Reyniès, A., Aerts, I., & Radvanyi, F. (2021). Identification of a high-risk retinoblastoma subtype with stemness features, dedifferentiated cone states and neuronal/ganglion cell gene expression. Nature Communications.
</p>