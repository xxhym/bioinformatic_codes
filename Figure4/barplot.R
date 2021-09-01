#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：barplot
# Functions: barplot

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为丰度文件(如profile.txt)
#
# 输入文件"-i", "--input"，profile.txt丰度文件；
#
# 图片宽"-w", "--width"，默认5，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认5，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.barplot.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="profile.txt",
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
# 设置输出文件缺省值，如果为空，则为输入+barplot.pdf
if(opts$output==""){opts$output=paste0(opts$input,"barplot.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library("ggplot2")
library("ggpubr")
library("reshape2")
library("ggsignif")
data = read.table(opts$input,header = T,row.names = 1,sep="\t",quote="",check.names = F)
colors = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3")

pdf(opts$output,,width = opts$width, height = opts$height, pointsize=4)
par(mar=c(18,6,3,3))
temp = barplot(t(data),las=1,beside = T,xaxt="n",col = colors[1:ncol(data)],legend=colnames(data),ylab="The number of KO")
text(x=colMeans(temp),y=-max(data[,1])/100,rownames(data),srt=60,xpd=T,adj =1)
dev.off()
