unit ModFUnit;

{Диалог начального возмущения}

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, RXSpin;

type
  TModeForm = class(TForm)
    GroupBox1: TGroupBox;
    rbAllX: TRadioButton;
    rbCustomX: TRadioButton;
    lbCustomX: TLabel;
    seEndX: TRxSpinEdit;
    seHalfPX: TRxSpinEdit;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    lbCustomY: TLabel;
    Label2: TLabel;
    rbAllY: TRadioButton;
    rbCustomY: TRadioButton;
    seEndY: TRxSpinEdit;
    seHalfPY: TRxSpinEdit;
    seStartY: TRxSpinEdit;
    seStartX: TRxSpinEdit;
    cbMode: TComboBox;
    Label3: TLabel;
    rgInitial: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    seExpX: TRxSpinEdit;
    seExpY: TRxSpinEdit;
    lbExpX: TLabel;
    lbExpY: TLabel;
    GroupBox3: TGroupBox;
    cbFromMedium: TCheckBox;
    cbManual: TCheckBox;
    procedure rbAllXClick(Sender: TObject);
    procedure rbCustomXClick(Sender: TObject);
    procedure rbAllYClick(Sender: TObject);
    procedure rbCustomYClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rgInitialClick(Sender: TObject);
    procedure cbManualClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetFromFile;
    procedure SetManual;
  end;

var
  ModeForm: TModeForm;

implementation

{$R *.DFM}

procedure TModeForm.rbAllXClick(Sender: TObject);
begin
  seStartX.Enabled := False;
  seEndX.Enabled := False;
  lbCustomX.Enabled := False;
end;

procedure TModeForm.rbCustomXClick(Sender: TObject);
begin
  seStartX.Enabled := True;
  seEndX.Enabled := True;
  lbCustomX.Enabled := True;
end;

procedure TModeForm.rbAllYClick(Sender: TObject);
begin
  seStartY.Enabled := False;
  seEndY.Enabled := False;
  lbCustomY.Enabled := False;
end;

procedure TModeForm.rbCustomYClick(Sender: TObject);
begin
  seStartY.Enabled := True;
  seEndY.Enabled := True;
  lbCustomY.Enabled := True;
end;

procedure TModeForm.FormCreate(Sender: TObject);
begin
  cbMode.ItemIndex := 0;
  rbCustomX.Checked := True;
  rbCustomXClick(Self);
  rbAllY.Checked := True;
  rbAllYClick(Self);
  cbManualClick(cbManual);
end;

procedure TModeForm.rgInitialClick(Sender: TObject);
begin
  case rgInitial.ItemIndex of
    0 :
    begin
      lbExpX.Visible := False;
      seExpX.Visible := False;
      lbExpY.Visible := False;
      seExpY.Visible := False;
    end;
    1 :
    begin
      lbExpX.Visible := True;
      seExpX.Visible := True;
      lbExpY.Visible := True;
      seExpY.Visible := True;
    end;
  end;
end;

procedure TModeForm.cbManualClick(Sender: TObject);
begin
  rgInitial.Enabled := cbManual.Checked;
  rbAllX.Enabled := cbManual.Checked;
  rbAllY.Enabled := cbManual.Checked;
  rbCustomx.Enabled := cbManual.Checked;
  rbCustomY.Enabled := cbManual.Checked;
  lbCustomX.Enabled := cbManual.Checked;
  lbCustomY.Enabled := cbManual.Checked;
  seStartX.Enabled := cbManual.Checked;
  seStartY.Enabled := cbManual.Checked;
  seEndX.Enabled := cbManual.Checked;
  seEndY.Enabled := cbManual.Checked;
  seHalfPX.Enabled := cbManual.Checked;
  seHalfPY.Enabled := cbManual.Checked;
  lbExpX.Enabled := cbManual.Checked;
  lbExpY.Enabled := cbManual.Checked;
  seExpX.Enabled := cbManual.Checked;
  seExpY.Enabled := cbManual.Checked;
  Label1.Enabled := cbManual.Checked;
  Label2.Enabled := cbManual.Checked;
end;

procedure TModeForm.SetFromFile;
begin
  cbManual.Checked := False;
  cbManualClick(cbManual);
end;

procedure TModeForm.SetManual;
begin
  cbManual.Checked := True;
  cbManualClick(cbManual);
end;

end.
