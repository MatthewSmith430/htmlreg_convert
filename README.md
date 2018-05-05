README
================

htmlreg\_convert
================

A function that converts word doc created using the htmlreg function (from the great texreg package) into a xlsx or csv file.

Here is an example of how to use the function.

First we implement a model - I have arbitrary chosen to run an `ergm` on Sampson dataset (that comes with the `ergm` package).

``` r
library(xergm)

data('sampson')

model <- ergm(samplike ~ edges + mutual + nodematch('group') + 
            gwesp(decay = .5, fixed = TRUE) + 
            gwidegree(decay = 1, fixed = TRUE))
```

We then create a .doc file using the `htmlreg` function, that is part of the `texreg` package.

``` r
library(texreg)
htmlreg(model,file="ERGM_EXAMPLE_MODEL.doc",
        custom.model.names ="ERGM example",
        digits=5,bold=TRUE)
```

We then manually save the .doc file as a .docx so that we can use the function to convert it to a xlsx/csv file.

*If there is a way to omit this step, or to convert the htmlreg output to a .docx file in R - please let me know (in issues)*

Once we have the docx file, we can then convert it to a xlsx/csv file. This function assume there is only one table in the docx file.

``` r
library(docxtractr)
library(openxlsx)

#Load the function
source("htmlreg_convert_function.R")

#convert to xlsx file
htmlreg_convert("ERGM_EXAMPLE_MODEL.doc","xlsx")

#convert to csv file
htmlreg_convert("ERGM_EXAMPLE_MODEL.doc", "csv")
```

The alternative is not to use the `texreg` package - rather use the `broom` package to convert model summary to a data frame, then to write his data frame to a csv.

``` r
library(broom)

modelDF<-tidy(model)

write.csv(modelDF,"modelDF.csv")

##Alternatively can write to xlsx
library(openxlsx)

write.xlsx(modelDF,"modelDF.xlsx")
```

We can also add the significant level stars (\*) using the following:

``` r
modelDF<-tidy(model)

modelDF<-ITNr::round_df(modelDF,4) #round value to 4 decimal places

LEN<-as.numeric(length(modelDF$p.value)) #Number of terms

for (i in 1:LEN
     ){
  PV<-modelDF$p.value[[i]]
  if(PV<0.001){
    modelDF$star[[i]]<-"***"
    } else if(0.001<=PV & PV<0.01){
      modelDF$star[[i]]<-"**"
    }else if(0.01<=PV & PV<0.05){
      modelDF$star[[i]]<-"*"
    } else modelDF$star[[i]]<-" "
}

head(modelDF)
```

    ##              term estimate std.error mcmc.error p.value star
    ## 1           edges  -1.0511    0.4330          0  0.0158    *
    ## 2          mutual   1.4291    0.5005          0  0.0046   **
    ## 3 nodematch.group   2.7061    0.4678          0  0.0000  ***
    ## 4 gwesp.fixed.0.5  -0.4833    0.1556          0  0.0021   **
    ## 5       gwidegree  -3.2500    0.9552          0  0.0008  ***
