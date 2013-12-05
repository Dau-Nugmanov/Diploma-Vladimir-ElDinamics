unit ASFUnit;

{Диалог автосохранения
OnSetup- событие при вызове диалога настроек}

{$D-}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, RXSpin, StpFUnit;

type
  TAutoSaveForm = class(TForm)
    cbEnable: TCheckBox;
    seTime: TRxSpinEdit;
    lbTime: TLabel;
    btSetup: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure cbEnableClick(Sender: TObject);
    procedure btSetupClick(Sender: TObject);
  private
    { Private declarations }
    FOnSetup: TNotifyEvent;
  protected
    procedure Setup;
  public
    { Public declarations }
    property OnSetup:TNotifyEvent read FOnSetup write FOnSetup;
  end;

var
  AutoSaveForm: TAutoSaveForm;

implementation

{$R *.DFM}

procedure TAutoSaveForm.Setup;
begin
  if Assigned(FOnSetup) then FOnSetup(Self);
end;

procedure TAutoSaveForm.cbEnableClick(Sender: TObject);
begin
  seTime.Enabled := cbEnable.Checked;
  lbTime.Enabled := cbEnable.Checked;
end;

procedure TAutoSaveForm.btSetupClick(Sender: TObject);
begin
  SetupForm.PageControl1.ActivePage := SetupForm.tsSave;
  if SetupForm.ShowModal = mrOK then
    Setup;
end;

end.
