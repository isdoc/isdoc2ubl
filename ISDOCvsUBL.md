# Rozdíly mezi ISDOC a evropskou fakturou v UBL

Formát ISDOC byl při svém vzniku inspirován tehdejší verzí formátu
UBL. Používá proto mnoho shodných jmen elementů. Nicméně pro snazší
používání používá jen jeden jmenný prostor. Zároveň formát ISDOC
obsahuje mnoho elementů, které řeší české národní speciality.

Sémantický model evropské faktury je poměrně omezený a pro mnoho
konstrukcí ISDOC v něm neexistuje ekvivalent. Sémantický model
evropské fakutry je však jen podmnožina UBL, a proto některé z
elementů ISDOC mohou být do UBL přeneseny, i když je sémantický model
evropské faktury nepodporuje.

## Doporučené mapování

Doporučené mapování z ISDOC na UBL je realizováno jako ukázková
transformace [`isdoc2ubl.xsl`](isdoc2ubl.xsl).

Mapování některých konstrukcí ISDOC není možné nebo není
jednoznačené. Tyto případy jsou dále rozebrány.

### Datum splatnosti faktury

ISDOC může obsahovat více datumů pro jednotlivé platby. Evropská
faktura podporuje pouze jedno datum. Při mapování se tedy použije
nejdřívější datum splatnosti.

### Typy dokumentů

Typ dokumentu 7 (Zjednodušený daňový doklad) není v mapování
podporován.

### Částky v cizí měně

ISDOC pracuje s částkami v cizí měně dost odlišne než UBL. V ISDOC
může být faktura v cizí měně, ale v tomto případě musí obsahovat
všechny částky jak v cizí měně tak v korunách. V UBL jsou jednotlivé
částky uvedeny vždy pouze v jedné měně, ale ta může být u každé částky
jiná (byť to asi nebývá běžné). Při mapování je tedy potřeba určit,
zda je faktura v cizí měně nebo v korunách. Podle toho se pak při
mapování do UBL dostanou buď jen částky v cizí měně, nebo jen částky v
korunách.





## Elementy ISDOC nepodporované v UBL

Následující tabulka shrnuje elementy ISDOC, které nejde mapovat na UBL.

| Element | Popis |
| --- | --- |
|/Invoice/SubDocumentType|	Podrobnější typ dokumentu. Číselník udržuje a zveřejňuje subjekt identifikovaný v SubDocumentTypeOrigin.
|/Invoice/SubDocumentTypeOrigin|	Správce číselníku podrobnějšího typu dokumentu.
|/Invoice/TargetConsolidator|	Identifikace cílového konsolidátora. Číselník je rozšířený číselník kódů bank a udržuje a zveřejňuje ho ČBA, používá se převážně v B2C systémech velkých výstavců faktur.
|/Invoice/ClientOnTargetConsolidator|	Identifikace klienta v systému výstavce, používá se převážně v B2C systémech velkých výstavců faktur.
|/Invoice/ClientBankAccount|	Kompletní číslo bankovního účtu příjemce faktury včetně kódu banky. Používá se převážně v B2C systémech velkých výstavců faktur.
|/Invoice/EgovFlag|	Příznak režimu "kontrolovaného státem"
|/Invoice/ISDS_ID|	Jednoznačný identifikátor Datové zprávy v systému ISDS, pokud byl dokument odeslán touto cestou
|/Invoice/FileReference|	Spisová značka, pod kterou byl vypraven tento doklad od emitenta, pokud emitent používá na tuto agendu spisovou službu
|/Invoice/ReferenceNumber|	Číslo jednací, pod kterým byl vypraven tento doklad od emitenta, pokud emitent používá na tuto agendu spisovou službu
|/Invoice/EgovClassifiers|	Kolekce klasifikátorů popisující dokument
|/Invoice/EgovClassifiers/EgovClassifier|	Klasifikátor egovernmentu pro výkonové účetnictví státu nebo agendové rozlišení
|/Invoice/IssuingSystem|	Identifikace systému, který odesílá/generuje fakturu
|/Invoice/VATApplicable|	Je předmětem DPH
|/Invoice/ElectronicPossibilityAgreementReference|	Označení dokumentu, kterým dal příjemce vystaviteli souhlas s elektronickou formou faktury
|/Invoice/LocalCurrencyCode|	Kód měny
|/Invoice/CurrRate|	Kurz cizí měny, pokud je použita, jinak 1
|/Invoice/RefCurrRate|	Vztažný kurz cizí měny, většinou 1
|/Invoice/Extensions|	Jakákoliv struktura uživatelských elementů. Elementy musí používat vlastní jmenný prostor.
|/Invoice/AccountingSupplierParty/Party/PartyIdentification/UserID|	Uživatelské číslo firmy/provozovny
|/Invoice/AccountingSupplierParty/Party/PartyIdentification/CatalogFirmIdentification|	Mezinárodní číslo firmy/provozovny, např. EAN
|/Invoice/AccountingSupplierParty/Party/RegisterIdentification|	Identifikace zápisu v rejstříku
|/Invoice/AccountingSupplierParty/Party/RegisterIdentification/RegisterKeptAt|	Správce rejstříku
|/Invoice/AccountingSupplierParty/Party/RegisterIdentification/RegisterFileRef|	Číslo registrace
|/Invoice/AccountingSupplierParty/Party/RegisterIdentification/Preformatted|	Předformátovaná informace o zápisu do rejstříku
|/Invoice/AccountingCustomerParty/Party/PartyIdentification/UserID|	Uživatelské číslo firmy/provozovny
|/Invoice/AccountingCustomerParty/Party/PartyIdentification/CatalogFirmIdentification|	Mezinárodní číslo firmy/provozovny, např. EAN
|/Invoice/AccountingCustomerParty/Party/RegisterIdentification|	Identifikace zápisu v rejstříku
|/Invoice/AccountingCustomerParty/Party/RegisterIdentification/RegisterKeptAt|	Správce rejstříku
|/Invoice/AccountingCustomerParty/Party/RegisterIdentification/RegisterFileRef|	Číslo registrace
|/Invoice/AccountingCustomerParty/Party/RegisterIdentification/Preformatted|	Předformátovaná informace o zápisu do rejstříku
|/Invoice/AnonymousCustomerParty|	Anonymní příjemce zjednodušeného daňového dokladu
|/Invoice/AnonymousCustomerParty/ID|	Unikátní identifikátor
|/Invoice/AnonymousCustomerParty/IDScheme|	Identifikace schématu použitého při tvorbě identifikátoru
|/Invoice/OrderReferences/OrderReference/ExternalOrderIssueDate|	Datum vystavení objednávky vydané (u objednávající strany)
|/Invoice/OrderReferences/OrderReference/ISDS_ID|	ID datové zprávy v ISDS, které vrátilo rozhraní ISDS při prvotním poslání této objednávky
|/Invoice/OrderReferences/OrderReference/FileReference|	Spisová značka, pod kterým byla vypravena písemnost Objednávka ve spisové službě objednatele
|/Invoice/OrderReferences/OrderReference/ReferenceNumber|	Číslo jednací, pod kterým byla vypravena písemnost Objednávka ve spisové službě objednatele
|/Invoice/DeliveryNoteReferences|	Hlavičková kolekce dodacích listů pro případnou vazbu
|/Invoice/DeliveryNoteReferences/DeliveryNoteReference|	Odkaz na související dodací list
|/Invoice/DeliveryNoteReferences/DeliveryNoteReference/ID|	Vlastní identifikátor dodacího listu u dodavatele
|/Invoice/DeliveryNoteReferences/DeliveryNoteReference/IssueDate|	Datum vystavení
|/Invoice/DeliveryNoteReferences/DeliveryNoteReference/UUID|	Unikátní identifikátor GUID
|/Invoice/OriginalDocumentReferences|	Hlavičková kolekce odkazů na původní doklady
|/Invoice/OriginalDocumentReferences/OriginalDocumentReference|	Odkaz na původní doklad, který tento aktuální doklad opravuje (jen pro typy dokumentů 2, 3 a 6)
|/Invoice/OriginalDocumentReferences/OriginalDocumentReference/ID|	Lidsky čitelné číslo původního dokladu
|/Invoice/OriginalDocumentReferences/OriginalDocumentReference/IssueDate|	Datum vystavení původního dokladu
|/Invoice/OriginalDocumentReferences/OriginalDocumentReference/UUID|	Unikátní identifikátor GUID
|/Invoice/ContractReferences/ContractReference/ISDS_ID|	Jednoznačný identifikátor Datové zprávy v systému ISDS, pokud byl dokument odeslán touto cestou
|/Invoice/ContractReferences/ContractReference/FileReference|	Spisová značka, pod kterou byl vypraven tento doklad od emitenta, pokud emitent používá na tuto agendu spisovou službu
|/Invoice/ContractReferences/ContractReference/ReferenceNumber|	Číslo jednací, pod kterým byl vypraven tento doklad od emitenta, pokud emitent používá na tuto agendu spisovou službu
|/Invoice/Delivery/Party|	Identifikace subjektu
|/Invoice/Delivery/Party/PartyIdentification|	Element identifikačních položek subjektu (firmy)
|/Invoice/Delivery/Party/PartyIdentification/UserID|	Uživatelské číslo firmy/provozovny
|/Invoice/Delivery/Party/PartyIdentification/CatalogFirmIdentification|	Mezinárodní číslo firmy/provozovny, např. EAN
|/Invoice/Delivery/Party/RegisterIdentification|	Identifikace zápisu v rejstříku
|/Invoice/Delivery/Party/RegisterIdentification/RegisterKeptAt|	Správce rejstříku
|/Invoice/Delivery/Party/RegisterIdentification/RegisterFileRef|	Číslo registrace
|/Invoice/Delivery/Party/RegisterIdentification/Preformatted|	Předformátovaná informace o zápisu do rejstříku
|/Invoice/InvoiceLines/InvoiceLine/DeliveryNoteReference|	Odkaz na související dodací list
|/Invoice/InvoiceLines/InvoiceLine/DeliveryNoteReference/LineID|	Číslo řádky na dokladu
|/Invoice/InvoiceLines/InvoiceLine/OriginalDocumentReference|	Odkaz na původní doklad, který tento aktuální doklad opravuje (jen pro typy dokumentů 2, 3 a 6)
|/Invoice/InvoiceLines/InvoiceLine/OriginalDocumentReference/LineID|	Číslo řádky na dokladu
|/Invoice/InvoiceLines/InvoiceLine/ContractReference|	Odkaz na související smlouvu
|/Invoice/InvoiceLines/InvoiceLine/ContractReference/ParagraphID|	Identifikace odstavce smlouvy
|/Invoice/InvoiceLines/InvoiceLine/EgovClassifier|	Klasifikátor egovernmentu pro výkonové účetnictví státu nebo agendové rozlišení
|/Invoice/InvoiceLines/InvoiceLine/LineExtensionAmountBeforeDiscount|	Celková cena bez daně na řádku v tuzemské měně před slevou
|/Invoice/InvoiceLines/InvoiceLine/LineExtensionAmountTaxInclusiveCurr|	Celková cena včetně daně na řádku v cizí měně
|/Invoice/InvoiceLines/InvoiceLine/LineExtensionAmountTaxInclusive|	Celková cena včetně daně na řádku v tuzemské měně
|/Invoice/InvoiceLines/InvoiceLine/LineExtensionAmountTaxInclusiveBeforeDiscount|	Celková cena včetně daně na řádku v tuzemské měně před slevou
|/Invoice/InvoiceLines/InvoiceLine/UnitPriceTaxInclusive|	Jednotková cena s daní na řádku v tuzemské měně
|/Invoice/InvoiceLines/InvoiceLine/ClassifiedTaxCategory/VATCalculationMethod|	Způsob výpočtu DPH
|/Invoice/InvoiceLines/InvoiceLine/ClassifiedTaxCategory/VATApplicable|	Je předmětem DPH
|/Invoice/InvoiceLines/InvoiceLine/ClassifiedTaxCategory/LocalReverseCharge|	Lokální režim přenesení daňové povinnosti
|/Invoice/InvoiceLines/InvoiceLine/ClassifiedTaxCategory/LocalReverseCharge/LocalReverseChargeCode|	Kód předmětu plnění DPH pro lokální režim přenesení daňové povinnosti
|/Invoice/InvoiceLines/InvoiceLine/ClassifiedTaxCategory/LocalReverseCharge/LocalReverseChargeQuantity|	Množství
|/Invoice/NonTaxedDeposits|	Kolekce nedaňových zálohových listů
|/Invoice/NonTaxedDeposits/NonTaxedDeposit|	Informace o konkrétním zaplaceném nedaňovém zálohovém listu
|/Invoice/NonTaxedDeposits/NonTaxedDeposit/ID|	Jméno dokladu, identifikace zálohového listu u vystavitele
|/Invoice/NonTaxedDeposits/NonTaxedDeposit/VariableSymbol|	Variabilní symbol, pod kterým byl zálohový list zaplacen
|/Invoice/NonTaxedDeposits/NonTaxedDeposit/DepositAmountCurr|	Kladná částka zálohy v cizí měně
|/Invoice/NonTaxedDeposits/NonTaxedDeposit/DepositAmount|	Kladná částka zálohy v tuzemské měně
|/Invoice/TaxedDeposits|	Kolekce odúčtování zdaněných zálohových listů
|/Invoice/TaxedDeposits/TaxedDeposit|	Informace o konkrétní částce v sazbě na odúčtovaném daňovém zálohovém listu
|/Invoice/TaxedDeposits/TaxedDeposit/ID|	Jméno dokladu, identifikace daňového zálohového listu u vystavitele
|/Invoice/TaxedDeposits/TaxedDeposit/VariableSymbol|	Variabilní symbol
|/Invoice/TaxedDeposits/TaxedDeposit/TaxableDepositAmountCurr|	Kladná část zálohy bez daně v cizí měně
|/Invoice/TaxedDeposits/TaxedDeposit/TaxableDepositAmount|	Kladná část zálohy bez daně v tuzemské měně
|/Invoice/TaxedDeposits/TaxedDeposit/TaxInclusiveDepositAmountCurr|	Kladná část zálohy s daní v cizí měně
|/Invoice/TaxedDeposits/TaxedDeposit/TaxInclusiveDepositAmount|	Kladná část zálohy s daní v tuzemské měně
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory|	Složená položka DPH
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory/Percent|	Procentní sazba DPH
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory/VATCalculationMethod|	Způsob výpočtu DPH
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory/VATApplicable|	Je předmětem DPH
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory/LocalReverseCharge|	Lokální režim přenesení daňové povinnosti
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory/LocalReverseCharge/LocalReverseChargeCode|	Kód předmětu plnění DPH pro lokální režim přenesení daňové povinnosti
|/Invoice/TaxedDeposits/TaxedDeposit/ClassifiedTaxCategory/LocalReverseCharge/LocalReverseChargeQuantity|	Množství
|/Invoice/PaymentMeans/Payment/PaidAmount|	Částka k zaplacení
|/Invoice/PaymentMeans/Payment/Details|	Podrobnosti o platbě
|/Invoice/PaymentMeans/Payment/Details/DocumentID|	Identifikátor svázaného dokladu, například pokladní účtenky
|/Invoice/PaymentMeans/Payment/Details/IssueDate|	Datum vystavení
|/Invoice/PaymentMeans/Payment/Details/VariableSymbol|	Variabilní symbol
|/Invoice/PaymentMeans/Payment/Details/ConstantSymbol|	Konstantní symbol nebo platební titul
|/Invoice/PaymentMeans/Payment/Details/SpecificSymbol|	Specifický symbol
|/Invoice/PaymentMeans/AlternateBankAccounts|	Kolekce dalších bankovních účtů, na které je možno také platit
|/Invoice/PaymentMeans/AlternateBankAccounts/AlternateBankAccount|	Informace o bankovním účtu
|/Invoice/SupplementsList/Supplement/DigestMethod|	Identifikace metody použité při výpočtu otisku přílohy
|/Invoice/SupplementsList/Supplement/DigestValue|	Hodnota otisku přílohy
