﻿unit frmContainer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  Tfrm_container = class(TForm)
    pnl_tips: TPanel;
    tim_cleartips: TTimer;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure tim_cleartipsTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_container: Tfrm_container;
  uvInput : String;
  uvStart : DWORD;

implementation

{$R *.dfm}

uses publicLib, SuperObject, frmFinish;

procedure Tfrm_container.FormKeyPress(Sender: TObject; var Key: Char);
const
  vInputLen = 6;
var
  vFinish: DWORD;
  vO: ISuperObject;
begin
  if uvInput = '' then uvStart := GetTickCount();
  if (Length(uvInput) >= vInputLen) AND (Key=#13) then
    begin
      vFinish := GetTickCount();
      if (vFinish - uvStart) / Length(uvInput) < 100 then
        begin
          uvInput := UpperCase(uvInput);
          if copy(uvInput,1,2)='AT' then  //扫描到的是容器
            begin
              vO := SO(scanContainer(uvInput));
              if vO.B['result.success'] then  //成功扫描到容器
                begin
                  if vO.B['result.isempty'] then
                    begin
                      gvContainer_id := vO.I['result.container_id'];
                      gvContainer_code := vO.S['result.container_name'];
                      gvContainer_name := vO.S['result.container_alias'];
                      frm_finish.lbl_container.Caption := '【' + gvContainer_code + '】' + gvContainer_name;
                      log(DateTimeToStr(now())+', [INFO] 容器号【'+gvContainer_code+'】的扫描成功成功！');
                      Self.Hide;
                      frm_finish.Show;
                    end
                  else
                    begin
                      pnl_tips.Caption := '容器不为空，请检查！';
                      pnl_tips.Color := clRed;
                      pnl_tips.Font.Color := clWhite;
                      pnl_tips.Font.Style := pnl_tips.Font.Style + [fsBold];
                      tim_cleartips.Enabled := True;
                    end;
                end
              else  //扫描容器失败
                begin
                  log(DateTimeToStr(now())+', [ERROR]  容器号【'+copy(uvInput,3,Length(uvInput)-2)+'】扫描失败，错误信息：'+vO.S['result.message']);
                end;
            end
          else
            begin
              pnl_tips.Caption := '非容器二维码，请检查！';
              pnl_tips.Color := clRed;
              pnl_tips.Font.Color := clWhite;
              pnl_tips.Font.Style := pnl_tips.Font.Style + [fsBold];
              tim_cleartips.Enabled := True;
            end;
        end
      else
        log(DateTimeToStr(now())+', [ERROR] 错误输入:' + uvInput);
      uvInput := '';
    end
  else
    begin
      uvInput := uvInput + Key;
    end;
end;

procedure Tfrm_container.FormShow(Sender: TObject);
begin
  pnl_tips.Color := clInfoBk;
  pnl_tips.Font.Style := pnl_tips.Font.Style + [fsBold];
  pnl_tips.Caption := '请扫描容器条码！';
end;

procedure Tfrm_container.tim_cleartipsTimer(Sender: TObject);
begin
  pnl_tips.Color := clInfoBk;
  pnl_tips.Font.Color := clBlack;
  pnl_tips.Font.Style := pnl_tips.Font.Style + [fsBold];
  pnl_tips.Caption := '请扫描容器条码！';
  tim_cleartips.Enabled := False;
end;

end.
