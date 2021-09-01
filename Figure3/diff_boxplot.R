#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：差异boxplot
# Functions: diff boxplot

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为差异物种丰度文件(如diff_profile.txt)+分组文件(group.txt)
#
# 输入文件"-i", "--input"，diff_profile.txt; 差异物种丰度文件；
#
# 分组文件"-g", "--group"，group.txt，分组文件；
#
# 图片宽"-w", "--width"，默认5，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认5，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.diff_boxplot.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="diff_profile.txt",
                help="diff species profile [default %default]"),
    make_option(c("-g", "--group"), type="character", default="group.txt",
                help="group file [default %default]"),
    make_option(c("-o", "--output"), type="character", default="",
                help="Output directory; name according to input [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=5,
                help="Figure width in mm [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=5,
                help="Figure heidth in mm [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$output))
}
# 设置输出文件缺省值，如果为空，则为输入+diff_boxplot.pdf
if(opts$output==""){opts$output=paste0(opts$input,".diff_boxplot.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library(ggplot2)
library(grid)

data <- read.table(opts$input,header=TRUE,sep="\t",check.names=F,quote="",na.string="")
data$Sample <- factor(data$Sample,levels=unique(data$Sample))
data$Tax <- factor(data$Tax,levels=unique(data$Tax))
group=read.table(opts$group,header=F,row.names=1,check.names=F,quote="",na.string="")
group_names = as.vector(unique(group[,1]))
group_num = length(group_names)
colors = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3")
group_colors = colors[1:group_num]
sample_colors = group_colors[as.numeric(group$V2)]

pdf(opts$output,,width = opts$width, height = opts$height, pointsize=4)
data$Group = factor(data$Group, levels=group_names)
p <-ggplot(data, aes(Tax,log2(Profile),fill=Group))

p +
geom_boxplot(outlier.size=1) +
theme( axis.text=element_text(colour="black"), axis.text.x=element_text(angle=60, size=8,hjust=1) ) +
scale_fill_manual(values=group_colors) +
labs(title="", x="", y="log(Relative Abundance)") +
theme(legend.position='left')
if(nrow(data)==0){
	p <- p + theme(axis.text.y=element_text(size=0)) +geom_text()+
	annotate("text", label = "no item for plot", x = 0, y = 0, size = 3, colour = "black")
}

dev.off()
