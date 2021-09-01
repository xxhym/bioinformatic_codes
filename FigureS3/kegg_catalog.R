#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：kegg功能统计
# Functions: kegg catalog stat

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为kegg功能统计文件(kegg_catalog.txt)
#
# 输入文件"-i", "--input"，kegg功能统计文件kegg_catalog.txt
#
# 图片宽"-w", "--width"，默认10，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认8，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出文件名；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="profile.txt",
                help="Beta diversity distance matrix [default %default]"),
    make_option(c("-o", "--output"), type="character", default="",
                help="Output directory; name according to input [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=10,
                help="Figure width [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=8,
                help="Figure height [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$outdir))
}
# 设置输出文件缺省值，如果为空，则为输入+gene_catalog.pdf
if(opts$output==""){opts$output=paste0(opts$input,".gene_catalog.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library(ggplot2)

#----2 绘图 Plotting#----
counts <- read.delim(opts$input,header=TRUE)
counts$Pathway <- factor(counts$Pathway, levels=unique(counts$Pathway))
pdf(opts$output,width = opts$width, height = opts$height, pointsize=6)

p <- ggplot(counts, aes(x=Pathway,y=precent,fill=CLASS))+
	coord_flip()+
	geom_bar(stat="identity")+
	labs(title="KEGG Classification",y="Percent of Genes (%)",x="")+
	theme(axis.text=element_text(colour="black",size=11))+
	geom_text(label=counts$num,size=3,hjust=-0.5, vjust=0.5)+
	ylim(0,20)
p
dev.off()
