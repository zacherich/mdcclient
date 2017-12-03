unit frmFinish;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.Buttons,
  Vcl.Grids, Vcl.DBGrids;

type
  Tfrm_finish = class(TForm)
    lbl_tag_doing_qty: TLabel;
    lbl_tag_good_qty: TLabel;
    lbl_tag_bad_qty: TLabel;
    lbl_bad_qty: TLabel;
    lbl_good_qty: TLabel;
    lbl_doing_qty: TLabel;
    lbl_tag_product_code: TLabel;
    lbl_product_code: TLabel;
    sbt_submit: TSpeedButton;
    dbg_badmode: TDBGrid;
    lbl_tag_container_code: TLabel;
    lbl_container_code: TLabel;
    Memo1: TMemo;
    lbl_tag_container_name: TLabel;
    lbl_container_name: TLabel;
    procedure sbt_submitClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_finish: Tfrm_finish;
  uvInput : String;
  uvStart : DWORD;

implementation

uses dataModule, publicLib, SuperObject;

{$R *.dfm}

procedure Tfrm_finish.FormKeyPress(Sender: TObject; var Key: Char);
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
          if copy(uvInput,1,2)='AT' then  //ɨ�赽��������
            begin
              memo1.Lines.Add(scanContainer(uvInput));
              vO := SO(scanContainer(uvInput));
              if vO.B['result.success'] then  //�ɹ�ɨ�赽����
                begin
                      gvContainer_id := vO.I['result.container_id'];
                      gvContainer_code := vO.S['result.container_name'];
                      gvContainer_name := vO.S['result.container_alias'];
                      frm_finish.lbl_container_code.Caption := gvContainer_code;
                      frm_finish.lbl_container_name.Caption := gvContainer_name;
                      log(DateTimeToStr(now())+', [INFO] �����š�'+gvContainer_code+'����ɨ��ɹ��ɹ���');
                end
              else  //ɨ������ʧ��
                begin
                  log(DateTimeToStr(now())+', [ERROR]  �����š�'+copy(uvInput,3,Length(uvInput)-2)+'��ɨ��ʧ�ܣ�������Ϣ��'+vO.S['result.message']);
                end;
            end;
        end
      else
        log(DateTimeToStr(now())+', [ERROR] ��������:' + uvInput);
      uvInput := '';
    end
  else
    begin
      uvInput := uvInput + Key;
    end;
end;

procedure Tfrm_finish.sbt_submitClick(Sender: TObject);
begin
  if lbl_bad_qty.Caption<>'0' then
    begin

    end;
  if gvline_type='flowing' then    //������
    begin
      //
    end
  else if gvline_type='station' then    //����վ
    begin
      if gvLastworkcenter then    //��������һ���������ɨ������
        begin
          if lbl_container_code.Caption<>'��' then
            begin

            end
          else
            begin
              Application.MessageBox(PChar('���һ�����򱨹�������ɨ��������ά�룡'),'����',MB_ICONERROR);
            end;
        end
      else
        begin
          //
        end;
    end;
end;

end.
