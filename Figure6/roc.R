#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：随机森林分析
# Functions: RandForest

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为丰度文件(profile.txt)+分组信息(group)
#
# 输入文件"-i", "--input"，丰度文件profile.txt
#
# 分组文件"-g", "--group"，默认`group.txt`，可手动修改文件位置；
#
# 分组文件"-n", "--num_features"，默认6，可手动修改特征值个数；
#
# 分组文件"-r", "--ratio"，默认0.7，可手动修改训练集和测试集的样本比例；
#
# 图片宽"-w", "--width"，默认5，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认5，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--outdir"，输出文件夹，默认当前文件夹；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="profile.txt",
                help="Beta diversity distance matrix [default %default]"),
	make_option(c("-n", "--num_features"), type="numeric", default=6,
				help="the num of features [default %default]"),
	make_option(c("-r", "--ratio"), type="numeric", default=0.7,
				help="the ratio of train and test [default %default]"),
    make_option(c("-g", "--group"), type="character", default="group.txt",
                help="Group file [default %default]"),
    make_option(c("-o", "--outdir"), type="character", default="",
                help="Outdir directory; current path [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=5,
                help="Figure width [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=5,
                help="Figure height [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$outdir))
}
# 设置输出文件缺省值，如果为空，则为输入+pcoa.pdf
if(opts$outdir==""){
	opts$outdir=file.path(getwd())
}
#suppressWarnings(dir.create(dirname(opts$outdir)), showWarnings = F))

#----1.3. 加载包 Load packages#----

library(pROC)
library(randomForest)

merge <-  function(data = data, group = group){
    data <- read.table(data,header = TRUE, check.names = F, row.names = 1,sep="\t")#丰度文件
    group <- read.table(group,header = FALSE,check.names = F,row.names =1)#分组文件
    data <- data[,rownames(group)]
    colnames(group) <- 'group'
    data1 <- cbind(t(data),group)
}
Forest <- function(data = data){
    data1 <- data
    set.seed(111)
    data.rf <- randomForest( group ~ ., data=data1, importance=TRUE, proximity=TRUE, ntree=500)
}

data1 <- merge(data = opts$input, group = opts$group)
data.rf <- Forest(data = data1)

n <- opts$num_features
pdf(paste(opts$outdir,"importance.pdf",sep='/'),height=opts$height,width=opts$width*1.6,pointsize=8)
varImpPlot(data.rf, sort=TRUE, n.var=min(n, nrow(data.rf$importance)),
       type=NULL, class=NULL, scale=TRUE,
       main=NULL)#输出特征重要性
dev.off()
pdf(paste(opts$outdir,"roc.pdf",sep='/'),height=opts$height,width=opts$width,pointsize=10)
data3 <- data1[,rownames(importance(data.rf,type=1))[order(importance(data.rf,type=1),decreasing=T)]][,c(1:n)]#选取特征值
group <- data1[,"group"]
data3 <- cbind(data3,group)
split <- sample(nrow(data3),nrow(data3)*opts$ratio)#随机选取训练集和测试集
train_data <- data3[split,]#训练集
test_data <- data3[-split,]#测试集
data3.rf <- randomForest(group ~ ., data=train_data, importance=TRUE,proximity=TRUE,ntree=500)
#data3.rf$importance
p <- predict(data3.rf,newdata=test_data,type="prob")
#p
roc1=plot.roc(test_data$group,p[,2],reuse.auc=T,axes=T,legacy.axes=T,
              col="blue", lwd=2, lty = 'solid',cex.axis=1.5,
              xlim=c(1,0),ylim=c(0,1),cex.lab=1.5,print.thres=TRUE,print.thres.cex=1.2,ci=T)#,of="se")
ci_roc = ci.auc(roc1)
ci_roc
legend("bottomright", legend=c(paste("AUC:",round(ci_roc[2],3),"(",round(ci_roc[1],3),"~",round(ci_roc[3],3),")",sep="")),bty="n",cex=1.3)
dev.off()
