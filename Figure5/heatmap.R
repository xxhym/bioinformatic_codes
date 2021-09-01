#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：相关性热图
# Functions: correlation heatmap

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为物种丰度文件(如profile.txt)+因子文件(envi.txt)
#
# 输入文件"-i", "--input"，profile.txt; 进行相关性分析的丰度文件，行或列与另一丰度文件行或列对应；
#
# 分组文件"-v", "--envi"，envi.txt，进行相关性分析的另一丰度文件；
#
# 图片宽"-w", "--width"，默认10，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认10，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.heatmap.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="profile.txt",
                help="profile for correlation [default %default]"),
    make_option(c("-v", "--envi"), type="character", default="envi.txt",
                help="profile for correlation [default %default]"),
    make_option(c("-o", "--output"), type="character", default="",
                help="Output directory; name according to input [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=10,
                help="Figure width in mm [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=10,
                help="Figure heidth in mm [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$output))
}
# 设置输出文件缺省值，如果为空，则为输入+heatmap.pdf
if(opts$output==""){opts$output=paste0(opts$input,".heatmap.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library(gplots)
library(pheatmap)

data1=read.table(opts$input,header=T,row.names = 1,check.names = F,sep="\t",quote="",dec=".")
data2=read.table(opts$envi,header=T,row.names=1,check.names=F,sep="\t",quote="",dec=".",blank.lines.skip=T)
data2=data2[colnames(data1),]
data2=data2[complete.cases(data2),]
data2=t(data2)
data1=data1[,colnames(data2)]
data1=data1[which(apply(data1,1,sum)!=0),]
data3=matrix(0,nrow(data1),nrow(data2))
rownames(data3)=rownames(data1)
colnames(data3)=rownames(data2)
data4=matrix(0,nrow(data1),nrow(data2))
rownames(data4)=rownames(data1)
colnames(data4)=rownames(data2)

n1=nrow(data1)
n2=nrow(data2)
for (i in 1:n1){
  for (j in 1:n2){
    temp=cor.test(as.numeric(data1[i,]),as.numeric(data2[j,]),method = "spearman")
    data3[i,j]=temp$p.value
    data4[i,j]=temp$estimate
  }
}

note=matrix(0,nrow(data3),ncol(data3))
for(i in 1:nrow(data3)){
	for(j in 1:ncol(data3)){
		if(data3[i,j]<0.01) note[i,j]="*" else if(data3[i,j]<0.05) note[i,j]="+" else note[i,j]=""
	}
}
pheatmap(mat=data4,  
         border_color='grey60', 
         treeheight_col=5,
         cellwidth=15,
         cellheight=15,
         cluster_row=TRUE,
         cluster_col=TRUE,
         show_rownames=TRUE,
         show_colnames=TRUE,
         clustering_method="complete", 
         display_numbers=note,
         filename=opts$output, width=opts$width, height=opts$height)
