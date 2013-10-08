unit StpFUnit;

{Диалог настроек
OnSave - событие при нажатии кнопки "Применить"}

{$D-}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, RXSpin, ComCtrls, Common6, ExtCtrls, IniFiles, FileUtil,
  ColorUnit;

type
  TSetupForm = class(TForm)
    PageControl1: TPageControl;
    tsDraw: TTabSheet;
    tsSave: TTabSheet;
    GroupBox1: TGroupBox;
    rbAll: TRadioButton;
    rbCustom: TRadioButton;
    cbWave: TCheckBox;
    cbComponents: TCheckBox;
    cbGraphics: TCheckBox;
    GroupBox2: TGroupBox;
    rbEachStep: TRadioButton;
    rbOnStep: TRadioButton;
    rbOnTime: TRadioButton;
    seStep: TRxSpinEdit;
    seTime: TRxSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    imColorLine: TImage;
    seMinColor: TRxSpinEdit;
    seMaxColor: TRxSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    rgToSave: TRadioGroup;
    lbWave: TLabel;
    lbComponents: TLabel;
    lbGraphics: TLabel;
    lbReport: TLabel;
    lbValues: TLabel;
    edWave: TEdit;
    edComponents: TEdit;
    edGraphics: TEdit;
    edValues: TEdit;
    edReport: TEdit;
    sbWave: TSpeedButton;
    sbComponents: TSpeedButton;
    sbGraphics: TSpeedButton;
    sbValues: TSpeedButton;
    sbReport: TSpeedButton;
    cbRewrite: TCheckBox;
    bbApply: TBitBtn;
    tsProgram: TTabSheet;
    GroupBox3: TGroupBox;
    seDelY: TRxSpinEdit;
    seSizeX: TRxSpinEdit;
    seDelX: TRxSpinEdit;
    seSizeY: TRxSpinEdit;
    Label5: TLabel;
    Label6: TLabel;
    lbDelX: TLabel;
    lbDelY: TLabel;
    gbDelT: TGroupBox;
    rbDelTByX: TRadioButton;
    rbDelTByY: TRadioButton;
    seDelTByX: TRxSpinEdit;
    seDelTByY: TRxSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    cbAxel: TCheckBox;
    lbDelXY: TLabel;
    seDelXY: TRxSpinEdit;
    cbGrPoints: TCheckBox;
    cbFourier: TCheckBox;
    edFourier: TEdit;
    Label7: TLabel;
    sbFourier: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure rbAllClick(Sender: TObject);
    procedure rbCustomClick(Sender: TObject);
    procedure bbApplyClick(Sender: TObject);
    procedure Modified(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbWaveClick(Sender: TObject);
    procedure sbComponentsClick(Sender: TObject);
    procedure sbGraphicsClick(Sender: TObject);
    procedure sbValuesClick(Sender: TObject);
    procedure sbReportClick(Sender: TObject);
    procedure cbAxelClick(Sender: TObject);
    procedure seSizeXChange(Sender: TObject);
    procedure seSizeYChange(Sender: TObject);
    procedure seDelXChange(Sender: TObject);
    procedure seDelYChange(Sender: TObject);
    procedure seDelXYChange(Sender: TObject);
    procedure rbDelTByXClick(Sender: TObject);
    procedure rbDelTByYClick(Sender: TObject);
    procedure sbFourierClick(Sender: TObject);
  private
    { Private declarations }
    FOnSave: TNotifyEvent;
  protected
    procedure Save;
  public
    { Public declarations }
    property OnSave: TNotifyEvent read FOnSave write FOnSave;
    procedure AxelClick;
  end;

const
  OptionsCode = 321123;
  OptionsFileName = 'FDTD.ini';

var
  SetupForm: TSetupForm;

implementation

{$R *.DFM}

procedure TSetupForm.Modified;
begin
//при изменении одного из параметров сделать доступной
//кнопку "Применить"
  bbApply.Enabled := True;
end;

procedure TSetupForm.Save;
begin
  if Assigned(FOnSave) then FOnSave(Self);
end;

procedure TSetupForm.FormCreate(Sender: TObject);
var
  Bitmap: TBitmap;
  i :Integer;
begin
  PageControl1.ActivePage := tsDraw;
  bbApply.Enabled := False;
//нарисовать градиент цветов
  Bitmap := TBitmap.Create;
  Bitmap.Width := 256;
  Bitmap.Height := 1;
  for i := 0 to 255 do
    Bitmap.Canvas.Pixels[i, 0] := ColorArray[i];
  imColorLine.Canvas.StretchDraw(Rect(0, 0, imColorLine.Width,
    imColorLine.Height), Bitmap);
  Bitmap.Free;
end;

procedure TSetupForm.rbAllClick(Sender: TObject);
begin
  cbWave.Enabled := False;
  cbComponents.Enabled := False;
  cbGraphics.Enabled := False;
  cbFourier.Enabled := False;
  Modified(Self);
end;

procedure TSetupForm.rbCustomClick(Sender: TObject);
begin
  cbWave.Enabled := True;
  cbComponents.Enabled := True;
  cbGraphics.Enabled := True;
  cbFourier.Enabled := True;
  Modified(Self);
end;

procedure TSetupForm.bbApplyClick(Sender: TObject);
begin
  Save;
  bbApply.Enabled := False;
end;

procedure TSetupForm.FormShow(Sender: TObject);
begin
  bbApply.Enabled := False;
end;

procedure TSetupForm.sbWaveClick(Sender: TObject);
var
  Path: string;
begin
  Path := WavePath;
  if BrowseDirectory(Path, 'Папка для рисунка волны', 0) then
  begin
    edWave.Text := Path;
    Modified(Self);
  end;
end;

procedure TSetupForm.sbComponentsClick(Sender: TObject);
var
  Path: string;
begin
  Path := CompPath;
  if BrowseDirectory(Path, 'Папка для компонент', 0) then
  begin
    edComponents.Text := Path;
    Modified(Self);
  end;
end;

procedure TSetupForm.sbGraphicsClick(Sender: TObject);
var
  Path: string;
begin
  Path := GraphPath;
  if BrowseDirectory(Path, 'Папка для графиков', 0) then
  begin
    edGraphics.Text := Path;
    Modified(Self);
  end;
end;

procedure TSetupForm.sbValuesClick(Sender: TObject);
var
  Path: string;
begin
  Path := ValuesPath;
  if BrowseDirectory(Path, 'Папка для значений', 0) then
  begin
    edValues.Text := Path;
    Modified(Self);
  end;
end;

procedure TSetupForm.sbReportClick(Sender: TObject);
var
  Path: string;
begin
  Path := ReportPath;
  if BrowseDirectory(Path, 'Папка для отчета', 0) then
  begin
    edReport.Text := Path;
    Modified(Self);
  end;
end;

procedure TSetupForm.cbAxelClick(Sender: TObject);
begin
  seDelX.Enabled := cbAxel.Checked;
  seDelY.Enabled := cbAxel.Checked;
  lbDelX.Enabled := cbAxel.Checked;
  lbDelY.Enabled := cbAxel.Checked;
  seDelXY.Enabled := not cbAxel.Checked;
  lbDelXY.Enabled := not cbAxel.Checked;
  seSizeXChange(Self);
  seSizeYChange(Self);
  if cbAxel.Checked then
  begin
    rbDelTByX.Enabled := True;
    rbDelTByY.Enabled := True;
  end
  else
  begin
    rbDelTByX.Enabled := rbDelTByX.Checked;
    rbDelTByY.Enabled := rbDelTByY.Checked;
  end;
  Modified(Self);
end;

procedure TSetupForm.seSizeXChange(Sender: TObject);
begin
  if cbAxel.Checked then
  begin
    if seSizeX.Text <> '' then
    begin
      seDelX.Value := seSizeX.Value / SizeX;
    end;
  end
  else
    if seSizeX.Text <> '' then
    begin
      seDelXY.Value := seSizeX.Value / SizeX;
      seSizeY.Value := seDelXY.Value * SizeY;
    end;
  Modified(Self);
end;

procedure TSetupForm.seSizeYChange(Sender: TObject);
begin
  if cbAxel.Checked then
  begin
    if seSizeY.Text <> '' then
    begin
      seDelY.Value := seSizeY.Value / SizeY;
    end;
  end
  else
    if seSizeY.Text <> '' then
    begin
      seDelXY.Value := seSizeY.Value / SizeY;
      seSizeX.Value := seDelXY.Value * SizeX;
    end;
  Modified(Self);
end;

procedure TSetupForm.seDelXChange(Sender: TObject);
begin
  if seDelX.Text <> '' then
  begin
    seSizeX.Value := seDelX.Value * SizeX;
  end;
  Modified(Self);
end;

procedure TSetupForm.seDelYChange(Sender: TObject);
begin
  if seDelY.Text <> '' then
  begin
    seSizeY.Value := seDelY.Value * SizeY;
  end;
  Modified(Self);
end;

procedure TSetupForm.seDelXYChange(Sender: TObject);
begin
  if seDelXY.Text <> '' then
  begin
    seSizeX.Value := seDelXY.Value * SizeX;
    seSizeY.Value := seDelXY.Value * SizeY;
  end;
  Modified(Self);
end;

procedure TSetupForm.rbDelTByXClick(Sender: TObject);
begin
  seDelTByX.Enabled := True;
  seDelTByY.Enabled := False;
  Modified(Self);
end;

procedure TSetupForm.rbDelTByYClick(Sender: TObject);
begin
  seDelTByX.Enabled := False;
  seDelTByY.Enabled := True;
  Modified(Self);
end;

procedure TSetupForm.AxelClick;
begin
  cbAxelClick(Self);
end;

procedure TSetupForm.sbFourierClick(Sender: TObject);
var
  Path: string;
begin
  Path := FourPath;
  if BrowseDirectory(Path, 'Папка для графиков', 0) then
  begin
    edFourier.Text := Path;
    Modified(Self);
  end;
end;

end.

