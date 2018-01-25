program mdcClient;

uses
  Vcl.Forms,
  publicLib in 'publicLib.pas',
  frmMain in 'frmMain.pas' {frm_main},
  frmSet in 'frmSet.pas' {frm_set},
  dataModule in 'dataModule.pas' {data_module: TDataModule},
  frmLogin in 'frmLogin.pas' {frm_login},
  frmFinish in 'frmFinish.pas' {frm_finish},
  frmContainer in 'frmContainer.pas' {frm_container},
  frmReplaceWO in 'frmReplaceWO.pas' {frm_ReplaceWO},
  frmMESLine in 'frmMESLine.pas' {frm_MESLine};

{$R *.res}


begin
  Application.MainFormOnTaskbar := True;

  Application.Title := '安费诺宁德MES';
  Application.CreateForm(Tfrm_main, frm_main);
  Application.CreateForm(Tfrm_set, frm_set);
  Application.CreateForm(Tfrm_finish, frm_finish);
  Application.CreateForm(Tdata_module, data_module);
  Application.CreateForm(Tfrm_container, frm_container);
  Application.CreateForm(Tfrm_ReplaceWO, frm_ReplaceWO);
  Application.CreateForm(Tfrm_MESLine, frm_MESLine);
  if frmLogin.Login() then  //呼叫登录窗口：就这一行，简单吧！
    Application.Run;
end.
