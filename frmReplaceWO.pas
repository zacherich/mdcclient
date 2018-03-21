unit frmReplaceWO;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.DBCtrls, Vcl.StdCtrls, Vcl.Buttons;

type
  Tfrm_ReplaceWO = class(TForm)
    dbg_replacewo: TDBGrid;
    lbl_tag_now_wo: TLabel;
    lbl_tag_now_product: TLabel;
    lbl_now_wo: TLabel;
    lbl_now_product: TLabel;
    lbl_tag_now_input: TLabel;
    lbl_now_input: TLabel;
    spb_default_wo: TSpeedButton;
    procedure dbg_replacewoDblClick(Sender: TObject);
    procedure spb_default_woClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_ReplaceWO: Tfrm_ReplaceWO;

implementation

uses frmMain, dataModule, publicLib;

{$R *.dfm}

procedure Tfrm_ReplaceWO.dbg_replacewoDblClick(Sender: TObject);
begin
  if dbg_replacewo.DataSource.DataSet.RecNo>0 then  //工单列表中有记录
    begin
      gvNon_default_wo_id := dbg_replacewo.DataSource.DataSet.FieldByName('order_id').AsInteger;
      //选择的工单和当前产线工单一致
      if gvWorkorder_id=gvNon_default_wo_id then
        begin
          Self.Hide;
        end
      else  //选择的工单和当前产线工单不一致
        begin
          gvProduct_id := 0;
          gvProduct_code := '';
          frm_main.lbl_product_code.Caption := gvProduct_code;
          frm_main.lbl_todo_qty.Caption := '0';
          frm_main.lbl_done_qty.Caption := '0';
          frm_main.lbl_good_qty.Caption := '0';
          frm_main.lbl_bad_qty.Caption := '0';
          frm_main.lbl_weld_count.Caption := '0';
          frm_main.lbl_wo_row.Caption := '0';
          Self.Hide;
          RefreshEquipment;
          RefreshWorkorder;
          RefreshMaterials;
          RefreshStaff;
        end;
    end
  else
    begin
      frm_main.InfoTips('没有可以切换的工单，请联系管理员！');
    end;
end;

procedure Tfrm_ReplaceWO.spb_default_woClick(Sender: TObject);
begin
  gvNon_default_wo_id := 0;
  gvProduct_id := 0;
  gvProduct_code := '';
  frm_main.lbl_product_code.Caption := gvProduct_code;
  frm_main.lbl_todo_qty.Caption := '0';
  frm_main.lbl_done_qty.Caption := '0';
  frm_main.lbl_good_qty.Caption := '0';
  frm_main.lbl_bad_qty.Caption := '0';
  frm_main.lbl_weld_count.Caption := '0';
  frm_main.lbl_wo_row.Caption := '0';
  Self.Hide;
  RefreshEquipment;
  RefreshWorkorder;
  RefreshMaterials;
  RefreshStaff;
end;

end.
