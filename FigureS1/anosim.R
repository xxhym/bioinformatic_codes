#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：Beta多样性Anosim分析
# Functions: Beta diversity -- Anosim

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为距离矩阵(如weighted_unifrac.txt)+分组信息(group.txt)
#
# 输入文件"-i", "--input"，beta/weighted_unifrac.txt; beta多样性距离矩阵文件，有多种距离可选，常用bray_curtis、jaccard、unifrac和unifrac_binary
#
# 分组文件"-g", "--group"，默认`group.txt`，可手动修改文件位置；
#
# 图片宽"-w", "--width"，默认5，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认5，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.anosim.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="beta/weighted_unifrac.txt",
                help="Beta diversity distance matrix [default %default]"),
	make_option(c("-n", "--distance"), type="character", default="weighted unifrac",
				help="Beta diversity distance method [default %default]"),
    make_option(c("-g", "--group"), type="character", default="group.txt",
                help="Group file [default %default]"),
    make_option(c("-o", "--output"), type="character", default="",
                help="Output directory; name according to input [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=3,
                help="Figure width in mm [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=3,
                help="Figure heidth in mm [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$output))
}
# 设置输出文件缺省值，如果为空，则为输入+.anosim.pdf
if(opts$output==""){opts$output=paste0(opts$input,".anosim.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library("vegan")

#----2. 读取文件 Read files#----

X=read.table(opts$input,header=TRUE,row.names=1,sep="\t",check.names=F,quote="")
group=read.table(opts$group,header=F,row.names=1,check.names=F,quote="",na.string="")
X = X[rownames(group),rownames(group)]
group_names = unique(as.vector(group[,1]))
group_num = length(group_names)
colors = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3")
group_colors = colors[1:group_num]
sample_colors = group_colors[as.numeric(group$V2)]

#----2.1 计算 Stat#----

anosim = anosim(as.dist(X), factor(group[,1], levels=group_names))

#----3.1 绘图 Plotting#----

pdf(opts$output,width = opts$width, height = opts$height, pointsize=4)
plot(anosim,
	 col=c('#FF6C00', group_colors),
	 ylab=paste(opts$distance,"Rank"),
	 main=paste(opts$distance,"Anosim")
)
dev.off()
