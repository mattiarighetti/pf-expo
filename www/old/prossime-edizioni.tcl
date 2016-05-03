ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    {ref ""}
}
set page_title "Iscriviti"
set context ""
set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
append logo_url [db_string query "select immagine from expo_edizioni where report is null limit 1"]
set fe_html_menu [pf::fe_html_menu -id 1]
template::head::add_css -href "/expo_style.css"
ad_form -name next_edition \
    -mode edit \
    -form {
	{email:text
	    {label "Email"}
	}
	{expo:text(radio)
	    {label "Città"}
	    {options {{"Padova 19/11/2015" padova} {"Milano 28/01/2016" milano}}}
	}
    } -on_submit {
	db_dml query "insert into expo_next (email, expo) values (:email, :expo)"
    } -after_submit {
	ad_returnredirect "prossime-edizioni?ref=$expo"
	ad_script_abort
    }
