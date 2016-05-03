ad_page_contract {
    @author Mattia Righetti
} {
}
set page_title "PatrimoniaExpert"
set context ""

#Controllo su utenza
if {[ad_conn user_id]} {
  ad_returnredirect "index"
  set user_loggedin 1
} else {
    set user_loggedin 0
}

#FORM SignUp investitori
ad_form -name investitori_signup \
    -html {class "registration-form"} \
    -form {
	{nome:text
		{label "Nome"}
	    {html {name "form-nome" placeholder "Nome*..." class "form-nome form-control"}}
	}
	{cognome:text
		{label "Cognome"}
	    {html {name "form-cognome" placeholder "Cognome*..." class "form-cognome form-control"}}
	}
	{nickname:text
		{label "Nickname"}
	    {html {name "form-nickname" placeholder "Nickname*... nel caso volessi rispondere in modo anonimo alle domande..." class "form-nickname form-control"}}
	}
	{email:text
		{label "Email"}
	    {html {name "form-email" placeholder "Email*..." class "form-email form-control"}}
	}
	{telefono:text
		{label "Cellulare"}
	    {html {name "form-telefono" placeholder "Cellulare*..." class "form-telefono form-control"}}
	}
	{indirizzo:text,optional
		{label "Indirizzo"}
	    {html {name "form-indirizzo" placeholder "Indirizzo..." class "form-indirizzo form-control"}}
	}
	{provincia:integer(select),optional
		{label "Provincia"}
	    {html {size 1 class "form-control"}}
	    {options {[db_list_of_lists query "select denominazione, provincia_id from province order by denominazione"]}}
	}
	{professione:text,optional
		{label "Professione"}
	    {html {name "form-professione" placeholder "Professione..." class "form-professione form-control"}}
	}
	{selCompetenza_investitori:integer(checkbox),multiple
		{label "Competenze"}
	    {html {class "form-control"}}
	    {options {[db_list_of_lists query "select denominazione, categoria_id from pe_categorie"]}}
	}
	{selAttuale_consulenza:integer(checkbox),multiple
		{label "In quale area hai bisogno di consulenza qualificata?"}
	    {html {class "form-control"}}
	    {options {[db_list_of_lists query "select descrizione, cons_id from pe_consattuale order by cons_id"]}}
	}
	{eta:text,optional
		{label "Età"}
	    {html {name "form-eta" placeholder "Età..." class "form-eta form-control"}}
	}
	{famiglia:text,optional
		{label "Numero membri del nucleo familiare"}
	    {html {name "form-famiglia" placeholder "Numero membri nucleo familiare..." class "form-famiglia form-control"}}
	}
	{selImmobili:text(radio),optional
		{label "Immobili di proprietà"}
	    {html {class "form-control"}}
	    {options {{"Sì" si} {"No" no}}}
	}
	{selInvesti_amministrato:text(radio),optional
		{label "Investi nel risparmio amministrato (Azioni, Obbligazioni, Titoli di Stato)?"}
	    {html {class "form-control"}}
	    {options {{"Sì" si} {"No" no}}}
	}
	{selInvesti_gestito:text(radio),optional
		{label "Investi nel risparmio gestito (Fondi comuni e gestioni patrimoniali)?"}
	    {html {class "form-control"}}
	    {options {{"Sì" si} {"No" no}}}
	}
	{selInvesti_altro:text(radio),optional
		{label "Investi in altri strumenti quotati (Certificates, Covered warrant)?"}
	    {html {class "form-control"}}
	    {options {{"Sì" si} {"No" no}}}
	}
	{patrimonio_complessivo:text,optional
		{label "Ammontare del proprio patrimonio complessivo"}
	    {html {name "form-patrimonio-complessivo" placeholder "Ammontare patrimonio complessivo..." class "form-patrimonio-complessivo form-control"}}
	}
	{disponibilita_finanziaria:text,optional
		{label "Disponibilità finanziaria"}
	    {html {name "form-disponibilita-finanziaria" placeholder "Disponibilità finanziaria..." class "form-disponibilita-finanziaria form-control"}}
	}
	{privacy:integer(checkbox)
		{label "Privacy"}
		{options {{"Acconsento" 1}}}
	}
	} -validate {
		{nome
			{[string length $nome] < 2}
			"Il campo <strong>nome</strong> è vuoto oppure contiene caratteri errati"
		}
		{cognome 
			{[string length $cognome] < 2}
			"Il campo <strong>cognome</strong> è vuoto oppure contiene caratteri errati"
		}
    } -on_submit {
	#Create OpenACS User
	set user_id [db_nextval acs_object_id_seq]
	if {$nickname eq ""} {
	    set $nickname [string tolower $nome]
	    append $nickname "." [string tolower $cognome] "." [db_string query "select trunc(random()*9)"]
	    set $nickname [string map {" " ""} $nickname]
	} else {
	    set $nickname [string map {" " ""} [string tolower $nickname]]
	}
	set password [string tolower $cognome]
	append password [db_string query "select trunc(random()*9999)+1"]
	set password [string map {" " ""} $password]
	array set creation_info [auth::create_user \
				     -user_id $user_id \
				     -username $nickname \
				     -email $email \
				     -first_names $nome \
				     -last_name $cognome \
				     -password $password]
	if {$creation_info(creation_status) ne "ok"} {
	    ad_return_complaint 1 "Error: $creation_info(creation_status) <hr> $creation_info(creation_message)"
	} else {
	    ns_log notice ppp $creation_info(creation_status)
	}
	# Genera nuovo ID Investitore
	set investitore_id [db_string query "SELECT COALESCE(MAX(investitore_id)+ trunc(random()*99+1),1) FROM pe_investitori"]
	
	#Inserimento profilo investitore...
	db_dml query "insert into pe_investitori (investitore_id, password, user_id, telefono, indirizzo, provincia_id, professione, eta, famiglia, immobili, investi_amministrato, investi_gestito, investi_altro, patrimonio_complessivo, disponibilita_finanziarie) values (:investitore_id, :password, :user_id, :telefono, :indirizzo, :provincia, :professione, :eta, :famiglia, :selImmobili, :selInvesti_amministrato, :selInvest_gestito, :selInvesti_altro, :patrimonio_complessivo, :disponibilita_finanziaria)"
	foreach cons_id $selAttuale_consulenza {
	    db_dml query "insert into pe_investitori_consattuale (investitore_id, cons_id) values (:investitore_id, :cons_id)"
	}
	foreach categoria_id $selCompetenza_investitori {
	    db_dml query "insert into pe_investitori_categorie (investitore_id, categoria_id) values (:investitore_id, :categoria_id)"
	}
    } -after_submit {
    	#Imposta email
set nominativo [db_string query "select nome||' ' ||cognome from pe_investitori where user_id = :user_id"]
set from_mail "no-reply@patrimoniaexpert.it"
set to_mail $email
set subject "Benvenuto in PatrimoniaExpert"
set body {
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>[SUBJECT]</title>
  <style type="text/css">
body {
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  padding-top: 0 !important;
  padding-bottom: 0 !important;
  margin: 0 !important;
  width: 100% !important;
  -webkit-text-size-adjust: 100% !important;
  -ms-text-size-adjust: 100% !important;
  -webkit-font-smoothing: antialiased !important;
}
.tableContent img {
  border: 0 !important;
  display: block !important;
  outline: none !important;
}
a {
  color: #000;
}
p, h1 {
  color: #382F2E;
  margin: 0;
}
div, p, ul, h1 {
  margin: 0;
}
p {
  font-size: 13px;
  color: #99A1A6;
  line-height: 19px;
}
h2, h1 {
  color: #444444;
  font-weight: normal;
  font-size: 22px;
  margin: 0;
}
a.link2 {
  padding: 15px;
  font-size: 13px;
  text-decoration: none;
  background: #2D94DF;
  color: #ffffff;
  border-radius: 6px;
  -moz-border-radius: 6px;
  -webkit-border-radius: 6px;
}
.bgBody {
  background: #f6f6f6;
}
.bgItem {
  background: #2C94E0;
}
</style>
  </head>
  <body paddingwidth="0" paddingheight="0" bgcolor="#d1d3d4" style="padding-top: 0; padding-bottom: 0; padding-top: 0; padding-bottom: 0; background-repeat: repeat; width: 100% !important; -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased;" offset="0" toppadding="0" leftpadding="0">
  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableContent bgBody" align="center" style="font-family:Helvetica, Arial,serif;">
    
    <!-- =============================== Header ====================================== -->
    
    <tr>
      <td><table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
          <tr>
          <td class="movableContentContainer"><div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td height="25" colspan="3"></td>
                </tr>
                <tr>
                  <td valign="top" colspan="3"><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td align="left" valign="middle"><div class="contentEditableContainer contentImageEditable">
                            <div class="contentEditable">
                              <center>
<img src="http://www.patrimoniaexpert.it/images/logo.png" alt="Logo" data-default="placeholder" data-max-width="300" width="274" height="91" />
                              </center>
                            </div>
                          </div></td>
                      </tr>
                    </table></td>
                </tr>
              </table>
            </div>
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td height="25">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="border-bottom:3px solid #DDDDDD"></td>
                      </tr>
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                      <tr>
                        <td width="50"></td>
                        <td width="500"><table width="500" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:15px; color:#ffff" align="left">Gentile }
                                      append body $nominativo
                                      append body {</h1>
<h1 style="font-size:15px; color:#ffff" align="left">nel ringraziarti per esserti iscritto al portale <strong>PatrimoniaExpert ti inviamo i tuoi dati d'accesso:</h1>
                                    <p style="font-size:15px; color:#ffff" align="left">&nbsp;</p>

                                    <p style="font-size:15px; color:#ffff" align="left">&nbsp;</p>
                                    <h1 style="font-size:15px; color:#ffff" align="left">
                                    
                                </div></td>
                            </tr>
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                <div class="contentEditable">
                                
                                <!--bo-->
                                
                                <div class="movableContent">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                    <tr>
                                      <td><table width="200" border="0" cellspacing="0" cellpadding="0" align="center">
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td style="border-bottom:1px solid #DDDDDD"></td>
                                          </tr>
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                </div>
                                }
                                
                                <div class="movableContent">
                                  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                    <tr>
                                      <td><table width="200" border="0" cellspacing="0" cellpadding="0" align="center">
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                          <tr>
                                            <td style="border-bottom:1px solid #DDDDDD"></td>
                                          </tr>
                                          <tr>
                                            <td height="15">&nbsp;</td>
                                          </tr>
                                        </table></td>
                                    </tr>
                                  </table>
                                </div>
                                <div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1> </h1>
                                    <h1 style="font-size:15px; color:#ffff">&nbsp;</h1>
                                    <p style="font-size:15px; color:#ffff">&nbsp;</p>
                                    <p style="font-size:15px; color:#ffff">&nbsp;</p>
                                    <h1 style="font-size:15px; color:#F90; font-weight: bold;" align="center">Ti ringraziamo per la disponibilità, ti aspettiamo il 16 marzo a Bari.
                                      </p>
                                      <!---azzurro--> </h1>
                                    <div class="movableContent">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                        <tr>
                                          <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                              <tr>
                                                <td colspan="3" height="10"></td>
                                              </tr>
                                              <tr>
                                                <td width="50"></td>
                                                <td width="540"><table width="400" border="0" cellspacing="0" cellpadding="0" align="center"  bgcolor="#FF9900"valign="top">
                                                    <tr>
                                                      <td align="center"><div class="contentEditableContainer contentTextEditable">
                                                          <div class="contentEditable">
                                                            <h1 style="font-size:20px; color:#FFF; font-weight: bold;">Lo staff di Professione Finanza</h1>
                                                          </div>
                                                        </div></td>
                                                    </tr>
                                                    <tr>
                                                      <td align="center"></td>
                                                    </tr>
                                                  </table></td>
                                                <td width="50"></td>
                                              </tr>
                                              <tr>
                                                <td colspan="3" height="15"></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </div>
                                    
                                    <!--fine azzurro--> 
                                    
                                  </div>
                                </div></td>
                            </tr>
                          </table></td>
                        <td width="50"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="18"></td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                      <tr>
                        <td style="border-bottom:3px solid #DDDDDD"></td>
                      </tr>
                      <tr>
                        <td height="10">&nbsp;</td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              
              <!--data-->
              
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td colspan="3" height="15"></td>
                      </tr>
                      <tr>
                        <td width="50"></td>
                        <td width="500"><table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:36px; color:#27567E"></h1>
                                  </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td height="10"></td>
                            </tr>
                            <tr>
                              <td align="center"><div class="contentEditableContainer contentTextEditable">
                                  <div class="contentEditable">
                                    <h1 style="font-size:32px; color: #F90;"><strong>Ti aspettiamo!</strong> </h1>
                                    <p style="font-size:32px; color: #27567E;">&nbsp;</p>
                                    
                                    <!---azzurro-->
                                    <div class="movableContent">
                                      <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                        <tr>
                                          <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" bgcolor="27567E" valign="top">
                                              <tr>
                                                <td colspan="3" height="20"></td>
                                              </tr>
                                              <tr>
                                                <td width="50"></td>
                                                <td width="500"><table width="549" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                                                    <tr>
                                                      <td align="center"><div class="contentEditableContainer contentTextEditable">
                                                          <div class="contentEditable">
                                                            <h1 style="font-size:20px; color:#FFF" ></h1>
                                                          </div>
                                                        </div></td>
                                                    </tr>
                                                    <tr>
                                                      <td align="center"></td>
                                                    </tr>
                                                  </table></td>
                                                <td width="50"></td>
                                              </tr>
                                              <tr>
                                                <td colspan="3" height="15"></td>
                                              </tr>
                                            </table></td>
                                        </tr>
                                      </table>
                                    </div>
                                    
                                    <!--fine azzurro--> 
                                  </div>
                                </div></td>
                            </tr>
                          </table></td>
                        <td width="50"></td>
                      </tr>
                      <tr>
                        <td colspan="3" height="5"></td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div>
              
              <!--data-->
              
              <div class="movableContent">
              <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                  <tr>
                  <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                      <tr>
                        <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center" valign="top">
                            <tr>
                              <td><table width="600" border="0" cellspacing="0" cellpadding="0" align="center">
                                  <tr>
                                    <td height="10">&nbsp;</td>
                                  </tr>
                                  <tr>
                                    <td style="border-bottom:1px solid #DDDDDD"></td>
                                  </tr>
                                  <tr>
                                    <td height="10">&nbsp;</td>
                                  </tr>
                                </table></td>
                            </tr>
                            <tr>
                              <td height="18">&nbsp;</td>
                            </tr>
                            <tr>
                              <td valign="top" align="center"><div class="contentEditableContainer contentImageEditable">
                                  <div class="contentEditable"> <img src="footer nuovo logo.png" /> </div>
                                </div></td>
                            </tr>
                            <tr>
                              <td height="28">&nbsp;</td>
                            </tr>
                            <tr>
                              <td valign="top" align="center"></td>
                            </tr>
                            <tr>
                              <td height="28">&nbsp;</td>
                            </tr>
                          </table></td>
                      </tr>
                    </table></td>
                </tr>
                </table>
            </div></td>
        </tr>
        </table></td>
    </tr>
  </table>
</body>
</html>
}
acs_mail_lite::send -to_addr $to_mail -from_addr $from_mail -mime_type "text/html" -subject $subject -body $body
	ad_returnredirect dashboard-investitori
	ad_script_abort
    }


ad_return_template
