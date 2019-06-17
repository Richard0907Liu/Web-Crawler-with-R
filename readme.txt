# Project guides:
extract the following 10 fields :
DOI, Title, Authors, Author Affiliations, Corresponding Author, Corresponding
Author's Email, Publication Date, Abstract, Keywords, Full Text (Textual format).
Extracted information should be written into a plain text file (one row per article and one
column per field). If any columns are not available, please mark them as NA (don’t leave
them blank).

Finally export the file: BMC Hereditas.

# Function discription:
1. title_link(main_page): Find all links in the main page.
2. read_html(all_link[i]): To read the article page.
3. crawling(article_page): Find every article's 10 feilds we need.
4. html_nodes(xpath=""): To find the special range in html.
5. article_page %>% html_nodes( xpath ='//p[@class="ArticleDOI"]/a') %>% html_text() 
   and strsplit(DOI1, "https://doi.org/")[[1]][2]: get the all DOI. 
6. DOI <- strsplit(DOI, "/")[[1]][2]
  dest <- "C:/Users/Liu/Desktop/html_file/"
  dest <- paste(dest, DOI, ".html", sep="")
  download.file(url= DOI1, destfile= dest)
  : To downlaod html files.
7. authors_num <- article_page %>% html_nodes(xpath = '//ul[@class="u-listReset"]/li/span') %>%      
   html_text(): find the all authors 
8. CorrespondingEmail <-  article_page %>% html_nodes(xpath = '//a[@class="EmailAuthor"]/@href')    
    %>%html_text(): find all corrseponding author's email.
9. PublicationDate <-  article_page %>% html_nodes(xpath = '//li[@class="History        
   HistoryOnlineDate"]/span') %>% html_text(): get the publication date.
  
