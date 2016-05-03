ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
}
set nome "Ciao"
set cognome "Ciao"
set html "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
  <head>
    <title>Badge PFEXPO15 - Milano.pdf</title>
  </head>
  <body>
    <table align=\"center\" height=\"90em\" width=\"640em\">
      <tr height=\"1%\" bgcolor=\"#194B82\" width=\"640em\">
        <td colspan=\"2\" align=\"center\" width=\"320em\" border=1>
          <img src=\"http://images.professionefinanza.com/logos/pfexpo.png\" width=\"18%\" height=\"8%\"align=\"center\">
        </td>
      </tr>
      <tr height=\"75%\"> 
        <td align=\"center\">
          <font face=\"Helvetica\" size=\"6px\">$nome<br>$cognome</font> 
        </td>
      </tr>
      <tr height=\"0.2em\" bgcolor=\"#194B82\" colspan=\"3\">
        <td>&nbsp;</td>
      </tr>
    </table>
  </body>
</html>
"
set filenamehtml "/tmp/badge-print.html"
set filenamepdf  "/tmp/badge-print.pdf"
set file_html [open $filenamehtml w]
puts $file_html $html
close $file_html
with_catch error_msg {
    exec htmldoc --portrait --webpage --header ... --footer ... --quiet --left 0.5cm --right 0.5cm --top 0.5cm --bottom 0.5cm --charset utf-8 --fontsize 12 -f $filenamepdf $filenamehtml
} {
    ns_log notice "errore htmldoc <code>$error_msg</code>"
}
ns_returnfile 200 application/pdf $filenamepdf
ns_unlink $filenamepdf
ns_unlink $filenamehtml
ad_script_abort
