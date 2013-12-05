unit ObjFUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList, Grids, StdCtrls, Buttons, ComCtrls, ToolWin, Regions, EditReg;

type
  TObjForm = class(TForm)
    TabControl1: TTabControl;
    StringGrid1: TStringGrid;
    sbProp: TSpeedButton;
    sbDelete: TSpeedButton;
    BitBtn1: TBitBtn;
    procedure TabControl1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbPropClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ObjForm: TObjForm;

{$IFDEF WRPROCESS}
var
  PrFile: Text;
{$ENDIF}

implementation

{$R *.DFM}

procedure TObjForm.TabControl1Change(Sender: TObject);
var
  i: Integer;
begin
  case TabControl1.TabIndex of
    0 :
    begin
      StringGrid1.ColCount := 3;
      if ShapeList.Count <> 0 then
        StringGrid1.RowCount := ShapeList.Count + 1
      else
      begin
        StringGrid1.Rows[1].Clear;
        StringGrid1.RowCount := 2;
      end;  
      StringGrid1.ColWidths[1] := 128;
      StringGrid1.ColWidths[2] := 133;
      for i := 0 to ShapeList.Count - 1 do
        with StringGrid1.Rows[i + 1] do
        begin
          Clear;
          Add(IntToStr(i + 1));
          Add(GetShape(ShapeList[i].Region.Figure.Shape));
          Add(GetMatterType(ShapeList[i].Region.MatterType));
        end;
    end;
    1 :
    begin
      StringGrid1.ColCount := 2;
      if ShapeList.FieldList.Count <> 0 then
        StringGrid1.RowCount := ShapeList.FieldList.Count + 1
      else
      begin
        StringGrid1.Rows[1].Clear;
        StringGrid1.RowCount := 2;
      end;
      StringGrid1.ColWidths[1] := 262;
      for i := 0 to ShapeList.FieldList.Count - 1 do
        with StringGrid1.Rows[i + 1] do
        begin
          Clear;
          Add(IntToStr(i + 1));
          Add(GetFieldType(ShapeList.FieldList[i].Field.FieldType));
        end;
    end;
  end;
  StringGrid1.SetFocus;
end;

procedure TObjForm.FormShow(Sender: TObject);
begin
  TabControl1Change(Self);
//  StringGrid1.SetFocus;
end;

procedure TObjForm.sbDeleteClick(Sender: TObject);
begin
  case TabControl1.TabIndex of
    0 : if ShapeList.Count <> 0 then
      ShapeList.Delete(StringGrid1.Row - 1);
    1 : if ShapeList.FieldList.Count <> 0 then
      ShapeList.FieldList.Delete(StringGrid1.Row - 1);
  end;
  TabControl1Change(Self);
{$IFDEF WRPROCESS}
  Writeln(PrFile, 'Deleting of a region or a field');
{$ENDIF}
end;

procedure TObjForm.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    sbPropClick(Self);
  if Key = 46 then
    sbDeleteClick(Self);
  if Key = 27 then
    Close;  
end;

procedure TObjForm.sbPropClick(Sender: TObject);
var
  Region: TRegion;
begin
  case TabControl1.TabIndex of
    0 :
    with EditForm do
    begin
      Region := TRegion.Create;
      Region.Assign(ShapeList[StringGrid1.Row - 1].Region);
      AssignParams(Region);
      if ShowModal = mrOK then
      begin
        AssignRegion(Region);
        TabControl1Change(Self);
        ShapeList[StringGrid1.Row - 1].UpdateRegion(Region);
      end;
      Region.Free;
    end;
    1 :
    begin
    end;
  end;
end;

procedure TObjForm.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

end.
