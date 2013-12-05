unit FParUnit;

interface

{$D+}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, RXSpin, Buttons, ExtCtrls, Regions, PhisCnst, sgr_def, sgr_data,
  ExtArr;

type
  TFieldParamForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Notebook1: TNotebook;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lbExpX: TLabel;
    lbExpY: TLabel;
    seStartXS: TRxSpinEdit;
    seEndXS: TRxSpinEdit;
    seStartY: TRxSpinEdit;
    seEndY: TRxSpinEdit;
    seHalfXS: TRxSpinEdit;
    seHalfY: TRxSpinEdit;
    seExpX: TRxSpinEdit;
    seExpY: TRxSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    seLambdaS: TRxSpinEdit;
    seOmegaS: TRxSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    seStartXR: TRxSpinEdit;
    seEndXR: TRxSpinEdit;
    cbRectList: TComboBox;
    seModeNumber: TRxSpinEdit;
    seHalfXR: TRxSpinEdit;
    seLambdaR: TRxSpinEdit;
    seOmegaR: TRxSpinEdit;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    spVert: Tsp_XYPlot;
    spHor: Tsp_XYPlot;
    splVert: Tsp_XYLine;
    splHor: Tsp_XYLine;
    lbError: TLabel;
    seQ: TRxSpinEdit;
    seP: TRxSpinEdit;
    lbQ: TLabel;
    lbP: TLabel;
    procedure seHalfXSChange(Sender: TObject);
    procedure seLambdaSChange(Sender: TObject);
    procedure seOmegaSChange(Sender: TObject);
    procedure seStartXSChange(Sender: TObject);
    procedure seEndXSChange(Sender: TObject);
    procedure seStartXRChange(Sender: TObject);
    procedure seEndXRChange(Sender: TObject);
    procedure seHalfXRChange(Sender: TObject);
    procedure seLambdaRChange(Sender: TObject);
    procedure seOmegaRChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure seStartYChange(Sender: TObject);
    procedure cbRectListChange(Sender: TObject);
    procedure seQChange(Sender: TObject);
    procedure sePChange(Sender: TObject);
  private
    { Private declarations }
  public
    Field: TField2;
    procedure Draw;
  end;

const
  Changing: Boolean = False;

var
  FieldParamForm: TFieldParamForm;

implementation

{$R *.DFM}

procedure TFieldParamForm.Draw;
var
  Ez: TExtArray;
  i: Integer;
begin
  splHor.Clear;
  splVert.Clear;
  lbError.Visible := False;

  case Field.FieldType of
    ftSin :
    begin
      try
        TSinField(Field).SetField(seEndXS.AsInteger -
           seStartXS.AsInteger, seEndY.AsInteger -
           seStartY.AsInteger, seStartXS.AsInteger,
           seStartY.AsInteger, seHalfXS.AsInteger,
           seHalfY.AsInteger);
       except
         lbError.Visible := True;
       end;
       for i := seStartXS.AsInteger to seEndXS.AsInteger do
         splHor.QuickAddXY(i, Ez0 * Sin(Pi * (i - seStartXS.Value)
           / (seEndXS.Value - seStartXS.Value) * seHalfXS.Value));
    end;
    ftGauss :
    begin
      try
        TGaussField(Field).SetField(seEndXS.AsInteger -
           seStartXS.AsInteger, seEndY.AsInteger -
           seStartY.AsInteger, seStartXS.AsInteger,
           seStartY.AsInteger, seHalfXS.AsInteger,
           seHalfY.AsInteger, seExpX.Value, seExpY.Value);
       except
         lbError.Visible := True;
       end;
       for i := seStartXS.AsInteger to seEndXS.AsInteger do
         splHor.QuickAddXY(i, Ez0 * Sin(Pi * (i - seStartXS.Value)
           / (seEndXS.Value - seStartXS.Value) * seHalfXS.Value)
           * Exp(-Sqr(seExpX.Value * (i
           - (seStartXS.Value + seEndXS.Value) / 2))));
    end;
    ftRectSelf :
    begin
      try
        TRectSelfField(Field).SetField(seEndXR.AsInteger -
          seStartXR.AsInteger, RegionList.SizeOfY - 1, seStartXR.AsInteger, 0,
          seHalfXR.AsInteger, 0, RegionList.Rects[cbRectList.ItemIndex],
          seModeNumber.AsInteger);
      except
         lbError.Visible := True;
      end;
      for i := seStartXR.AsInteger to seEndXR.AsInteger do
        splHor.QuickAddXY(i, Ez0 * Sin(Pi * (i - seStartXR.Value)
          / (seEndXR.Value - seStartXR.Value) * seHalfXR.Value));
    end;
    ftRectSelf2 :
    begin
      try
        TRectSelfField2(Field).SetField(seEndXR.AsInteger -
          seStartXR.AsInteger, RegionList.SizeOfY - 1, seStartXR.AsInteger, 0,
          seHalfXR.AsInteger, 0, RegionList.Rects[cbRectList.ItemIndex],
          seModeNumber.AsInteger, seP.Value, seQ.Value);
      except
         lbError.Visible := True;
      end;
      for i := seStartXR.AsInteger to seEndXR.AsInteger do
        splHor.QuickAddXY(i, Ez0 * Sin(Pi * (i - seStartXR.Value)
          / (seEndXR.Value - seStartXR.Value) * seHalfXR.Value));
    end;
  end;

  Ez := TExtArray.Create(vtExtended, 1, RegionList.SizeOfY, 0, 0,
    0, 0, 0, 0);
{  if Field.FieldType <> ftRectSelf2 then}
    Field.FillEzMax(Ez);
  for i := Field.StartY to Field.StartY + Field.SizeOfY do
    if (i + 2) mod 2 = 0 then
      splVert.QuickAddXY(Ez[0, i], Field.StartY + Field.SizeOfY - i);

  Ez.Free;
end;

procedure TFieldParamForm.seHalfXSChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seHalfXS.Text = '' then
    Exit;
  if seHalfXS.Value = 0 then
    Exit;
  Changing := True;
  seEndXS.Value := seStartXS.Value + Round(
    seHalfXS.Value * seLambdaS.Value / 2 / RegionList.DelX * 1e-6);
  while seEndXS.Value > RegionList.SizeOfX do
  begin
    seLambdaS.Value := seLambdaS.Value - 0.1;
    seEndXS.Value := seStartXS.Value + Round(
      seHalfXS.Value * seLambdaS.Value / 2 / RegionList.DelX * 1e-6);
    if seLambdaS.Value = 0.1 then
      Break;
  end;
  seOmegaS.Value := 2 * Pi / seLambdaS.Value * C * 1e-3;
  Changing := False;
  Draw;
end;

procedure TFieldParamForm.seLambdaSChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seLambdaS.Text = '' then
    Exit;
  if seLambdaS.Value = 0 then
    Exit;
  Changing := True;
  seEndXS.Value := seStartXS.Value + Round(
    seHalfXS.Value * seLambdaS.Value / 2 / RegionList.DelX * 1e-6);
  while seEndXS.Value > RegionList.SizeOfX do
  begin
    seHalfXS.Value := seHalfXS.Value - 1;
    seEndXS.Value := seStartXS.Value + Round(
      seHalfXS.Value * seLambdaS.Value / 2 / RegionList.DelX * 1e-6);
    if seHalfXS.Value = 1 then
      Break;
  end;
  seOmegaS.Value := 2 * Pi / seLambdaS.Value * C * 1e-3;
  Changing := False;
  Draw;
end;

procedure TFieldParamForm.seOmegaSChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seOmegaS.Text = '' then
    Exit;
  Changing := True;
  seLambdaS.Value := 2 * Pi / seOmegaS.Value * C * 1e-3;
  seEndXS.Value := seStartXS.Value + Round(
    seHalfXS.Value * seLambdaS.Value / 2/ RegionList.DelX * 1e-6);
  while seEndXS.Value > RegionList.SizeOfX do
  begin
    seHalfXS.Value := seHalfXS.Value - 1;
    seEndXS.Value := seStartXS.Value + Round(
      seHalfXS.Value * seLambdaS.Value / 2 / RegionList.DelX * 1e-6);
    if seHalfXS.Value = 1 then
      Break;
  end;
  Changing := False;
  Draw;
end;

procedure TFieldParamForm.seStartXSChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seStartXS.Text = '' then
    Exit;
  seLambdaS.Value := (seEndXS.Value - seStartXS.Value) / seHalfXS.Value * 2
    * RegionList.DelX * 1e6;
  seOmegaS.Value := 2 * Pi / seLambdaS.Value * C * 1e-3;
end;

procedure TFieldParamForm.seEndXSChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seEndXS.Text = '' then
    Exit;
  seLambdaS.Value := (seEndXS.Value - seStartXS.Value) / seHalfXS.Value * 2
    * RegionList.DelX * 1e6;
  seOmegaS.Value := 2 * Pi / seLambdaS.Value * C * 1e-3;
  Draw;
end;

procedure TFieldParamForm.seStartXRChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seStartXR.Text = '' then
    Exit;
  seLambdaR.Value := (seEndXR.Value - seStartXR.Value) / seHalfXR.Value * 2
    * RegionList.DelX * 1e6;
  seOmegaR.Value := 2 * Pi / seLambdaR.Value * C * 1e-3;
end;

procedure TFieldParamForm.seEndXRChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seEndXR.Text = '' then
    Exit;
  seLambdaR.Value := (seEndXR.Value - seStartXR.Value) / seHalfXR.Value * 2
    * RegionList.DelX * 1e6;
  seOmegaR.Value := 2 * Pi / seLambdaR.Value * C * 1e-3;
  Draw;
end;

procedure TFieldParamForm.seHalfXRChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seHalfXR.Text = '' then
    Exit;
  if seHalfXR.Value = 0 then
    Exit;
  Changing := True;
  seEndXR.Value := seStartXR.Value + Round(
    seHalfXR.Value * seLambdaR.Value / 2 / RegionList.DelX * 1e-6);
  while seEndXR.Value > RegionList.SizeOfX do
  begin
    seLambdaR.Value := seLambdaR.Value - 0.1;
    seEndXR.Value := seStartXR.Value + Round(
      seHalfXR.Value * seLambdaR.Value / 2 / RegionList.DelX * 1e-6);
    if seLambdaR.Value = 0.1 then
      Break;
  end;
  seOmegaR.Value := 2 * Pi / seLambdaR.Value * C * 1e-3;
  Changing := False;
  Draw;
end;

procedure TFieldParamForm.seLambdaRChange(Sender: TObject);
var
  TempField: TRectSelfField;
begin
  if Changing then
    Exit;
  if seLambdaR.Text = '' then
    Exit;
  if seLambdaR.Value = 0 then
    Exit;
  Changing := True;

{  TempField := TRectSelfField.Create;
  try
    TempField.SetField(seEndXR.AsInteger - seStartXR.AsInteger,
      RegionList.SizeOfY - 1, seStartXR.AsInteger, 0,
      seHalfXR.AsInteger, 0, RegionList.Rects[cbRectList.ItemIndex],
      seModeNumber.AsInteger);
  except
    Changing := False;
    TempField.Free;
    Exit;
  end;}

  seEndXR.Value := seStartXR.Value + Round(
    seHalfXR.Value * seLambdaR.Value / 2 / RegionList.DelX * 1e-6);
{  seEndXR.Value := seStartXR.Value + Round(
    Pi * TempField.HalfX / TempField.Betta / RegionList.DelX);}
//  seEndXR.Value := seStartXR.AsInteger + TempField.SizeOfX;
  while seEndXR.Value > RegionList.SizeOfX do
  begin
    seHalfXR.Value := seHalfXR.Value - 1;
    seEndXR.Value := seStartXR.Value + Round(
      seHalfXR.Value * seLambdaR.Value / 2 / RegionList.DelX * 1e-6);
{    try
      TempField.SetField(seEndXR.AsInteger - seStartXR.AsInteger,
        RegionList.SizeOfY - 1, seStartXR.AsInteger, 0,
        seHalfXR.AsInteger, 0, RegionList.Rects[cbRectList.ItemIndex],
        seModeNumber.AsInteger);
    except
      Changing := False;
      TempField.Free;
      Exit;
    end;
{    seEndXR.Value := seStartXR.Value + Round(
      Pi * TempField.HalfX / TempField.Betta / RegionList.DelX);}
//    seEndXR.Value := seStartXR.AsInteger + TempField.SizeOfX;
    if seHalfXR.Value = 1 then
      Break;
  end;
  seOmegaR.Value := 2 * Pi / seLambdaR.Value * C * 1e-3;
//  TempField.Free;
  Changing := False;
  Draw;
end;

procedure TFieldParamForm.seOmegaRChange(Sender: TObject);
begin
  if Changing then
    Exit;
  if seOmegaR.Text = '' then
    Exit;
  Changing := True;
  seLambdaR.Value := 2 * Pi / seOmegaR.Value * C * 1e-3;
  seEndXR.Value := seStartXR.Value + Round(
    seHalfXR.Value * seLambdaR.Value / 2/ RegionList.DelX * 1e-6);
  while seEndXR.Value > RegionList.SizeOfX do
  begin
    seHalfXR.Value := seHalfXR.Value - 1;
    seEndXR.Value := seStartXR.Value + Round(
      seHalfXR.Value * seLambdaR.Value / 2 / RegionList.DelX * 1e-6);
    if seHalfXR.Value = 1 then
      Break;
  end;
  Changing := False;
  Draw;
end;

procedure TFieldParamForm.FormShow(Sender: TObject);
begin
  spHor.BottomAxis.SetMinMax(0, RegionList.SizeOfX);
  spVert.LeftAxis.SetMinMax(0, RegionList.SizeOfY);
  Draw;
end;

procedure TFieldParamForm.seStartYChange(Sender: TObject);
begin
  Draw;
end;

procedure TFieldParamForm.cbRectListChange(Sender: TObject);
begin
  Draw;
end;

procedure TFieldParamForm.seQChange(Sender: TObject);
begin
  if seQ.Text <> '' then
    Draw;
end;

procedure TFieldParamForm.sePChange(Sender: TObject);
begin
  if seP.Text <> '' then
    Draw;
end;

end.
