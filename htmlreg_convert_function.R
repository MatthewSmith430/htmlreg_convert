htmlreg_convert<-function(doc,format){
  NAME1<-gsub(".doc",".xlsx",doc)
  NAME2<-gsub(".doc",".csv",doc)
  complx <- docxtractr::read_docx("ERGM_EXAMPLE_MODEL.docx") #Read .doc created using htmlreg

  TABLE_XLS<-docxtractr::docx_extract_tbl(complx, 1, header=TRUE)
  
  if (format=="xlsx"){
    openxlsx::write.xlsx(TABLE_XLS,NAME1)
  }else write.csv(TABLE_XLS,NAME2)
}

