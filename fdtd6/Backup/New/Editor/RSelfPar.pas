unit RSelfPar;

{$D+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RXSpin, PhisCnst, Regions;

type
  TRSelfForm = class(TForm)
    Label1: TLabel;
    seStartX: TRxSpinEdit;
    seEndX: TRxSpinEdit;
    cbRectList: TComboBox;
    Label2: TLabel;
    seModeNumber: TRxSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    seHalfX: TRxSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label5: TLabel;
    seLambda: TRxSpinEdit;
    seOmega: TRxSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    procedure seHalfXChange(Sender: TObject);
    procedure seLambdaChange(Sender: TObject);
    procedure seOmegaChange(Sender: TObject);
    procedure seStartXChange(Sender: TObject);
    procedure seEndXChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RSelfForm: TRSelfForm;

implementation

const
  Changing: Boolean = False;

{$R *.DFM}

procedure TRSelfForm.seHalfXChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seHalfX.Text = '' then
    Exit;
  if seHalfX.Value = 0 then
    Exit;
  Changing := True;
  seLambda.Value := (seEndX.Value - seStartX.Value) / seHalfX.Value * 2
    * RegionList.DelX * 1e6;
  seOmega.Value := 2 * Pi / seLambda.Value * C * 1e-6;
  Changing := False;
end;

procedure TRSelfForm.seLambdaChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seLambda.Text = '' then
    Exit;
  if seLambda.Value = 0 then
    Exit;
  Changing := True;
  seEndX.Value := seStartX.Value + Round(
    seHalfX.Value * seLambda.Value / 2 / RegionList.DelX * 1e-6);
  while seEndX.Value > RegionList.SizeOfX do
  begin
    seHalfX.Value := seHalfX.Value - 1;
    seEndX.Value := seStartX.Value + Round(
      seHalfX.Value * seLambda.Value / 2 / RegionList.DelX * 1e-6);
    if seHalfX.Value = 1 then
      Break;
  end;
  seOmega.Value := 2 * Pi / seLambda.Value * C * 1e-6;
  Changing := False;
end;

procedure TRSelfForm.seOmegaChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seOmega.Text = '' then
    Exit;
  Changing := True;
  seLambda.Value := seOmega.Value / 2 / Pi / C * 1e6;
  seEndX.Value := seStartX.Value + Round(
    seHalfX.Value * seLambda.Value / 2/ RegionList.DelX * 1e-9);
  while seEndX.Value > RegionList.SizeOfX do
  begin
    seHalfX.Value := seHalfX.Value - 1;
    seEndX.Value := seStartX.Value + Round(
      seHalfX.Value * seLambda.Value / 2 / RegionList.DelX * 1e-6);
    if seHalfX.Value = 1 then
      Break;
  end;
  Changing := False;
end;

procedure TRSelfForm.seStartXChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seStartX.Text = '' then
    Exit;
  seLambda.Value := (seEndX.Value - seStartX.Value) / seHalfX.Value * 2
    * RegionList.DelX * 1e6;
  seOmega.Value := 2 * Pi / seLambda.Value * C * 1e-6;
end;

procedure TRSelfForm.seEndXChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seEndX.Text = '' then
    Exit;
  seLambda.Value := (seEndX.Value - seStartX.Value) / seHalfX.Value * 2
    * RegionList.DelX * 1e6;
  seOmega.Value := 2 * Pi / seLambda.Value * C * 1e-6;
end;

end.
