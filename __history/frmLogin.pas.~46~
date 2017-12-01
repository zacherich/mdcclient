unit frmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.Samples.Spin;

type
  Tfrm_login = class(TForm)
    PageControl1: TPageControl;
    tbs_login: TTabSheet;
    tbs_netset: TTabSheet;
    lbl_username: TLabel;
    lbl_password: TLabel;
    edt_username: TEdit;
    edt_password: TEdit;
    btn_login: TBitBtn;
    edt_host: TEdit;
    lbl_port: TLabel;
    lbl_host: TLabel;
    lbl_server: TLabel;
    lbl_net: TLabel;
    lbl_proxyhost: TLabel;
    edt_proxyhost: TEdit;
    lbl_proxyport: TLabel;
    btn_confirm: TBitBtn;
    btn_cancel: TBitBtn;
    ckb_savepwd: TCheckBox;
    ckb_proxy: TCheckBox;
    spn_port: TSpinEdit;
    spn_proxyport: TSpinEdit;
    lbl_database: TLabel;
    edt_database: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_loginClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbl_usernameDblClick(Sender: TObject);
    procedure btn_confirmClick(Sender: TObject);
    procedure ckb_proxyClick(Sender: TObject);
    procedure ckb_savepwdClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    uvTryTimes: Integer;
    function CheckUserInfo(fvDatabase, fvUserName, fvPassword: string): Boolean;
  public
    { Public declarations }
  end;
  function Login: Boolean;  //登录函数
var
  frm_login: Tfrm_login;

implementation

{$R *.dfm}

uses publicLib, SuperObject;

function Login: Boolean;
begin
  //动态创建登录窗口
  with Tfrm_login.Create(nil) do
  begin
    //只有返回OK的时候认为登录成功
    Result := ShowModal() = mrOk;
    Free;
  end;
end;

procedure Tfrm_login.btn_cancelClick(Sender: TObject);
begin
  tbs_login.Show;
end;

procedure Tfrm_login.btn_confirmClick(Sender: TObject);
var
  vResponse: String;
begin
  if Trim(edt_host.Text) = '' then
    begin
      showmessage('服务地址必须设置！');
      Exit;
    end;
  {check port}
  if spn_port.Value = 0 then
    begin
      showmessage('服务端口号必须设置！');
      Exit;
    end;
  if Trim(edt_database.Text) = '' then
    begin
      showmessage('账套名称必须设置！');
      Exit;
    end;
  if ckb_proxy.Checked then
    begin
      if Trim(edt_proxyhost.Text) = '' then
        begin
          showmessage('代理服务地址必须设置！');
          Exit;
        end;
      {check port}
      if spn_proxyport.Value = 0 then
        begin
          showmessage('代理服务端口号必须设置！');
          Exit;
        end;
      ini_set.WriteString('server', 'proxy_host', edt_proxyhost.Text);
      ini_set.Writeinteger('server', 'proxy_port', spn_proxyport.Value);
      ini_set.UpdateFile;
    end;
  vResponse:= JsonRPCdblist(Aurl(Trim(edt_host.Text),spn_port.Value));
  if Pos(Trim(edt_database.Text),vResponse)>0 then
    begin
      gvUse_Proxy:= ckb_proxy.Checked;
      gvDatabase:= Trim(edt_database.Text);
      gvServer_Host:= Trim(edt_host.Text);
      gvServer_Port:= spn_port.Value;
      tbs_login.Show;
    end
  else
    begin
      showmessage('登录服务器信息设置有误，请重新设置！');
    end;
end;

procedure Tfrm_login.btn_loginClick(Sender: TObject);
begin
  Inc(uvTryTimes); //尝试登录的次数 + 1

  if CheckUserInfo(edt_database.Text, edt_username.Text, edt_password.Text) then
    begin
      //如果通过检查，返回OK
      Self.ModalResult := mrOk;
      if gvSave_PWD then
        begin
          ini_set.WriteBool('profile', 'save_pwd', gvSave_PWD);
          ini_set.WriteString('profile', 'user_name', gvUserName);
          ini_set.WriteString('profile', 'password', gvPassword);
          ini_set.UpdateFile;
        end;
    end
  else
    begin
      if (uvTryTimes > 2) then
      begin
        MessageBox(self.Handle, '你已经尝试登录3次，请联系系统管理员。', '错误', MB_OK + MB_ICONERROR);
        Self.ModalResult := mrCancel;
        Exit;
      end;

      //通不过，报错
      MessageBox(self.Handle, '错误的用户名或密码，请重新输入!', '错误', MB_OK + MB_ICONERROR);
      edt_username.SetFocus();
      edt_username.SelectAll();
    end;
end;

function Tfrm_login.CheckUserInfo(fvDatabase, fvUserName, fvPassword: String): Boolean;
var
  vO: ISuperObject;
begin
  vO := SO(JsonRPClogin(Aurl(gvServer_Host,gvServer_Port), fvDatabase, fvUserName, fvPassword));
  if vO.S['result']='false' then
    begin
      Result := FALSE;
      log(DateTimeToStr(now())+', [Eror] 登陆服务器：账套名称'+fvDatabase+'用户名'+fvUserName, clRed);
    end
  else
    begin
      try
        gvUserID:= vO.I['result'];
      except
        on E: Exception do
          begin
            log(DateTimeToStr(now())+', [Exception] 登陆服务器：账套名称'+StringReplace(E.Message, #13#10, ': ', [rfReplaceAll]));
            Result := FALSE;
          end;
      end;
      gvUserName:= fvUserName;
      gvPassword:= fvPassword;
      log(DateTimeToStr(now())+', [Info] 登陆服务器：账套名称'+fvDatabase+'用户名'+fvUserName+'登录成功！', clGreen);
      Result := TRUE;
    end;
end;

procedure Tfrm_login.ckb_proxyClick(Sender: TObject);
begin
  edt_proxyhost.Enabled:=ckb_proxy.Checked;
  spn_proxyport.Enabled:=ckb_proxy.Checked;
end;

procedure Tfrm_login.ckb_savepwdClick(Sender: TObject);
begin
  gvSave_PWD:= ckb_savepwd.Checked;
end;

procedure Tfrm_login.FormCreate(Sender: TObject);
begin
  uvTryTimes := 0;
end;

procedure Tfrm_login.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if key=#13 then btn_login.Click;
end;

procedure Tfrm_login.FormShow(Sender: TObject);
begin
  tbs_login.Show;
  ckb_savepwd.Checked:=gvSave_PWD;
  edt_username.Text:=gvUserName;
  edt_password.Text:=gvPassword;
  ckb_proxy.Checked:=gvUse_Proxy;
  edt_proxyhost.Enabled:=ckb_proxy.Checked;
  spn_proxyport.Enabled:=ckb_proxy.Checked;
  edt_database.Text:=gvDatabase;
  edt_host.Text:=gvServer_Host;
  spn_port.Value:=gvServer_Port;
end;

procedure Tfrm_login.lbl_usernameDblClick(Sender: TObject);
begin
  tbs_netset.Show;
end;

end.
