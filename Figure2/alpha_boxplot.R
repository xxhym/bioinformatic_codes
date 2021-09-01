#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：Alpha多样性
# Functions: Alpha diversity

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为alpha多样性指数文件(如shannon.txt)+分组信息(group.txt)
#
# 输入文件"-i", "--input"，alpha/shannon.txt; alpha多样性指数文件，有多种指数可选，常用shannon、simpson、shannon和goods_coverage等
#
# 图片宽"-w", "--width"，默认5，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认5，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.alpha_boxplot.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--input"), type="character", default="alpha/shannon.txt",
                help="Alpha diversity index values [default %default]"),
    make_option(c("-n", "--index"), type="character", default="shannon",
                help="index name [default %default]"),
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
# 设置输出文件缺省值，如果为空，则为输入+alpha_boxplot.pdf
if(opts$output==""){opts$output=paste0(opts$input,".alpha_boxplot.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library("ggplot2")
library("ggpubr")
library("reshape2")
library("ggsignif")
data = read.table(opts$input,header=F,row.names=1,check.names=F,fill=T,quote="")
group_names = rownames(data)
group_num = length(group_names)
colors = c("dodgerblue", "goldenrod1", "darkorange1", "seagreen3")
group_colors = colors[1:group_num]

data <- data[group_names,]
data_m <- melt(t(data))
data_m <- data_m[complete.cases(data_m),]
colnames(data_m) <- c("index","group","value")

pdf(opts$output,,width = opts$width, height = opts$height, pointsize=4)

p <- ggboxplot(data_m, x="group", y="value", fill = group_colors,width = 0.5,size = 0.8,
               xlab = FALSE,ylab = "Abundance",font.y=20,font.xtickslab = 20,font.ytickslab = 18,ggtheme = theme_pubr(border = TRUE))
p <- p + scale_x_discrete(limits=rownames(data)) + theme(legend.position='none')+
  labs(title = "Alpha diff boxplot", x = "", y= bquote(paste(alpha, " Diversity (" ,.(opts$index), " diversity index)",sep="")))+
  theme(plot.title = element_text(size=20,hjust=0.5))+
  theme(axis.text.x = element_text(hjust = 0.5, vjust = 0.5))
my_comparisons <- list()
for(i in 1:(nrow(data)-1)){
  for(j in (i+1):nrow(data)){
    comp <- c(rownames(data)[i],rownames(data)[j])
    my_comparisons <- c(my_comparisons,list(comp))
  }
}
n=(max(data_m$value)-min(data_m$value))*0.1

tags <- 'signif'
paired=FALSE
if(tags == 'signif'){
         if(group_num==2){
          
           d=signif(wilcox.test(value~group, data=data_m,paired=paired)$p.value,2)
            if(d<0.01){
              sign="**"
            }else if(d<0.05){
            sign="*"
            }else{sign="NS."}
            p <- p + geom_signif(comparisons = my_comparisons, test = wilcox.test, step_increase = 0.16, textsize =5,map_signif_level = T,y=max(data_m$value)+n,annotations=sign)+
            annotate("text",x=1, y=max(data_m$value)+(max(data_m$value)-min(data_m$value))/2, label= paste("Wilcoxon,p=",d),cex=5)
          }
         else if(group_num==3){
                p <- p+geom_signif(comparisons = my_comparisons, test = wilcox.test, step_increase = 0.16, textsize =5, map_signif_level = T)+
                stat_compare_means(size = 5,label.y =max(data_m$value)+(max(data_m$value)-min(data_m$value))/2)#不同组间比较并标出显著性
          }
         else if(group_num==4){
                p <- p+geom_signif(comparisons = my_comparisons, test = wilcox.test, step_increase = 0.16, textsize =5, map_signif_level = T)+
                stat_compare_means(size = 5,label.y =max(data_m$value)+max(data_m$value)-min(data_m$value))
         }
         else if(group_num>4 & group_num<7){
                p <- p+geom_signif(comparisons = my_comparisons, test = wilcox.test, step_increase = 0.16, textsize =4.5, map_signif_level = T)+
                stat_compare_means(size = 5,label.y =(max(data_m$value)+(max(data_m$value)-min(data_m$value))*(group_num-3.5)))

         }else{
                p <- p + stat_compare_means(size = 5,label.x=1.2,label.y =max(data_m$value)+(max(data_m$value)-min(data_m$value))/8)#超过6组不画组间比较
         }

}else{
	p <- p + stat_compare_means(size = 5,label.x=1.2,label.y =max(data_m$value)+(max(data_m$value)-min(data_m$value))/8)#只显示p值
}
p
dev.off()
