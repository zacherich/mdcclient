program mdcClient;

uses
  Vcl.Forms,
  frmSet in 'frmSet.pas' {frm_set},
  publicLib in 'publicLib.pas',
  frmMain in 'frmMain.pas' {frm_main},
  dataModule in 'dataModule.pas' {data_module: TDataModule},
  frmLogin in 'frmLogin.pas' {frm_login},
  frmFinish in 'frmFinish.pas' {frm_finish};

{$R *.res}

begin
  Application.MainFormOnTaskbar := True;

  Application.CreateForm(Tfrm_main, frm_main);
  Application.CreateForm(Tfrm_set, frm_set);
  Application.CreateForm(Tdata_module, data_module);
  Application.CreateForm(Tfrm_finish, frm_finish);
  if frmLogin.Login() then  //呼叫登录窗口：就这一行，简单吧！
    Application.Run;
end.
