pageextension 50102 SalesCrMemo extends "Sales Credit Memos"
{
    actions
    {
        addlast(Processing)
        {
            action("CreateSalesInvoiceForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create Cr.Memo for WCB';
                ToolTip = 'Creates a Cr.Memo for a random Customer that has Document Sending profile WiseCourierPeppol, if no customer exists with that sending profile, a new one will be created';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateSalesCrMemo(false);
                    Message('Data created successfully.');
                end;
            }
            action("CreateSalesInvoiceWithDiscountForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create Cr.Memo with discount for WCB';
                ToolTip = 'Creates a Cr.Memo with discount for a random Customer that has Document Sending profile WiseCourierPeppol, if no customer exists with that sending profile, a new one will be created';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateSalesCrMemo(true);
                    Message('Data created successfully.');
                end;
            }
        }

    }
}
