unit EditReg;

{Диалог редактирования объекта}

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RXSpin, Buttons, Regions;

type
  TEditForm = class(TForm)
    rgGeometry: TRadioGroup;
    rgMatter: TRadioGroup;
    Label1: TLabel;
    Label2: TLabel;
    seCoordX: TRxSpinEdit;
    seCoordY: TRxSpinEdit;
    Notebook1: TNotebook;
    Label3: TLabel;
    Label4: TLabel;
    seHorSize: TRxSpinEdit;
    seVertSize: TRxSpinEdit;
    Label5: TLabel;
    seRadius: TRxSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    seVertAxel: TRxSpinEdit;
    seHorAxel: TRxSpinEdit;
    Label8: TLabel;
    cbOrientation: TComboBox;
    lbEps: TLabel;
    seEps: TRxSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    seEps2: TRxSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    procedure rgGeometryClick(Sender: TObject);
    procedure rgMatterClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure AssignParams(Region: TRegion);
    procedure AssignRegion(Region: TRegion);
  end;

var
  EditForm: TEditForm;

implementation

{$R *.DFM}

procedure TEditForm.AssignParams(Region: TRegion);
begin
  seCoordX.Value := Region.Figure.CoordX;
  seCoordY.Value := Region.Figure.CoordY;
  case Region.Figure.Shape of
    shRect :
    begin
      rgGeometry.ItemIndex := 0;
      seHorSize.Value := TRect(Region.Figure).HorSize;
      seVertSize.Value := TRect(Region.Figure).VertSize;
    end;
    shCircle :
    begin
      rgGeometry.ItemIndex := 1;
      seRadius.Value := TCircle(Region.Figure).Radius;
    end;
    shEllipse :
    begin
      rgGeometry.ItemIndex := 2;
      seHorAxel.Value := TEllipse(Region.Figure).HorAxel;
      seVertAxel.Value := TEllipse(Region.Figure).VertAxel;
    end;
    shHalfSpace :
    begin
      rgGeometry.ItemIndex := 3;
      cbOrientation.ItemIndex := Ord(THalfSpace(Region.Figure).Orientation);
    end;
  end;

  seEps.Enabled := False;
  seEps2.Enabled := False;
  case Region.MatterType of
    mtVacuum   : rgMatter.ItemIndex := 0;
    mtMetall   : rgMatter.ItemIndex := 1;
    mtDielectr :
    begin
      rgMatter.ItemIndex := 2;
      seEps.Enabled := True;
      seEps2.Enabled := True;
    end;
  end;

  seEps.Value := Region.Eps;
  seEps2.Value := Region.Eps2;
end;

procedure TEditForm.AssignRegion(Region: TRegion);
begin
  case rgGeometry.ItemIndex of
    0 :
    begin
      Region.CreateFigure(shRect);
      TRect(Region.Figure).HorSize := seHorSize.AsInteger;
      TRect(Region.Figure).VertSize := seVertSize.AsInteger;
    end;
    1 :
    begin
      Region.CreateFigure(shCircle);
      TCircle(Region.Figure).Radius := seRadius.AsInteger;
    end;
    2 :
    begin
      Region.CreateFigure(shEllipse);
      TEllipse(Region.Figure).HorAxel := seHorAxel.AsInteger;
      TEllipse(Region.Figure).VertAxel := seVertAxel.AsInteger;
    end;
    3 :
    begin
      Region.CreateFigure(shHalfSpace);
      with THalfSpace(Region.Figure) do
        case cbOrientation.ItemIndex of
          0 : Orientation := orLeft;
          1 : Orientation := orRight;
          2 : Orientation := orTop;
          3 : Orientation := orBottom;
        end;
    end;
  end;

  Region.Figure.CoordX := seCoordX.AsInteger;
  Region.Figure.CoordY := seCoordY.AsInteger;

{  case rgMatter.ItemIndex of
    0 : Region.MatterType := mtVacuum;
    1 : Region.MatterType := mtMetall;
    2 :
    begin
      Region.MatterType := mtDielectr;
      Region.Eps := seEps.Value;
    end;
  end;}
  Region.Eps := seEps.Value;
  Region.Eps2 := seEps2.Value;
end;

procedure TEditForm.rgGeometryClick(Sender: TObject);
begin
  NoteBook1.PageIndex := rgGeometry.ItemIndex;
end;

procedure TEditForm.rgMatterClick(Sender: TObject);
begin
  case rgMatter.ItemIndex of
    0 :
    begin
      seEps.Value := 1;
      seEps.Enabled := False;
    end;
    1 :
    begin
      seEps.Value := 0;
      seEps.Enabled := False;
    end;
    2 :
    begin
      seEps.Value := 1;
      seEps.Enabled := True;
    end;
  end;
end;

end.
