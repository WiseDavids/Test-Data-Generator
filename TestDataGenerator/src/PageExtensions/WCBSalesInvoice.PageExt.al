pageextension 50101 SalesInvoice extends "Sales Invoice List"
{
    actions
    {
        addlast(Processing)
        {
            action("CreateSalesInvoiceForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create SalesInvoice for WCB';
                ToolTip = 'Creates a Sales Invoice for a random Customer that has Document Sending profile WiseCourierPeppol, if no customer exists with that sending profile, a new one will be created';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateSalesInvoices(false);
                    Message('Data created successfully.');
                end;
            }
            action("CreateSalesInvoiceWithDiscountForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create SalesInvoice with discount for WCB';
                ToolTip = 'Creates a Sales Invoice with discount for a random Customer that has Document Sending profile WiseCourierPeppol, if no customer exists with that sending profile, a new one will be created';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateSalesInvoices(true);
                    Message('Data created successfully.');
                end;
            }
        }

    }
}
