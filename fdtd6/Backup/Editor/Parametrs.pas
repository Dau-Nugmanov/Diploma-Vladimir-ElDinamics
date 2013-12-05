unit Parametrs;

{Диалог праметров объекта при создании}

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RXSpin, ExtCtrls, Regions;

type
  TParamForm = class(TForm)
    Notebook1: TNotebook;
    seHorSize: TRxSpinEdit;
    seVertSize: TRxSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    lbEps: TLabel;
    seEps: TRxSpinEdit;
    seRadius: TRxSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    seVertAxel: TRxSpinEdit;
    seHorAxel: TRxSpinEdit;
    cbOrientation: TComboBox;
    Label7: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label3: TLabel;
    Label8: TLabel;
    seHorSizeR: TRxSpinEdit;
    seVertSizeR: TRxSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    seHorAxelR: TRxSpinEdit;
    Label12: TLabel;
    Label13: TLabel;
    seVertAxelR: TRxSpinEdit;
    Label14: TLabel;
    Label17: TLabel;
    seRadiusR: TRxSpinEdit;
    Label18: TLabel;
    lbEps2: TLabel;
    seEps2: TRxSpinEdit;
    lbEps3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure seHorSizeChange(Sender: TObject);
    procedure seVertSizeChange(Sender: TObject);
    procedure seHorSizeRChange(Sender: TObject);
    procedure seVertSizeRChange(Sender: TObject);
    procedure seRadiusChange(Sender: TObject);
    procedure seRadiusRChange(Sender: TObject);
    procedure seHorAxelChange(Sender: TObject);
    procedure seVertAxelChange(Sender: TObject);
    procedure seHorAxelRChange(Sender: TObject);
    procedure seVertAxelRChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ParamForm: TParamForm;

implementation

{$R *.DFM}

procedure TParamForm.FormCreate(Sender: TObject);
begin
  cbOrientation.ItemIndex := 0;
end;

procedure TParamForm.seHorSizeChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seHorSizeR.Value := seHorSize.Value * RegionList.DelX * 1e6;
end;

procedure TParamForm.seVertSizeChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seVertSizeR.Value := seVertSize.Value * RegionList.DelY * 1e6;
end;

procedure TParamForm.seHorSizeRChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seHorSize.Value := Round(seHorSizeR.Value / RegionList.DelX * 1e-6);
end;

procedure TParamForm.seVertSizeRChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seVertSize.Value := Round(seVertSizeR.Value / RegionList.DelY * 1e-6);
end;

procedure TParamForm.seRadiusChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seRadiusR.Value := seRadius.Value * Sqrt(Sqr(RegionList.DelX)
    + Sqr(RegionList.DelY)) * 1e6;
end;

procedure TParamForm.seRadiusRChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seRadius.Value := Round(seRadiusR.Value / Sqrt(Sqr(RegionList.DelX)
    + Sqr(RegionList.DelY)) * 1e-6);
end;

procedure TParamForm.seHorAxelChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seHorAxelR.Value := seHorAxel.Value * RegionList.DelX * 1e6;
end;

procedure TParamForm.seVertAxelChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seVertAxelR.Value := seVertAxel.Value * RegionList.DelY * 1e6;
end;

procedure TParamForm.seHorAxelRChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seHorAxel.Value := Round(seHorAxelR.Value / RegionList.DelX * 1e-6);
end;

procedure TParamForm.seVertAxelRChange(Sender: TObject);
begin
  if TRxSpinEdit(Sender).Text = '' then
    Exit;
  seVertAxel.Value := Round(seVertAxelR.Value / RegionList.DelY * 1e-6);
end;

procedure TParamForm.FormShow(Sender: TObject);
begin
  seHorSizeChange(Self);
  seVertSizeChange(Self);
  seRadiusChange(Self);
  seHorAxelChange(Self);
  seVertAxelChange(Self);
end;

end.
