ad_page_contract {
}
set html ""
db_foreach query "select immagine from expo_partners order by denominazione" {
    append html "<img height=\"180px\" width=\"180px\" style=\"margin-top:-40px\" src=\"http://images.professionefinanza.com/pfexpo/partners_portraits/$immagine\">"
}
ad_return_template
