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
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CreateData: Codeunit CreateData;
                begin
                    CreateData.Run();
                    Message('Data created successfully.');
                end;
            }
        }

    }
}
