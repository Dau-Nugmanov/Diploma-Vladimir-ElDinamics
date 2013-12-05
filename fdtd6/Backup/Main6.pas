unit Main6;

{Основной модуль}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ExtCtrls, ImgList, Menus, StdCtrls, Grapher, RXSlider,
  Common6, Regions, THR6, ExtArr, Proc6, Initial6, RXSpin, ModFUnit,
  Buttons, StpFUnit, DdeMan, ASFUnit, ExtIniF, OleCtnrs, EditMess, FFTran,
  Fourie, Utils, ColorUnit, PhisCnst, sgr_def, sgr_data, FIFUnit, FSFUnit,
  IPFUnit, Clipbrd, Plots;

type
  TMainForm = class(TForm)
    PageControl1: TPageControl;
    WavePage: TTabSheet;
    CompPage: TTabSheet;
    GrPage: TTabSheet;
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    tbEditor: TToolButton;
    ToolButton1: TToolButton;
    tbStart: TToolButton;
    tbPause: TToolButton;
    tbRestart: TToolButton;
    ImageList1: TImageList;
    MainMenu1: TMainMenu;
    mmFile: TMenuItem;
    mmOpen: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    cbMode: TComboBox;
    Panel2: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    cbCompField1: TComboBox;
    cbCompField2: TComboBox;
    cbCompField3: TComboBox;
    cbCompField4: TComboBox;
    Splitter1: TSplitter;
    ScrollBox7: TScrollBox;
    grWave: TGrapher;
    cbScale: TComboBox;
    cbWaveField: TComboBox;
    cbGr1: TCheckBox;
    cbGr2: TCheckBox;
    cbGrField1: TComboBox;
    cbGrField2: TComboBox;
    StatusBar1: TStatusBar;
    seXGr2: TRxSpinEdit;
    seXGr1: TRxSpinEdit;
    seYGr1: TRxSpinEdit;
    seYGr2: TRxSpinEdit;
    lbXGr1: TLabel;
    lbYGr1: TLabel;
    lbXGr2: TLabel;
    lbYGr2: TLabel;
    GroupBox4: TGroupBox;
    slFixY: TRxSlider;
    seFixY: TRxSpinEdit;
    lbCoordY: TLabel;
    slFixX: TRxSlider;
    lbCoordX: TLabel;
    seFixX: TRxSpinEdit;
    rbCoordX: TRadioButton;
    rbCoordY: TRadioButton;
    Label9: TLabel;
    Label10: TLabel;
    seAutoStop: TRxSpinEdit;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    sbModeChoose: TSpeedButton;
    mmSave: TMenuItem;
    mmRun: TMenuItem;
    mmStart: TMenuItem;
    mmPause: TMenuItem;
    mmRestart: TMenuItem;
    mmOptions: TMenuItem;
    mmMode: TMenuItem;
    mmSetup: TMenuItem;
    DdeClientConv1: TDdeClientConv;
    DdeClientItem1: TDdeClientItem;
    mmSaveAll: TMenuItem;
    mmDraw: TMenuItem;
    mmSaveSetup: TMenuItem;
    N2: TMenuItem;
    mmAutoSave: TMenuItem;
    FourieTimePage: TTabSheet;
    ScrollBox8: TScrollBox;
    grFourierTime1: TGrapher;
    ScrollBox9: TScrollBox;
    Splitter2: TSplitter;
    grFourierTime2: TGrapher;
    ToolButton2: TToolButton;
    tbFourie: TToolButton;
    N1: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    mmEditor: TMenuItem;
    mmExit: TMenuItem;
    mmProgram: TMenuItem;
    Label3: TLabel;
    Image1: TImage;
    Image2: TImage;
    FourierPage: TTabSheet;
    Panel4: TPanel;
    Panel5: TPanel;
    ScrollBox11: TScrollBox;
    grFourier2: TGrapher;
    Splitter3: TSplitter;
    ScrollBox10: TScrollBox;
    grFourier1: TGrapher;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    seFourX2: TRxSpinEdit;
    slFourX2: TRxSlider;
    Label11: TLabel;
    seFourX1: TRxSpinEdit;
    slFourX1: TRxSlider;
    cbFourField1: TComboBox;
    cbFourField2: TComboBox;
    IntegegralPage: TTabSheet;
    Panel6: TPanel;
    seIntX: TRxSpinEdit;
    Label4: TLabel;
    spLineIntF: Tsp_XYLine;
    bbIntFourie: TBitBtn;
    bbIntProp: TBitBtn;
    Splitter4: TSplitter;
    spLineIntB: Tsp_XYLine;
    splComp1: Tsp_XYLine;
    splComp2: Tsp_XYLine;
    splComp3: Tsp_XYLine;
    splComp4: Tsp_XYLine;
    splGraph1: Tsp_XYLine;
    splGraph2: Tsp_XYLine;
    spComp1: TXYPlot;
    spComp2: TXYPlot;
    spComp3: TXYPlot;
    spComp4: TXYPlot;
    spGraph2: TXYPlot;
    spGraph1: TXYPlot;
    spIntegralF: TXYPlot;
    spIntegralB: TXYPlot;
    Panel7: TPanel;
    BitBtn1: TBitBtn;
    procedure AppMessage(var Msg: TMsg; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure grWavePaint(Sender: TObject);
    procedure tbStartClick(Sender: TObject);
    procedure tbPauseClick(Sender: TObject);
    procedure tbRestartClick(Sender: TObject);
    procedure cbModeChange(Sender: TObject);
    procedure cbWaveFieldChange(Sender: TObject);
    procedure cbCompField1Change(Sender: TObject);
    procedure cbCompField2Change(Sender: TObject);
    procedure cbCompField3Change(Sender: TObject);
    procedure cbCompField4Change(Sender: TObject);
    procedure slFixYChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure tbOpenClick(Sender: TObject);
    procedure cbGr1Click(Sender: TObject);
    procedure cbGr2Click(Sender: TObject);
    procedure slFixXChange(Sender: TObject);
    procedure rbCoordXClick(Sender: TObject);
    procedure rbCoordYClick(Sender: TObject);
    procedure grWaveMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grWaveMouseLeave(Sender: TObject);
    procedure grWaveMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure grComp1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grComp2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grComp3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grComp4MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure grComp1MouseLeave(Sender: TObject);
    procedure grComp2MouseLeave(Sender: TObject);
    procedure grComp3MouseLeave(Sender: TObject);
    procedure grComp4MouseLeave(Sender: TObject);
    procedure grWaveMouseEnter(Sender: TObject);
    procedure grComp1MouseEnter(Sender: TObject);
    procedure grComp2MouseEnter(Sender: TObject);
    procedure grComp3MouseEnter(Sender: TObject);
    procedure grComp4MouseEnter(Sender: TObject);
    procedure sbModeChooseClick(Sender: TObject);
    procedure mmSetupClick(Sender: TObject);
    procedure cbScaleChange(Sender: TObject);
    procedure mmOpenClick(Sender: TObject);
    procedure mmStartClick(Sender: TObject);
    procedure mmPauseClick(Sender: TObject);
    procedure mmRestartClick(Sender: TObject);
    procedure mmModeClick(Sender: TObject);
    procedure tbEditorClick(Sender: TObject);
    procedure mmEditorClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure mmSaveClick(Sender: TObject);
    procedure mmSaveAllClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure mmAutoSaveClick(Sender: TObject);
    procedure mmDrawClick(Sender: TObject);
    procedure mmSaveSetupClick(Sender: TObject);
    procedure grFourierTime1Paint(Sender: TObject);
    procedure grFourierTime2Paint(Sender: TObject);
    procedure tbFourieClick(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure mmProgramClick(Sender: TObject);
    procedure Splitter2Moved(Sender: TObject);
    procedure seFixYChange(Sender: TObject);
    procedure seFixXChange(Sender: TObject);
    procedure seXGr1Change(Sender: TObject);
    procedure seYGr1Change(Sender: TObject);
    procedure seXGr2Change(Sender: TObject);
    procedure seYGr2Change(Sender: TObject);
    procedure grFourier2Paint(Sender: TObject);
    procedure grFourier1Paint(Sender: TObject);
    procedure seFourX1Change(Sender: TObject);
    procedure seFourX2Change(Sender: TObject);
    procedure cbFourField1Change(Sender: TObject);
    procedure cbFourField2Change(Sender: TObject);
    procedure slFourX1Change(Sender: TObject);
    procedure slFourX2Change(Sender: TObject);
    procedure bbIntFourieClick(Sender: TObject);
    procedure bbIntPropClick(Sender: TObject);
    procedure spComp1MouseEnter(Sender: TObject);
    procedure spComp2MouseEnter(Sender: TObject);
    procedure spComp3MouseEnter(Sender: TObject);
    procedure spComp4MouseEnter(Sender: TObject);
    procedure spComp1MouseLeave(Sender: TObject);
    procedure spComp2MouseLeave(Sender: TObject);
    procedure spComp3MouseLeave(Sender: TObject);
    procedure spComp4MouseLeave(Sender: TObject);
    procedure spCompMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure cbGrField1Change(Sender: TObject);
    procedure cbGrField2Change(Sender: TObject);
    procedure spIntegralMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure spIntegralMouseLeave(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    THR:TTHR;
    Loaded: Boolean;
    procedure UpdateMedium;
    procedure Start;
    procedure Pause;
    procedure Restart;
    procedure SetInitialWave;
    procedure Draw(Sender: TObject);
    procedure DrawWave(Required: Boolean);
    procedure DrawGraphics(Required: Boolean);
    procedure DrawComponents(Required: Boolean);
    procedure DrawComponent(FieldP: TFieldPointer; SPLine: Tsp_XYLine);
    procedure DrawFourier(Required: Boolean);
    procedure DrawIntegral;
    procedure SaveWave;
    procedure SaveComponents;
    procedure SaveGraphics;
    procedure SaveFourier;
    procedure SaveFourierTime;
    procedure Save;
    procedure UpdateDraw;
    procedure UpdateSave(Sender: TObject);
    procedure UpdateProgram;
    function IntToStr3(X: Integer): string;
    procedure FieldByIndex(Index: Integer; var FieldP: TFieldPointer);
    function FieldName(FieldP: TFieldPointer): string;
    function CheckOnDraw(FieldType: TFieldType): Boolean;
    function ColorByValue(FieldType: TFieldType; Value: Extended): TColor;
    function GetMaxValue(FieldType: TFieldType): Single;
    function Tag(FieldType: TFieldType): Byte;
    procedure DisableOnRun;
    procedure EnableOnStop;
    procedure EnableOnRestart;
    procedure CreateTHR;
    procedure SaveOptions;
    function LoadOptions: Boolean;
    procedure UpdateOptions;
    procedure ApplyOptions(Sender: TObject);
  public
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.AppMessage;
begin
//проверка сообщений
  if Msg.message = WM_APPLYCHANGES then
  begin
//редактор обработал файл
{$IFDEF WRPROCESS}
    Writeln(PrFile, '');
    Writeln(PrFile, 'Editor has sent changes');
{$ENDIF}
    RegionList.LoadFromFile(TempFile);
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Medium is loaded');
{$ENDIF}
    UpdateMedium;
    Handled := True;
  end;
  if (Msg.message = WM_CANCELCHANGES) or
    (Msg.message = WM_NOCHANGES) then
  begin
//изменений не было или они отменены
{$IFDEF WRPROCESS}
    Writeln(PrFile, '');
    Writeln(PrFile, 'Editor has not done any changes');
{$ENDIF}
    DdeClientConv1.CloseLink;
    Handled := True;
  end;
end;

procedure TMainForm.FieldByIndex(Index: Integer; var FieldP: TFieldPointer);
begin
//назначает указатель на компоненту для прорисовки
  case Index of
    0  : FieldP.Field := @Ex;
    1  : FieldP.Field := @Ey;
    2  : FieldP.Field := @Ez;
    3  : FieldP.Field := @Dx;
    4  : FieldP.Field := @Dy;
    5  : FieldP.Field := @Dz;
    6  : FieldP.Field := @Hx;
    7  : FieldP.Field := @Hy;
    8  : FieldP.Field := @Hz;
    9  : FieldP.Field := @Bx;
    10 : FieldP.Field := @By;
    11 : FieldP.Field := @Bz;
  end;
  if Index < 3 then
  begin
    FieldP.FieldType := ftEType;
    Exit;
  end;
  if (Index > 2) and (Index < 6) then
  begin
    FieldP.FieldType := ftDType;
    Exit;
  end;
  if (Index > 5) and (Index < 9) then
  begin
    FieldP.FieldType := ftHType;
    Exit;
  end;
  FieldP.FieldType := ftBType;
end;

function TMainForm.FieldName(FieldP: TFieldPointer): string;
begin
//возвращает строку с названием компоненты
  if (FieldP.Field = @Ex) or (FieldP.Field = @ExN) then
  begin
    Result := 'Ex';
    Exit;
  end;
  if (FieldP.Field = @Ey) or (FieldP.Field = @EyN) then
  begin
    Result := 'Ey';
    Exit;
  end;
  if (FieldP.Field = @Ez) or (FieldP.Field = @EzN) then
  begin
    Result := 'Ez';
    Exit;
  end;

  if (FieldP.Field = @Dx) or (FieldP.Field = @DxN) then
  begin
    Result := 'Dx';
    Exit;
  end;
  if (FieldP.Field = @Dy) or (FieldP.Field = @DyN) then
  begin
    Result := 'Dy';
    Exit;
  end;
  if (FieldP.Field = @Dz) or (FieldP.Field = @DzN) then
  begin
    Result := 'Dz';
    Exit;
  end;

  if (FieldP.Field = @Bx) or (FieldP.Field = @BxN) then
  begin
    Result := 'Bx';
    Exit;
  end;
  if (FieldP.Field = @By) or (FieldP.Field = @ByN) then
  begin
    Result := 'By';
    Exit;
  end;
  if (FieldP.Field = @Bz) or (FieldP.Field = @BzN) then
  begin
    Result := 'Bz';
    Exit;
  end;

  if (FieldP.Field = @Hx) or (FieldP.Field = @HxN) then
  begin
    Result := 'Hx';
    Exit;
  end;
  if (FieldP.Field = @Hy) or (FieldP.Field = @HyN) then
  begin
    Result := 'Hy';
    Exit;
  end;
  if (FieldP.Field = @Hz) or (FieldP.Field = @HzN) then
  begin
    Result := 'Hz';
    Exit;
  end;

  Result := '';
end;

function TMainForm.GetMaxValue(FieldType: TFieldType): Single;
begin
//возвращает максимальное начальное значение компоненты
  Result := 0.1;
  case FieldType of
    ftEType : Result := Ez0;
    ftDType : Result := Ez0 * Eps0 * RegionList.Eps;
    ftHType : Result := Hz0;
    ftBType : Result := Hz0 * Mu0;
  end;
end;

function TMainForm.Tag(FieldType: TFieldType): Byte;
begin
//возрашает 0 если компонента является электрической
//и 1 - если магнитной
//нужно для выполнения перешагивания
  Result := 0;
  if (FieldType = ftBType) or (FieldType = ftHType) then
    Result := 1;
end;

function TMainForm.ColorByValue(FieldType: TFieldType;
  Value: Extended): TColor;
var
  Max, Min: Extended;
begin
//возвращает цвет по значению поля
//нужно для прорисовки рисунка поля
  Max := BlackValue * GetMaxValue(FieldType);
  Min := WhiteValue * GetMaxValue(FieldType);
  if Abs(Value) >= Max then
  begin
    Result := clBlack;
    Exit;
  end;
  if Abs(Value) <= Min then
  begin
    Result := clWhite;
    Exit;
  end;
  Result := ColorArray[Round(255 * (Abs(Value) - Min) / (Max - Min))];
end;

procedure TMainForm.UpdateMedium;
var
  i: Integer;
begin
//переопределение параметров если среда изменилась
  SizeX := RegionList.SizeOfX;
  SizeY := RegionList.SizeOfY;
  DelX := RegionList.DelX;
  DelY := RegionList.DelY;
  DelT := RegionList.DelT;
  DtDivDx := DelT / DelX;
  DtDivDy := DelT / DelY;
  BoundWidth := RegionList.BoundsWidth;
  SigmaX := RegionList.Sigma;
  SigmaY := RegionList.Sigma;
  CoefG := RegionList.CoefG;
  if InitialX2 >= SizeX then InitialX2 := SizeX - 1;
  if InitialY2 >= SizeY then InitialY2 := SizeY - 1;
  grWave.Width := SizeX;
  grWave.Height := SizeY;
  WaveBitmap.Free;
  WaveBitmap := TBitmap.Create;
  WaveBitmap.Width := SizeX;
  WaveBitmap.Height := SizeY;
  WaveBitmap.PixelFormat := pf32Bit;
  RegionList.DrawContour(WaveBitmap.Canvas, WaveBitmap.Height,
    WaveBitmap.Width);
  grWave.Repaint;
  cbCompField1Change(Self);
  cbCompField2Change(Self);
  cbCompField3Change(Self);
  cbCompField4Change(Self);
  case CompCoord of
    ccHoriz : rbCoordXClick(Self);
    ccVert : rbCoordYClick(Self);
  end;
  spIntegralF.LeftAxis.SetMinMax(-Sqr(Ez0) / Z0 * SizeY * {DelY *} 2,
    Sqr(Ez0) / Z0 * SizeY * {DelY *} 2);
  spIntegralB.LeftAxis.SetMinMax(-Sqr(Ez0) / Z0 * SizeY {* DelY},
    Sqr(Ez0) / Z0 * SizeY {* DelY});
  slFixY.MaxValue := SizeY - 1;
  slFixY.Value := SizeY div 2;
  slFixX.MaxValue := SizeX - 1;
  slFixX.Value := SizeX div 2;
  slFixYChange(Self);
  slFixXChange(Self);
  case RegionList.BoundsType of
    btMetall : StatusBar1.Panels[0].Text := 'Металл';
    btAbsorb : StatusBar1.Panels[0].Text := 'Поглощающие слои'
      + ' (' + IntToStr(RegionList.BoundsWidth) + ')';
  end;
  StatusBar1.Panels[1].Text := 'Размер: ' + IntToStr(SizeX)
    + 'x' + IntToStr(SizeY);

  IntEnable := False;
  if Assigned(ModeForm) then
  begin
    if RegionList.FieldList.Count = 0 then
    begin
      ModeForm.SetManual;
      InitialStyleSet := [isManual];
    end
    else
    begin
      ModeForm.SetFromFile;
      InitialStyleSet := [isFromMedium];
      for i := 0 to RegionList.FieldList.Count - 1 do
        if (RegionList.FieldList[i].FieldType = ftRectSelf)
          or (RegionList.FieldList[i].FieldType = ftRectSelf2) then
        begin
          IntEnable := True;
          Break;
        end;
    end;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, '');
  Writeln(PrFile, 'Medium is updated');
{$ENDIF}
end;

procedure TMainForm.DisableOnRun;
begin
//делает недоступными некоторые компоненты при запуске процесса
  tbStart.Enabled := False;
  mmStart.Enabled := False;
  tbPause.Enabled := True;
  mmPause.Enabled := True;
  tbRestart.Enabled := False;
  mmRestart.Enabled := False;
  tbOpen.Enabled := False;
  mmOpen.Enabled := False;
  tbEditor.Enabled := False;
  mmEditor.Enabled := False;
  tbFourie.Enabled := False;
  cbMode.Enabled := False;
  seAutoStop.Enabled := False;
  cbGr1.Enabled := False;
  cbGr2.Enabled := False;
  cbGrField1.Enabled := False;
  cbGrField2.Enabled := False;
  seXGr1.Enabled := False;
  seYGr1.Enabled := False;
  seXGr2.Enabled := False;
  seYGr2.Enabled := False;
  lbXGr1.Enabled := False;
  lbYGr1.Enabled := False;
  lbXGr2.Enabled := False;
  lbYGr2.Enabled := False;
  sbModeChoose.Enabled := False;
  mmMode.Enabled := False;
  mmSetup.Enabled := False;
  mmDraw.Enabled := False;
  mmSaveSetup.Enabled := False;
  seIntX.Enabled := False;
  bbIntFourie.Enabled := False;
  bbIntProp.Enabled := False;
end;

procedure TMainForm.EnableOnStop;
begin
//делает доступными некоторые компоненты при паузе процесса
  tbStart.Enabled := True;
  mmStart.Enabled := True;
  tbPause.Enabled := False;
  mmPause.Enabled := False;
  tbRestart.Enabled := True;
  mmRestart.Enabled := True;
  seAutoStop.Enabled := True;
  mmSetup.Enabled := True;
  mmDraw.Enabled := True;
  mmSaveSetup.Enabled := True;
  if GrF1.Enable or GrF2.Enable then
    tbFourie.Enabled := True;
  bbIntFourie.Enabled := True;
end;

procedure TMainForm.EnableOnRestart;
begin
//делает доступными некоторые компоненты при перезапуске процесса
  tbRestart.Enabled := False;
  mmRestart.Enabled := False;
  tbOpen.Enabled := True;
  mmOpen.Enabled := True;
  tbEditor.Enabled := True;
  mmEditor.Enabled := True;
  tbFourie.Enabled := False;
  cbMode.Enabled := True;
  cbGr1.Enabled := True;
  cbGr2.Enabled := True;
  cbGrField1.Enabled := True;
  cbGrField2.Enabled := True;
  seXGr1.Enabled := True;
  seYGr1.Enabled := True;
  seXGr2.Enabled := True;
  seYGr2.Enabled := True;
  lbXGr1.Enabled := True;
  lbYGr1.Enabled := True;
  lbXGr2.Enabled := True;
  lbYGr2.Enabled := True;
  sbModeChoose.Enabled := True;
  mmMode.Enabled := True;
  bbIntFourie.Enabled := False;
  seIntX.Enabled := True;
  bbIntProp.Enabled := True;
end;

procedure TMainForm.CreateTHR;
begin
//создает основную подзадачу
  THR := TTHR.Create(True);
//присвоить событие прорисовки
  THR.OnCalculate := Draw;
  THR.FreeOnTerminate := True;
end;

function TMainForm.CheckOnDraw;
var
  StepsNeeded: Integer;
begin
//проверяет должна ли компонента прорисовываться на данном шаге
//зависит от того, является компонента электрической или магнитной
//и от количества шагов, через которое происходит прорисовка
  if DrawRecord.ToDraw = tdOnStep then
    StepsNeeded := DrawRecord.StepCount
  else
    StepsNeeded := 2;
  Result := (Tn + 2) mod StepsNeeded = Tag(FieldType);
end;

//procedure TMainForm.DrawComponent(FieldP: TFieldPointer; var Grapher: TGrapher);
procedure TMainForm.DrawComponent(FieldP: TFieldPointer; SPLine: Tsp_XYLine);
var
  i, j: Integer;
begin
//рисует компоненту FieldP в Grapher на странице "Компоненты"
  SPLine.Clear;
  case CompCoord of
    ccVert :
      for i := 0 to SizeX - 1 do
        if (i + FixY + 2) mod 2 = Tag(FieldP.FieldType) then
          SPLine.QuickAddXY(i, FieldP.Field^[i, FixY]);
    ccHoriz :
      for j := 0 to SizeY - 1 do
        if (FixX + j + 2) mod 2 = Tag(FieldP.FieldType) then
          SPLine.QuickAddXY(j, FieldP.Field^[FixX, j]);
  end;
end;

procedure TMainForm.DrawComponents(Required: Boolean);
var
  FieldValue: Single;
begin
//рисует все компоненты
  if CheckOnDraw(CompF1.FieldType) or Required then
    DrawComponent(CompF1, splComp1);
  if CheckOnDraw(CompF2.FieldType) or Required then
    DrawComponent(CompF2, splComp2);
  if CheckOnDraw(CompF3.FieldType) or Required then
    DrawComponent(CompF3, splComp3);
  if CheckOnDraw(CompF4.FieldType) or Required then
    DrawComponent(CompF4, splComp4);

//если курсор мыши на одном из Grapher-ов то вывести значение
//компоненты в данной точке
  FieldValue := 0;
  if MouseOnComp1 then
  begin
    case CompCoord of
      ccVert :
      begin
        if (XMouse + FixY + 2) mod 2 <> Tag(CompF1.FieldType) then Inc(XMouse);
        FieldValue := CompF1.Field^[XMouse, FixY];
      end;
      ccHoriz :
      begin
        if (FixX + YMouse + 2) mod 2 <> Tag(CompF1.FieldType) then Inc(YMouse);
        FieldValue := CompF1.Field^[FixX, YMouse];
      end;
    end;
    StatusBar1.Panels[3].Text := 'Поле: ' + FloatToStrF(
      FieldValue, ffGeneral, 4, 4) + ' (' + IntToStr(Round(Abs(
      FieldValue) / GetMaxValue(CompF1.FieldType) * 100)) + '%)';
  end;

  if MouseOnComp2 then
  begin
    case CompCoord of
      ccVert :
      begin
        if (XMouse + FixY + 2) mod 2 <> Tag(CompF2.FieldType) then Inc(XMouse);
        FieldValue := CompF2.Field^[XMouse, FixY];
      end;
      ccHoriz :
      begin
        if (FixX + YMouse + 2) mod 2 <> Tag(CompF2.FieldType) then Inc(YMouse);
        FieldValue := CompF2.Field^[FixX, YMouse];
      end;
    end;
    StatusBar1.Panels[3].Text := 'Поле: ' + FloatToStrF(
      FieldValue, ffGeneral, 4, 4) + ' (' + IntToStr(Round(Abs(
      FieldValue) / GetMaxValue(CompF2.FieldType) * 100)) + '%)';
  end;

  if MouseOnComp3 then
  begin
    case CompCoord of
      ccVert :
      begin
        if (XMouse + FixY + 2) mod 2 <> Tag(CompF3.FieldType) then Inc(XMouse);
        FieldValue := CompF3.Field^[XMouse, FixY];
      end;
      ccHoriz :
      begin
        if (FixX + YMouse + 2) mod 2 <> Tag(CompF3.FieldType) then Inc(YMouse);
        FieldValue := CompF3.Field^[FixX, YMouse];
      end;
    end;
    StatusBar1.Panels[3].Text := 'Поле: ' + FloatToStrF(
      FieldValue, ffGeneral, 4, 4) + ' (' + IntToStr(Round(Abs(
      FieldValue) / GetMaxValue(CompF3.FieldType) * 100)) + '%)';
  end;

  if MouseOnComp4 then
  begin
    case CompCoord of
      ccVert :
      begin
        if (XMouse + FixY + 2) mod 2 <> Tag(CompF4.FieldType) then Inc(XMouse);
        FieldValue := CompF4.Field^[XMouse, FixY];
      end;
      ccHoriz :
      begin
        if (FixX + YMouse + 2) mod 2 <> Tag(CompF4.FieldType) then Inc(YMouse);
        FieldValue := CompF4.Field^[FixX, YMouse];
      end;
    end;
    StatusBar1.Panels[3].Text := 'Поле: ' + FloatToStrF(
      FieldValue, ffGeneral, 4, 4) + ' (' + IntToStr(Round(Abs(
      FieldValue) / GetMaxValue(CompF4.FieldType) * 100)) + '%)';
  end;
end;

procedure TMainForm.DrawGraphics(Required: Boolean);
var
  i: Integer;
begin
//прсрисовка графиков
  if LastAdded = 0 then
    Exit;

  if GrF1.Enable and (CheckOnDraw(GrF1.FieldType)or Required) then
  begin
    for i := GPoints1.Count - LastAdded to GPoints1.Count - 1 do
      splGraph1.QuickAddXY(GPoints1.Values[i].X, GPoints1.Values[i].Y);
//если время (Tn) велико то сдвинуть рисунок
    if Tn > spGraph1.BottomAxis.Max then
      spGraph1.BottomAxis.MoveMinMax(Tn - spGraph1.BottomAxis.Max);
  end;

  if GrF2.Enable and (CheckOnDraw(GrF2.FieldType) or Required) then
  begin
    for i := GPoints2.Count - LastAdded to GPoints2.Count - 1 do
      splGraph2.QuickAddXY(GPoints2.Values[i].X, GPoints2.Values[i].Y);
    if Tn > spGraph2.BottomAxis.Max then
      spGraph2.BottomAxis.MoveMinMax(Tn - spGraph2.BottomAxis.Max);
  end;
  LastAdded := 0;
end;

procedure TMainForm.DrawFourier(Required: Boolean);
var
  Points1, Points2: TPoints;
  i: Integer;
begin
  Points1 := TPoints.Create;
  Points2 := TPoints.Create;
  for i := 0 to FourierF1.Field^.SizeY - 1 do
  begin
    if CheckOnDraw(FourierF1.FieldType) or Required then
      if (i + FourX1 +2) mod 2 = Tag(FourierF1.FieldType) then
        Points1.Add(i, FourierF1.Field^[FourX1, i]);
    if CheckOnDraw(FourierF2.FieldType) or Required then
      if (i + FourX2 +2) mod 2 = Tag(FourierF2.FieldType) then
        Points2.Add(i, FourierF2.Field^[FourX2, i]);
  end;
  if CheckOnDraw(FourierF1.FieldType) or Required then
  begin
     DoFFT(Points1);
     grFourier1.PointsList[0].Assign(Points1);
     grFourier1.Repaint;
  end;
  if CheckOnDraw(FourierF2.FieldType) or Required then
  begin
    DoFFT(Points2);
    grFourier2.PointsList[0].Assign(Points2);
    grFourier2.Repaint;
  end;
  Points1.Free;
  Points2.Free;
end;

procedure TMainForm.DrawWave(Required: Boolean);
type
  TIntArray = array[0..32767] of Integer;
  PIntArray = ^TIntArray;
var
  i, j: Integer;
  Line: PIntArray;
  FieldValue: Single;
begin
//прорисовка рисунка волны
  if CheckOnDraw(WaveF.FieldType) or Required then
  begin
//нарисовать волну
    for j := 0 to SizeY - 1 do
    begin
      Line := WaveBitmap.ScanLine[j];
      for i := 0 to SizeX - 1 do
        if (i + j + 2) mod 2 = Tag(WaveF.FieldType) then
          Line[i] := ColorByValue(WaveF.FieldType, WaveF.Field^[i, j]);
    end;
//нарисовать контуры объектов
    RegionList.DrawContour(WaveBitmap.Canvas, WaveBitmap.Height,
      WaveBitmap.Width);
    grWave.Repaint;
//если курсор мыши на рисунке то вывести значение
//поля в данной точке
    if MouseOnWave and (XMouse < SizeX) and (YMouse < SizeY) then
    begin
      FieldValue := WaveF.Field^[XMouse, YMouse];
      StatusBar1.Panels[3].Text := 'Поле: ' + FloatToStrF(
        FieldValue,  ffGeneral, 4, 4) + ' (' + IntToStr(Round(
        Abs(FieldValue) / GetMaxValue(WaveF.FieldType) * 100)) + '%)';
    end
    else
      StatusBar1.Panels[3].Text := '';
  end;
end;

procedure TMainForm.DrawIntegral;
var
  i: Integer;
begin
  if LastAddedI = 0 then
    Exit;
  for i := IntFPoints.Count - LastAddedI to IntFPoints.Count - 1 do
    spLineIntF.QuickAddXY(IntFPoints.Values[i].X, IntFPoints.Values[i].Y);
  if Tn > spIntegralF.BottomAxis.Max then
    spIntegralF.BottomAxis.MoveMinMax(Tn - spIntegralF.BottomAxis.Max);

  for i := IntBPoints.Count - LastAddedI to IntBPoints.Count - 1 do
    spLineIntB.QuickAddXY(IntBPoints.Values[i].X, IntBPoints.Values[i].Y);
  if Tn > spIntegralB.BottomAxis.Max then
    spIntegralB.BottomAxis.MoveMinMax(Tn - spIntegralB.BottomAxis.Max);

  LastAddedI := 0;
end;

procedure TMainForm.Draw(Sender: TObject);
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Enter draw procedure');
{$ENDIF}
//вызов всех процедур прорисовок, сама вызывается из подзадачи
//если нужно прорисовать (прошло определенное количество шагов
//или время), то рисовать активную страницу
  if IntEnable then
    DrawIntegral;
  if DrawRecord.ReadyToDraw then
  begin
    if (PageControl1.ActivePage = CompPage)and
      (doComponents in DrawRecord.ObjectsSet) then
      DrawComponents(False);
    if (PageControl1.ActivePage = GrPage)and
      (doGraphics in DrawRecord.ObjectsSet) then
      DrawGraphics(False);
    if (PageControl1.ActivePage = WavePage)and
      (doWave in DrawRecord.ObjectsSet) then
      DrawWave(False);
    if (PageControl1.ActivePage = FourierPage)and
      (doFourier in DrawRecord.ObjectsSet) then
      DrawFourier(False);
    DrawRecord.ReadyToDraw:=False;
  end;
  StatusBar1.Panels[4].Text := 'Шаг: ' + IntToStr(Tn) + ' ('
    + FloatToStrF(RoundFloat(Tn * DelT, 3), ffGeneral, 3, 3) + ')';
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Finish to draw');
{$ENDIF}
end;

function TMainForm.IntToStr3(X: Integer): String;
begin
//возвращает строку с числом в трёхцифровом формате
//1 = 001, 10=010, 100=100, 1000=1000
  Result := IntToStrD(X, 3);
end;

procedure TMainForm.SaveWave;
var
  FileName: string;
begin
//сохранить рисунок волны
  repeat
//найти новое имя для файла
    Inc(WaveSaveCount);
    FileName := WavePath + 'Wav' + FieldName(WaveF)
      + IntToStr3(WaveSaveCount) + '.bmp';
  until (not FileExists(FileName)) or (not ToRewrite);
  WaveBitmap.SaveToFile(FileName);
end;

procedure TMainForm.SaveComponents;
var
  FileName1, FileName2, FileName3, FileName4: string;
  Bitmap: TBitmap;
begin
//сохранить компоненты
  repeat
    Inc(CompSaveCount);
    FileName1 := CompPath + FieldName(CompF1) + IntToStr3(CompSaveCount)
      + '.bmp';
    FileName2 := CompPath + FieldName(CompF2) + IntToStr3(CompSaveCount)
      + '.bmp';
    FileName3 := CompPath + FieldName(CompF3) + IntToStr3(CompSaveCount)
      + '.bmp';
    FileName4 := CompPath + FieldName(CompF4) + IntToStr3(CompSaveCount)
      + '.bmp';
  until ((not FileExists(FileName1)) and (not FileExists(FileName3))
    and (not FileExists(FileName2)) and (not FileExists(FileName4)))
    or (not ToRewrite);
  Bitmap := TBitmap.Create;
  Bitmap.Width := spComp1.Width;
  Bitmap.Height := spComp1.Height;

  spComp1.CopyToClipboardBitmap;
  Bitmap.Assign(Clipboard);
  Bitmap.SaveToFile(FileName1);
  spComp2.CopyToClipboardBitmap;
  Bitmap.Assign(Clipboard);
  Bitmap.SaveToFile(FileName2);
  spComp3.CopyToClipboardBitmap;
  Bitmap.Assign(Clipboard);
  Bitmap.SaveToFile(FileName3);
  spComp4.CopyToClipboardBitmap;
  Bitmap.Assign(Clipboard);
  Bitmap.SaveToFile(FileName4);

  Bitmap.Free;
end;

procedure TMainForm.SaveGraphics;
var
  FileName1, FileName2: string;
  Bitmap: TBitmap;
begin
//сохранить графики
  repeat
    Inc(GraphSaveCount);
    FileName1 := GraphPath + 'Gr1_' + FieldName(GrF2)
      + IntToStr3(GraphSaveCount) + '.bmp';
    FileName2 := GraphPath + 'Gr2_' + FieldName(GrF1)
      + IntToStr3(GraphSaveCount) + '.bmp';
  until (not FileExists(FileName1)) and (not FileExists(FileName2))
    or (not ToRewrite);
  Bitmap := TBitmap.Create;
  spGraph1.CopyToClipboardBitmap;
  Bitmap.Assign(Clipboard);
  Bitmap.SaveToFile(FileName1);
  spGraph2.CopyToClipboardBitmap;
  Bitmap.Assign(Clipboard);
  Bitmap.SaveToFile(FileName2);
  Bitmap.Free;
end;

procedure TMainForm.SaveFourier;
begin
{}
end;

procedure TMainForm.SaveFourierTime;
var
  FileName1, FileName2: string;
begin
//сохранить графики Фурье преобразования
  repeat
    Inc(GraphSaveCount);
    FileName1 := GraphPath + 'F1_' + FieldName(GrF2)
      + IntToStr3(CompSaveCount) + '.bmp';
    FileName2 := GraphPath + 'F2_' + FieldName(GrF1)
      + IntToStr3(CompSaveCount) + '.bmp';
  until (not FileExists(FileName1)) and (not FileExists(FileName2))
    or (not ToRewrite);
  grFourierTime1.Bitmap.SaveToFile(FileName1);
  grFourierTime2.Bitmap.SaveToFile(FileName2);
end;

procedure TMainForm.Save;
begin
//вызов всех процедур сохранения
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Saving');
{$ENDIF}
  if doWave in Saving then
  begin
    DrawWave(True);
    SaveWave;
  end;
  if doComponents in Saving then
  begin
    DrawComponents(True);
    SaveComponents;
  end;
  if doFourier in Saving then
  begin
    DrawFourier(True);
    SaveFourier;
  end;
  if (doGraphics in Saving) and (GrF1.Enable) and (GrF2.Enable) then
  begin
    DrawGraphics(True);
    SaveGraphics;
  end;
end;

procedure TMainForm.UpdateDraw;
begin
//переопределение параметров прорисовки после изменения
  with SetupForm do
  begin
//частота прорисовки
    if rbEachStep.Checked then
      DrawRecord.ToDraw := tdEachStep;
    if rbOnStep.Checked then
    begin
      DrawRecord.ToDraw := tdOnStep;
      DrawRecord.StepCount := seStep.AsInteger;
    end;
    if rbOnTime.Checked then
    begin
      DrawRecord.ToDraw := tdOnTime;
      DrawRecord.Time := seTime.Value;
      Timer1.Interval := Round(DrawRecord.Time * 1000);
    end;
//объекты прорисовки
    if rbAll.Checked then
      DrawRecord.ObjectsSet := [doWave..doFourier];
    if rbCustom.Checked then
    begin
      DrawRecord.ObjectsSet := [];
      if cbWave.Checked then
        DrawRecord.ObjectsSet := DrawRecord.ObjectsSet+[doWave];
      if cbGraphics.Checked then
        DrawRecord.ObjectsSet := DrawRecord.ObjectsSet+[doGraphics];
      if cbComponents.Checked then
        DrawRecord.ObjectsSet := DrawRecord.ObjectsSet+[doComponents];
      if cbFourier.Checked then
        DrawRecord.ObjectsSet := DrawRecord.ObjectsSet+[doFourier];
    end;
//максимальное и минимальное значения поля
    WhiteValue := seMinColor.AsInteger/100;
    BlackValue := seMaxColor.AsInteger/100;
//прорисовка точек графиков
    DrawGraphicsPoints := cbGrPoints.Checked;
    cbGr1Click(Self);
    cbGr2Click(Self);
  end;
end;

procedure TMainForm.UpdateSave;
begin
//переопределение параметров сохранения после изменения
  with SetupForm do
  begin
//пути для сохранения
    WavePath := edWave.Text;
    CompPath := edComponents.Text;
    GraphPath := edGraphics.Text;
    ValuesPath := edValues.Text;
    ReportPath := edReport.Text;
    SaveOnActivePage := False;
//объекты сохранения
    case rgToSave.ItemIndex of
      0 : Saving := [doWave..doFourier];
      1 : Saving := [doWave];
      2 : Saving := [doComponents];
      3 : Saving := [doGraphics];
      4 : Saving := [doFourier];
      5 :
      begin
        SaveOnActivePage := True;
        PageControl1Change(Self);
      end;
    end;
//нужно ли преписывать имеющиеся файлы
    ToRewrite := cbRewrite.Checked;
  end;
end;

procedure TMainForm.UpdateProgram;
begin
//переопределение параметров программы
  with SetupForm do
  begin
    Lx := seSizeX.Value;
    Ly := seSizeY.Value;
    if cbAxel.Checked then
    begin
      DelX := seDelX.Value;
      DelY := seDelY.Value;
    end
    else
    begin
      DelX := seDelXY.Value;
      DelY := DelX;
    end;
    if rbDelTByX.Checked then
      DelT := seDelTByX.Value * DelX / C;
    if rbDelTByY.Checked then
      DelT := seDelTByY.Value * DelX / C;
  end;
  RegionList.DelX := DelX;
  RegionList.DelY := DelY;
  RegionList.DelT := DelT;

  DtDivDx := DelT / DelX;
  DtDivDy := DelT / DelY;
end;

procedure TMainForm.SetInitialWave;
begin
  if isManual in InitialStyleSet then
    case ModeType of
      mtTE :
        case InitialWave of
          iwSin   : PlaneWaveTE;
          iwGauss : GaussTE;
        end;
      mtTM :
        case InitialWave of
          iwSin   : PlaneWaveTM;
          iwGauss : GaussTM;
        end;
    end;
  if isFromMedium in InitialStyleSet then
    WaveFromRegionList;
end;

procedure TMainForm.Pause;
var
  i: Integer;
begin
//поставить процесс на паузу
  EnableOnStop;
  ProcessState := psPaused;
  THR.Suspend;
//сохранить значения графиков
  try
    if GrF1.Enable then
    begin
      for i := Written to GPoints1.Count - 1 do
        Writeln(ValuesFile1, GPoints1.Values[i].Y);
      if not GrF2.Enable then
        Written := GPoints1.Count - 1;
    end;
    if GrF2.Enable then
    begin
      for i := Written to GPoints2.Count - 1 do
        Writeln(ValuesFile2, GPoints2.Values[i].Y);
      Written := GPoints2.Count - 1;
    end;
  except
    raise Exception.Create('Не могу записать в файл значений');
  end;
end;

procedure TMainForm.Restart;
begin
//перезапуск процесса
  EnableOnRestart;
  ProcessState := psStoped;
  THR.Free;
  DestroyFields;
  Tn := 0;
  WaveBitmap.Free;
  WaveBitmap := TBitmap.Create;
  WaveBitmap.Width := SizeX;
  WaveBitmap.Height := SizeY;
  WaveBitmap.PixelFormat := pf32Bit;
  grWave.Repaint;

  if RegionList.BoundsType = btAbsorb then
    FreeSigmaCoeffs;

  if Assigned(IntFModeEz) then
    IntFModeEz.Free;
  if Assigned(IntFModeHy) then
    IntFModeHy.Free;
  IntFPoints.Clear;
  IntBPoints.Clear;
  GPoints1.Clear;
  GPoints2.Clear;

  splGraph1.Clear;
  splGraph2.Clear;
  spGraph1.BottomAxis.SetMinMax(0, 500);
  spGraph2.BottomAxis.SetMinMax(0, 500);
  spLineIntF.Clear;
  spLineIntB.Clear;
  spIntegralF.BottomAxis.SetMinMax(0, 500);
  spIntegralB.BottomAxis.SetMinMax(0, 500);
  LastAddedI := 0;
end;

procedure TMainForm.Start;
begin
//запуск процесса
  DisableOnRun;
  if ProcessState = psStoped then
  begin
    CreateTHR;
    CreateFields;
//назначить компоненты для графиков
    FieldByIndex(cbGrField1.ItemIndex, GrF1);
    FieldByIndex(cbGrField2.ItemIndex, GrF2);
    XGr1 := seXGr1.AsInteger;
    YGr1 := seYGr1.AsInteger;
    XGr2 := seXGr2.AsInteger;
    YGr2 := seYGr2.AsInteger;
    SetInitialWave;

    if RegionList.BoundsType = btAbsorb then
      SetSigmaCoeffs;

    IntFPoints.Clear;
    if IntEnable then
      SetIntMode;
  end;
  if seAutoStop.AsInteger > 0 then
    AutoStopTime := seAutoStop.AsInteger
  else
    AutoStopTime := -1;
  IntX := seIntX.AsInteger;
  ProcessState := psRuning;
  THR.Resume;
end;

procedure TMainForm.SaveOptions;
var
  IniFile: TExtIniFile;
  Bool: Boolean;
  Str: string;
begin
//сохранение настроек в ini-файл
  UpdateDraw;
  UpdateSave(Self);
  IniFile := TExtIniFile.Create('.\' + OptionsFileName);

  try
    {Draw Section}

    Bool := doWave in DrawRecord.ObjectsSet;
    IniFile.WriteBoolAsString('Draw', 'Wave', Bool);
    Bool := doComponents in DrawRecord.ObjectsSet;
    IniFile.WriteBoolAsString('Draw', 'Components', Bool);
    Bool := doGraphics in DrawRecord.ObjectsSet;
    IniFile.WriteBoolAsString('Draw', 'Graphics', Bool);
    Bool := doFourier in DrawRecord.ObjectsSet;
    IniFile.WriteBoolAsString('Draw', 'Fourier', Bool);

    case DrawRecord.ToDraw of
      tdEachStep :
      begin
        IniFile.WriteString('Draw', 'Freq', 'EachStep');
        IniFile.DeleteKey('Draw', 'Steps');
        IniFile.DeleteKey('Draw', 'Time');
      end;
      tdOnStep :
      begin
        IniFile.WriteString('Draw', 'Freq', 'OnStep');
        IniFile.WriteInteger('Draw', 'Steps', DrawRecord.StepCount);
        IniFile.DeleteKey('Draw', 'Time');
      end;
      tdOnTime :
      begin
        IniFile.WriteString('Draw', 'Freq', 'OnTime');
        IniFile.WriteFloat('Draw', 'Time', DrawRecord.Time);
        IniFile.DeleteKey('Draw', 'Steps');
      end;
    end;
    IniFile.WriteBoolAsString('Draw', 'GraphicsPoints', DrawGraphicsPoints);

    {Colors Section}

    IniFile.WriteFloat('Colors', 'White', WhiteValue);
    IniFile.WriteFloat('Colors', 'Black', BlackValue);

    {Save Section}

    if SaveOnActivePage then
      Str := 'OnActivePage'
    else
    begin
      if doWave in Saving then
        Str := 'Wave';
      if doComponents in Saving then
        Str := 'Components';
      if doGraphics in Saving then
        Str := 'Graphics';
      if doFourier in Saving then
        Str := 'Fourier';
      if Saving=[doWave..doFourier] then
        Str := 'All';
    end;
    IniFile.WriteString('Save', 'SaveObjects', Str);
    IniFile.WriteBoolAsString('Save', 'Overwrite', True);

    {Pathes Section}

    IniFile.WriteString('Pathes', 'WavePath', WavePath);
    IniFile.WriteString('Pathes', 'CompPath', CompPath);
    IniFile.WriteString('Pathes', 'GraphPath', GraphPath);
    IniFile.WriteString('Pathes', 'FourierPath', FourPath);
    IniFile.WriteString('Pathes', 'ValuesPath', ValuesPath);
    IniFile.WriteString('Pathes', 'ReportPath', ReportPath);

    {Param Section}

    IniFile.WriteFloat('Param', 'SizeOfX', Lx);
    IniFile.WriteFloat('Param', 'SizeOfY', Ly);
    IniFile.WriteFloat('Param', 'dx', RoundFloat(DelX, 3));
    IniFile.WriteFloat('Param', 'dy', RoundFloat(DelY, 3));
    IniFile.WriteFloat('Param', 'dt', RoundFloat(DelT, 3));

    IniFile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

function TMainForm.LoadOptions;
var
  IniFile: TExtIniFile;
  Str: string;
begin
//загрузка настроек из ini-файла
  Result := False;
  if not(FileExists('.\' + OptionsFileName)) then
    Exit;
  IniFile:=TExtIniFile.Create('.\' + OptionsFileName);

  try
    {Draw  Section}

    DrawRecord.ObjectsSet := [];
    if IniFile.ReadStringAsBool('Draw', 'Wave', False) then
      DrawRecord.ObjectsSet := DrawRecord.ObjectsSet + [doWave];
    if IniFile.ReadStringAsBool('Draw', 'Components', False) then
      DrawRecord.ObjectsSet := DrawRecord.ObjectsSet + [doComponents];
    if IniFile.ReadStringAsBool('Draw', 'Graphics', False) then
      DrawRecord.ObjectsSet := DrawRecord.ObjectsSet + [doGraphics];
    if IniFile.ReadStringAsBool('Draw', 'Fourier', False) then
      DrawRecord.ObjectsSet := DrawRecord.ObjectsSet + [doFourier];

    Str := IniFile.ReadString('Draw', 'Freq', 'EachStep');
    if Str = 'EachStep' then
      DrawRecord.ToDraw := tdEachStep;
    if Str = 'OnStep' then
    begin
      DrawRecord.ToDraw := tdOnStep;
      DrawRecord.StepCount := IniFile.ReadInteger('Draw', 'Steps', 2);
    end;
    if Str = 'OnTime' then
    begin
      DrawRecord.ToDraw := tdOnTime;
      DrawRecord.Time := IniFile.ReadFloat('Draw', 'Time', 0.2);
    end;
    DrawGraphicsPoints := IniFile.ReadStringAsBool(
      'Draw', 'GraphicsPoints', DrawGraphicsPoints);

    {Colors Section}

    WhiteValue := IniFile.ReadFloat('Colors', 'White', 0);
    BlackValue := IniFile.ReadFloat('Colors', 'Black', 1.5);

    {Save Section}

    Str := IniFile.ReadString('Save', 'SaveObjects', 'All');
    SaveOnActivePage := Str = 'OnActivePage';
    if Str = 'All' then
      Saving := [doWave..doGraphics];
    if Str = 'Wave' then
      Saving := [doWave];
    if Str = 'Components' then
      Saving := [doComponents];
    if Str = 'Graphics' then
      Saving := [doGraphics];
    if Str = 'Fourier' then
      Saving := [doFourier];
    ToRewrite := IniFile.ReadStringAsBool('Save', 'Overwrite', True);

    {Pathes Section}

    WavePath := IniFile.ReadString('Pathes', 'WavePath', WavePath);
    CompPath := IniFile.ReadString('Pathes', 'CompPath', CompPath);
    GraphPath := IniFile.ReadString('Pathes', 'GraphPath', GraphPath);
    FourPath := IniFile.ReadString('Pathes', 'FourierPath', FourPath);
    ValuesPath := IniFile.ReadString('Pathes', 'ValuesPath', ValuesPath);
    ReportPath := IniFile.ReadString('Pathes', 'ReportPath', ReportPath);

    {Param Section}

    Lx := IniFile.ReadFloat('Param', 'SizeOfX', Lx);
    Ly := IniFile.ReadFloat('Param', 'SizeOfY', Ly);
    DelX := IniFile.ReadFloat('Param', 'dx', DelX);
    DelY := IniFile.ReadFloat('Param', 'dy', DelY);
    DelT := IniFile.ReadFloat('Param', 'dt', DelT);

    Result := True;
  finally
    IniFile.Free;
  end;
end;

procedure TMainForm.UpdateOptions;
begin
//переопределение параметров после изменения настроек
  with SetupForm do
  begin
//прорисовка
    if DrawRecord.ObjectsSet = [doWave..doFourier] then
      rbAll.Checked := True
    else
    begin
      rbCustom.Checked := True;
      if doWave in DrawRecord.ObjectsSet then
        cbWave.Checked := True;
      if doComponents in DrawRecord.ObjectsSet then
        cbComponents.Checked := True;
      if doGraphics in DrawRecord.ObjectsSet then
        cbGraphics.Checked := True;
      if doFourier in DrawRecord.ObjectsSet then
        cbFourier.Checked := True;
    end;
    case DrawRecord.ToDraw of
      tdEachStep : rbEachStep.Checked := True;
      tdOnStep :
      begin
        rbOnStep.Checked := True;
        seStep.Value := DrawRecord.StepCount;
      end;
      tdOnTime :
      begin
        rbOnTime.Checked := True;
        seTime.Value := DrawRecord.Time;
      end;
    end;
    seMinColor.Value := WhiteValue*100;
    seMaxColor.Value := BlackValue*100;
    cbGrPoints.Checked := DrawGraphicsPoints;
//сохранение
    if SaveOnActivePage then
      rgToSave.ItemIndex := 5
    else
    begin
      if Saving = [doWave..doFourier] then
        rgToSave.ItemIndex := 0
      else
      begin
        if doWave in Saving then
          rgToSave.ItemIndex := 1;
        if doComponents in Saving then
          rgToSave.ItemIndex := 2;
        if doGraphics in Saving then
          rgToSave.ItemIndex := 3;
        if doFourier in Saving then
          rgToSave.ItemIndex := 4;
      end;
    end;
    edWave.Text := WavePath;
    edComponents.Text := CompPath;
    edGraphics.Text := GraphPath;
    edFourier.Text := FourPath;
    edValues.Text := ValuesPath;
    edReport.Text := ReportPath;
    cbRewrite.Checked := ToRewrite;
//программа
    seSizeX.Value := Lx;
    seSizeY.Value := Ly;
    if DelX = DelY then
    begin
      cbAxel.Checked := False;
      AxelClick;
      seDelXY.Value := DelX;
      seDelTByX.Value := DelT/DelX*C;
    end
    else
    begin
      cbAxel.Checked := True;
      AxelClick;
      seDelX.Value := DelX;
      seDelY.Value := DelY;
      seDelTByX.Value := DelT/DelX*C;
    end;
  end;
end;

procedure TMainForm.ApplyOptions(Sender: TObject);
begin
//применить изменение настроек
  UpdateDraw;
  UpdateSave(Sender);
  UpdateProgram;
  SaveOptions;
end;

//процедуры событий

procedure TMainForm.FormCreate(Sender: TObject);
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Creating of main form');
{$ENDIF}
//присвоить событие перехвата сообщений
  Application.OnMessage := AppMessage;

  ProcessState := psStoped;
  CompCoord := ccVert;
  FixY:=SizeY0 div 2;
  FixX:=SizeX0 div 2;
  AutoStopTime := -1;

  WaveBitmap := TBitmap.Create;
  WaveBitmap.Width := SizeX;
  WaveBitmap.Height := SizeY;
  WaveBitmap.PixelFormat := pf32Bit;
  PageControl1.ActivePage := WavePage;
  grFourierTime1.PointsList.Add;
  grFourierTime2.PointsList.Add;
  grFourier1.PointsList.Add;
  grFourier2.PointsList.Add;
  tbPause.Enabled := False;
  tbRestart.Enabled := False;
  cbMode.ItemIndex := 0;
  cbWaveField.ItemIndex := 2;
  cbCompField1.ItemIndex := 2;
  cbCompField2.ItemIndex := 5;
  cbCompField3.ItemIndex := 6;
  cbCompField4.ItemIndex := 7;
  cbGrField1.ItemIndex := 2;
  cbGrField2.ItemIndex := 2;
  cbScale.ItemIndex := 2;
  FourierF1.Field := @Ez;
  FourierF2.Field := @Dz;
  FourierF1.FieldType := ftEType;
  FourierF2.FieldType := ftDType;

  cbWaveFieldChange(Self);
  UpdateMedium;

  ValuesPath := MainPath + 'Saved\';
  WavePath := MainPath + 'Saved\';
  CompPath := MainPath + 'Saved\';
  GraphPath := MainPath + 'Saved\';
  ReportPath := MainPath + 'Saved\';
  EditorPath := MainPath + 'Editor\';
  OpenDialog1.InitialDir := MainPath + 'Mediums\';

//загрузить настройки
  Loaded := LoadOptions;

  Written := 0;
  try
    AssignFile(ValuesFile1, ValuesPath + ValuesFile1Name);
    AssignFile(ValuesFile2, ValuesPath + ValuesFile2Name);
    Rewrite(ValuesFile1);
    Rewrite(ValuesFile2);
  except
    raise Exception.Create('Не могу создать файлы значений');
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, '');
  Writeln(PrFile, 'Finish form creating');
{$ENDIF}
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  i: Integer;
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile, '');
  Writeln(PrFile, 'Closing main form');
{$ENDIF}
//сохранить значения графиков
  try
    if (GrF1.Enable) and (Written < GPoints1.Count - 1) then
      for i := Written to GPoints1.Count - 1 do
        Writeln(ValuesFile1, GPoints1.Values[i].Y);
    if (GrF2.Enable) and (Written < GPoints2.Count - 1) then
      for i := Written to GPoints2.Count - 1 do
        Writeln(ValuesFile2, GPoints2.Values[i].Y);
    CloseFile(ValuesFile1);
    CloseFile(ValuesFile2);
  finally
//удалить временный файл для предачи редактору
    if FileExists(TempFile) then
      DeleteFile(TempFile);

    if ProcessState <> psStoped then
    begin
      THR.Suspend;
      THR.Terminate;
      DestroyFields;
      FreeSigmaCoeffs;
      if Assigned(IntFModeEz) then
        IntFModeEz.Free;
      if Assigned(IntFModeHy) then
        IntFModeHy.Free;
    end;
    WaveBitmap.Free;

    GPoints1.Free;
    GPoints2.Free;
    IntFPoints.Free;
    IntBPoints.Free;

    RegionList.Free;
{$IFDEF WRPROCESS}
    Writeln(PrFile);
    Writeln(PrFile, 'Finish of the application');
    CloseFile(PrFile);
{$ENDIF}
  end;
end;

procedure TMainForm.grWavePaint(Sender: TObject);
var
  ScaledWidth, ScaledHeight: Integer;
begin
//прорисовка рисунка волны с учетом масштаба
  if Assigned(WaveBitmap) then
  begin
    ScaledWidth := Round(ScaleCoef * SizeX);
    ScaledHeight := Round(ScaleCoef * SizeY);
    grWave.Canvas.StretchDraw(Rect(0, 0, ScaledWidth,
      ScaledHeight), WaveBitmap);
  end;
end;

procedure TMainForm.tbStartClick(Sender: TObject);
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile);
  Writeln(PrFile, 'Start is clicked');
{$ENDIF}
  Start;
end;

procedure TMainForm.tbPauseClick(Sender: TObject);
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile);
  Writeln(PrFile, 'Pause is clicked');
{$ENDIF}
  Pause;
end;

procedure TMainForm.tbRestartClick(Sender: TObject);
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile);
  Writeln(PrFile, 'Restart is clicked');
{$ENDIF}
  Restart;
end;

procedure TMainForm.cbModeChange(Sender: TObject);
begin
  case cbMode.ItemIndex of
    0 : ModeType := mtTE;
    1 : ModeType := mtTM;
  end;
end;

procedure TMainForm.cbWaveFieldChange(Sender: TObject);
begin
  FieldByIndex(cbWaveField.ItemIndex, WaveF);
end;

procedure TMainForm.cbCompField1Change(Sender: TObject);
begin
  FieldByIndex(cbCompField1.ItemIndex, CompF1);
//изменить масштабирование с учетом максимального значения
//выбранной компоненты
  spComp1.LeftAxis.SetMinMax(-1.2 * GetMaxValue(CompF1.FieldType),
    1.2 * GetMaxValue(CompF1.FieldType));
end;

procedure TMainForm.cbCompField2Change(Sender: TObject);
begin
  FieldByIndex(cbCompField2.ItemIndex, CompF2);
  spComp2.LeftAxis.SetMinMax(-1.2 * GetMaxValue(CompF2.FieldType),
    1.2 * GetMaxValue(CompF2.FieldType));
end;

procedure TMainForm.cbCompField3Change(Sender: TObject);
begin
  FieldByIndex(cbCompField3.ItemIndex, CompF3);
  spComp3.LeftAxis.SetMinMax(-1.2 * GetMaxValue(CompF3.FieldType),
    1.2 * GetMaxValue(CompF3.FieldType));
end;

procedure TMainForm.cbCompField4Change(Sender: TObject);
begin
  FieldByIndex(cbCompField4.ItemIndex, CompF4);
  spComp4.LeftAxis.SetMinMax(-1.2 * GetMaxValue(CompF4.FieldType),
    1.2 * GetMaxValue(CompF4.FieldType));
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
//автосохранение
  if AutoSave and (Tn mod AutoSaveTime = 0) and (ProcessState = psRuning) then
  begin
    Save;
    Thr.Resume;
  end;
//автостоп
  if (Tn >= AutoStopTime) and (AutoStopTime > 0) then
  begin
    Draw(Self);
    Thr.Resume;
    Pause;
    seAutoStop.Value := 0;
  end;
//прорисовка, если она по таймеру
  if (ProcessState = psRuning)and(DrawRecord.ToDraw = tdOnTime) then
  begin
    DrawRecord.ReadyToDraw := True;
  end;
end;

procedure TMainForm.tbOpenClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    RegionList.LoadFromFile(OpenDialog1.FileName);
{$IFDEF WRPROCESS}
    Writeln(PrFile, '');
    Writeln(PrFile, 'Medium is loaded');
{$ENDIF}
    UpdateMedium;
    SetupForm.OnSave := ApplyOptions;
    UpdateOptions;
  end;
end;

procedure TMainForm.cbGr1Click(Sender: TObject);
begin
  GrF1.Enable := cbGr1.Checked;
  if DrawGraphicsPoints then
    Image1.Visible := GrF1.Enable
  else
    Image1.Visible := False;
end;

procedure TMainForm.cbGr2Click(Sender: TObject);
begin
  GrF2.Enable := cbGr2.Checked;
  if DrawGraphicsPoints then
    Image2.Visible := GrF2.Enable
  else
    Image2.Visible := False;
end;

procedure TMainForm.slFixYChange(Sender: TObject);
begin
  FixY := slFixY.Value;
  seFixY.Value := FixY;
  if (ProcessState <> psStoped) and
    (doComponents in DrawRecord.ObjectsSet) then
    DrawComponents(True);
end;

procedure TMainForm.slFixXChange(Sender: TObject);
begin
  FixX := slFixX.Value;
  seFixX.Value := FixX;
  if (ProcessState <> psStoped) and
    (doComponents in DrawRecord.ObjectsSet) then
    DrawComponents(True);
end;

procedure TMainForm.seFixYChange(Sender: TObject);
begin
  if seFixY.Text <> '' then
  begin
    FixY := seFixY.AsInteger;
    slFixY.Value := FixY;
    if (ProcessState <> psStoped) and
      (doComponents in DrawRecord.ObjectsSet) then
      DrawComponents(True);
  end;
end;

procedure TMainForm.seFixXChange(Sender: TObject);
begin
  if seFixX.Text <> '' then
  begin
    FixX := seFixX.AsInteger;
    slFixX.Value := FixX;
    if (ProcessState <> psStoped) and
      (doComponents in DrawRecord.ObjectsSet) then
      DrawComponents(True);
  end;
end;

procedure TMainForm.rbCoordYClick(Sender: TObject);
begin
  CompCoord := ccHoriz;
  slFixX.Enabled := True;
  seFixX.Enabled := True;
  lbCoordX.Enabled := True;
  slFixY.Enabled := False;
  seFixY.Enabled := False;
  lbCoordY.Enabled := False;
  spComp1.BottomAxis.SetMinMax(0, SizeY - 1);
  spComp2.BottomAxis.SetMinMax(0, SizeY - 1);
  spComp3.BottomAxis.SetMinMax(0, SizeY - 1);
  spComp4.BottomAxis.SetMinMax(0, SizeY - 1);
  if (ProcessState <> psStoped) and
    (doComponents in DrawRecord.ObjectsSet) then
    DrawComponents(True);
end;

procedure TMainForm.rbCoordXClick(Sender: TObject);
begin
  CompCoord := ccVert;
  slFixX.Enabled := False;
  seFixX.Enabled := False;
  lbCoordX.Enabled := False;
  slFixY.Enabled := True;
  seFixY.Enabled := True;
  lbCoordY.Enabled := True;
  spComp1.BottomAxis.SetMinMax(0, SizeX - 1);
  spComp2.BottomAxis.SetMinMax(0, SizeX - 1);
  spComp3.BottomAxis.SetMinMax(0, SizeX - 1);
  spComp4.BottomAxis.SetMinMax(0, SizeX - 1);
  if (ProcessState <> psStoped) and
    (doComponents in DrawRecord.ObjectsSet) then
    DrawComponents(True);
end;

procedure TMainForm.grWaveMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (X < SizeX)and(Y < SizeY) then
    StatusBar1.Panels[2].Text := IntToStr(X) + ':' + IntToStr(Y)
  else
    StatusBar1.Panels[2].Text := '';
  XMouse := X;
  YMouse := Y;
  if (X + Y + 2) mod 2 <> Tag(WaveF.FieldType) then
    Inc(XMouse);
end;

procedure TMainForm.grWaveMouseLeave(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := '';
  MouseOnWave := False;
end;

procedure TMainForm.grWaveMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ProcessState = psStoped) and (X < SizeX) and (Y < SizeY) then
  case Button of
    mbLeft :
    begin
      cbGr1.Checked := True;
      seXGr1.Value := X;
      seYGr1.Value := Y;
      if DrawGraphicsPoints then
      begin
        Image1.Left := X - 7;
        Image1.Top := Y - 7;
        Image1.Visible := True;
      end;
    end;
    mbRight :
    begin
      cbGr2.Checked := True;
      seXGr2.Value := X;
      seYGr2.Value := Y;
      if DrawGraphicsPoints then
      begin
        Image2.Left := X - 7;
        Image2.Top := Y - 7;
        Image2.Visible := True;
      end;
    end;
  end;
end;

procedure TMainForm.grComp1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  XMouse := X;
  YMouse := Y;
  case CompCoord of
    ccVert :
    begin
      StatusBar1.Panels[2].Text := IntToStr(X) + ':' + IntToStr(FixY);
      if (X + FixY + 2) mod 2 <> Tag(CompF1.FieldType) then Inc(XMouse);
    end;
    ccHoriz :
    begin
      StatusBar1.Panels[2].Text := IntToStr(FixX) + ':' + IntToStr(Y);
      if (FixX + Y + 2) mod 2 <> Tag(CompF1.FieldType) then Inc(YMouse);
    end;
  end;
end;

procedure TMainForm.grComp2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  XMouse := X;
  YMouse := Y;
  case CompCoord of
    ccVert :
    begin
      StatusBar1.Panels[2].Text := IntToStr(X) + ':' + IntToStr(FixY);
      if (X + FixY + 2) mod 2 <> Tag(CompF2.FieldType) then Inc(XMouse);
    end;
    ccHoriz :
    begin
      StatusBar1.Panels[2].Text := IntToStr(FixX) + ':' + IntToStr(Y);
      if (FixX + Y + 2) mod 2 <> Tag(CompF2.FieldType) then Inc(YMouse);
    end;
  end;
end;

procedure TMainForm.grComp3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  XMouse := X;
  YMouse := Y;
  case CompCoord of
    ccVert :
    begin
      StatusBar1.Panels[2].Text := IntToStr(X) + ':' + IntToStr(FixY);
      if (X + FixY + 2) mod 2 <> Tag(CompF3.FieldType) then Inc(XMouse);
    end;
    ccHoriz :
    begin
      StatusBar1.Panels[2].Text := IntToStr(FixX) + ':' + IntToStr(Y);
      if (FixX + Y + 2) mod 2 <> Tag(CompF3.FieldType) then Inc(YMouse);
    end;
  end;
end;

procedure TMainForm.grComp4MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  XMouse := X;
  YMouse := Y;
  case CompCoord of
    ccVert :
    begin
      StatusBar1.Panels[2].Text := IntToStr(X) + ':' + IntToStr(FixY);
      if (X + FixY + 2)mod 2 <> Tag(CompF4.FieldType) then Inc(XMouse);
    end;
    ccHoriz :
    begin
      StatusBar1.Panels[2].Text := IntToStr(FixX) + ':' + IntToStr(Y);
      if (FixX + Y + 2) mod 2 <> Tag(CompF4.FieldType) then Inc(YMouse);
    end;
  end;
end;

procedure TMainForm.grComp1MouseLeave(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := '';
  MouseOnComp2 := False;
end;

procedure TMainForm.grComp2MouseLeave(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := '';
  MouseOnComp2 := False;
end;

procedure TMainForm.grComp3MouseLeave(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := '';
  MouseOnComp3 := False;
end;

procedure TMainForm.grComp4MouseLeave(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := '';
  MouseOnComp4 := False;
end;

procedure TMainForm.grWaveMouseEnter(Sender: TObject);
begin
  MouseOnWave := True;
end;

procedure TMainForm.grComp1MouseEnter(Sender: TObject);
begin
  MouseOnComp1 := True;
end;

procedure TMainForm.grComp2MouseEnter(Sender: TObject);
begin
  MouseOnComp2 := True;
end;

procedure TMainForm.grComp3MouseEnter(Sender: TObject);
begin
  MouseOnComp3 := True;
end;

procedure TMainForm.grComp4MouseEnter(Sender: TObject);
begin
  MouseOnComp4 := True;
end;

procedure TMainForm.sbModeChooseClick(Sender: TObject);
begin
//изменение начального возмущения
//настройка диалога по имеющимся параметрам
  ModeForm.cbMode.ItemIndex := cbMode.ItemIndex;
  with ModeForm do
  begin
    seStartX.MaxValue := SizeX - 11;
    seEndX.MaxValue := SizeX - 1;
    if (InitialX1 = 0)and(InitialX2 = SizeX - 1) then
      rbAllXClick(ModeForm)
    else
    begin
      rbCustomXClick(ModeForm);
      seStartX.Value := InitialX1;
      seEndX.Value := InitialX2;
    end;
    seStartY.MaxValue := SizeY - 11;
    seEndY.MaxValue := SizeY - 1;
    if (InitialY1 = 0) and (InitialY2 = SizeY - 1) then
      rbAllYClick(ModeForm)
    else
    begin
      rbCustomYClick(ModeForm);
      seStartY.Value := InitialY1;
      seEndY.Value := InitialY2;
    end;
    seHalfPX.Value := HalfPX;
    seHalfPY.Value := HalfPY;

    if ShowModal = mrOK then
    begin
//переопределение параметров возмущения
      InitialStyleSet := [];
      if cbFromMedium.Checked then
        InitialStyleSet := [isFromMedium];
      if cbManual.Checked then
        InitialStyleSet := InitialStyleSet + [isManual];
      MainForm.cbMode.ItemIndex := cbMode.ItemIndex;
      case rgInitial.ItemIndex of
        0 : InitialWave := iwSin;
        1 :
        begin
          InitialWave := iwGauss;
          ExpX := seExpX.Value;
          ExpY := seExpY.Value;
        end;
      end;
      if rbCustomX.Checked then
      begin
        InitialX1 := seStartX.AsInteger;
        InitialX2 := seEndX.AsInteger;
      end
      else
      begin
        InitialX1 := 0;
        InitialX2 := SizeX - 1;
      end;
      if rbCustomY.Checked then
      begin
        InitialY1 := seStartY.AsInteger;
        InitialY2 := seEndY.AsInteger;
      end
      else
      begin
        InitialY1 := 0;
        InitialY2 := SizeY - 1;
      end;
      HalfPX := seHalfPX.AsInteger;
      HalfPY := seHalfPY.AsInteger;
    end;
  end;
  cbModeChange(Self);
end;

procedure TMainForm.mmSetupClick(Sender: TObject);
begin
//вызов диалога настроек
  SetupForm.OnSave := ApplyOptions;
  if Loaded then UpdateOptions;
  Loaded := False;
  if SetupForm.ShowModal = mrOK then
  begin
    UpdateDraw;
    UpdateSave(Self);
    UpdateProgram;
  end;
end;

procedure TMainForm.cbScaleChange(Sender: TObject);

const
  NormalWidth = 428;
  NormalHeight = 356;

begin
  case cbScale.ItemIndex of
    0 : ScaleCoef := 0.50;
    1 : ScaleCoef := 0.750;
    2 : ScaleCoef := 1.0;
    3 : ScaleCoef := 2.0;
    4 : ScaleCoef := 4.0;
  end;
//если рисунок больше Grapher-а волны (grWave), то
//увеличить Grapher
  if Round(ScaleCoef * SizeX) > grWave.Width then
    grWave.Width := Round(ScaleCoef * SizeX);
  if Round(ScaleCoef * SizeY) > grWave.Height then
    grWave.Height := Round(ScaleCoef * SizeY);
//если рисунок мал, а Grapher волны (grWave) слишком велик, то
//уменшить Grapher
  if Round(ScaleCoef * SizeX) <= NormalWidth then
    grWave.Width := NormalWidth;
  if Round(ScaleCoef * SizeY) <= NormalHeight then
    grWave.Height := NormalHeight;
end;

procedure TMainForm.mmOpenClick(Sender: TObject);
begin
  tbOpenClick(Self);
end;

procedure TMainForm.mmStartClick(Sender: TObject);
begin
  tbStartClick(Self);
end;

procedure TMainForm.mmPauseClick(Sender: TObject);
begin
 tbPauseClick(Self);
end;

procedure TMainForm.mmRestartClick(Sender: TObject);
begin
  tbRestartClick(Self);
end;

procedure TMainForm.mmModeClick(Sender: TObject);
begin
  sbModeChooseClick(Self);
end;

procedure TMainForm.tbEditorClick(Sender: TObject);
begin
//вызов редактора
  DDEClientConv1.SetLink('MediumEditor','DDEServerConv1');
  DDEClientConv1.OpenLink;
{$IFDEF WRPROCESS}
  Writeln(PrFile, '');
  Writeln(PrFile, 'Link to editor is opened');
{$ENDIF}
//послать идентификатор (Handle) приложения для аддресации
//сообщений
  DdeClientConv1.ExecuteMacro(PChar(IntToStr(Application.Handle)),
    False);
//сохранить среду во временный файл
  RegionList.SaveToFile(TempFile);
  DdeClientConv1.ExecuteMacro('Restore', False);
  DdeClientConv1.ExecuteMacro('Load', False);
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Macros are sent');
{$ENDIF}
end;

procedure TMainForm.mmEditorClick(Sender: TObject);
begin
  tbEditorClick(Self);
end;

procedure TMainForm.tbSaveClick(Sender: TObject);
begin
  Save;
end;

procedure TMainForm.mmSaveClick(Sender: TObject);
begin
  tbSaveClick(Self);
end;

procedure TMainForm.mmSaveAllClick(Sender: TObject);
var
  TempSet: TDrawObjectsSet;
begin
  TempSet := Saving;
  Saving := [doWave, doComponents, doGraphics];
  Save;
  SaveFourierTime;
  Saving := TempSet;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
//если сохранение на активной странице, то переопределить
//объект для сохранения
  if PageControl1.ActivePage = WavePage  then
  begin
    if SaveOnActivePage then
      Saving := [doWave];
    if (ProcessState <> psStoped)and
      (doWave in DrawRecord.ObjectsSet) then
      DrawWave(True);
  end;
  if PageControl1.ActivePage = CompPage  then
  begin
    if SaveOnActivePage then
      Saving := [doComponents];
    if (ProcessState <> psStoped)and
      (doComponents in DrawRecord.ObjectsSet) then
      DrawComponents(True);
  end;
  if PageControl1.ActivePage = GrPage  then
  begin
    if SaveOnActivePage then
      Saving := [doGraphics];
    if (ProcessState <> psStoped)and
      (doGraphics in DrawRecord.ObjectsSet) then
      DrawGraphics(True);
  end;
end;

procedure TMainForm.mmAutoSaveClick(Sender: TObject);
begin
  with AutoSaveForm do
  begin
    OnSetup := UpdateSave;
    if ShowModal = mrOK then
    begin
      AutoSave := cbEnable.Checked;
      if AutoSave then
        AutoSaveTime := seTime.AsInteger;
    end;
  end;
end;

procedure TMainForm.mmDrawClick(Sender: TObject);
begin
  SetupForm.OnSave := ApplyOptions;
  if Loaded then UpdateOptions;
  Loaded := False;
  SetupForm.PageControl1.ActivePage := SetupForm.tsDraw;
  if SetupForm.ShowModal = mrOK then
    UpdateDraw;
end;

procedure TMainForm.mmSaveSetupClick(Sender: TObject);
begin
  SetupForm.OnSave := ApplyOptions;
  if Loaded then UpdateOptions;
  Loaded := False;
  SetupForm.PageControl1.ActivePage := SetupForm.tsSave;
  if SetupForm.ShowModal = mrOK then
    UpdateSave(Self);
end;

procedure TMainForm.grFourierTime1Paint(Sender: TObject);
begin
  grFourierTime1.GraphAll;
end;

procedure TMainForm.grFourierTime2Paint(Sender: TObject);
begin
  grFourierTime2.GraphAll;
end;

procedure TMainForm.tbFourieClick(Sender: TObject);
var
  Points1, Points2: TPoints;
begin
  if GrF1.Enable then
  begin
    Points1 := TPoints.Create;
    Points1.Assign(GPoints1);
    DoFFT(Points1);
    grFourierTime1.PointsList[0].Assign(Points1);
    grFourierTime1.Repaint;
    Points1.Free;
  end;
  if GrF2.Enable then
  begin
    Points2 := TPoints.Create;
    Points2.Assign(GPoints2);
    DoFFT(Points2);
    grFourierTime2.PointsList[0].Assign(Points2);
    grFourierTime2.Repaint;
    Points2.Free;
  end;
end;

procedure TMainForm.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.mmProgramClick(Sender: TObject);
begin
  SetupForm.OnSave := ApplyOptions;
  if Loaded then UpdateOptions;
  Loaded := False;
  SetupForm.PageControl1.ActivePage := SetupForm.tsProgram;
  if SetupForm.ShowModal = mrOK then
    UpdateProgram;
end;

procedure TMainForm.Splitter2Moved(Sender: TObject);
begin
  grFourierTime1.Height := ScrollBox8.Height - 4;
  grFourierTime2.Height := ScrollBox9.Height - 4;
  grFourierTime1.Repaint;
  grFourierTime2.Repaint;
end;

procedure TMainForm.seXGr1Change(Sender: TObject);
begin
  if seXGr1.Text <> '' then
  begin
    XGr1 := seXGr1.AsInteger;
    Image1.Left := XGr1 - 7;
  end;
end;

procedure TMainForm.seYGr1Change(Sender: TObject);
begin
  if seYGr1.Text <> '' then
  begin
    YGr1 := seYGr1.AsInteger;
    Image1.Top := YGr1 - 7;
  end;
end;

procedure TMainForm.seXGr2Change(Sender: TObject);
begin
  if seXGr2.Text <> '' then
  begin
    XGr2 := seXGr2.AsInteger;
    Image2.Left := XGr2 - 7;
  end;
end;

procedure TMainForm.seYGr2Change(Sender: TObject);
begin
  if seYGr2.Text <> '' then
  begin
    YGr2 := seYGr2.AsInteger;
    Image2.Top := YGr2 - 7;
  end;
end;

procedure TMainForm.grFourier2Paint(Sender: TObject);
begin
  grFourier1.Graph(0);
end;

procedure TMainForm.grFourier1Paint(Sender: TObject);
begin
  grFourier2.Graph(0);
end;

procedure TMainForm.seFourX1Change(Sender: TObject);
begin
  if seFourX1.Text <> '' then
  begin
    FourX1 := seFourX1.AsInteger;
    slFourX1.Value := FourX1;
  end;
end;

procedure TMainForm.seFourX2Change(Sender: TObject);
begin
  if seFourX2.Text <> '' then
  begin
    FourX2 := seFourX2.AsInteger;
    slFourX2.Value := FourX2;
  end;
end;

procedure TMainForm.cbFourField1Change(Sender: TObject);
begin
  FieldByIndex(cbFourField1.ItemIndex, FourierF1);
end;

procedure TMainForm.cbFourField2Change(Sender: TObject);
begin
  FieldByIndex(cbFourField2.ItemIndex, FourierF2);
end;

procedure TMainForm.slFourX1Change(Sender: TObject);
begin
  FourX1 := slFourX1.Value;
  seFourX1.AsInteger := FourX1;
end;

procedure TMainForm.slFourX2Change(Sender: TObject);
begin
  FourX2 := slFourX2.Value;
  seFourX2.AsInteger := FourX2;
end;

procedure TMainForm.bbIntFourieClick(Sender: TObject);
var
  MaxF, MinF, MaxB, MinB, MaxFreq: Integer;
begin
  FSForm.seToF.MaxValue := IntFPoints.Count * 2;
  if FSForm.seToF.Value > IntFPoints.Count then
    FSForm.seToF.Value := IntFPoints.Count * 2;
  FSForm.seToB.MaxValue := IntBPoints.Count * 2;
  if FSForm.seToB.Value > IntBPoints.Count then
    FSForm.seToB.Value := IntBPoints.Count * 2;

  if FSForm.ShowModal <> mrOK then
    Exit;
  if FSForm.rbAllF.Checked then
  begin
    MinF := 0;
    MaxF := IntFPoints.Count - 1;
  end
  else
  begin
    MinF := FSForm.seFromF.AsInteger div 2;
    MaxF := FSForm.seToF.AsInteger div 2 - 1;
  end;
  if FSForm.rbAllB.Checked then
  begin
    MinB := 0;
    MaxB := IntBPoints.Count - 1;
  end
  else
  begin
    MinB := FSForm.seFromB.AsInteger div 2;
    MaxB := FSForm.seToB.AsInteger div 2 - 1;
  end;

  if FSForm.rbMaxFreq.Checked then
    MaxFreq := FSForm.seMaxFreq.AsInteger
  else
    MaxFreq := -1;

  with TFIForm.Create(Application) do
  begin
    Draw(IntFPoints, IntBPoints, MinF, MaxF, MinB, MaxB,
      FSForm.cbWindowF.Checked, FSForm.cbWindowB.Checked, True, MaxFreq);
    Show;
  end;
end;

procedure TMainForm.bbIntPropClick(Sender: TObject);
const
  FieldsCount: Integer = 0;
var
  i: Integer;
begin
  with RegionList, IntPropForm do
  begin
    cbModes.Items.Clear;
    for i := 0 to FieldList.Count - 1 do
      if FieldList[i].FieldType = ftRectSelf then
      begin
        Inc(FieldsCount);
        cbModes.Items.Add(IntToStr(cbModes.Items.Count));
      end;

    if FieldsCount = 0 then
    begin
      ShowMessage('Нет собственных мод пластин');
      Exit;
    end;

    cbModes.ItemIndex := 0;
    if ShowModal = mrOk then
    begin
      SelfModeNumber := cbModes.ItemIndex;
    end;
  end;
end;

procedure TMainForm.spComp1MouseEnter(Sender: TObject);
begin
  MouseOnComp1 := True;
end;

procedure TMainForm.spComp2MouseEnter(Sender: TObject);
begin
  MouseOnComp2 := True;
end;

procedure TMainForm.spComp3MouseEnter(Sender: TObject);
begin
  MouseOnComp3 := True;
end;

procedure TMainForm.spComp4MouseEnter(Sender: TObject);
begin
  MouseOnComp4 := True;
end;

procedure TMainForm.spComp1MouseLeave(Sender: TObject);
begin
  MouseOnComp1 := False;
  StatusBar1.Panels[2].Text := '';
  StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.spComp2MouseLeave(Sender: TObject);
begin
  MouseOnComp2 := False;
  StatusBar1.Panels[2].Text := '';
  StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.spComp3MouseLeave(Sender: TObject);
begin
  MouseOnComp3 := False;
  StatusBar1.Panels[2].Text := '';
  StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.spComp4MouseLeave(Sender: TObject);
begin
  MouseOnComp4 := False;
  StatusBar1.Panels[2].Text := '';
  StatusBar1.Panels[3].Text := '';
end;

procedure TMainForm.spCompMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  XMouse := X;
  YMouse := Y;
  case CompCoord of
    ccVert :
      StatusBar1.Panels[2].Text := IntToStr(X) + ':' + IntToStr(FixY);
    ccHoriz :
      StatusBar1.Panels[2].Text := IntToStr(FixX) + ':' + IntToStr(Y);
  end;
end;

procedure TMainForm.cbGrField1Change(Sender: TObject);
begin
  FieldByIndex(cbGrField1.ItemIndex, GrF1);
  spGraph1.LeftAxis.SetMinMax(-1.5 * GetMaxValue(GrF1.FieldType),
    1.5 * GetMaxValue(GrF1.FieldType));
end;

procedure TMainForm.cbGrField2Change(Sender: TObject);
begin
  FieldByIndex(cbGrField2.ItemIndex, GrF2);
  spGraph2.LeftAxis.SetMinMax(-1.5 * GetMaxValue(GrF2.FieldType),
    1.5 * GetMaxValue(GrF2.FieldType));
end;

procedure TMainForm.spIntegralMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  StatusBar1.Panels[2].Text := IntToStr(Round(
    TXYPlot(Sender).BottomAxis.P2V(X)));
end;

procedure TMainForm.spIntegralMouseLeave(Sender: TObject);
begin
  StatusBar1.Panels[2].Text := '';
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
var
  MaxF, MinF, MaxB, MinB, MaxFreq: Integer;
begin
  FSForm.seToF.MaxValue := GPoints1.Count * 2;
  if FSForm.seToF.Value > GPoints1.Count then
    FSForm.seToF.Value := GPoints1.Count * 2;
  FSForm.seToB.MaxValue := GPoints2.Count * 2;
  if FSForm.seToB.Value > GPoints2.Count then
    FSForm.seToB.Value := GPoints2.Count * 2;

  if FSForm.ShowModal <> mrOK then
    Exit;
  if FSForm.rbAllF.Checked then
  begin
    MinF := 0;
    MaxF := GPoints1.Count - 1;
  end
  else
  begin
    MinF := FSForm.seFromF.AsInteger div 2;
    MaxF := FSForm.seToF.AsInteger div 2 - 1;
  end;
  if FSForm.rbAllB.Checked then
  begin
    MinB := 0;
    MaxB := GPoints2.Count - 1;
  end
  else
  begin
    MinB := FSForm.seFromB.AsInteger div 2;
    MaxB := FSForm.seToB.AsInteger div 2 - 1;
  end;

  if FSForm.rbMaxFreq.Checked then
    MaxFreq := FSForm.seMaxFreq.AsInteger
  else
    MaxFreq := -1;

  with TFIForm.Create(Application) do
  begin
    Draw(GPoints1, GPoints2, MinF, MaxF, MinB, MaxB,
      FSForm.cbWindowF.Checked, FSForm.cbWindowB.Checked, False, MaxFreq);
    Show;
  end;
end;

end.
