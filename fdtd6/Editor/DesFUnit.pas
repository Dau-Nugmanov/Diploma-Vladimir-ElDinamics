unit DesFUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TDescrForm = class(TForm)
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DescrForm: TDescrForm;

implementation

{$R *.DFM}

procedure TDescrForm.FormShow(Sender: TObject);
begin
  Memo1.SetFocus;
end;

end.
