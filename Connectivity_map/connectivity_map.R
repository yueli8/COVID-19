library(stringr)
library(sva)
library(ASSIGN)
library(data.table)
library(readxl)
library(ggpubr)
suppressMessages(require(Seurat))
suppressMessages(require(ggplot2))
suppressMessages(require(cowplot))
suppressMessages(require(scater))
suppressMessages(require(scran))
suppressMessages(require(BiocParallel))


cov2<-read.csv("~/covid19/result01/connectivity_map/SARS-cov2.csv")
strong_cov2<-droplevels.data.frame(subset(cov2,cov2$Score< -90|cov2$Score > 90))
dim(strong_cov2)
drugs<-c("ivermectin","ibuprofen","irbesartan","olmesartan","losartan","chloroquine","dexamethasone","fluticasone","perindopril","lopinavir","ribavirin","ritonavir","ramipril","tamoxifen","atorvastatin","ketoconazole")
strong_cov2_interesting<-rbind(strong_cov2,cov2[(cov2$Name%in%drugs),])
strong_cov2_interesting<-strong_cov2_interesting[duplicated(strong_cov2_interesting)==F,]
#write.csv(strong_cov2_interesting,"~/Desktop/COVID19/Manuscript/Source Data/interesting_CMAP_cs.csv")
dim(droplevels.data.frame(subset(cov2,cov2$Score< -90&cov2$Type=="cp")))##45 potential targets
#cp
strong_cov2_class<-droplevels(strong_cov2[strong_cov2$Score< -90 &strong_cov2$Description!="-"&strong_cov2$Type=="cp",])
classes<-names(table(strong_cov2_class[,6])[table(strong_cov2_class[,6])>2])
strong_cov2_class_filt<-droplevels(strong_cov2_class[strong_cov2_class$Description%in%classes,])
all_classes<-names(table(strong_cov2[,6])[table(strong_cov2[,6])>3])
all_classes<-all_classes[!all_classes%in%c("-","CD molecules" ,"Mitochondrial respiratory chain complex / Complex I","RNA binding motif (RRM) containing","Zinc fingers, C2H2-type" )]
all_strong_cov2_class_filt<-droplevels(strong_cov2[strong_cov2$Description%in%all_classes,])
# ggplot(all_strong_cov2_class_filt, aes(x=Type, y=Score, fill=Description)) + 
#   geom_boxplot()+geom_jitter(shape=16, position=position_jitter(0.2))+theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
#   theme_classic()
cov2$Description[cov2$Description=="Angiotensin antagonist"]<-"Angiotensin receptor antagonist"
cov2$Description[cov2$Description=="HIV protease inhibitor"]<-"Antiviral"
fig3a<-ggplot(strong_cov2_class_filt, aes(x=Description, y=Score, fill=Description)) + 
  geom_boxplot()+geom_jitter(shape=16, position=position_jitter(0.2))+
  labs(y= "CS",x= element_blank())+ylim(-100,-90)+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
fig3b<-ggplot(cov2[cov2$Name%in%drugs,],aes(x =Name, y=Score, fill=Description))+
  geom_bar(stat="identity", position=position_dodge())+
  labs(y= "CS",x= element_blank())+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
ggarrange(fig3a,fig3b,nrow = 2,heights = c(1.5,1),labels = c("a","b"))
