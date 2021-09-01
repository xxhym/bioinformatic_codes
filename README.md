### Figure1

#### 韦恩图

* 代码：venn.R
* 数据：data/data_venn.txt

`Rscript venn.R -i ../data/data_venn.txt -o venn.pdf`

#### aplha多样性boxplot

* 代码：alpha_boxplot.R
* 数据：data/shannon1.txt

`Rscript alpha_boxplot.R -i ../data/shannon.txt -o alpha_boxplot.pdf -n shannon`

#### NMDS

* 代码：nmds.R
* 数据：data/weighted_unifrac.txt

`Rscript nmds.R -i ../data/weighted_unifrac.txt -g ../data/group.txt -o nmds.pdf`

#### PCoA

* 代码：pcoa.R
* 数据：data/weighted_unifrac.txt

`Rscript pcoa.R -i ../data/weighted_unifrac.txt -g ../data/group.txt -o pcoa.pdf`

### Figure2

#### diff_boxplot

- 代码：diff_boxplot.R
- 数据：data/diff_profile.txt

`Rscript diff_boxplot.R -i ../data/diff_profile.txt -g ../data/group.txt -o diff_boxplot.pdf`

#### LEfSe

* 代码：plot_res.py
* 数据：data/LDA.res

`python plot_res.py ../data/LDA.res LDA.pdf -group_file ../data/group.txt --format pdf`

#### boxplot

- 代码：alpha_boxplot.R
- 数据：data/species.txt

`Rscript alpha_boxplot.R -i ../data/species.txt -o species_boxplot.pdf`

### Figure3

#### LEfSe

- 代码：plot_res.py
- 数据：data/LDA.res

`python plot_res.py ../data/LDA.res LDA.pdf -group_file ../data/group.txt --format pdf`

#### diff_boxplot

* 代码：diff_boxplot.R

- 数据：data/diff_profile.txt

`Rscript diff_boxplot.R -i ../data/diff_profile.txt -g ../data/group.txt -o diff_boxplot.pdf`

### Figure4

#### LEfSe

- 代码：plot_res.py
- 数据：data/LDA.res

`python plot_res.py ../data/LDA.res LDA.pdf -group_file ../data/group.txt --format pdf`

#### diff_boxplot

- 代码：diff_boxplot.R

- 数据：data/diff_profile.txt

`Rscript diff_boxplot.R -i ../data/diff_profile.txt -g ../data/group.txt -o diff_boxplot.pdf`

#### kegg_barplot

* 代码：kegg_barplot.R
* 数据：data/kegg_profile.txt

`Rscript barplot.R -i ../data/kegg_profile.txt -o barplot.pdf`

### Figure5

#### heatmap

* 代码：heatmap.R
* 数据：data/profile.txt、data/envi.txt

`Rscript heatmap.R -i ../data/profile.txt -v ../data/envi.txt -o heatmap.pdf`

#### boxplot

* 代码：alpha_boxplot.R

* 数据：data/species.txt

`Rscript alpha_boxplot.R -i ../data/species.txt -o species_boxplot.pdf`

### Figure6

#### Random Forest

* 代码：roc.R
* 数据：data/profile.txt

`Rscript roc.R -i ../data/profile.txt -g ../data/group.txt`

### FigureS1

#### anosim

- 代码：roc.R
- 数据：data/profile.txt

`Rscript roc.R -i ../data/profile.txt -g ../data/group.txt`

#### alpha_boxplot

- 代码：alpha_boxplot.R
- 数据：data/chao1.txt

`Rscript alpha_boxplot.R -i ../data/chao1.txt -o alpha_boxplot.pdf -n chao1`

### FigureS2

#### 物种barplot

* 代码：species_barplot.R
* 数据：data/genus_barplot.profile.txt

`Rscript species_barplot.R -i ../data/genus_barplot.profile.txt -g ../data/group.txt -o barplot.pdf`

#### LEfSe cladogram

- 代码：plot_cladogram.py
- 数据：data/LDA.res

`python plot_cladogram.py ../data/LDA.res LDA.cladogram.pdf --format pdf`

### FigureS3

#### kegg catalog

* 代码：kegg_catalog.R
* 数据：data/gene_catalog.path.class

`Rscript kegg_catalog.R -i ../data/gene_catalog.path.class -o gene_catalog.path.class.pdf`

#### kegg barplot

* 代码：kegg_barplot.R
* 数据：data/kegg_level2_profile.txt

`Rscript kegg_barplot.R -i ../kegg_level2_profile.txt -g ../data/meta_group.txt -o kegg_barplot.pdf`

#### FigureS4

#### fishtaco

* 代码：fishtaco.R
* 数据：data/fishtaco/、data/taxon.list

`Rscript fishtaco.R -i ../data/fishtaco/ -t ../data/taxon.list -o fishtaco.pdf `