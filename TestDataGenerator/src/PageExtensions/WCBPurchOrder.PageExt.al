pageextension 50103 PurchOrder extends "Purchase Order List"
{
    actions
    {
        addlast(Processing)
        {
            action("CreatePurchOrder")
            {
                ApplicationArea = All;
                Caption = 'Create Purch Order for WCB';
                ToolTip = 'Creates a Purch Order for a random Vendor  that has Document Sending profile WiseCourierPeppol, if no Vendor exists with that sending profile, a new one will be created';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreatePurchOrder();
                    Message('Data created successfully.');
                end;
            }
        }

    }
}
