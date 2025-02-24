use AdventureWorksWeb

load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\City.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Currency.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Customer.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\CustomerInfo.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Order.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Products.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\ProductType.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Promotion.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Sale.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\SaleCustomer.js');
load('C:\\Users\\migue\\Documents\\GitHub\\ProjCBD\\ProjetoCBD Versão final\\imports\\Territory.js');

//Listar por Produto o "histórico de vendas" adquiridos por cidade
db.Sale.aggregate([
  {
    $lookup: {
      from: "Product",
      localField: "salProductKey",
      foreignField: "_id",
      as: "product_info"
    }
  },
  {
    $lookup: {
      from: "City",
      localField: "salSalesTerritoryKey",
      foreignField: "_id",
      as: "city_info"
    }
  },
  {
    $unwind: "$product_info"
  },
  {
    $unwind: "$city_info"
  },
  {
    $group: {
      _id: {
        product_id: "$salProductKey",
        city_id: "$salSalesTerritoryKey"
      },
      total_sales: { $sum: "$salSalesAmount" },
      product_name: { $first: "$product_info.prodEnglishDescription" },
      city_name: { $first: "$city_info.cCity" }
    }
  },
  {
    $project: {
      _id: 0,
      product_id: "$_id.product_id",
      city_id: "$_id.city_id",
      product_name: 1,
      city_name: 1,
      total_sales: 1
    }
  }
])

//Listar por Produto o valor total por mês/ano e a média mensal
db.Sale.aggregate([
  {
    $project: {
      yearMonth: { $dateToString: { format: "%Y-%m", date: "$odOrderDate" } },
      salSalesAmount: 1
    }
  },
  {
    $group: {
      _id: "$yearMonth",
      totalSales: { $sum: "$salSalesAmount" },
      averageSales: { $avg: "$salSalesAmount" }
    }
  },
  {
    $sort: {
      _id: 1
    }
  }
])