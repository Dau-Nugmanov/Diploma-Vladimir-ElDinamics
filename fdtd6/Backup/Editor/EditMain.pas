unit EditMain;

{Оновной модуль}

{$D+}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls, Regions, ToolWin, ComCtrls, ImgList, Parametrs,
  SysParam, Menus, EditReg, DdeMan, Registry, EditMess, MesFUnit, VclUtils,
  FParUnit, Math, ExtMath, AlForm, PhisCnst, ColorUnit, DesFUnit, ObjFUnit;

type
  TForm1 = class(TForm)
    ControlBar1: TControlBar;
    ToolBar1: TToolBar;
    Panel1: TPanel;
    tbNew: TToolButton;
    tbOpen: TToolButton;
    tbSave: TToolButton;
    ImageList1: TImageList;
    DrawPanel: TPanel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    PopupMenu1: TPopupMenu;
    pmDelete: TMenuItem;
    pmProp: TMenuItem;
    sbParam: TSpeedButton;
    DdeServerConv1: TDdeServerConv;
    DdeServerItem1: TDdeServerItem;
    PageControl1: TPageControl;
    ObjectsPage: TTabSheet;
    FieldPage: TTabSheet;
    sbSelect: TSpeedButton;
    sbVacuum: TSpeedButton;
    sbMetall: TSpeedButton;
    sbRect: TSpeedButton;
    sbCircle: TSpeedButton;
    sbDielectr: TSpeedButton;
    sbEllipse: TSpeedButton;
    sbHSpace: TSpeedButton;
    sbClearObjects: TSpeedButton;
    sbSelect2: TSpeedButton;
    sbSin: TSpeedButton;
    sbGauss: TSpeedButton;
    sbRectSelf: TSpeedButton;
    sbClearField: TSpeedButton;
    N1: TMenuItem;
    pmAlign: TMenuItem;
    N3: TMenuItem;
    sbHoriz: TScrollBar;
    sbVert: TScrollBar;
    sbObjects: TSpeedButton;
    SpeedButton1: TSpeedButton;
    PopupMenu2: TPopupMenu;
    pmFDelete: TMenuItem;
    pmFProp: TMenuItem;
    N2: TMenuItem;
    sbRectSelf2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure sbSelectClick(Sender: TObject);
    procedure sbRectClick(Sender: TObject);
    procedure sbCircleClick(Sender: TObject);
    procedure sbEllipseClick(Sender: TObject);
    procedure sbHSpaceClick(Sender: TObject);
    procedure sbVacuumClick(Sender: TObject);
    procedure sbMetallClick(Sender: TObject);
    procedure sbDielectrClick(Sender: TObject);
    procedure DrawPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbOpenClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure DrawPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure sbClearObjectsClick(Sender: TObject);
    procedure tbNewClick(Sender: TObject);
    procedure pmDeleteClick(Sender: TObject);
    procedure sbParamClick(Sender: TObject);
    procedure pmPropClick(Sender: TObject);
    procedure DdeServerConv1Open(Sender: TObject);
    procedure DdeServerConv1ExecuteMacro(Sender: TObject; Msg: TStrings);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure sbSinClick(Sender: TObject);
    procedure sbGaussClick(Sender: TObject);
    procedure sbRectSelfClick(Sender: TObject);
    procedure sbClearFieldClick(Sender: TObject);
    procedure pmAlignClick(Sender: TObject);
    procedure sbVertChange(Sender: TObject);
    procedure sbHorizChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure pmFDeleteClick(Sender: TObject);
    procedure sbObjectsClick(Sender: TObject);
    procedure pmFPropClick(Sender: TObject);
    procedure sbRectSelf2Click(Sender: TObject);
  private
    { Private declarations }
    TempRegion: TRegion;
    TempField: TField2;
    CanCreate: Boolean;
    BeginClick: Boolean;
    Modified: Boolean;
    WorkFileName: string;
    Path: string;
    ClientHandle: THandle;
    RunByClient: Boolean;
    procedure MediumUpdate;
    procedure MoveThroughShape(Sender: TObject; X, Y: Integer);
    procedure DownOnShape(Sender: TObject; X, Y: Integer);
    procedure UpOnShape(Sender: TObject; X, Y: Integer);
    procedure LoadFromFile(const FileName: string);
    function NewFileName: string;
    procedure UpdateCaption;
    procedure SetSinWave(X, Y: Integer);
    procedure SetGaussWave(X, Y: Integer);
    procedure SetRectSelfWave;
    procedure SetRectSelfWave2;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.UpdateCaption;
var
  ExtStr: string;
begin
//обновить заголовок
  if RunByClient then
    ExtStr := 'Called by FDTD'
  else
    ExtStr := ExtractFileName(WorkFileName);
  Caption := 'Medium Editor - ' + ExtStr;
end;

function TForm1.NewFileName;
var
  Count: Integer;
begin
//новое имя файла
  Count := 0;
  repeat
    Inc(Count);
    Result := 'Medium' + IntToStr(Count) + '.mdm';
  until not FileExists(Result);
end;

procedure TForm1.LoadFromFile;
var
  i: Integer;
begin
//загтузить среду из файла
  if not(ShapeList.LoadFromFile(DrawPanel, FileName)) then
  begin
    raise Exception.Create('Can' + '''' + 't load file: ' + FileName);
    Exit;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Medium is loaded');
{$ENDIF}
  if ShapeList.Count <> 0 then
    for i := 0 to ShapeList.Count - 1 do
      ShapeList[i].Menu := PopupMenu1;
  if ShapeList.FieldList.Count <> 0 then
    for i := 0 to ShapeList.FieldList.Count - 1 do
      ShapeList.FieldList[i].Menu := PopupMenu2;
  MediumUpdate;

  if not RunByClient then
    WorkFileName := FileName;
  Modified := RunByClient;
  UpdateCaption;
end;

procedure TForm1.MediumUpdate;
begin
//обновить компоненты после изменения среды
  DrawPanel.Left := 150;
  DrawPanel.Top := 30;
  DrawPanel.Width := RegionList.SizeOfX;
  DrawPanel.Height := RegionList.SizeOfY;
  sbHoriz.Visible := DrawPanel.Width > 395;
  sbVert.Visible := DrawPanel.Height > 297;
  sbHoriz.Max := (DrawPanel.Width - 395) * Ord(sbHoriz.Visible);
  sbVert.Max := (DrawPanel.Height - 297) * Ord(sbVert.Visible);
  sbHoriz.Position := 0;
  sbVert.Position := 0;
  case RegionList.BoundsType of
    btMetall : StatusBar1.Panels[0].Text := 'Металл';
    btAbsorb : StatusBar1.Panels[0].Text := 'Поглощающие слои';
  end;
  StatusBar1.Panels[1].Text := IntToStr(RegionList.SizeOfX) + ':'
    + IntToStr(RegionList.SizeOfY);
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Medium is updated');
{$ENDIF}
end;

procedure TForm1.SetSinWave(X, Y: Integer);
begin
  with FieldParamForm do
  begin
    Field := TempField;

    Changing := True;
    Notebook1.PageIndex := 0;
    lbExpX.Visible := False;
    lbExpY.Visible := False;
    seExpX.Visible := False;
    seExpY.Visible := False;
    seStartXS.Value := X;
    seStartY.Value := 0;
    if (X + 60) < RegionList.SizeOfX - 1 then
      seEndXS.Value := X + 60
    else
      seEndXS.Value := RegionList.SizeOfX - 1;
    seEndY.Value := RegionList.SizeOfY - 1;
    Changing := False;
    seEndXSChange(Self);

    if ShowModal = mrOK then
    begin
      Modified := True;

      TSinField(TempField).SetField(seEndXS.AsInteger -
         seStartXS.AsInteger, seEndY.AsInteger -
         seStartY.AsInteger, seStartXS.AsInteger,
         seStartY.AsInteger, seHalfXS.AsInteger,
         seHalfY.AsInteger);

      ShapeList.FieldList.Add(DrawPanel, TempField);
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].OnParentMove :=
        MoveThroughShape;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Menu :=
        PopupMenu2;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Repaint;
    end;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Sinusoidal wave is added');
{$ENDIF}
end;

procedure TForm1.SetGaussWave(X, Y: Integer);
begin
  with FieldParamForm do
  begin
    Field := TempField;

    Changing := True;
    Notebook1.PageIndex := 0;
    lbExpX.Visible := True;
    lbExpY.Visible := True;
    seExpX.Visible := True;
    seExpY.Visible := True;
    seStartXS.Value := X;
    seStartY.Value := 0;
    if (X + 60) < RegionList.SizeOfX - 1 then
      seEndXS.Value := X + 60
    else
      seEndXS.Value := RegionList.SizeOfX - 1;
    seEndY.Value := RegionList.SizeOfY - 1;
    Changing := False;
    seEndXSChange(Self);

    if ShowModal = mrOK then
    begin
      Modified := True;

      TGaussField(TempField).SetField(seEndXS.AsInteger -
         seStartXS.AsInteger, seEndY.AsInteger -
         seStartY.AsInteger, seStartXS.AsInteger,
         seStartY.AsInteger, seHalfXS.AsInteger,
         seHalfY.AsInteger, seExpX.Value, seExpY.Value);

      ShapeList.FieldList.Add(DrawPanel, TempField);
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].OnParentMove :=
        MoveThroughShape;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Menu :=
        PopupMenu2;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Repaint;
    end;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Gauss wave is added');
{$ENDIF}
end;

procedure TForm1.SetRectSelfWave;
var
  i: Integer;
begin
  if RegionList.RectNum = 0 then
  begin
    ShowMessage('Нет плоских диэлектриков');
    Exit;
  end;

  with FieldParamForm do
  begin
    Field := TempField;

    Changing := True;
    Notebook1.PageIndex := 1;
    cbRectList.Items.Clear;
    for i := 0 to RegionList.RectNum - 1 do
      cbRectList.Items.Add(IntToStr(i));
    cbRectList.ItemIndex := 0;
    seStartXR.Value := RegionList.Rects[0].Figure.CoordX;
    seEndXR.Value := RegionList.Rects[0].Figure.CoordX
      + TRect(RegionList.Rects[0].Figure).HorSize;
    Changing := False;
    seEndXRChange(Self);

    if ShowModal = mrOK then
    begin
      Modified := True;

      TRectSelfField(TempField).SetField(seEndXR.AsInteger -
        seStartXR.AsInteger, RegionList.SizeOfY - 1, seStartXR.AsInteger, 0,
        seHalfXR.AsInteger, 0, RegionList.Rects[cbRectList.ItemIndex],
        seModeNumber.AsInteger);

      ShapeList.FieldList.Add(DrawPanel, TempField);
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].OnParentMove :=
        MoveThroughShape;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Menu :=
        PopupMenu2;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Repaint
    end;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Self-slab wave is added');
{$ENDIF}
end;

procedure TForm1.SetRectSelfWave2;
var
  i: Integer;
begin
  if RegionList.RectNum = 0 then
  begin
    ShowMessage('Нет плоских диэлектриков');
    Exit;
  end;

  with FieldParamForm do
  begin
    Field := TempField;

    Changing := True;
    Notebook1.PageIndex := 1;
    cbRectList.Items.Clear;
    for i := 0 to RegionList.RectNum - 1 do
      cbRectList.Items.Add(IntToStr(i));
    cbRectList.ItemIndex := 0;
    seStartXR.Value := RegionList.Rects[0].Figure.CoordX;
    seEndXR.Value := RegionList.Rects[0].Figure.CoordX
      + TRect(RegionList.Rects[0].Figure).HorSize;
    Changing := False;
    seEndXRChange(Self);

    lbQ.Visible := True;
    lbP.Visible := True;
    seQ.Visible := True;
    seP.Visible := True;

    if ShowModal = mrOK then
    begin
      Modified := True;

      TRectSelfField2(TempField).SetField(seEndXR.AsInteger -
        seStartXR.AsInteger, RegionList.SizeOfY - 1, seStartXR.AsInteger, 0,
        seHalfXR.AsInteger, 0, RegionList.Rects[cbRectList.ItemIndex],
        seModeNumber.AsInteger, seP.Value, seQ.Value);

      ShapeList.FieldList.Add(DrawPanel, TempField);
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].OnParentMove :=
        MoveThroughShape;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Menu :=
        PopupMenu2;
      ShapeList.FieldList[ShapeList.FieldList.Count - 1].Repaint
    end;

    lbQ.Visible := False;
    lbP.Visible := False;
    seQ.Visible := False;
    seP.Visible := False;
  end;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Self-slab wave is added');
{$ENDIF}
end;

procedure TForm1.MoveThroughShape;
var
  Shift: TShiftState;
begin
  DrawPanelMouseMove(Sender, Shift, X, Y);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  FileName: string;
  i: Integer;
begin
{$IFDEF WRPROCESS}
  AssignFile(PrFile, 'EditProc.txt');
  Rewrite(PrFile);
  Writeln(PrFile, 'Creating of main form');
{$ENDIF}
  GetDir(0, Path);
  RegionList := TRegionList.Create;
  ShapeList := TShapeList.Create;
  TempRegion := TRegion.Create;
  TempField := TSinField.Create;
  ShapeList.ActiveOnMove := False;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Objects are created');
{$ENDIF}
//начальная настройка компонент
  PageControl1.ActivePage := ObjectsPage;
  CanCreate := True;
  BeginClick := False;
  sbRectClick(Self);
  sbDielectrClick(Self);
  MediumUpdate;
//присвоить события
  ShapeList.OnParentMove := MoveThroughShape;
  ShapeList.OnParentDown := DownOnShape;
  ShapeList.OnParentUp := UpOnShape;

  WorkFileName := NewFileName;
  RunByClient := False;
//проверить наличие праметров при запуске
  if ParamCount <> 0 then
  begin
    FileName := ParamStr(1);
    for i := 2 to ParamCount do
      FileName := FileName + ' ' + ParamStr(i);
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Reading parameters');
{$ENDIF}
    LoadFromFile(FileName);
  end;
  OpenDialog1.InitialDir := MainPath + 'Mediums\';
  SaveDialog1.InitialDir := MainPath + 'Mediums\';

  UpdateCaption;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Finish form creating');
{$ENDIF}
end;

procedure TForm1.sbSelectClick(Sender: TObject);
begin
  ShapeList.ActiveOnMove := True;
  CanCreate := False;
  sbSelect.Down := True;
  sbSelect2.Down := True;
end;

procedure TForm1.sbRectClick(Sender: TObject);
begin
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect2.Down then
    sbSin.Down := True;
  TempRegion.CreateFigure(shRect);
  TRect(TempRegion.Figure).HorSize := 50;
  TRect(TempRegion.Figure).VertSize := 30;
  if Assigned(ParamForm) then
    ParamForm.Notebook1.ActivePage := 'RectPage';
end;

procedure TForm1.sbCircleClick(Sender: TObject);
begin
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect2.Down then
    sbSin.Down := True;
  TempRegion.CreateFigure(shCircle);
  TCircle(TempRegion.Figure).Radius := 30;
  ParamForm.Notebook1.ActivePage := 'CirclePage';
end;

procedure TForm1.sbEllipseClick(Sender: TObject);
begin
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect2.Down then
    sbSin.Down := True;
  TempRegion.CreateFigure(shEllipse);
  TEllipse(TempRegion.Figure).HorAxel := 50;
  TEllipse(TempRegion.Figure).VertAxel := 30;
  ParamForm.Notebook1.ActivePage := 'EllipsePage';
end;

procedure TForm1.sbHSpaceClick(Sender: TObject);
begin
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect2.Down then
    sbSin.Down := True;
  TempRegion.CreateFigure(shHalfSpace);
  THalfSpace(TempRegion.Figure).Orientation := orLeft;
  ParamForm.Notebook1.ActivePage := 'HSpacePage';
end;

procedure TForm1.sbVacuumClick(Sender: TObject);
begin
  TempRegion.MatterType := mtVacuum;
  ParamForm.seEps.Value := 1;
  ParamForm.seEps.Visible := False;
  ParamForm.seEps2.Value := 1;
  ParamForm.seEps2.Visible := False;
  ParamForm.lbEps.Visible := False;
  ParamForm.lbEps2.Visible := False;
  ParamForm.lbEps3.Visible := False;
end;

procedure TForm1.sbMetallClick(Sender: TObject);
begin
  TempRegion.MatterType := mtMetall;
  ParamForm.seEps.Value := 0;
  ParamForm.seEps.Visible := False;
  ParamForm.seEps2.Value := 0;
  ParamForm.seEps2.Visible := False;
  ParamForm.lbEps.Visible := False;
  ParamForm.lbEps2.Visible := False;
  ParamForm.lbEps3.Visible := False;
end;

procedure TForm1.sbDielectrClick(Sender: TObject);
begin
  TempRegion.MatterType := mtDielectr;
  if Assigned(ParamForm) then
  begin
    ParamForm.seEps.Value := 2;
    ParamForm.seEps.Visible := True;
    ParamForm.seEps2.Value := 0;
    ParamForm.seEps2.Visible := True;
    ParamForm.lbEps.Visible := True;
    ParamForm.lbEps2.Visible := True;
    ParamForm.lbEps3.Visible := True;
  end;
end;

procedure TForm1.DrawPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then BeginClick := True;
end;

procedure TForm1.DrawPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//создание нового объекта или поля
  if BeginClick and CanCreate then
  begin
//объект
    if PageControl1.ActivePage = ObjectsPage then
      if ParamForm.ShowModal = mrOK then
        with TempRegion do
        begin
{$IFDEF WRPROCESS}
          Writeln(PrFile, 'Adding region');
{$ENDIF}

          Modified := True;

          Figure.CoordX := X;
          Figure.CoordY := Y;

          case Figure.Shape of
            shRect :
            begin
              TRect(Figure).HorSize := ParamForm.seHorSize.AsInteger;
              TRect(Figure).VertSize := ParamForm.seVertSize.AsInteger;
{$IFDEF WRPROCESS}
              Writeln(PrFile, 'Rectangle is added');
{$ENDIF}
            end;
            shCircle :
            begin
              TCircle(Figure).Radius := ParamForm.seRadius.AsInteger;
{$IFDEF WRPROCESS}
              Writeln(PrFile, 'Circle is added');
{$ENDIF}
            end;
            shEllipse :
            begin
              TEllipse(Figure).HorAxel := ParamForm.seHorAxel.AsInteger;
              TEllipse(Figure).VertAxel := ParamForm.seVertAxel.AsInteger;
{$IFDEF WRPROCESS}
              Writeln(PrFile, 'Ellipse is added');
{$ENDIF}
            end;
            shHalfSpace :
            begin
              with THalfSpace(Figure) do
                case ParamForm.cbOrientation.ItemIndex of
                  0 : Orientation := orLeft;
                  1 : Orientation := orRight;
                  2 : Orientation := orTop;
                  3 : Orientation := orBottom;
                end;
{$IFDEF WRPROCESS}
              Writeln(PrFile, 'Halfspace is added');
{$ENDIF}
            end;
          end;

          Eps := ParamForm.seEps.Value;
          Eps2 := ParamForm.seEps2.Value;

          ShapeList.Add(DrawPanel, TempRegion);
          ShapeList[ShapeList.Count-1].Menu := PopupMenu1;
        end;

//поле
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Adding field');
{$ENDIF}
    if PageControl1.ActivePage = FieldPage then
      case TempField.FieldType of
        ftSin       : SetSinWave(X, Y);
        ftGauss     : SetGaussWave(X, Y);
        ftRectSelf  : SetRectSelfWave;
        ftRectSelf2 : SetRectSelfWave2;
      end;
  end;

  BeginClick := False;
end;

procedure TForm1.tbOpenClick(Sender: TObject);
var
  Name: string;
begin
  if Modified then
  begin
    if RunByClient then
      Name := NewFileName
    else
      Name := ExtractFileName(WorkFileName);
    case MessForm.AskForSave(Name) of
      mrYes    : tbSave.Click;
      mrCancel : Exit;
    end;
  end;
  if OpenDialog1.Execute then
    LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.tbSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    if RunByClient and (SaveDialog1.FileName = TempFile) then
      raise Exception.Create('Файл ' + ExtractFileName(TempFile)
        + ' необходим для правильной работы программы');
    ShapeList.SaveToFile(SaveDialog1.FileName);
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Saving of a medium');
{$ENDIF}
    if not RunByClient then
    begin
      WorkFileName := SaveDialog1.FileName;
      Modified := False;
    end;
    UpdateCaption;
  end;
end;

procedure TForm1.DrawPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  StatusBar1.Panels[2].Text := IntToStr(X) + ':'
    + IntToStr(Y);
end;

procedure TForm1.sbClearObjectsClick(Sender: TObject);
begin
  ShapeList.Clear;
  Modified := True;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'All regions have been deleted');
{$ENDIF}
end;

procedure TForm1.tbNewClick(Sender: TObject);
var
  FileName: string;
begin
  if RunByClient then
    FileName := NewFileName
  else
    FileName := WorkFileName;
  if Modified then
    case MessForm.AskForSave(ExtractFileName(FileName)) of
      mrYes    : tbSave.Click;
      mrCancel : Exit;
    end;

  if SystemForm.ShowModal = mrOK then
  begin
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Creating new medium');
{$ENDIF}
    RegionList.SizeOfX := SystemForm.seSizeOfX.AsInteger;
    RegionList.SizeOfY := SystemForm.seSizeOfY.AsInteger;
    RegionList.DelX := SystemForm.seDelX.Value * 1e-6;
    RegionList.DelY := SystemForm.seDelY.Value * 1e-6;
    RegionList.DelT := SystemForm.seDelT.Value * RegionList.DelX / C;
    RegionList.Eps := SystemForm.seEps.Value;
    case SystemForm.rgBounds.ItemIndex of
      0 : RegionList.BoundsType := btMetall;
      1 :
      begin
        RegionList.BoundsType := btAbsorb;
        RegionList.BoundsWidth := SystemForm.seWidth.AsInteger;
        RegionList.Sigma := SystemForm.seSigma.Value * Eps0 / RegionList.DelT;
        RegionList.CoefG := SystemForm.seCoefG.Value;
      end;
    end;
    RegionList.Describ := '';
    ShapeList.Clear;
    ShapeList.FieldList.Clear;
    MediumUpdate;
    Modified := True;
    WorkFileName := NewFileName;
    UpdateCaption;
  end;
end;

procedure TForm1.pmDeleteClick(Sender: TObject);
var
  Region: TShapeRegion;
begin
  Region := TShapeRegion(PopupMenu1.PopupComponent);
  ShapeList.Delete(ShapeList.IndexOf(Region));
  Modified := True;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Deleting of a region');
{$ENDIF}
end;

procedure TForm1.sbParamClick(Sender: TObject);
begin
//изменение параметров системы
  with SystemForm do
  begin
    seSizeOfX.Value := RegionList.SizeOfX;
    seSizeOfY.Value := RegionList.SizeOfY;
    seDelX.Value := RegionList.DelX * 1e6;
    seDelY.Value := RegionList.DelY * 1e6;
    seDelT.Value := RegionList.DelT / RegionList.DelX * C;
    seEps.Value := RegionList.Eps;
    if RegionList.BoundsType = btAbsorb then
    begin
      seSigma.Value := {1e14 * }RegionList.Sigma / Eps0 * RegionList.DelT;
      seWidth.Value := RegionList.BoundsWidth;
      seCoefG.Value := RegionList.CoefG;
    end;
    rgBounds.ItemIndex := Ord(RegionList.BoundsType);
    BoundsClick;
  end;
  if SystemForm.ShowModal = mrOK then
  begin
//обновить параметры
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Mediums properties have been changed');
{$ENDIF}
    Modified := True;

    RegionList.SizeOfX := SystemForm.seSizeOfX.AsInteger;
    RegionList.SizeOfY := SystemForm.seSizeOfY.AsInteger;
    RegionList.DelX := SystemForm.seDelX.Value * 1e-6;
    RegionList.DelY := SystemForm.seDelY.Value * 1e-6;
    RegionList.DelT := SystemForm.seDelT.Value * RegionList.DelX / C;
    RegionList.Eps := SystemForm.seEps.Value;
    case SystemForm.rgBounds.ItemIndex of
      0 : RegionList.BoundsType := btMetall;
      1 :
      begin
        RegionList.BoundsType := btAbsorb;
        RegionList.BoundsWidth := SystemForm.seWidth.AsInteger;
        RegionList.Sigma := SystemForm.seSigma.Value{ * 1e-14} * Eps0 / RegionList.DelT;
        RegionList.CoefG := SystemForm.seCoefG.Value;
      end;
    end;
    MediumUpdate;
  end;
end;

procedure TForm1.DownOnShape(Sender: TObject; X, Y: Integer);
{var
  Shift: TShiftState;}
begin
{  DrawPanelMouseDown(Self, mbLeft, Shift, X, Y);}
end;

procedure TForm1.UpOnShape(Sender: TObject; X, Y: Integer);
{var
  Shift: TShiftState;}
begin
{  DrawPanelMouseUp(Self, mbLeft, Shift, X, Y);}
end;

procedure TForm1.pmPropClick(Sender: TObject);
var
  Region: TRegion;
begin
//редактирование объекта
  Region := TRegion.Create;
  Region.Assign((PopupMenu1.PopupComponent as TShapeRegion).Region);

  with EditForm do
  begin
    AssignParams(Region);

    if ShowModal = mrOK then
    begin
//обновление
      Modified := True;

      AssignRegion(Region);
      (PopupMenu1.PopupComponent as TShapeRegion).UpdateRegion(Region);
    end;
  end;
  Region.Free;
end;

procedure TForm1.DdeServerConv1Open(Sender: TObject);
begin
//вызов другим приложением
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Called by FDTD');
{$ENDIF}
{  Application.Restore;
  Application.BringToFront;}
  RunByClient := True;
end;

procedure TForm1.DdeServerConv1ExecuteMacro(Sender: TObject;
  Msg: TStrings);
var
  MsgText: string;
begin
//получена команда
  MsgText := Msg.Strings[0];

  if MsgText = 'Restore' then
  begin
//развернуть
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Restore  macro is recieved');
{$ENDIF}
    Application.Restore;
    Application.BringToFront;
    FormStyle := fsNormal;
    Show;
    Exit;
  end;

  if (MsgText[1] > '0') and (MsgText[1] < '9') then
  begin
//идентификатор (Handle) вызвавшего приложения
{$IFDEF WRPROCESS}
    Writeln(PrFile, 'Handle macro is recieved');
{$ENDIF}
    ClientHandle := StrToInt(MsgText);
    Exit;
  end;

//имя обрабатываемого файла
  WorkFileName := TempFile;

  LoadFromFile(WorkFileName);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  FileName: string;
begin
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Trying to close form');
{$ENDIF}
  if RunByClient then
    FileName := 'среде'
  else
    FileName := ExtractFileName(WorkFileName);

  if Modified then
    case MessForm.AskForSave(FileName) of
      mrYes :
        if RunByClient then
        begin
//отослать подтверждение
{$IFDEF WRPROCESS}
          Writeln(PrFile, 'Sending "Apply" to FDTD');
{$ENDIF}
          ShapeList.SaveToFile(TempFile);
          SendApply(ClientHandle);
//вызвавшее приложение должно успеть закрыть связь до того, как
//редактор будет закрыт, поэтому подождать
          Delay(500);
        end
        else
          tbSave.Click;
      mrNo :
        if RunByClient then
        begin
//отослать отмену
{$IFDEF WRPROCESS}
          Writeln(PrFile, 'Sending "Cancel" to FDTD');
{$ENDIF}
          SendCancel(ClientHandle);
          Delay(500);
        end;
      mrCancel :
      begin
        CanClose := False;
        Exit;
      end;
     end
  else
    if RunByClient then
    begin
      SendNoChanges(ClientHandle);
      Delay(500);
    end;

{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Dstroying of objects');
{$ENDIF}
  ShapeList.Free;
  RegionList.Free;
  TempRegion.Free;
  TempField.Free;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Finish of the application');
  CloseFile(PrFile);
{$ENDIF}
end;

procedure TForm1.sbSinClick(Sender: TObject);
begin
  TempField.Free;
  TempField := TSinField.Create;
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect.Down then
    sbRect.Down := True;
end;

procedure TForm1.sbGaussClick(Sender: TObject);
begin
  TempField.Free;
  TempField := TGaussField.Create;
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect.Down then
    sbRect.Down := True;
end;

procedure TForm1.sbRectSelfClick(Sender: TObject);
begin
  TempField.Free;
  TempField := TRectSelfField.Create;
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect.Down then
    sbRect.Down := True;
end;

procedure TForm1.sbClearFieldClick(Sender: TObject);
begin
  ShapeList.FieldList.Clear;
  Modified := True;
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Deleting of all fields');
{$ENDIF}
end;

procedure TForm1.pmAlignClick(Sender: TObject);
begin
  AlignForm.rgVertAlign.ItemIndex := 3;
  AlignForm.rgHorAlign.ItemIndex := 3;
  if AlignForm.ShowModal = mrOK then
    ShapeList.Align(
      ShapeList.IndexOf(TShapeRegion(PopupMenu1.PopupComponent)),
      THorAlign(AlignForm.rgHorAlign.ItemIndex),
      TVertAlign(AlignForm.rgVertAlign.ItemIndex));
end;

procedure TForm1.sbVertChange(Sender: TObject);
begin
  DrawPanel.Top := 30 - sbVert.Position;
end;

procedure TForm1.sbHorizChange(Sender: TObject);
begin
  DrawPanel.Left := 150 - sbHoriz.Position;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  with DescrForm do
  begin
    Memo1.Text := RegionList.Describ;
    if ShowModal = mrOK then
      RegionList.Describ := Memo1.Text;
  end;
end;

procedure TForm1.pmFDeleteClick(Sender: TObject);
var
  Field: TShapeField;
begin
  Field := TShapeField(PopupMenu2.PopupComponent);
  ShapeList.FieldList.Delete(ShapeList.FieldList.IndexOf(Field));
  Modified := True;
end;

procedure TForm1.sbObjectsClick(Sender: TObject);
begin
  ObjForm.ShowModal;
end;

procedure TForm1.pmFPropClick(Sender: TObject);
begin
  with FieldParamForm do
  begin
    Field := (PopupMenu2.PopupComponent as TShapeField).Field;
  end;
end;

procedure TForm1.sbRectSelf2Click(Sender: TObject);
begin
  TempField.Free;
  TempField := TRectSelfField2.Create;
  ShapeList.ActiveOnMove := False;
  CanCreate := True;
  if sbSelect.Down then
    sbRect.Down := True;
end;

end.
