pageextension 50105 Vendors extends "Vendor List"
{
    actions
    {
        addlast(Processing)
        {
            action("CreateVendorsForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create Vendors for WCB';
                ToolTip = 'Creates a 5 Vendors with Document Sending profile WiseCourierPeppol';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateVendors();
                    Message('Data created successfully.');
                end;
            }
        }
    }
}
