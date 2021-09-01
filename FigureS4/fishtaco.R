#----1. 参数 Parameters#----

#----1.1 功能描述 Function description#----

# 程序功能：fishtaco
# Functions: fishtaco

options(warn = -1) # Turn off warning


## 设置输入输出文件和参数

# 修改下面`default=`后面的文件和参数。
#
# 输入文件为fishtaco结果文件夹+物种分类信息(taxon.list)
#
# 输入文件"-i", "--indir"，fishtaco结果文件夹;
#
# 分组文件"-t", "--taxon"，默认`taxon.list`，可手动修改文件位置；
#
# 图片宽"-w", "--width"，默认12，根据图像布局可适当增大或缩小
#
# 图片高"-e", "--height"，默认6，根据图像布局可适当增大或缩小
#
# 分组列名"-o", "--output"，输出目录，默认同输入+.fishtaco.pdf；
#

#----1.2 参数 Parameters#----

# 解析参数-h显示帮助信息
library("optparse")
if (TRUE){
  option_list = list(
    make_option(c("-i", "--indir"), type="character",
                help="input dir [default %default]"),
    make_option(c("-t", "--taxon"), type="character", default="taxon.list",
                help="taxonomic list [default %default]"),
    make_option(c("-o", "--output"), type="character", default="",
                help="Output directory; name according to input [default %default]"),
    make_option(c("-w", "--width"), type="numeric", default=12,
                help="Figure width in mm [default %default]"),
    make_option(c("-e", "--height"), type="numeric", default=6,
                help="Figure heidth in mm [default %default]")
  )
  opts = parse_args(OptionParser(option_list=option_list))
  # suppressWarnings(dir.create(opts$output))
}
# 设置输出文件缺省值，如果为空，则为输入+fishtaco.pdf
if(opts$output==""){opts$output=paste0(opts$input,".fishtaco.pdf")}
opts$output = gsub(".txt","",opts$output)
suppressWarnings(dir.create(dirname(opts$output), showWarnings = F))

#----1.3. 加载包 Load packages#----

library("ggplot2")
library("scales")
library("grid")
df = read.table(paste(opts$indir,"/fishtaco_STAT_predicted_DA_value_SCORE_wilcoxon_ASSESSMENT_multi_taxa.tab",sep=""),header=T,check.names=F,sep="\t",quote="")
df = df[which(df[,2]>0),]
input_function_filter_list=as.vector(df[,1])
input_function_filter_list
breaks = c(1:length(input_function_filter_list))
source("MultiFunctionTaxaContributionPlots.R")
p <- MultiFunctionTaxaContributionPlots(input_dir=opts$indir, input_prefix="fishtaco",
                                        input_taxa_taxonomy=opts$taxon, sort_by="list", plot_type="bars",
                                        input_function_filter_list=input_function_filter_list,
                                        add_predicted_da_markers=TRUE, add_original_da_markers=TRUE)
p <- p + scale_x_continuous(breaks = breaks,labels = input_function_filter_list)+
  guides(fill=guide_legend(nrow=10)) + ylab("Wilcoxon test statistic (W)") +
  theme(plot.title=element_blank(), axis.title.x=element_text(size=12,colour="black",face="plain"),
        axis.text.x=element_text(size=10,colour="black",face="plain"), axis.title.y=element_blank(),
        axis.text.y=element_text(size=10,colour="black",face="plain"), axis.ticks.y=element_blank(),
        axis.ticks.x=element_blank(), panel.grid.major.x = element_line(colour="light gray"), panel.grid.major.y = element_line(colour="light gray"),
        panel.grid.minor.x = element_line(colour="light gray"), panel.grid.minor.y = element_line(colour="light gray"),
        panel.background = element_rect(fill="transparent",colour=NA), panel.border = element_rect(fill="transparent",colour="black"),
        legend.background=element_rect(colour="black"), legend.title=element_text(size=10), legend.text=element_text(size=8,face="plain"),
        legend.key.size=unit(0.8,"line"), legend.margin=unit(0.1,"line"), legend.position="bottom")

ggsave <- ggplot2::ggsave; body(ggsave) <- body(ggplot2::ggsave)[-2]

pdf(opts$output,width=opts$width, height=opts$height)
p
dev.off()
