pageextension 50100 WCBSetup extends "RSMBAS Setup"
{
    actions
    {
        addlast(Processing)
        {
            action("CreateDataForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create Data for WCB';
                ToolTip = 'Creates 5 customers and 5 vendors. One Sales Invoice and one Sales Cr. Memo will be created for each customer and for each vendor a Purchase Order will be created';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateCustomersAndDocuments();
                    CreateData.CreateVendorsAndDocuments();
                    Message('Data created successfully.');
                end;
            }
        }

    }
}
