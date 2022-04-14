remove.packages("ggplot2") # Unisntall ggplot
if(!require("readxl")) install.packages("readxl")
if(!require("cowplot")) install.packages("cowplot")
if(!require(ggplot2)) install.packages("ggplot2")
library("readxl")
library(ggplot2)
library("cowplot")
my_data <- read_excel("sampledatafoodsales.xlsx", sheet = 2)


my_data_sum_prod <- setNames(aggregate(my_data$Quantity, list(my_data$Product), FUN=sum), c("Product", "Quantity"))
my_data_sum_reg <- setNames(aggregate(my_data$Quantity, list(my_data$Region), FUN=sum), c("Region", "Quantity"))

my_data_sum_prod_top5 <-my_data_sum_prod[head(order(my_data_sum_prod$Quantity), 5),]

p1 <- ggplot(my_data_sum_prod_top5,aes(x = reorder(Product, -Quantity), y = Quantity))+
  geom_bar(stat = "identity", colour="black", width=1, na.rm=TRUE, fill = "Green")+
  theme(axis.text.x = element_text(angle=90))+ 
  scale_x_discrete("Product Name")+ 
  scale_y_discrete("Quantity")

p2 <- ggplot(my_data_sum_reg,aes(x = reorder(Region, -Quantity), y = Quantity))+
  geom_bar(stat = "identity", colour="black", width=1, na.rm=TRUE, fill = "Blue")+ 
  scale_x_discrete("Region")+ 
  scale_y_discrete("Quantity")

p3 <- ggplot(my_data_sum_prod_top5, aes(x="", y=Quantity, fill=Product)) +
  geom_bar(stat="identity", colour="black", width=1) +
  coord_polar("y", start=0)+ theme_void()

p <- plot_grid(p1, p2, p3,"",
          ncol = 2, nrow = 2)

p

png("myplot.png")
print(p)
dev.off()