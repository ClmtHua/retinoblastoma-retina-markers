################################################################################
## Information page text
################################################################################

start_text <- "<h2>Presentation</h2>
<p>This visualization tool [<a href='https://retinoblastoma-retina-markers.curie.fr/'>https://retinoblastoma-retina-markers.curie.fr</a>] takes advantage of the single-cell RNA-seq (scRNA-seq) analyses of the developing human retina published by Lu et al. (2020) [1]. 
 The authors performed scRNA-seq analysis on 16 time points from developing retina and four different maturation stages of retinal organoids. They identified the developmental trajectories and transcriptional profiles of the different retinal cell populations. 
This tool makes it possible to visualize the expression of markers of retina cell populations, of markers of the two subtypes of retinoblastoma and other genes of interest cited in the manuscript by Liu et al. (in this report) at various time points during retina development [2]. The expression of these markers can also be visualized for the retinoblastoma subtype 2 tumor analyzed in [2] by scRNAseq. </p>

<br>
<hr style='border: none; border-top: 2px solid #000000; margin: 5px; text-align: center'>
<p style='font-size:smaller;'><strong>References</strong></p>
<p style='font-size:smaller;'>[1] Lu, Y., Shiau, F., Yi, W., Lu, S., Wu, Q., Pearson, J. D., Kallman, A., Zhong, S., Hoang, T., Zuo, Z., Zhao, F., Zhang, M., Tsai, N., Zhuo, Y., He, S., Zhang, J., Stein-O’Brien, G. L., Sherman, T. D., Duan, X., Fertig, E. J., Goff, L. A., Zack, D. J., Handa, J. T., Xue, T., Bremner, R., Blackshaw, S., Wang, X., & Clark, B. S. (2020). Single-cell analysis of human retina identifies evolutionarily conserved and species-specific mechanisms controlling development. <em>Developmental cell</em>, 53, 473-491.
<br><br>
[2] Liu, J., Ottaviani, D., Sefta, M., Desbrousses, C., Chapeaublanc, E., Aschero, R., Sirab, N., Lubieniecki, F., Lamas, G., Tonon, L., Dehainault, C., Fréneaux, P., Reichman, S., Hua, C., Karbou, N., Biton, A., Mirabal, L., Larcher, M., Brulard, C., Arrufat, S., Nicolas, A., Elarouci, N., Popova, T., Némati, F., Decaudin, D., Gentien, D., Baulande, S., Mariani, O., Dufour, F., Guibert, S., Vallot, C., Lumbroso-Le Rouic, L., Desjardins, L., Pascual-Pasto, G., Suñol, M., Catala-Mora, J., Correa Llano, G., Couturier, J., Barillot, E., Schaiquevich, P., Gauthier-Villars, M., Stoppa-Lyonnet, D., Golmard, L., Houdayer, C., Brisse, H., Bernard-Pierrot, I., Letouzé, E., Viari, A., Saule, S., Sastre-Garau, X., Doz, F., Carcaboso, A. M., Cassoux, N., Pouponnot, C., Goureau, O., Chantada, G., De Reyniès, A., Aerts, I., & Radvanyi, F. (2021). Identification of a high-risk retinoblastoma subtype with stemness features, dedifferentiated cone states and neuronal/ganglion cell gene expression. <em>(this report)</em></p>
"
# We thanks the department of Institut Curie.
# <p>The full source code are available in a git repository at [<a href='https://gitlab.curie.fr/chua/om_retinalmarkers'>https://gitlab.curie.fr/chua/om_retinalmarkers</a>].</p>




HowTo_Part1 <- "<h2>Visualization of gene expression</h2>
<p> In this part, the tool can be used to visualize gene expression data for the normal retina [1] and retinoblastoma [2] with various types of plots.</p>
<h3>Description of the inputs</h3>
<h4>Step 1: Choose genes</h4>
<p> There is two ways to <strong>choose your genes of interest:</strong> </p>
<p>
	<ul>
	  <li><strong>Input - from gene list(s):</strong> Select the wanted genes within the different lists. Category and subcategory can be pick up to filter the list of genes. In details: 
	    <ul>
  	    <li><strong>1. Select gene category(ies): </strong> One or several categories can be selected.
  	      <ul>
  	        <li><em>Retinal markers (Liu et al.):</em> Retinal cell type markers obtained from a systematic literature search and from scRNAseq data at different time points of the retina development [1] (Supplementary Table 3 in [2]). </li>
  	        <li><em>Genes related to Figures:</em> Genes that appear in the different figures in Liu <em>et al.</em></li>
  	        <li><em>DEGs between subtypes:</em> The most differentially expressed genes (DEGs, top 100 ranked by log-fold change) between the two retinoblastoma subtypes (Supplementary Table 3 in [2])</li>
            <p><i class='fas fa-caret-right'></i> <strong>Then click on 'Validate gene category(ies)'</strong></p>
  	      </ul>
  	    </li>
        <li><strong>2. Select gene subcategory(ies):</strong> 
          <ul>
            <li>In the 'Retinal markers (Liu et al.)' list, the subcategories correspond to the different retinal cell types.</li>
            <li>In the 'Genes related to Figures' list, the subcategories correspond to the different figures of Liu <em>et al.</em>.</li>
            <li>In the list of the top DEGs between the two retinoblastoma subtypes, two gene subcategories can be selected, genes 'Upregulated in subtype 1' and genes 'Upregulated in subtype 2'. </li>
            <p><i class='fas fa-caret-right'></i> <strong>Then click on 'Validate gene subcategory(ies)'</strong></p>
          </ul>
        </li>
        <li><strong>3. Select gene(s):</strong> One, several or all genes can be selected for gene expression visualization.</li>
            <p><i class='fas fa-caret-right'></i> <strong>Then click on 'Run'</strong></p>
        </li>
      </ul>
      
    </li>
    <li><strong>Input - from text box:</strong> Type your genes of interest in the text box as gene symbol. All the genes in the aforementioned lists, top 150 markers of each retinal cell type derived from Lu's data (Supplementary Table 3 in [2]) and genes mentioned in the article are available.</li>
    <p><i class='fas fa-caret-right'></i> <strong>Then click on 'Run'</strong></p>
  </ul>
</p>

<h4>Step 2: Display plots</h4>
<p> <strong> <em style='color:red'> Important: </em> Select the dataset you want to visualize.</strong>
	<ul>
	  <li><strong>Normal retina (Lu 2020):</strong> Visualization of the gene expression in normal retina at different time points published in [1]. More precisely, there is 4 early stages of retinal organoid maturation (at 24, 30, 42, and 59 days), 16 time points of developing fetal retina (at 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 24, 27 gestational weeks (GW)), 1 sample at 8 days post-natal (PND) and 1 sample from a 86-year-old donor (Adult).
	  Each plots are described below. </li>
	  <li><strong>Retinoblastoma:</strong> Visualization of the gene expression in the retinoblastoma subtype 2 tumor analysed in [2]. Each plots are described below. </li>
	</ul>
</p>

<h4>Bookmark current gene list</h4>
<p>
	Click on this button to get a link to retrieve your current results.
</p>

<h4>Graphical options</h4>
<p>
	<ul>
	  <li><strong>Run Feature plot (time-consuming):</strong> By default, feature plots for Lu data are not computed because it is computationally demanding. Activate this option if you want to compute the feature plots.</li>
	</ul>
</p>


<h3>Description of the plots</h3>
<h4>Normal retina (Lu 2020)</h4>
  <ul>
  <li><strong>Age-dependent dot plot:</strong> This plot takes into account the developmental age in addition to the cell type. For each gene (horizontal) and each cell type (vertical), a pseudo-dot plot is provided. At each age (x-axis), the dot size is proportional to the percentage of expressing cells (<em>e.g.</em> non-zero count) and its y-coordinate represents the mean expression.</li>
  <li><strong>General dot plot:</strong> Classical dot plot where each dot represents a gene (x-axis) for each cell type (y-axis). The dot size is proportional to the percentage of expressing cells (<em>e.g.</em> non-zero count). The color represents the average expression level.</li>
  <li><strong>Feature plot:</strong> 	Visualize feature expression in a low-dimensional space (UMAP coordinates given in [1]). Since three dimensions are provided, we represent three plots where two of the three dimensions are used.</li>
  <li><strong>Table of annotations:</strong> Table recapitulating the different annotations associated with the selected genes. </li>
  <li><strong>Table Age-dependent dot plot:</strong> Table that give the computed values used to make the 'Age-dependent dot plot'. It can be used to have the proportion and the absolute count of expressing cells.</li>
  </ul>

<h4>Retinoblastoma</h4>
  <ul>
  <li><strong>Feature plot:</strong> Visualize feature expression in a low-dimensional space (t-SNE coordinates given in [2]). </li>
  <li><strong>Dot-violin plot:</strong> Classical violin-plot to visualize single-cell expression distribution in each cluster. 
  An additional dot is added. The dot size is proportional to the percentage of expressing cells (<em>e.g.</em> non-zero count) and its y-coordinate represents the mean expression.</li>
  </ul>



<br>
<hr style='border: none; border-top: 2px solid #000000; margin: 5px; text-align: center'>
<p style='font-size:smaller;'><strong>References</strong></p>
<p style='font-size:smaller;'>
[1] Lu, Y., Shiau, F., Yi, W., Lu, S., Wu, Q., Pearson, J. D., Kallman, A., Zhong, S., Hoang, T., Zuo, Z., Zhao, F., Zhang, M., Tsai, N., Zhuo, Y., He, S., Zhang, J., Stein-O’Brien, G. L., Sherman, T. D., Duan, X., Fertig, E. J., Goff, L. A., Zack, D. J., Handa, J. T., Xue, T., Bremner, R., Blackshaw, S., Wang, X., & Clark, B. S. (2020). Single-cell analysis of human retina identifies evolutionarily conserved and species-specific mechanisms controlling development. <em>Developmental cell</em>, 53, 473-491.
<br><br>
[2] Liu, J., Ottaviani, D., Sefta, M., Desbrousses, C., Chapeaublanc, E., Aschero, R., Sirab, N., Lubieniecki, F., Lamas, G., Tonon, L., Dehainault, C., Fréneaux, P., Reichman, S., Hua, C., Karbou, N., Biton, A., Mirabal, L., Larcher, M., Brulard, C., Arrufat, S., Nicolas, A., Elarouci, N., Popova, T., Némati, F., Decaudin, D., Gentien, D., Baulande, S., Mariani, O., Dufour, F., Guibert, S., Vallot, C., Lumbroso-Le Rouic, L., Desjardins, L., Pascual-Pasto, G., Suñol, M., Catala-Mora, J., Correa Llano, G., Couturier, J., Barillot, E., Schaiquevich, P., Gauthier-Villars, M., Stoppa-Lyonnet, D., Golmard, L., Houdayer, C., Brisse, H., Bernard-Pierrot, I., Letouzé, E., Viari, A., Saule, S., Sastre-Garau, X., Doz, F., Carcaboso, A. M., Cassoux, N., Pouponnot, C., Goureau, O., Chantada, G., De Reyniès, A., Aerts, I., & Radvanyi, F. (2021). Identification of a high-risk retinoblastoma subtype with stemness features, dedifferentiated cone states and neuronal/ganglion cell gene expression. <em>(this report)</em></p>
</p>"



HowTo_Part2 <- "<h2>Visualization of co-expressed genes</h2>
<p> In this part, the tool can be used to visualize cells simultaneously expressing sets of genes. Here, a cell is considered to express a gene when at least one read for this gene is detected in this cell.</p>

<h3>Description of the inputs</h3>
<h4>Step 1: Inputs</h4>
<p>
	<ul>
		<li><strong> Gene symbol:</strong> Type your genes of interest in the text box. Gene should be provided as gene symbol.</li> 
		<li><strong> Grouping variables (Table):</strong> Select the variables that will be used to compute the absolute count and proportion of cells co-expressing the different gene combinations.</li> 
	 	<li><strong>Show all gene combinations:</strong> If this option is selected, all gene combinations will be considered. In the other case, only the cells expressing all the selected genes will be considered (the visualization will be easier).</li> 
	 <p><i class='fas fa-caret-right'></i> <strong>Then click on 'Run'</strong></p>
	</ul>
</p>

<h4>Step 2: Display plots</h4>
<p> <strong> <em style='color:red'> Important: </em> Select the dataset you want to visualize.</strong>
	<ul>
	  <li><strong>Normal retina (Lu 2020):</strong> Visualization of the gene expression in normal retina at different time points published in [1]. More precisely, there is 4 early stages of retinal organoid maturation (at 24, 30, 42, and 59 days), 16 time points of developing fetal retina (at 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 22, 24, 27 gestational weeks (GW)), 1 sample at 8 days post-natal (PND) and 1 sample from a 86-year-old donor (Adult).
	  Each plots are described below. </li>
	  <li><strong>Retinoblastoma:</strong> Visualization of the gene expression in the retinoblastoma subtype 2 tumor analysed in [2]. Each plots are described below. </li>
	</ul>
</p>

<h3>Description of the plots</h3>
<h4>Normal retina (Lu 2020)</h4>
  <ul>
  <li><strong>Feature plot:</strong> Visualize co-expression combination in a low-dimensional space (UMAP coordinates given in [1]). Since three dimensions are provided, we represent three plots where two of the three dimensions are used.</li>
  <li><strong>Bar plot:</strong>   For each cell type, a bar plot represents the proportion of cells co-expressing the different selected genes (x-axis) at the different ages (y-axis). When the number of cells co-expressing all the selected genes is not zero is not zero, the proportion and absolute number of co-expressing cells is displayed.</li>
  <li><strong>Table:</strong> Table giving the proportion and absolute number of co-expressing cells for the selected genes depending on the chosen grouping variables.</li>
  </ul>

<h4>Retinoblastoma</h4>
  <ul>
  <li><strong>Feature plot:</strong> Visualize feature expression in a low-dimensional space (t-SNE coordinates given in [2]). </li>
  <li><strong>Bar plot:</strong> A bar plot represents the proportion of cells co-expressing the different selected genes (x-axis) for each cell cluster (y-axis). When the number of cells co-expressing all the selected genes is not zero is not zero, the proportion and absolute number of co-expressing cells is displayed.</li>
  <li><strong>Table:</strong> Table giving the proportion and absolute number of co-expressing cells for the selected genes depending on the chosen grouping variables.</li>
  </ul>

<h4>Bookmark current gene list</h4>
<p>
	Click on this button to get a link to retrieve your current results.
</p>

<br>
<hr style='border: none; border-top: 2px solid #000000; margin: 5px; text-align: center'>
<p style='font-size:smaller;'><strong>References</strong></p>
<p style='font-size:smaller;'>
[1] Lu, Y., Shiau, F., Yi, W., Lu, S., Wu, Q., Pearson, J. D., Kallman, A., Zhong, S., Hoang, T., Zuo, Z., Zhao, F., Zhang, M., Tsai, N., Zhuo, Y., He, S., Zhang, J., Stein-O’Brien, G. L., Sherman, T. D., Duan, X., Fertig, E. J., Goff, L. A., Zack, D. J., Handa, J. T., Xue, T., Bremner, R., Blackshaw, S., Wang, X., & Clark, B. S. (2020). Single-cell analysis of human retina identifies evolutionarily conserved and species-specific mechanisms controlling development. <em>Developmental cell</em>, 53, 473-491.
<br><br>
[2] Liu, J., Ottaviani, D., Sefta, M., Desbrousses, C., Chapeaublanc, E., Aschero, R., Sirab, N., Lubieniecki, F., Lamas, G., Tonon, L., Dehainault, C., Fréneaux, P., Reichman, S., Hua, C., Karbou, N., Biton, A., Mirabal, L., Larcher, M., Brulard, C., Arrufat, S., Nicolas, A., Elarouci, N., Popova, T., Némati, F., Decaudin, D., Gentien, D., Baulande, S., Mariani, O., Dufour, F., Guibert, S., Vallot, C., Lumbroso-Le Rouic, L., Desjardins, L., Pascual-Pasto, G., Suñol, M., Catala-Mora, J., Correa Llano, G., Couturier, J., Barillot, E., Schaiquevich, P., Gauthier-Villars, M., Stoppa-Lyonnet, D., Golmard, L., Houdayer, C., Brisse, H., Bernard-Pierrot, I., Letouzé, E., Viari, A., Saule, S., Sastre-Garau, X., Doz, F., Carcaboso, A. M., Cassoux, N., Pouponnot, C., Goureau, O., Chantada, G., De Reyniès, A., Aerts, I., & Radvanyi, F. (2021). Identification of a high-risk retinoblastoma subtype with stemness features, dedifferentiated cone states and neuronal/ganglion cell gene expression. <em>(this report)</em></p>
</p>"


