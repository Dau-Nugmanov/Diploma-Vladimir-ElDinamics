program MediumEditor;

uses
  Forms,
  EditMain in 'EditMain.pas' {Form1},
  ShapeReg in 'ShapeReg.pas',
  Regions in '..\Regions.pas',
  Parametrs in 'Parametrs.pas' {ParamForm},
  SysParam in 'SysParam.pas' {SystemForm},
  EditReg in 'EditReg.pas' {EditForm},
  EditMess in '..\EditMess.pas',
  MesFUnit in 'MesFUnit.pas' {MessForm},
  ColorUnit in '..\ColorUnit.pas',
  FParUnit in 'FParUnit.pas' {FieldParamForm},
  RSelfPar in 'RSelfPar.pas' {RSelfForm},
  AlForm in 'AlForm.pas' {AlignForm},
  PhisCnst in '..\PhisCnst.pas',
  ExtArr in '..\Extarr.pas',
  ExtMath in '..\ExtMath.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TParamForm, ParamForm);
  Application.CreateForm(TSystemForm, SystemForm);
  Application.CreateForm(TEditForm, EditForm);
  Application.CreateForm(TMessForm, MessForm);
  Application.CreateForm(TFieldParamForm, FieldParamForm);
  Application.CreateForm(TRSelfForm, RSelfForm);
  Application.CreateForm(TAlignForm, AlignForm);
  Application.Run;
end.
