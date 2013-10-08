unit IPFUnit;

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TIntPropForm = class(TForm)
    cbModes: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  IntPropForm: TIntPropForm;

implementation

{$R *.DFM}

end.
