USE AdventureWorks;
GO

-- Tabela City
SELECT 'db.City.insert({_id:' + CAST(c.cCityKey AS VARCHAR) + ', ' +
    'city:"' + c.cCity + '", ' +
    'countryRegionCode:"' + ISNULL(c.cCountryRegionCode, '') + '", ' +
    'countryRegionName:"' + ISNULL(c.cCountryRegionName, '') + '", ' +
    'stateProvinceCode:"' + ISNULL(c.cStateProvinceCode, '') + '", ' +
    'stateProvinceName:"' + ISNULL(c.cStateProvinceName, '') + '"});' AS Script
FROM Sales.City c
ORDER BY c.cCityKey;


SELECT 'db.Territory.insert({_id:' + CAST(stSalesTerritoryKey AS VARCHAR) + ', ' +
    'stSalesTerritoryRegion:"' + stSalesTerritoryRegion + '", ' +
    'stSalesTerritoryCountry:"' + stSalesTerritoryCountry + '", ' +
    'stSalesTerritoryGroup:"' + stSalesTerritoryGroup + '"});' AS Script
FROM Sales.Territory
ORDER BY stSalesTerritoryKey;


SELECT 'db.CustomerInfo.insert({_id:' + CAST(ciCustomerKey AS VARCHAR) + ', ' +
    'cinfoTitle:"' + cinfoTitle + '", ' +
    'cinfoFirstName:"' + cinfoFirstName + '", ' +
    'cinfoMiddleName:"' + cinfoMiddleName + '", ' +
    'cinfoLastName:"' + cinfoLastName + '", ' +
    'cinfoBirthDate:"' + cinfoBirthDate + '", ' +
    'cinfoMaritalStatus:"' + cinfoMaritalStatus + '", ' +
    'cinfoGender:"' + cinfoGender + '", ' +
    'cinfoEmailAddress:"' + cinfoEmailAddress + '", ' +
    'cinfoYearlyIncome:' + CAST(cinfoYearlyIncome AS VARCHAR) + ', ' +
    'cinfoTotalChildren:' + CAST(cinfoTotalChildren AS VARCHAR) + ', ' +
    'cinfoNumberChildrenAtHome:' + CAST(cinfoNumberChildrenAtHome AS VARCHAR) + ', ' +
    'cinfoEducation:"' + cinfoEducation + '", ' +
    'cinfoOccupation:"' + cinfoOccupation + '", ' +
    'cinfoPhone:"' + cinfoPhone + '", ' +
    'cinfoHouseOwnerFlag:' + CAST(cinfoHouseOwnerFlag AS VARCHAR) + ', ' +
    'cinfoNumberCarsOwned:' + CAST(cinfoNumberCarsOwned AS VARCHAR) + '});' AS Script
FROM Sales.CustomerInfo
ORDER BY ciCustomerKey;


SELECT 'db.Currency.insert({_id:' + CAST(curCurrencyKey AS VARCHAR) + ', ' +
    'curCurrencyAcronymKey:"' + curCurrencyAcronymKey + '", ' +
    'curCurrencyName:"' + curCurrencyName + '"});' AS Script
FROM Sales.Currency
ORDER BY curCurrencyKey;


SELECT 'db.Promotion.insert({_id:' + CAST(proPromotionKey AS VARCHAR) + ', ' +
    'proUnitPriceDiscountPct:' + CAST(proUnitPriceDiscountPct AS VARCHAR) + ', ' +
    'proDiscountAmount:' + CAST(proDiscountAmount AS VARCHAR) + '});' AS Script
FROM Sales.Promotion
ORDER BY proPromotionKey;


SELECT 'db.Sale.insert({_id:' + CAST(salSaleKey AS VARCHAR) + ', ' +
    'salProductKey:' + CAST(salProductKey AS VARCHAR) + ', ' +
    'salCustomerKey:' + CAST(salCustomerKey AS VARCHAR) + ', ' +
    'salPromotionKey:' + CAST(salPromotionKey AS VARCHAR) + ', ' +
    'salCurrencyKey:' + CAST(salCurrencyKey AS VARCHAR) + ', ' +
    'salSalesTerritoryKey:' + CAST(salSalesTerritoryKey AS VARCHAR) + ', ' +
    'salSalesOrderNumber:"' + salSalesOrderNumber + '", ' +
    'salRevisionNumber:' + CAST(salRevisionNumber AS VARCHAR) + ', ' +
    'salExtendedAmount:' + CAST(salExtendedAmount AS VARCHAR) + ', ' +
    'salProductStandardCost:' + CAST(salProductStandardCost AS VARCHAR) + ', ' +
    'salTotalProductCost:' + CAST(salTotalProductCost AS VARCHAR) + ', ' +
    'salSalesAmount:' + CAST(salSalesAmount AS VARCHAR) + ', ' +
    'salTaxAmt:' + CAST(salTaxAmt AS VARCHAR) + ', ' +
    'salFreight:' + CAST(salFreight AS VARCHAR) + '});' AS Script
FROM Sales.Sale
ORDER BY salSaleKey;


SELECT 'db.Product.insert({_id:' + 
    CAST(ISNULL(prodProductKey, 'null') AS VARCHAR) + ', ' +
    'prodStandardCost:' + 
    ISNULL(CAST(prodStandardCost AS VARCHAR), 'null') + ', ' +
    'prodFinishedGoodsFlag:"' + 
    ISNULL(prodFinishedGoodsFlag, '') + '", ' +
    'prodSafetyStockLevel:' + 
    ISNULL(CAST(prodSafetyStockLevel AS VARCHAR), 'null') + ', ' +
    'prodListPrice:' + 
    ISNULL(CAST(prodListPrice AS VARCHAR), 'null') +
    '});' AS Script
FROM Factory.Product
ORDER BY prodProductKey;


SELECT 'db.ProductType.insert({_id:' + CAST(ptProductTypeKey AS VARCHAR) + ', ' +
    'ptProductKey:' + COALESCE(CAST(ptProductKey AS VARCHAR), 'null') + ', ' +
    'ptWeightUnitMeasureCode:"' + ISNULL(ptWeightUnitMeasureCode, '') + '", ' +
    'ptSizeUnitMeasureCode:"' + ISNULL(ptSizeUnitMeasureCode, '') + '", ' +
    'ptEnglishProductName:"' + ISNULL(ptEnglishProductName, '') + '", ' +
    'ptSpanishProductName:"' + ISNULL(ptSpanishProductName, '') + '", ' +
    'ptColor:"' + ISNULL(ptColor, '') + '", ' +
    'ptSize:' + COALESCE(CAST(ptSize AS VARCHAR), 'null') + ', ' +
    'ptSizeRange:"' + ISNULL(ptSizeRange, '') + '", ' +
    'ptWeight:' + COALESCE(CAST(ptWeight AS VARCHAR), 'null') + ', ' +
    'ptDaysToManufacture:' + COALESCE(CAST(ptDaysToManufacture AS VARCHAR), 'null') + ', ' +
    'ptStyle:"' + ISNULL(ptStyle, '') + '", ' +
    'ptModelName:"' + ISNULL(ptModelName, '') + '", ' +
    'ptProductSubcategoryKey:' + COALESCE(CAST(ptProductSubcategoryKey AS VARCHAR), 'null') + ', ' +
    'ptEnglishProductCategoryName:"' + ISNULL(ptEnglishProductCategoryName, '') + '", ' +
    'ptSpanishProductCategoryName:"' + ISNULL(ptSpanishProductCategoryName, '') + '", ' +
    'ptEnglishProductSubcategoryName:"' + ISNULL(ptEnglishProductSubcategoryName, '') + '", ' +
    'ptSpanishProductSubcategoryName:"' + ISNULL(ptSpanishProductSubcategoryName, '') + '", ' +
    'ptFrenchProductSubcategoryName:"' + ISNULL(ptFrenchProductSubcategoryName, '') + '"});' AS Script
FROM Factory.ProductType
ORDER BY ptProductTypeKey;


SELECT 'db.Orders.insert({_id:' + CAST(odOrderKey AS VARCHAR) + ', ' +
    'odSalesOrderNumber:"' + odSalesOrderNumber + '", ' +
    'odOrderQuantity:' + CAST(odOrderQuantity AS VARCHAR) + ', ' +
    'odCustomerKey:' + CAST(odCustomerKey AS VARCHAR) + ', ' +
    'odProductKey:' + CAST(odProductKey AS VARCHAR) + ', ' +
    'odUnitPrice:' + CAST(odUnitPrice AS VARCHAR) + ', ' +
    'odCarrierTrackingNumber:"' + ISNULL(odCarrierTrackingNumber, '') + '", ' +
    'odSalesOrderLineNumber:' + CAST(odSalesOrderLineNumber AS VARCHAR) + ', ' +
    'odOrderDate:"' + CONVERT(VARCHAR, odOrderDate, 120) + '", ' +
    'odDueDate:"' + CONVERT(VARCHAR, odDueDate, 120) + '", ' +
    'odShipDate:"' + CONVERT(VARCHAR, odShipDate, 120) + '"});' AS Script
FROM Sales.Orders
ORDER BY odOrderKey;


SELECT 'db.SaleCustomer.insert({_id:' + CAST(scSalesKey AS VARCHAR) + ', ' +
    'scCustomerKey:' + CAST(scCustomerKey AS VARCHAR) + '});' AS Script
FROM Sales.SaleCustomer
ORDER BY scSalesKey, scCustomerKey;


SELECT 'db.Customer.insert({_id:' + CAST(ctCustomerKey AS VARCHAR) + ', ' +
    'ctNameStyle:' + CAST(ctNameStyle AS VARCHAR) + ', ' +
    'ctSalesTerritoryKey:' + COALESCE(CAST(ctSalesTerritoryKey AS VARCHAR), 'null') + ', ' +
    'ctDateFirstPurchase:"' + ISNULL(ctDateFirstPurchase, '') + '", ' +
    'ctCommuteDistance:"' + ISNULL(ctCommuteDistance, '') + '", ' +
    'ctAddressLine1:"' + ISNULL(ctAddressLine1, '') + '", ' +
    'ctAddressLine2:"' + ISNULL(ctAddressLine2, '') + '", ' +
    'ctCityKey:' + COALESCE(CAST(ctCityKey AS VARCHAR), 'null') + ', ' +
    'ctPostalCode:"' + ISNULL(ctPostalCode, '') + '"});' AS Script
FROM Sales.Customer
ORDER BY ctCustomerKey;