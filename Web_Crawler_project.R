### Final Edition 1st R project
library(rvest)
library(stringr)

title_link <- function(html_content) { 
  linkrow <- html_content %>% html_nodes(xpath = '//h3[@class="c-teaser__title"]/a/@href') %>%  html_text()
  return (linkrow)
}
crawling <- function(article_page){
  DOI1 <- article_page %>% html_nodes( xpath ='//p[@class="ArticleDOI"]/a') %>% html_text()
  DOI <- strsplit(DOI1, "https://doi.org/")[[1]][2]
  ### download html 
  DOI <- strsplit(DOI, "/")[[1]][2]
  DOI
  dest <- "C:/Users/Liu/Desktop/html_file/"
  dest <- paste(dest, DOI, ".html", sep="")
  dest
  ## dest at C:\Users\Liu\Desktop\html_file
  download.file(url= DOI1, destfile= dest)
  ####
  name <- strsplit(DOI, "/")[[1]][2]
  name <- paste(name,".html",sep = "")
  file.rename(from = name, paste(strsplit(DOI, "/")[[1]][1], name))
  Title <- article_page %>% html_nodes(xpath = '//h1[@class="ArticleTitle"]') %>% html_text()
  authors_num <- article_page %>% html_nodes(xpath = '//ul[@class="u-listReset"]/li/span') %>% html_text()
  Authors <- vector()
  for(i in 1:length(authors_num)){
    Authors = c(Authors, authors_num[i])
  }
  AuthorAffiliations <- NA
  Co_A <- article_page %>% html_nodes(xpath = '//*[contains(concat( " ", @class, " " ), concat( " ", "hasAffil", " " ))]') %>% html_text()
  Co_A
  Corresponding_Author <- vector()
  for(i in 1:length(Co_A)){
    if(length(str_subset(Co_A[i], "Email"))>0){
      Corresponding_Author = c(Corresponding_Author,strsplit(Co_A[i],"[0-9]+(.*)?Email")[[1]][1])
    }
  }
  CorrespondingEmail <-  article_page %>% html_nodes(xpath = '//a[@class="EmailAuthor"]/@href') %>% html_text()
  PublicationDate <-  article_page %>% html_nodes(xpath = '//li[@class="History HistoryOnlineDate"]/span') %>% html_text()
  Abstract <- article_page %>% html_nodes(xpath = '//*[(@id = "Abs1")]') %>% html_text()
  Keywords <- article_page %>% html_nodes(xpath = '//li[@class="c-keywords__item"]') %>% html_text()
  FullText <- article_page %>% html_nodes(xpath = '//article') %>% html_text()
  
  final1 <- list(DOI,Title,Authors,AuthorAffiliations, Corresponding_Author,CorrespondingEmail, PublicationDate, Abstract, Keywords, FullText)
  names(final1) <-list("DOI", "Title", "Authors", "AuthorAffiliations", "Corresponding_Author", "CorrespondingEmail", "PublicationDate", "Abstract", "Keywords", "FullText")
  ### Collect authors as a string
  len <- length(final1$Authors)
  Authors <- final1$Authors[1]
  if(len>1){
    for(i in 2:len){
      Authors  <- paste(Authors, final1$Authors[i], sep= ", ")
    }
  }
  # Delete †
  Authors <- gsub("†,", "", Authors )
  ####### Author_Affiliations
  len <- length(final1$AuthorAffiliations)
  AuthorAffiliations <- final1$AuthorAffiliations[1]
  if(len>1){
    for(i in 2:len){
      AuthorAffiliations  <- paste(AuthorAffiliations, final1$AuthorAffiliations[i], sep= ", ")
    }
  }
  ####### Corresponding_Author
  len <- length(final1$Corresponding_Author)
  Corresponding_Author <- final1$Corresponding_Author[1]
  if(len>1){
    for(i in 2:len){
      Corresponding_Author  <- paste(Corresponding_Author, final1$Corresponding_Author[i], sep= ", ")
    }
  }
  ######### Corresponding_Author_Email
  len <- length(final1$CorrespondingEmail)
  CorrespondingEmail <- final1$CorrespondingEmail[1]
  if(len>1){
    for(i in 2:len){
      CorrespondingEmail  <- paste(CorrespondingEmail, final1$CorrespondingEmail[i], sep= ", ")
    }
  }
  #### Keywords
  len <- length(final1$Keywords)
  Keywords <- final1$Keywords[1]
  if(len>1){
    for(i in 2:len){
      Keywords  <- paste(Keywords, final1$Keywords[i], sep= ", ")
    }
  }
  Keywords <- gsub("\n", "", Keywords )

  each_fields <- rbind(c(DOI, Title, Authors, AuthorAffiliations, Corresponding_Author, CorrespondingEmail, PublicationDate, Abstract, Keywords, FullText))
  return (each_fields)
}

url = "https://hereditasjournal.biomedcentral.com/articles"
main_page <- read_html(url)
all_links <- title_link(main_page)
last_data <- cbind("DOI","Title", "Authors", "Author Affiliations", "Corresponding Author", "Corresponding Author's Email", "Publication Date", "Abstract", "Keywords",  "Full Text")
for (i in 1:length(all_links)) {
  all_links[i] = strsplit(all_links[i], "/articles")[[1]][2]
  all_links[i] = paste(url, all_links[i], sep = "")
  
  article_page <- read_html(all_links[i])
  every_page <- crawling(article_page)
  last_data <- rbind(last_data, every_page)
  print(i)
}
## file at C:\Users\Liu\Documents
dput(last_data, "BMC Hereditas.txt")
#df <- data.frame(last_data)
#write.csv(df, "right_format_R_1st.csv")


