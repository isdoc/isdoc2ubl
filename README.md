# ISDOC2UBL

Repozitář obsahuje nástroje pro konverzi faktur ve formátu
[ISDOC](http://www.isdoc.cz/6.0.1/readme-cs.html) do UBL syntaxe
evropského formátu faktur (EN 16931).

Obsah repozitáře:

* `isdoc2ubl.xsl` -- transformace ISDOC do UBL zapsaná v jazyce
  XSLT 3.0

* `test/*` -- adresář s testovacími fakturami ve formátu ISDOC

* `xsd/*` -- XML schémata pro ISDOC a UBL

Nástroje slouží jako ukázka. Vzhledem k velkému množství rozdílů mezi formáty není doporučeno nástroj bez dalších úprav používat v produkčním prostředí.

Nástroje v této repozitory je možné používat v souladu s [licencí](LICENSE).

## Rozdíly mezi formáty

Formát ISDOC je v mnoha aspektech bohatší než formát evropské
faktury. Při konverzi některých faktur tak při převodu dochází ke
ztrátě informací. Transformace se v těchto případech snaží vypsáním
varování upozornit na údaje, které se nepřenášejí.

Podrobnější popis rozdílů mezi oběma formáty najdete [v samostatném dokumentu](ISDOCvsUBL.md).

## Spouštění konverze

Převod faktury ve formátu ISDOC na evropskou fakturu ve formátu UBL
může být proveden pomocí volně dostupného procesoru XSLT
Saxon. Stáhnout je možné jej např. z adresy
https://sourceforge.net/projects/saxon/files/Saxon-HE/9.9/

````
java -jar saxon9he.jar -s:_vstupní dokument.isdoc_ -xsl:isdoc2ubl.xsl -o:_výstup.xml_
````

Pokud dokument ISDOC obsahuje údaje, které nejde zkonvertovat, vypíše
se o tom informace na výstup. Vypisování upozornění lze potlačit
pomocí parametru `verbose`:

````
java -jar saxon9he.jar -s:_vstupní dokument.isdoc_ -xsl:isdoc2ubl.xsl -o:_výstup.xml_ ?verbose=false()
````



