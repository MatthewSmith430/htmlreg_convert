htmlreg_convert<-function(doc,format){
  NAME1<-gsub(".docx",".xlsx",doc)
  NAME2<-gsub(".docx",".csv",doc)
  complx <- docxtractr::read_docx(doc) #Read .doc created using htmlreg

  TABLE_XLS<-docxtractr::docx_extract_tbl(complx, 1, header=TRUE)
  
  if (format=="xlsx"){
    openxlsx::write.xlsx(TABLE_XLS,NAME1)
  }else write.csv(TABLE_XLS,NAME2)
}

