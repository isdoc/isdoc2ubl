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
      
      <!-- ForeignCurrencyCode is optional in ISDOC, but mandatory in EU -->    
      <xsl:apply-templates select="ForeignCurrencyCode"/>
      <xsl:if test="not(ForeignCurrencyCode)">
        <xsl:apply-templates select="LocalCurrencyCode"/>
      </xsl:if>
      
      <xsl:apply-templates select="AccountingSupplierParty"/>
      
        
      
    </invoice:Invoice>
    
    
  </xsl:template>
  
  <xsl:template match="TaxPointDate">
    <cbc:TaxPointDate>{.}</cbc:TaxPointDate>
  </xsl:template>

  <!-- LocalCurrencyCode is used only if ForeignCurrencyCode is not specified --> 
  <xsl:template match="ForeignCurrencyCode | LocalCurrencyCode">
    <cbc:DocumentCurrencyCode>{.}</cbc:DocumentCurrencyCode>
  </xsl:template>
  
  <xsl:template match="AccountingSupplierParty">
    <cac:AccountingSupplierParty>
      <xsl:apply-templates select="Party"/>
    </cac:AccountingSupplierParty>
  </xsl:template>
  
  <xsl:template match="Party">
    <cac:Party>
      <xsl:apply-templates select="Contact/ElectronicMail"/>
      <xsl:apply-templates select="PartyIdentification"/>
      <xsl:apply-templates select="PartyName"/>
      <!-- 
PartyName
PartyName/Name
PostalAddress
PostalAddress/StreetName
PostalAddress/BuildingNumber
PostalAddress/CityName
PostalAddress/PostalZone
PostalAddress/Country
PostalAddress/Country/IdentificationCode
PostalAddress/Country/Name
PartyTaxScheme
PartyTaxScheme/CompanyID
PartyTaxScheme/TaxScheme
RegisterIdentification
RegisterIdentification/RegisterKeptAt
RegisterIdentification/RegisterFileRef
RegisterIdentification/RegisterDate
RegisterIdentification/Preformatted
Contact
Contact/Name
Contact/Telephone
-->
    </cac:Party>
  </xsl:template>

  <xsl:template match="ElectronicMail">
    <cbc:EndpointID schemeID="EMAIL">{.}</cbc:EndpointID>
    <!-- FIXME: Find code list specifing schemaID values 
         "EMAIL" is used in example in CEN TS 16931-3-2 but CEF should be maintaining and providing actual codelist 
    -->
  </xsl:template>
  
  <xsl:template match="PartyIdentification">
    <cac:PartyIdentification>
      <cbc:ID schemeID="FIXME">{ID}</cbc:ID>
      <!-- FIXME: schemeID for IČO must be registered as ICD according to ISO/IEC 6523 -->
      <xsl:if test="UserID">
        <xsl:message>Do not know how to map UserID into ICD identification scheme. Skipping element.</xsl:message>
      </xsl:if>
      <xsl:if test="CatalogFirmIdentification">
        <xsl:message>Do not know how to map CatalogFirmIdentification into ICD identification scheme.  Skipping element.</xsl:message>
      </xsl:if>
    </cac:PartyIdentification>
  </xsl:template>
  
  <xsl:template match="PartyName">
    <cac:PartyName>
      <xsl:apply-templates select="Name"/>
    </cac:PartyName>
  </xsl:template>
  
  <xsl:template match="Name">
    <cbc:Name>{.}</cbc:Name>
  </xsl:template>

</xsl:stylesheet>