pageextension 50104 Customers extends "Customer List"
{
    actions
    {
        addlast(Processing)
        {
            action("CreateCustomerForWCB")
            {
                ApplicationArea = All;
                Caption = 'Create Customers for WCB';
                ToolTip = 'Creates a 5 Customers with Document Sending profile WiseCourierPeppol';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.CreateCustomers();
                    Message('Data created successfully.');
                end;
            }
        }
    }
}
