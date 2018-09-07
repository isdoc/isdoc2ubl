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
  
  <xsl:param name="verbose" select="true()" static="true"/>
  
  <xsl:variable name="in-foreign-currency" select="exists(/Invoice/ForeignCurrencyCode)"/>
  <xsl:variable name="currency" select="if ($in-foreign-currency) then /Invoice/ForeignCurrencyCode else /Invoice/LocalCurrencyCode"/>
  

  <xsl:template match="Invoice">
    <invoice:Invoice>
      <cbc:ID>{ID}</cbc:ID>
      
      <!-- UUID is not part of EU invoice, but it is supported in UBL -->
      <cbc:UUID>{UUID}</cbc:UUID>
      
      <cbc:IssueDate>{IssueDate}</cbc:IssueDate>
      
      <xsl:if test="count(PaymentMeans/Payment/Details/PaymentDueDate) > 1">
        <xsl:message use-when="$verbose">More payments due dates found. Using the earliest date in the output.</xsl:message>
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
      <xsl:if test="not($document-types(DocumentType))">
        <xsl:message use-when="$verbose">DocumentType {DocumentType} is not supported.</xsl:message>
      </xsl:if>
      <cbc:InvoiceTypeCode>{$document-types(DocumentType)}</cbc:InvoiceTypeCode>
      
      <xsl:apply-templates select="TaxPointDate"/>
      
      <!-- ForeignCurrencyCode is optional in ISDOC, but mandatory in EU -->    
      <xsl:apply-templates select="ForeignCurrencyCode"/>
      <xsl:if test="not(ForeignCurrencyCode)">
        <xsl:apply-templates select="LocalCurrencyCode"/>
      </xsl:if>
      
      <xsl:apply-templates select="OrderReferences"/>
      
      <xsl:apply-templates select="ContractReferences"/>
      
      <xsl:apply-templates select="AccountingSupplierParty"/>
      
      <xsl:apply-templates select="AccountingCustomerParty"/>

      <xsl:apply-templates select="BuyerCustomerParty"/>

      <xsl:apply-templates select="SellerSupplierParty"/>
      
      <xsl:apply-templates select="Delivery"/>
      
      <xsl:apply-templates select="InvoiceLines"/>
      
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

  <xsl:template match="AccountingCustomerParty">
    <cac:AccountingCustomerParty>
      <xsl:apply-templates select="Party"/>
    </cac:AccountingCustomerParty>
  </xsl:template>

  <xsl:template match="SellerSupplierParty">
    <!-- SellerSupplierParty is not in EU semantic model but UBL supports it -->
    <cac:SellerSupplierParty>
      <xsl:apply-templates select="Party"/>
    </cac:SellerSupplierParty>
  </xsl:template>

  <xsl:template match="BuyerCustomerParty">
    <!-- BuyerCustomerParty is not in EU semantic model but UBL supports it -->
    <cac:BuyerCustomerParty>
      <xsl:apply-templates select="Party"/>
    </cac:BuyerCustomerParty>
  </xsl:template>
  
  <xsl:template match="Party">
    <cac:Party>
      <xsl:apply-templates select="PartyIdentification"/>
      <xsl:apply-templates select="PartyName"/>
      <xsl:apply-templates select="PostalAddress"/>
      <xsl:apply-templates select="PartyTaxScheme"/>
      <xsl:apply-templates select="RegisterIdentification"/>
      <xsl:apply-templates select="Contact"/>
    </cac:Party>
  </xsl:template>

  <xsl:template match="PartyIdentification">
    <cac:PartyIdentification>
      <cbc:ID schemeID="FIXME">{ID}</cbc:ID>
      <!-- FIXME: schemeID for IČO must be registered as ICD according to ISO/IEC 6523 -->
      <xsl:if test="UserID">
        <xsl:message use-when="$verbose">Do not know how to map UserID into ICD identification scheme. Skipping element.</xsl:message>
      </xsl:if>
      <xsl:if test="CatalogFirmIdentification">
        <xsl:message use-when="$verbose">Do not know how to map CatalogFirmIdentification into ICD identification scheme.  Skipping element.</xsl:message>
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
  
  <xsl:template match="PostalAddress">
    <cac:PostalAddress>
      <xsl:apply-templates select="StreetName"/>
      <xsl:apply-templates select="CityName"/>
      <xsl:apply-templates select="PostalZone"/>
      <xsl:apply-templates select="Country"/>
    </cac:PostalAddress>
  </xsl:template>

  <xsl:template match="Delivery/Party/PostalAddress" mode="PostalAddressAsAddress">
    <cac:Address>
      <xsl:apply-templates select="StreetName"/>
      <xsl:apply-templates select="CityName"/>
      <xsl:apply-templates select="PostalZone"/>
      <xsl:apply-templates select="Country"/>
    </cac:Address>
  </xsl:template>
  
  <xsl:template match="StreetName">
    <cbc:StreetName>
      <xsl:value-of select="."/>
      <xsl:if test="following-sibling::BuildingNumber">
        <xsl:text> </xsl:text>
        <xsl:value-of select="following-sibling::BuildingNumber"/>
      </xsl:if>
    </cbc:StreetName>
  </xsl:template>
  
  <xsl:template match="CityName">
    <cbc:CityName>{.}</cbc:CityName>
  </xsl:template>
  
  <xsl:template match="PostalZone">
    <cbc:PostalZone>{.}</cbc:PostalZone>
  </xsl:template>
  
  <xsl:template match="Country">
    <cac:Country>
      <xsl:apply-templates select="IdentificationCode"/>
    </cac:Country>
  </xsl:template>
  
  <xsl:template match="IdentificationCode">
    <cbc:IdentificationCode>{.}</cbc:IdentificationCode>
  </xsl:template>
  
  <xsl:template match="PartyTaxScheme">
    <cac:PartyTaxScheme>
      <xsl:apply-templates select="CompanyID"/>
      <xsl:apply-templates select="TaxScheme"/>
    </cac:PartyTaxScheme>
  </xsl:template>
  
  <xsl:template match="CompanyID">
    <cbc:CompanyID>{.}</cbc:CompanyID>
  </xsl:template>
  
  <xsl:template match="TaxScheme">
    <cac:TaxScheme>
      <cbc:ID>{.}</cbc:ID>
    </cac:TaxScheme>
  </xsl:template>
  
  <xsl:template match="Contact">
    <cac:Contact>
      <xsl:apply-templates select="Name"/>
      <xsl:apply-templates select="Telephone"/>
      <xsl:apply-templates select="ElectronicMail"/>
    </cac:Contact>
  </xsl:template>
  
  <xsl:template match="Telephone">
    <cbc:Telephone>{.}</cbc:Telephone>
  </xsl:template>

  <xsl:template match="ElectronicMail">
    <cbc:ElectronicMail>{.}</cbc:ElectronicMail>
  </xsl:template>
  
  <xsl:template match="RegisterIdentification">
    <cac:PartyLegalEntity>
      <xsl:apply-templates select="RegisterDate"/>
      <!-- 
        FIXME: how to represent these
        RegisterIdentification/RegisterFileRef
        RegisterIdentification/RegisterKeptAt
        RegisterIdentification/Preformatted
      -->
      <xsl:apply-templates select="RegisterFileRef | RegisterKeptAt | Preformatted"/>
    </cac:PartyLegalEntity>
  </xsl:template>
  
  <xsl:template match="RegisterDate">
    <cbc:RegistrationDate>{.}</cbc:RegistrationDate>
  </xsl:template>
  
  <xsl:template match="OrderReferences">
    <xsl:choose>
      <xsl:when test="count(OrderReference) > 1">
        <xsl:message use-when="$verbose">Only one OrderReference is supported. Skipping all OrderReferences.</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="OrderReference"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="OrderReference">
    <cac:OrderReference>
      <cbc:ID>{ExternalOrderID}</cbc:ID>
      <xsl:apply-templates select="SalesOrderID"/>
      <xsl:apply-templates select="IssueDate"/>
      <xsl:apply-templates select="UUID"/>
      <xsl:apply-templates select="ISDS_ID"/>
      <xsl:apply-templates select="ExternalOrderIssueDate"/>
      <xsl:apply-templates select="FileReference"/>
      <xsl:apply-templates select="ReferenceNumber"/>
    </cac:OrderReference>
  </xsl:template>
  
  <xsl:template match="SalesOrderID">
    <cbc:SalesOrderID>{.}</cbc:SalesOrderID>
  </xsl:template>
  
  <xsl:template match="IssueDate">
    <cbc:IssueDate>{.}</cbc:IssueDate>
  </xsl:template>

  <xsl:template match="UUID">
    <cbc:UUID>{.}</cbc:UUID>
  </xsl:template>
  
  <xsl:template match="ContractReferences">
    <xsl:apply-templates select="ContractReference"/>
  </xsl:template>
  
  <xsl:template match="ContractReference">
    <cac:ContractDocumentReference>
      <xsl:apply-templates select="ID"/>
      <xsl:apply-templates select="UUID"/>
      <xsl:apply-templates select="IssueDate"/>
      <xsl:if test="LastValidDate  | LastValidDateUnbouded">
        <cac:ValidityPeriod>
          <xsl:apply-templates select="LastValidDate  | LastValidDateUnbouded"/>
        </cac:ValidityPeriod>
      </xsl:if>
      <xsl:apply-templates select="ISDS_ID"/>
      <xsl:apply-templates select="FileReference"/>
      <xsl:apply-templates select="ReferenceNumber"/>
    </cac:ContractDocumentReference>
  </xsl:template>
  
  <xsl:template match="ID">
    <cbc:ID>{.}</cbc:ID>
  </xsl:template>
  
  <xsl:template match="LastValidDate">
    <cbc:EndDate>{.}</cbc:EndDate>
  </xsl:template>
  
  <xsl:template match="LastValidDateUnbounded">
    <xsl:message use-when="$verbose">Unbounded last valid date of contract has been replaced by 9999-12-31.</xsl:message>
    <cbc:EndDate>9999-12-31</cbc:EndDate>
  </xsl:template>
  
  <xsl:template match="Delivery">
    <cac:Delivery>
      <xsl:if test="Party/PostalAddress">
        <cac:DeliveryLocation>          
          <xsl:apply-templates select="Party/PostalAddress" mode="PostalAddressAsAddress"/>
        </cac:DeliveryLocation>
      </xsl:if>
      <cac:DeliveryParty>
        <xsl:apply-templates select="Party/*"/>
      </cac:DeliveryParty>
    </cac:Delivery>
  </xsl:template>
  
  <xsl:template match="InvoiceLines">
    <xsl:apply-templates select="InvoiceLine"/>
  </xsl:template>
  
  <xsl:template match="InvoiceLine">
    <cac:InvoiceLine>
      <xsl:apply-templates select="ID"/>
      
      <xsl:apply-templates select="InvoicedQuantity"/>
      
      <xsl:apply-templates select="if ($in-foreign-currency) then LineExtensionAmountCurr else LineExtensionAmount"/>
      
      <xsl:apply-templates select="OrderReference"/>
      
      <!-- FIXME: DeliveryNoteReference, OriginalDocumentReference, ContractReference, EgovClassifier -->
      
      <xsl:apply-templates select="LineExtensionAmountBeforeDiscount
                                   | LineExtensionAmountTaxInclusiveCurr
                                   | LineExtensionAmountTaxInclusive
                                   | LineExtensionAmountTaxInclusiveBeforeDiscount"/>
      
      <xsl:apply-templates select="LineExtensionTaxAmount"/>
      
    </cac:InvoiceLine>
  </xsl:template>
  
  <xsl:template match="InvoicedQuantity">
    <cbc:InvoicedQuantity>
      <xsl:copy-of select="@unitCode"/>
      <xsl:value-of select="."/>
    </cbc:InvoicedQuantity>
  </xsl:template>
  
  <xsl:template match="LineExtensionAmount | LineExtensionAmountCurr">
    <cbc:LineExtensionAmount currencyID="{$currency}">{.}</cbc:LineExtensionAmount>
  </xsl:template>
  
  <!-- Supported in UBL, but not part of EU SM -->
  <xsl:template match="LineExtensionTaxAmount">
    <cac:TaxTotal>
      <cbc:TaxAmount currencyID="{$currency}">{.}</cbc:TaxAmount>
    </cac:TaxTotal>
  </xsl:template>
  
  <xsl:key name="OrderReference" match="OrderReference" use="@id"/>
  
  <xsl:template match="InvoiceLine/OrderReference">
    <cac:OrderLineReference>
      <xsl:apply-templates select="LineID"/>
      <xsl:apply-templates select="key('OrderReference', @ref)"/>
    </cac:OrderLineReference>
  </xsl:template>
  
  <xsl:template match="LineID">
    <cbc:LineID>{.}</cbc:LineID>
  </xsl:template>
  
  <xsl:template match="ISDS_ID | ExternalOrderIssueDate | FileReference | ReferenceNumber
                      | RegisterFileRef | RegisterKeptAt | Preformatted
                      | LineExtensionAmountBeforeDiscount
                      | LineExtensionAmountTaxInclusiveCurr
                      | LineExtensionAmountTaxInclusive
                      | LineExtensionAmountTaxInclusiveBeforeDiscount
                      | *">
    <xsl:if test="$verbose">
      <xsl:message>Skipping {local-name()} element.</xsl:message>
    </xsl:if>
  </xsl:template>
  
 
  
</xsl:stylesheet>