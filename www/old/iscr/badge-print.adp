<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>Badge-PFexpo2015</title>
  </head>
<body>
<table width ="100%">
   <tr>
     <td><font><p align="left">@parametro@</p></font></td>
     <td><font><p align="left">@comune@</p></font></td>
     <td><font><p align="right">@datastamp@</p></font></td>
   </tr>
</table>
<br>
<br>
<table width="100%">
   <tr>
     <td align=left><font size=40><b> ELENCO DETTAGLI FATTURE</b></font></td>
     <td align=right><font size=10> <p align = "right"> PAG.@sheets@ </p></font></td>
   </tr>
</table>
<table cellpadding="1" cellspacing="1" border=0.1 width="100%">
 <tr>
<br>
</tr>
<tr>
<br>
<br>
</tr>

  <tr>
    <td align = center width="13%"> <font size=4> <b>FATATURA</b></font></td>
       <td align = center width="14%"> <font size=4> <b>DATA EM.</b> </font> </td>
    <td align = center width="25%"> <font size=4> <b>CLIENTI</b> </font> </td>
    <td align = center width="15%"> <font size=4> <b>TIPI PAGAMENTO</b> </font> </td>
    <td align = center width="10%"> <font size=4> <b>PRODOTTI</b> </font> </td>
    <td align = center width="10%"> <font size=4> <b>QTA</b> </font> </td>
    <td align = center width="13%"> <font size=4> <b>PREZZI</b> </font> </td>
</tr>
<tr>
    <td align = center ><font size=3> 
       <multiple name="dettfattc">@dettfattc.fattura;noquote@<br>&nbsp;<br></multiple>
    </font></td>
   <td align = center ><font size=3>
      <multiple name="dettfattc">@dettfattc.dataemiss;noquote@<br>&nbsp;<br></multiple>
    </font></td>
<td align = center ><font size=3>
      <multiple name="dettfattc">@dettfattc.clienti;noquote@<br>&nbsp;<br></multiple>
    </font></td>
<td align = center ><font size=3>
      <multiple name="dettfattc">@dettfattc.tipopag;noquote@<br>&nbsp;<br></multiple>
    </font></td>
<td align = center ><font size=3>
      <multiple name="dettfattc">@dettfattc.prodotti;noquote@<br>&nbsp;<br></multiple>
    </font></td>
<td align = center ><font size=3>
      <multiple name="dettfattc">@dettfattc.quantita;noquote@<br>&nbsp;<br></multiple>
    </font></td>
<td align = right><font size=3>
      <multiple name="dettfattc">@dettfattc.prezzo;noquote@<br>&nbsp;<br></multiple>
    </font></td>


</tr>  
</table>

</body>

</html>
