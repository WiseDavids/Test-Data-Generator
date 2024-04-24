codeunit 50100 CreateData
{

    trigger OnRun()
    var


    begin
        CreateCustomers();
        CreateVendors();

    end;

    local procedure CreateCustomers()
    var
        CustomerNo: Code[20];
        i: Integer;
    begin
        for i := 1 to 5 do begin
            CustomerNo := '';
            CreateCustomer(CustomerNo);
            CreateSalesInvoice(CustomerNo);
            CreateCrMemo(CustomerNo);
        end;
    end;

    local procedure CreateVendors()
    var
        VendorNo: Code[20];
        i: Integer;
    begin
        for i := 1 to 5 do begin
            VendorNo := '';
            CreateVendor(VendorNo);
            CreatePurchaseOrder(VendorNo);
        end;
    end;


    local procedure CreateCustomer(Var CustomerNo: Code[20])
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        LibSales.CreateCustomer(Customer);
        LibSales.CreateCustomerAddress(Customer);
        LibSales.CreateCustomerBankAccount(CustomerBankAccount, Customer."No.");
        LibSales.CreateShipToAddress(ShipToAddress, Customer."No.");
        Customer."Document Sending Profile" := 'WISECOURIERPEPPOL';
        Customer.Modify();
        CustomerNo := Customer."No.";
    end;

    local procedure CreateVendor(var VendorNo: Code[20])
    var
        Vendor: Record Vendor;
        OrderAddress: Record "Order Address";
        VendorBankAccount: Record "Vendor Bank Account";
        LibSales: codeunit "Library - Sales";
    begin
        LibPurchase.CreateVendorWithAddress(Vendor);
        LibPurchase.CreateVendorBankAccount(VendorBankAccount, Vendor."No.");
        LibPurchase.CreateOrderAddress(OrderAddress, Vendor."No.");
        Vendor."Document Sending Profile" := 'WISECOURIERPEPPOL';
        Vendor.Modify();
        VendorNo := Vendor."No.";
    end;

    local procedure CreateSalesInvoice(CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        Lines: Integer;
    begin
        Lines := 0;
        LibSales.CreateSalesInvoiceForCustomerNo(SalesHeader, CustomerNo);
        while Lines < 5 do begin
            libraryinventory.CreateItemWithUnitPriceAndUnitCost(Item, LibRandom.RandDecInRange(1, 100, 2), LibRandom.RandDecInRange(1, 100, 2));
            LibSales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibRandom.RandInt(100));
            Lines += 1;
        end;

    end;

    local procedure CreateCrMemo(CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        Lines: Integer;
    begin
        Lines := 0;
        LibSales.CreateSalesCreditMemoForCustomerNo(SalesHeader, CustomerNo);
        while Lines < 5 do begin
            libraryinventory.CreateItemWithUnitPriceAndUnitCost(Item, LibRandom.RandDecInRange(1, 100, 2), LibRandom.RandDecInRange(1, 100, 2));
            LibSales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, Item."No.", LibRandom.RandInt(100));
            Lines += 1;
        end;

    end;

    local procedure CreatePurchaseOrder(VendorNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ItemVendor: Record "Item Vendor";
        Item: Record Item;
        Lines: Integer;
    begin
        Lines := 0;
        LibPurchase.CreatePurchaseOrderForVendorNo(PurchaseHeader, VendorNo);
        while Lines < 5 do begin
            libraryinventory.CreateItemWithUnitPriceAndUnitCost(Item, LibRandom.RandDecInRange(1, 100, 2), LibRandom.RandDecInRange(1, 100, 2));
            libraryinventory.CreateItemVendor(ItemVendor, VendorNo, Item."No.");
            LibPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, Item."No.", LibRandom.RandInt(100));
            Lines += 1;
        end;
    end;


    var
        LibSales: codeunit "Library - Sales";
        LibPurchase: codeunit "Library - Purchase";

        libraryinventory: codeunit "Library - Inventory";
        LibRandom: codeunit "Library - Random";
}
