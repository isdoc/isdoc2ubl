<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:invoice="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"  
  xmlns:isdoc="http://isdoc.cz/namespace/2013"
  xpath-default-namespace="http://isdoc.cz/namespace/2013"
  exclude-result-prefixes="xs isdoc"
  expand-text="yes"
  version="3.0">

  <xsl:output indent="yes"></xsl:output>
  
  <xsl:param name="verbose" select="true()"/>

  <xsl:template match="Invoice">
    <invoice:Invoice>
      <cbc:ID>{ID}</cbc:ID>
      
      <!-- UUID is not part of EU invoice, but it is supported in UBL -->
      <cbc:UUID>{UUID}</cbc:UUID>
      
      <cbc:IssueDate>{IssueDate}</cbc:IssueDate>
      
      <xsl:if test="$verbose and count(PaymentMeans/Payment/Details/PaymentDueDate) > 1">
        <xsl:message>More payments due dates found. Using the earliest date in the output.</xsl:message>
      </xsl:if>
      <cbc:DueDate>{min(PaymentMeans/Payment/Details/PaymentDueDate ! xs:date(.))}</cbc:DueDate>
      
      <!-- Codelist is available at http://www.unece.org/fileadmin/DAM/trade/untdid/d16b/tred/tred1001.htm -->
      <xsl:variable name="document-types" 
                    select="map{ '1': '380' (: invoice :),
                                 '2': '381' (: credit not :),
                                 '3': '383' (: debit note :),
                                 '4': '386' (: proforma invoice (no VAT) :),
                                 '5': '386' (: advance invoice (with VAT) :),
                                 '6': '381' (: credit note for advance invoice (with VAT) :)                                 
                                 }"/>
      <xsl:if test="$verbose and not($document-types(DocumentType))">
        <xsl:message>DocumentType {DocumentType} is not supported.</xsl:message>
      </xsl:if>
      <cbc:InvoiceTypeCode>{$document-types(DocumentType)}</cbc:InvoiceTypeCode>
      
      <xsl:apply-templates select="TaxPointDate"/>
    </invoice:Invoice>
  </xsl:template>
  
  <xsl:template match="TaxPointDate">
    <cbc:TaxPointDate>{.}</cbc:TaxPointDate>
  </xsl:template>
  
</xsl:stylesheet>