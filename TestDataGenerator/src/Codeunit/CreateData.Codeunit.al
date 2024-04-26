codeunit 50100 CreateData
{


    procedure CreateCustomersAndDocuments()
    begin
        CreateCustomersWithDocuments();
    end;

    procedure CreateVendorsAndDocuments()
    begin
        CreateVendorWithDocuments();
    end;

    procedure CreateSalesInvoices(Discount: Boolean)
    begin
        if Discount then
            CreateSalesInvoiceWithDiscount(GetWiseCourierCustomer())
        else
            CreateSalesInvoice(GetWiseCourierCustomer());
    end;

    procedure CreateSalesCrMemo(Discount: Boolean)
    begin
        if Discount then
            CreateCrMemoWithDiscount(GetWiseCourierCustomer())
        else
            CreateCrMemo(GetWiseCourierCustomer());
    end;

    procedure CreatePurchOrder()
    begin
        CreatePurchaseOrder(GetWiseCourierVendor());
    end;

    procedure CreateCustomers()
    var
        CustomerNo: Code[20];
        i: Integer;
    begin
        for i := 1 to 5 do begin
            CustomerNo := '';
            CreateCustomer(CustomerNo, i);
        end;
    end;

    procedure CreateVendors()
    var
        VendorNo: Code[20];
        i: Integer;
    begin
        for i := 1 to 5 do begin
            VendorNo := '';
            CreateVendor(VendorNo, i);
        end;
    end;

    local procedure CreateCustomersWithDocuments()
    var
        CustomerNo: Code[20];
        i: Integer;
    begin
        for i := 1 to 5 do begin
            CustomerNo := '';
            CreateCustomer(CustomerNo, i);
            CreateSalesInvoice(CustomerNo);
            CreateCrMemo(CustomerNo);
        end;
    end;

    local procedure CreateVendorWithDocuments()
    var
        VendorNo: Code[20];
        i: Integer;
    begin
        for i := 1 to 5 do begin
            VendorNo := '';
            CreateVendor(VendorNo, i);
            CreatePurchaseOrder(VendorNo);
        end;
    end;


    local procedure CreateCustomer(Var CustomerNo: Code[20]; i: Integer)
    var
        Customer: Record Customer;
        ShipToAddress: Record "Ship-to Address";
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        LibSales.CreateCustomerWithVATRegNo(Customer);
        LibSales.CreateCustomerAddress(Customer);
        LibSales.CreateCustomerBankAccount(CustomerBankAccount, Customer."No.");
        LibSales.CreateShipToAddress(ShipToAddress, Customer."No.");
        Customer."Document Sending Profile" := 'WISECOURIERPEPPOL';
        Customer."Registration Number" := '123456789' + Format(i);
        Customer.Name := GenerateRandomName();
        Customer.Modify();
        CustomerNo := Customer."No.";
    end;

    local procedure CreateVendor(var VendorNo: Code[20]; i: Integer)
    var
        Vendor: Record Vendor;
        OrderAddress: Record "Order Address";
        VendorBankAccount: Record "Vendor Bank Account";
        LibSales: codeunit "Library - Sales";
    begin
        LibPurchase.CreateVendorWithVATRegNo(Vendor);
        LibPurchase.CreateVendorWithAddress(Vendor);
        LibPurchase.CreateVendorBankAccount(VendorBankAccount, Vendor."No.");
        LibPurchase.CreateOrderAddress(OrderAddress, Vendor."No.");
        Vendor."Document Sending Profile" := 'WISECOURIERPEPPOL';
        Vendor."Registration Number" := '987654321' + Format(i);
        Vendor.Name := GenerateRandomName();
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
            LibSales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, GetRandomItem(), LibRandom.RandInt(15));
            if SalesLine."Unit Price" = 0 then begin
                SalesLine.Validate("Unit Price", LibRandom.RandDecInDecimalRange(1, 50000, 2));
                SalesLine.Modify();
            end;
            Lines += 1;
        end;

    end;

    local procedure CreateSalesInvoiceWithDiscount(CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        Lines: Integer;
    begin
        Lines := 0;
        LibSales.CreateSalesInvoiceForCustomerNo(SalesHeader, CustomerNo);
        while Lines < 5 do begin
            LibSales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, GetRandomItem(), LibRandom.RandInt(15));
            if SalesLine."Unit Price" = 0 then
                SalesLine.Validate("Unit Price", LibRandom.RandDecInDecimalRange(1, 50000, 2));
            SalesLine.Validate(SalesLine."Line Discount %", LibRandom.RandInt(50));
            SalesLine.Modify();
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
        if SalesHeader."Applies-to Doc. Type" = SalesHeader."Applies-to Doc. Type"::" " then begin
            SalesHeader.Validate("Applies-to Doc. Type", SalesHeader."Document Type"::Invoice);
            SalesHeader."Applies-to Doc. No." := Format(LibRandom.RandInt(100000));
            SalesHeader.Modify();
        end;
        while Lines < 5 do begin
            LibSales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, GetRandomItem(), LibRandom.RandInt(15));
            if SalesLine."Unit Price" = 0 then begin
                SalesLine.Validate("Unit Price", LibRandom.RandDecInDecimalRange(1, 50000, 2));
                SalesLine.Modify();
            end;
            Lines += 1;
        end;
    end;

    local procedure CreateCrMemoWithDiscount(CustomerNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        Lines: Integer;
    begin
        Lines := 0;
        LibSales.CreateSalesCreditMemoForCustomerNo(SalesHeader, CustomerNo);
        if SalesHeader."Applies-to Doc. Type" = SalesHeader."Applies-to Doc. Type"::" " then begin
            SalesHeader.Validate("Applies-to Doc. Type", SalesHeader."Document Type"::Invoice);
            SalesHeader."Applies-to Doc. No." := Format(LibRandom.RandInt(100000));
            SalesHeader.Modify();
        end;
        while Lines < 5 do begin
            LibSales.CreateSalesLine(SalesLine, SalesHeader, SalesLine.Type::Item, GetRandomItem(), LibRandom.RandInt(15));
            if SalesLine."Unit Price" = 0 then
                SalesLine.Validate("Unit Price", LibRandom.RandDecInDecimalRange(1, 50000, 2));
            SalesLine.Validate(SalesLine."Line Discount %", LibRandom.RandInt(50));
            SalesLine.Modify();
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
            LibPurchase.CreatePurchaseLine(PurchaseLine, PurchaseHeader, PurchaseLine.Type::Item, GetRandomItem(), LibRandom.RandInt(15));
            if PurchaseLine."Direct Unit Cost" = 0 then begin
                PurchaseLine.Validate("Direct Unit Cost", LibRandom.RandDecInDecimalRange(1, 50000, 2));
                PurchaseLine.Modify();
            end;
            Lines += 1;
        end;
    end;


    local procedure GenerateRandomName(): Text
    var
        FirstNames: Array[10] of Text[50];
        LastNames: Array[10] of Text[50];
        myInteger: Integer;
        FirstNameIndex: Integer;
        LastNameIndex: Integer;
    begin
        FirstNames[1] := 'John';
        FirstNames[2] := 'Jane';
        FirstNames[3] := 'Bob';
        FirstNames[4] := 'Alice';
        FirstNames[5] := 'Charlie';
        FirstNames[6] := 'Bílasalan';
        FirstNames[7] := 'Bílaverkstæði';
        FirstNames[8] := 'Bílaleiga';
        FirstNames[9] := 'Sveitarfélagið';
        FirstNames[10] := 'Heildsalan';

        LastNames[1] := 'Smith';
        LastNames[2] := 'Doe';
        LastNames[3] := 'Johnson';
        LastNames[4] := 'Brown';
        LastNames[5] := 'Davis';

        FirstNameIndex := LibRandom.RandIntInRange(1, ArrayLen(FirstNames));
        LastNameIndex := LibRandom.RandIntInRange(1, ArrayLen(LastNames));

        if FirstNameIndex > 5 then
            exit(FirstNames[FirstNameIndex])
        else
            exit(FirstNames[FirstNameIndex] + ' ' + LastNames[LastNameIndex]);
    end;

    local procedure GetWiseCourierCustomer() CustomerNo: Code[20]
    var
        Customer: Record Customer;
        Counter: Integer;
        RandomCustomer: Integer;
    begin
        Customer.SetRange("Document Sending Profile", 'WISECOURIERPEPPOL');
        If Customer.IsEmpty then begin
            CreateCustomer(CustomerNo, LibRandom.RandInt(9));
            exit;
        end else begin
            Customer.FindSet();
            Counter := Customer.count();
            RandomCustomer := LibRandom.RandIntInRange(1, Counter);
            Customer.Next(RandomCustomer);
            CustomerNo := Customer."No.";
        end;

    end;

    local procedure GetWiseCourierVendor() VendorNo: Code[20]
    var
        Vendor: Record Vendor;
        Counter: Integer;
        RandomCustomer: Integer;
    begin
        Vendor.SetRange("Document Sending Profile", 'WISECOURIERPEPPOL');
        If Vendor.IsEmpty then begin
            CreateVendor(VendorNo, LibRandom.RandInt(9));
            exit;
        end else begin
            Vendor.FindSet();
            Counter := Vendor.count();
            RandomCustomer := LibRandom.RandIntInRange(1, Counter);
            Vendor.Next(RandomCustomer);
            VendorNo := Vendor."No.";
        end;

    end;

    local procedure GetRandomItem() ItemNo: Code[20]
    var
        Item: Record Item;
        Counter: Integer;
        RandomItem: Integer;
    begin
        Item.FindSet();
        Counter := Item.count();
        RandomItem := LibRandom.RandIntInRange(1, Counter);
        Item.Next(RandomItem);
        ItemNo := Item."No.";
    end;


    var
        LibSales: codeunit "Library - Sales";
        LibPurchase: codeunit "Library - Purchase";

        libraryinventory: codeunit "Library - Inventory";
        LibRandom: codeunit "Library - Random";
}
