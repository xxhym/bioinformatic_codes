#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：Venn图
# Functions: Venn plot

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为韦恩图数据(如data_venn.txt)
#
# 输入文件"-i", "--input"，韦恩图数据如data_venn.txt; 
#
# 图片宽"-w", "--width"，默认5，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认5，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.venn.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="data_venn.txt",
                help="Alpha diversity index values [default %default]"),
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
# 设置输出文件缺省值，如果为空，则为输入+venn.pdf
if(opts$output==""){opts$output=paste0(opts$input,".venn.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library(VennDiagram)
library(Cairo)
# 设置pdf文件名，用于存储绘制的图形
pdf(file=opts$output, width=opts$width, height=opts$height, pointsize=8) 
data=read.table(opts$input,,sep='\t',row.names=1,header=F,check.names=F,quote="")
data_list <- list()
for(i in 1:nrow(data)){
    temp = as.vector(unlist(strsplit(as.vector(data[i,]),' ')))
    data_list <- c(data_list,list(temp))
}
for(i in 1:length(data_list)){
	names(data_list)[i] <- rownames(data)[i]
}
p1 <- venn.diagram(
  #提取各组中`=1`的行名。需根据自己的分组，调整list中的分组情况
  x=data_list,
 # 不指定保存的文件名，也不指定`imagetype`
 filename = NULL, lwd = 3, alpha = 0.6,
 #设置字体颜色
 label.col = "white", cex = 1.5,
 #设置各组的颜色
 fill = c("dodgerblue", "goldenrod1"),
 cat.col = c("dodgerblue", "goldenrod1"),
 #设置字体
 fontfamily = "serif", fontface = "bold",
 cat.fontfamily = "serif",cat.fontface = "bold",
 margin = 0.05)
#使用`grid.draw`函数在`venn.diagram`绘图函数外绘制图形
grid.draw(p1) 
dev.off()
#CairoPNG(file="venn.png", width=4, height=3, res=300, units="in")
#grid.draw(p1) 
#dev.off()
