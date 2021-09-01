#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：功能barplot
# Functions: species barplot

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为功能丰度文件(如species_profile.txt)+分组信息(group.txt)
#
# 输入文件"-i", "--input"，功能丰度文件species_profile.txt;
#
# 分组文件"-g", "--group"，默认`group.txt`，可手动修改文件位置；
#
# 分组文件"-l", "--level"，默认level1，功能层级；
#
# 图片宽"-w", "--width"，默认7，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认6，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.species_barplot.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="species_profile.txt",
                help="species profile [default %default]"),
	make_option(c("-l", "--level"), type="character", default="Genus",
				help="the profile level [default %default]"),
    make_option(c("-g", "--group"), type="character", default="group.txt",
                help="Group file [default %default]"),
    make_option(c("-o", "--output"), type="character", default="",
                help="Output directory; name according to input [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=7,
                help="Figure width in mm [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=6,
                help="Figure heidth in mm [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$output))
}
# 设置输出文件缺省值，如果为空，则为输入+species_barplot.pdf
if(opts$output==""){opts$output=paste0(opts$input,".species_barplot.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library(ggplot2)
library(reshape2)
library(RColorBrewer)
data <- read.table(opts$input,header=TRUE,row.names=1,sep='\t', check.names=F,quote="")
group <- read.table(opts$group,header=F,sep="\t",quote="",check.names = F,row.names = 1)
#data <- data[order(apply(data,1,sum),decreasing = T),]
data <- data[,rownames(group)]
#data <- t(apply(data,1,function(x) c(tapply(x,group[,1],sum))))
#data = data[order(apply(data,1,sum),decreasing = F),]
species_name = rev(rownames(data))
data$species = species_name
data = melt(data)
data$species = factor(data$species, levels=species_name)

colourCount = length(unique(data$species))
getPalette = colorRampPalette(brewer.pal(8, "Set1"))

pdf(opts$output,width = opts$width, height = opts$height, pointsize=4)
p <- ggplot(data, aes(x=variable, y=value, fill = species)) +
	geom_col(position = "stack", width = 1)+
  labs( y = 'Relative abundance', title=paste(opts$level,' Level Barplot',sep="")) + 
  scale_fill_manual(values = getPalette(colourCount))
p + theme_bw()+
	theme(panel.border = element_blank(),panel.grid.major = element_blank(),
		  panel.grid.minor = element_blank(),
		  axis.title.x=element_blank(),axis.line.x=element_blank(),
		  axis.line.y=element_line(colour="black",size=0.6),
		  axis.title.y=element_text(colour="black",size=17),
		  axis.text.x=element_text(colour="black",angle=60,hjust=1,vjust=1),
		  plot.title=element_text(colour="black",size=15,hjust=0.5),
		  legend.title=element_blank(),
		  legend.key.size = unit(0.2,'inches'))
#		  legend.text = element_text(size = 10, vjust = 3))
dev.off()
