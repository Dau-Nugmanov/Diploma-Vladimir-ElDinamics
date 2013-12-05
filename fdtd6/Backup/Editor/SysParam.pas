unit SysParam;

{Диалог параметров системы}

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, RXSpin, Buttons;

type
  TSystemForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    seSizeOfX: TRxSpinEdit;
    seSizeOfY: TRxSpinEdit;
    rgBounds: TRadioGroup;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    seSigma: TRxSpinEdit;
    seWidth: TRxSpinEdit;
    lbSigma: TLabel;
    lbWidth: TLabel;
    lbSigma2: TLabel;
    seCoefG: TRxSpinEdit;
    lbCoefG: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    seDelX: TRxSpinEdit;
    seDelY: TRxSpinEdit;
    seDelT: TRxSpinEdit;
    Label6: TLabel;
    seEps: TRxSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure rgBoundsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BoundsClick;
  end;

var
  SystemForm: TSystemForm;

implementation

{$R *.DFM}

procedure TSystemForm.BoundsClick;
begin
  rgBoundsClick(rgBounds);
end;

procedure TSystemForm.rgBoundsClick(Sender: TObject);
begin
//удлинение-укорачивание окошка (Form-ы)
  case rgBounds.ItemIndex of
    0 :
    begin
      lbSigma.Visible := False;
      lbSigma2.Visible := False;
      seSigma.Visible := False;
      lbWidth.Visible := False;
      seWidth.Visible := False;
      lbCoefG.Visible := False;
      seCoefG.Visible := False;
      Label13.Visible := False;
      bbOK.Top := 227;
      bbCancel.Top := 227;
      Height := 282;
    end;
    1 :
    begin
      lbSigma.Visible := True;
      lbSigma2.Visible := True;
      seSigma.Visible := True;
      lbWidth.Visible := True;
      seWidth.Visible := True;
      lbCoefG.Visible := True;
      seCoefG.Visible := True;
      Label13.Visible := True;
      bbOK.Top := 299;
      bbCancel.Top := 299;
      Height := 354;
    end;
  end;
end;

procedure TSystemForm.FormCreate(Sender: TObject);
begin
  rgBoundsClick(Self);
end;

end.
