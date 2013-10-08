unit FSFUnit;

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RXSpin, ExtCtrls;

type
  TFSForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    GroupBox1: TGroupBox;
    rbAllF: TRadioButton;
    rbFromF: TRadioButton;
    seFromF: TRxSpinEdit;
    lbToF: TLabel;
    seToF: TRxSpinEdit;
    GroupBox2: TGroupBox;
    lbToB: TLabel;
    rbAllB: TRadioButton;
    rbFromB: TRadioButton;
    seFromB: TRxSpinEdit;
    seToB: TRxSpinEdit;
    cbWindowF: TCheckBox;
    cbWindowB: TCheckBox;
    procedure rbFromFClick(Sender: TObject);
    procedure rbFromBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FSForm: TFSForm;

implementation

{$R *.DFM}

procedure TFSForm.rbFromFClick(Sender: TObject);
begin
  seFromF.Enabled := rbFromF.Checked;
  seToF.Enabled := rbFromF.Checked;
end;

procedure TFSForm.rbFromBClick(Sender: TObject);
begin
  seFromB.Enabled := rbFromB.Checked;
  seToB.Enabled := rbFromB.Checked;
end;

end.
