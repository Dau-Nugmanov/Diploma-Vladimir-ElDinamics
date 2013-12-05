unit AlForm;

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TAlignForm = class(TForm)
    rgVertAlign: TRadioGroup;
    rgHorAlign: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlignForm: TAlignForm;

implementation

{$R *.DFM}

end.
