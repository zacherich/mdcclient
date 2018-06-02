unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, O2DirSpy, Redis.Client, Redis.Commons, Redis.Values,
  Redis.NetLib.Factory, Redis.NetLib.INDY, sliderPanel;

type
  Tfrm_main = class(TForm)
    pnl_top: TPanel;
    pgc_under: TPageControl;
    tbs_collection: TTabSheet;
    tbs_log: TTabSheet;
    dbg_collection: TDBGrid;
    pnl_collection: TPanel;
    lbl_tag_send_qty: TLabel;
    lbl_send_qty: TLabel;
    lbl_tag_fail_qty: TLabel;
    lbl_fail_qty: TLabel;
    lbl_equipment_state: TLabel;
    shp_equipment_state: TShape;
    tbs_workorder: TTabSheet;
    gpl_operator: TGridPanel;
    lbl_tag_operator: TLabel;
    lbl_operator: TLabel;
    gpl_equipment: TGridPanel;
    lbl_tag_equipment: TLabel;
    lbl_equipment: TLabel;
    lbl_tag_line: TLabel;
    lbl_line: TLabel;
    lbl_tag_station: TLabel;
    lbl_station: TLabel;
    pnl_workorder: TPanel;
    Splitter1: TSplitter;
    pnl_materiel: TPanel;
    lbl_tag_materiel: TLabel;
    dbg_workorder: TDBGrid;
    dbg_materiel: TDBGrid;
    tim_cleartips: TTimer;
    pnl_workorder_title: TPanel;
    lbl_tag_workorder: TLabel;
    lbl_wo_rows: TLabel;
    lbl_tag_wo_rows: TLabel;
    lbl_wo_row: TLabel;
    lbl_tag_wo_row: TLabel;
    pgc_top: TPageControl;
    tbs_wo: TTabSheet;
    tbs_tip: TTabSheet;
    pnl_middle: TPanel;
    lbl_tag_product_code: TLabel;
    lbl_tag_todo_qty: TLabel;
    lbl_tag_done_qty: TLabel;
    lbl_tag_good_qty: TLabel;
    lbl_tag_bad_qty: TLabel;
    lbl_tag_doing_qty: TLabel;
    lbl_wo: TLabel;
    lbl_product_code: TLabel;
    lbl_todo_qty: TLabel;
    lbl_done_qty: TLabel;
    lbl_good_qty: TLabel;
    lbl_bad_qty: TLabel;
    lbl_doing_qty: TLabel;
    lbl_tag_title: TLabel;
    spb_submit: TSpeedButton;
    spb_refresh: TSpeedButton;
    lbl_tag_state: TLabel;
    lbl_state: TLabel;
    spb_start: TSpeedButton;
    lbl_tag_weld_count: TLabel;
    lbl_weld_count: TLabel;
    spb_random: TSpeedButton;
    spb_first: TSpeedButton;
    spb_last: TSpeedButton;
    spb_debug: TSpeedButton;
    spb_replace: TSpeedButton;
    lbl_tip: TLabel;
    rdg_unproductive: TRadioGroup;
    lbx_log: TListBox;
    lbl_tag_qty: TLabel;
    lbl_tag_count: TLabel;
    procedure spb_firstClick(Sender: TObject);
    procedure spb_randomClick(Sender: TObject);
    procedure spb_lastClick(Sender: TObject);
    procedure spb_debugClick(Sender: TObject);
    procedure spb_replaceClick(Sender: TObject);
    procedure lbl_woDblClick(Sender: TObject);
    type uvTipType=(right, error, warn);

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure spb_startClick(Sender: TObject);
    procedure spb_submitClick(Sender: TObject);
    procedure InfoTips(fvContent : String; fvTipType : uvTipType = error);
    procedure lbl_tag_equipmentDblClick(Sender: TObject);
    procedure dbg_workorderDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbg_workorderDblClick(Sender: TObject);
    procedure spb_refreshClick(Sender: TObject);
    procedure lbl_lineDblClick(Sender: TObject);
    procedure tim_cleartipsTimer(Sender: TObject);
  private
    { Private declarations }
  public
    OxygenDirectorySpy1: TOxygenDirectorySpy;
    procedure OxygenDirectorySpy1ChangeDirectory(Sender: TObject;
      ChangeRecord: TDirectoryChangeRecord);
    { Public declarations }
  end;
  procedure RefreshEquipment;
  procedure RefreshWorkorder;
  procedure RefreshMaterials(fvConsumelist : String = '');
  procedure RefreshStaff;
  procedure Collection_Data(const fvFileName : String);
  procedure Get_InspectionList;

var
  frm_main: Tfrm_main;
  uvTip_count : Integer = 0;
  uvWeld_count : Integer = 0;
  uvFirst_count  : Integer = 0;
  uvRandom_count  : Integer = 0;
  uvLast_count  : Integer = 0;
  uvMInput : String = '';
  uvMStart : DWORD;
implementation

{$R *.dfm}

uses frmSet, publicLib, SuperObject, SuperXmlParser, dataModule,
     frmFinish, frmContainer, frmMESLine, frmReplaceWO, frmInspect;

procedure Tfrm_main.InfoTips(fvContent : String; fvTipType : uvTipType = error);
begin
  lbl_tip.Caption := fvContent;
  lbl_tip.Font.Style := lbl_tip.Font.Style + [fsBold];
  tbs_tip.Show;
  case fvTipType of
  right:
    begin
      Self.Color := clLime;
      lbl_tip.Font.Color := clBlack;
    end;
  error:
    begin
      Self.Color := clRed;
      lbl_tip.Font.Color := clWhite;
    end;
  warn:
    begin
      Self.Color := clInfoBk;
      lbl_tip.Font.Color := clBlack;
    end;
  end;
  tim_cleartips.Enabled := True;
end;

procedure RefreshEquipment;
begin
  if gvApp_code<>'' then
    begin
      frm_set.edt_app_code.Text := gvApp_code;
      if queryEquipment then   //jsonRPC获取设备数据成功
        begin
          //主窗口设备信息
          frm_main.lbl_equipment.Caption := '【'+ gvApp_code + '】' + #13 + gvApp_name;
          frm_main.lbl_line.Caption := gvMESLine_name;
          frm_main.lbl_station.Caption := gvWorkstation_code + ' ' + gvWorkstation_name;
          frm_main.lbl_equipment_state.Caption := gvApp_state;
          if gvApp_state='normal' then
            begin
              frm_main.lbl_equipment_state.Font.Color := clGreen;
              frm_main.shp_equipment_state.Brush.Color := clGreen;
              frm_main.lbl_tag_equipment.Font.Color := clGreen;
              frm_main.lbl_equipment.Font.Color := clGreen;
            end;
          if gvApp_state='repair' then
            begin
              frm_main.lbl_equipment_state.Font.Color := clYellow;
              frm_main.shp_equipment_state.Brush.Color := clYellow;
            end;
          if gvApp_state='maintain' then
            begin
              frm_main.lbl_equipment_state.Font.Color := clFuchsia;
              frm_main.shp_equipment_state.Brush.Color := clFuchsia;
            end;
          if gvApp_state='test' then
            begin
              frm_main.lbl_equipment_state.Font.Color := clBlue;
              frm_main.shp_equipment_state.Brush.Color := clBlue;
            end;
          if gvApp_state='produce' then
            begin
              frm_main.lbl_equipment_state.Font.Color := clGreen;
              frm_main.shp_equipment_state.Brush.Color := clGreen;
            end;
          if gvApp_state='scrap' then
            begin
              frm_main.lbl_equipment_state.Font.Color := clGray;
              frm_main.shp_equipment_state.Brush.Color := clGray;
            end;
          //设置窗口设备信息
          frm_set.lbl_app_id.Caption := IntToStr(gvApp_id);
          frm_set.lbl_app_code.Caption := gvApp_code;
          frm_set.lbl_app_name.Caption := gvApp_name;
          frm_set.edt_app_secret.Text := IntToStr(gvApp_secret);
          frm_set.lbl_app_secret.Caption := IntToStr(gvApp_secret);
          frm_set.lbl_equipment_state.Caption := gvApp_state;
          frm_set.lbl_line_id.Caption := IntToStr(gvMESLine_id);
          frm_set.lbl_line_code.Caption := gvMESLine_name;
          frm_set.lbl_station_id.Caption := IntToStr(gvWorkstation_id);
          frm_set.lbl_station_code.Caption := gvWorkstation_code;
          frm_set.lbl_station_name.Caption := gvWorkstation_name;
          if gvMESLine_name<>'' then
            begin
              if queryLineType(gvMESLine_name) then
                begin
                  log(DateTimeToStr(now())+', [Info] 生产线【'+gvMESLine_name+'】获取产线类型：'+gvline_type);
                  //获取到了产线类型
                end
              else
                begin
                  log(DateTimeToStr(now())+', [Eror] 生产线【'+gvMESLine_name+'】获取产线类型失败！');
                end;
            end;
          if gvQueue_name<>'' then
            begin
              frm_set.edt_queue_name.Text:=gvQueue_name;
              if queryRedis(gvQueue_name) then
                begin
                  frm_set.lbl_host.Caption:=gvRedis_Host;
                  frm_set.lbl_port.Caption:=IntToStr(gvRedis_Port);
                end
              else
                begin
                  frm_main.InfoTips('MDC服务地址获取失败，请联系管理员！');
                  frm_set.ShowModal;
                  frm_set.tbs_collection.Show;
                  frm_set.lbl_host.Caption:='';
                  frm_set.lbl_port.Caption:='';
                end;
            end
          else
            begin
              frm_main.InfoTips('Redis队列名称必须设置，请联系管理员！');
              //Application.MessageBox(PChar('Redis队列名称必须设置，请联系管理员设置！'),'错误',MB_ICONERROR);
              frm_set.ShowModal;
              frm_set.tbs_collection.Show;
              frm_set.lbl_host.Caption:='';
              frm_set.lbl_port.Caption:='';
            end;
        end
      else
        begin
          frm_main.InfoTips('设备信息获取失败，请联系管理员！');
          frm_set.ShowModal;
          frm_set.tbs_equipment.Show;
          frm_set.lbl_app_id.Caption := '';
          frm_set.lbl_app_code.Caption := '';
          frm_set.lbl_app_name.Caption := '';
          frm_set.edt_app_secret.Text := '';
          frm_set.lbl_app_secret.Caption := '';
          frm_set.lbl_line_id.Caption := '';
          frm_set.lbl_line_code.Caption := '';
          frm_set.lbl_station_id.Caption := '';
          frm_set.lbl_station_code.Caption := '';
          frm_set.lbl_station_name.Caption := '';
        end;
    end
  else
    begin
      frm_main.InfoTips('设备编码必须设置，请联系管理员！');
      frm_set.ShowModal;
      frm_set.tbs_equipment.Show;
      frm_set.lbl_app_id.Caption := '';
      frm_set.lbl_app_code.Caption := '';
      frm_set.lbl_app_name.Caption := '';
      frm_set.edt_app_secret.Text := '';
      frm_set.lbl_app_secret.Caption := '';
      frm_set.lbl_line_id.Caption := '';
      frm_set.lbl_line_code.Caption := '';
      frm_set.lbl_station_id.Caption := '';
      frm_set.lbl_station_code.Caption := '';
      frm_set.lbl_station_name.Caption := '';
    end;
end;

procedure RefreshWorkorder;
var
  vO, vResult_v: ISuperObject;
  vVirtuallist : TSuperArray;
  i : Integer;
begin
  frm_main.lbl_wo.Caption := '无';
  data_module.cds_workorder.EmptyDataSet;
  if gvline_type='flowing' then
    begin
      vO := SO(getLineWorkorder(gvNon_default_wo_id));
      if vO.B['result.success'] then  //成功刷新主线子工单
        begin
          if gvApp_testing then
            begin
              //切换工单测试机待报工数量改为零。
              if gvWorkorder_name<>vO.S['result.workorder_name'] then frm_main.lbl_doing_qty.Caption := '0';

              gvMainorder_id := vO.I['result.mainorder_id'];
              gvMainorder_name := vO.S['result.mainorder_name'];
              gvWorkorder_id := vO.I['result.workorder_id'];
              gvWorkorder_name := vO.S['result.workorder_name'];
              frm_main.lbl_wo.Caption := gvWorkorder_name;
              gvFin_product_id := vO.I['result.product_id'];
              gvFin_product_code := vO.S['result.product_code'];
              gvProduct_id :=  vO.I['result.product_id'];
              gvProduct_code := vO.S['result.product_code'];
              frm_main.lbl_product_code.Caption := gvProduct_code;
              gvInput_qty := vO.C['result.input_qty'];
              frm_main.lbl_todo_qty.Caption := FloatToStr(gvInput_qty);
            end
          else
            begin
              gvMainorder_id := vO.I['result.mainorder_id'];
              gvMainorder_name := vO.S['result.mainorder_name'];
              gvWorkorder_id := vO.I['result.workorder_id'];
              gvWorkorder_name := vO.S['result.workorder_name'];
              gvFin_product_id := vO.I['result.product_id'];
              gvFin_product_code := vO.S['result.product_code'];
              gvInput_qty := vO.C['result.input_qty'];
              frm_main.lbl_wo.Caption := gvWorkorder_name;
              vVirtuallist := vO.A['result.virtuallist'];
              if vVirtuallist.Length>0 then   //存在有虚拟物料记录
                begin
                  with data_module.cds_workorder do
                    begin
                      for i := 0 to vVirtuallist.Length-1 do
                        begin
                          vResult_v := SO(vVirtuallist[i].AsString);
                          Append;
                          FieldByName('product_id').AsInteger := vResult_v.I['product_id'];
                          FieldByName('product_code').AsWideString := vResult_v.S['product_code'];
                          FieldByName('input_qty').AsFloat := vResult_v.C['input_qty'];
                          FieldByName('todo_qty').AsFloat := vResult_v.C['todo_qty'];
                          FieldByName('output_qty').AsFloat := vResult_v.C['output_qty'];
                          FieldByName('actual_qty').AsFloat := vResult_v.C['actual_qty'];
                          FieldByName('badmode_qty').AsFloat := vResult_v.C['badmode_qty'];
                          if vResult_v.I['weld_count']=0 then FieldByName('weld_count').AsInteger := 1
                          else FieldByName('weld_count').AsInteger := vResult_v.I['weld_count'];
                          FieldByName('materiallist').AsWideString := vResult_v.S['materiallist'];
                          Post;
                        end;
                      First;
                      while not eof do
                        begin
                          if FieldByName('product_id').AsInteger=gvProduct_id then   //当前选中的产品高良显示
                            begin
                              Break;
                            end;
                          Next;
                        end;
                    end;
                  frm_main.lbl_wo_rows.Caption := ' ' + IntToStr(vVirtuallist.Length) + ' 行';
                end
              else
                begin
                  with data_module.cds_workorder do
                    begin
                      EmptyDataSet;
                    end;
                end;
            end;
        end
      else  //刷新工单失败
        begin
          log(DateTimeToStr(now())+', [ERROR] 生产线没有本道工位的工单，错误信息：'+vO.S['result.message']);
        end;
      frm_main.spb_start.Hide;
    end
  else if gvline_type='station' then
    begin
      vO := SO(scanWorkticket(gvWorkorder_barcode));
      if vO.B['result.success'] then  //成功刷新支线工单
        begin
          gvMainorder_id := vO.I['result.mainorder_id'];
          gvMainorder_name := vO.S['result.mainorder_name'];
          gvWorkorder_id := vO.I['result.workorder_id'];
          gvWorkorder_name := vO.S['result.workorder_name'];
          frm_main.lbl_wo.Caption := gvWorkorder_name;
          gvWorkticket_id := vO.I['result.workticket_id'];
          gvWorkticket_name := vO.S['result.workticket_name'];
          gvWorkcenter_id := vO.I['result.workcenter_id'];
          gvWorkcenter_name := vO.S['result.workcenter_name'];
          gvWorkticket_state := vO.S['result.state'];
          frm_main.lbl_state.Caption := gvWorkticket_state;
          gvProduct_code := vO.S['result.product_code'];
          frm_main.lbl_product_code.Caption := gvProduct_code;
          gvInput_qty := vO.C['result.input_qty'];
          frm_main.lbl_todo_qty.Caption := FloatToStr(gvInput_qty);
          gvOutput_qty := vO.C['result.output_qty'];
          frm_main.lbl_good_qty.Caption := FloatToStr(gvOutput_qty);
          gvBadmode_qty := vO.C['result.badmode_qty'];
          frm_main.lbl_bad_qty.Caption := FloatToStr(gvBadmode_qty);
          frm_main.lbl_done_qty.Caption := FloatToStr(gvOutput_qty+gvBadmode_qty);
          gvLastworkcenter := vO.B['result.lastworkcenter'];
          gvOutput_manner :=  vO.S['result.output_manner'];
          gvFin_product_id := vO.I['result.finalproduct_id'];
          gvFin_product_code := vO.S['result.finalproduct_code'];
          log(DateTimeToStr(now())+', [INFO] 工单号【'+gvWorkorder_barcode+'】的刷新成功！');
        end
      else  //刷新工单失败
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_barcode+'】的不应该出现在本道工位，错误信息：'+vO.S['result.message']);
        end;
      frm_main.spb_start.Show;
    end;
end;

procedure RefreshStaff;
begin
  if queryStaffExist then  //设备上有操作工
    begin
      frm_main.lbl_operator.Caption := gvStaff_code;
      log(DateTimeToStr(now())+', [INFO] 设备号【'+gvApp_code+'】上，有员工号【'+gvStaff_code+'】的'+gvStaff_name+'在岗！');
    end
  else  //设备上没有操作工
    begin
      frm_main.lbl_operator.Caption := '';
      log(DateTimeToStr(now())+', [INFO] 设备号【'+gvApp_code+'】上，没有有员工号在岗！');
    end;
end;


procedure RefreshMaterials(fvConsumelist : String = '');
var
  vsTemp : String;
  vO_c, vO_m, vResult_c, vResult_m: ISuperObject;
  vMaterials, vConsume : TSuperArray;
  c , m: Integer;
begin
  vO_m := SO(getFeedMaterials);
  vsTemp:=vO_m.AsObject.S['result.success'];
  if vO_m.B['result.success'] then  //成功得到设备所在工位的上料信息
    begin
      vMaterials := vO_m.A['result.materiallist'];
    end
  else
    begin
      vO_m := SO('{"materiallist":[]}');
      vMaterials := vO_m.A['materiallist'];
    end;
  if fvConsumelist='' then  //没有传入参数
    begin
      if gvWorkorder_id>0 then  //当前有工单在制
        begin
          vO_c := SO(getWorkordConsume(gvWorkorder_id, gvWorkcenter_id));
          if vO_c.B['result.success'] then  //成功得到工单消耗明细
            begin
              vConsume := vO_c.A['result.consumelist'];
            end
          else
            begin
              vO_c := SO('{"consumelist":[]}');
              vConsume := vO_c.A['consumelist'];
            end;
        end
      else
        begin
          vO_c := SO('{"consumelist":[]}');
          vConsume := vO_c.A['consumelist'];
        end;
    end
  else
    begin
      vO_c := SO(fvConsumelist);
      vConsume := vO_c.A['consumelist'];
    end;
  if (vConsume.Length<>0) or (vMaterials.Length<>0) then     //至少有消耗信息或上料信息
    begin
      if (vConsume.Length<>0) and (vMaterials.Length<>0) then  //消耗信息和上料信息都有
        begin
          with data_module.cds_materials do
            begin
              EmptyDataSet;
              for c := 0 to vConsume.Length-1 do
                begin
                  vResult_c := SO(vConsume[c].AsString);
                  Append;
                  FieldByName('material_id').AsInteger := vResult_c.I['material_id'];
                  FieldByName('material_code').AsWideString := vResult_c.S['material_code'];
                  FieldByName('input_qty').AsFloat := vResult_c.C['input_qty'];
                  FieldByName('consume_qty').AsFloat := vResult_c.C['consume_qty'];
                  FieldByName('consume_unit').AsFloat := vResult_c.C['consume_unit'];
                  FieldByName('leave_qty').AsFloat := vResult_c.C['leave_qty'];
                  for m := 0 to vMaterials.Length-1 do    //如果有相同料号的上料库存，则更新dataset，否则插入新记录
                    begin
                      vResult_m := SO(vMaterials[m].AsString);
                      if vResult_c.I['material_id']=vResult_m.I['material_id'] then   //消耗信息和上料信息中有同样的原料
                        begin
                          FieldByName('material_qty').AsFloat := vResult_m.C['material_qty'];
                          FieldByName('materiallot_id').AsInteger := vResult_m.I['materiallot_id'];
                          FieldByName('materiallot_name').AsWideString := vResult_m.S['materiallot_name'];
                          Break;
                        end;
                    end;
                  Post;
                end;
            end;
        end
      else if vConsume.Length<>0 then   //只有消耗信息
        begin
          with data_module.cds_materials do
            begin
              EmptyDataSet;
              for c := 0 to vConsume.Length-1 do
                begin
                  Append;
                  vResult_c := SO(vConsume[c].AsString);
                  FieldByName('material_id').AsInteger := vResult_c.I['material_id'];
                  FieldByName('material_code').AsWideString := vResult_c.S['material_code'];
                  FieldByName('input_qty').AsFloat := vResult_c.C['input_qty'];
                  FieldByName('consume_qty').AsFloat := vResult_c.C['consume_qty'];
                  FieldByName('material_qty').AsFloat := 0;
                  FieldByName('consume_unit').AsFloat := vResult_c.C['consume_unit'];
                  FieldByName('leave_qty').AsFloat := vResult_c.C['leave_qty'];
                  FieldByName('materiallot_id').AsInteger := 0;
                  FieldByName('materiallot_name').AsWideString := '';
                  Post;
                end;
            end;
        end
      else   //只有上料信息
        begin
          with data_module.cds_materials do
            begin
              EmptyDataSet;
              for m := 0 to vMaterials.Length-1 do
                begin
                  Append;
                  vResult_m := SO(vMaterials[m].AsString);
                  FieldByName('material_id').AsInteger := vResult_m.I['material_id'];
                  FieldByName('material_code').AsWideString := vResult_m.S['material_code'];
                  FieldByName('input_qty').AsFloat := 0;
                  FieldByName('consume_qty').AsFloat := 0;
                  FieldByName('material_qty').AsFloat := vResult_m.C['material_qty'];
                  FieldByName('consume_unit').AsFloat := 0;
                  FieldByName('leave_qty').AsFloat := 0;
                  FieldByName('materiallot_id').AsInteger := vResult_m.I['materiallot_id'];
                  FieldByName('materiallot_name').AsWideString := vResult_m.S['materiallot_name'];
                  Post;
                end;
            end;
        end;
      data_module.cds_materials.First;
    end
  else
    begin
      with data_module.cds_materials do
        begin
          EmptyDataSet;
        end;
    end;
end;

procedure Weld2yield;
begin
  Inc(uvWeld_count);
  if uvWeld_count<gvWeld_count then
    begin
      Inc(uvWeld_count);
    end
  else
    begin
      gvDoing_qty:=gvDoing_qty+1;
      frm_main.lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
      if gvline_type='station' then
        begin
          ini_set.WriteString('job', 'workorder', gvWorkorder_barcode);
          ini_set.WriteInteger('job', 'doing_qty', gvDoing_qty);
          ini_set.UpdateFile;
        end;
      case frm_main.rdg_unproductive.ItemIndex of
      -1:    //正常生产的产量算作正常生产
        begin
          //
        end;
      0:     //调机的产量算作正常生产
        begin
          frm_main.spb_debug.Down := False;
          frm_main.rdg_unproductive.ItemIndex := -1;
        end;
      1:     //换型的产量算作正常生产
        begin
          frm_main.spb_replace.Down := False;
          frm_main.rdg_unproductive.ItemIndex := -1;
        end;
      2:     //首件的产量算作报废
        begin
          //vBadmode_lines := '[{"badmode_id": 206, "badmode_qty": 1}]';
{
          if gvline_type='flowing' then    //主线上
            begin
              vO := SO(Virtual_FINISH(gvProduct_id, 1, vBadmode_lines));
              if vO.B['result.success'] then  //报工成功
                begin
                  frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+1);
                  frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+1);
                  RefreshWorkorder;
                  RefreshMaterials(gvConsumelist);
                end
              else
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】首件报工失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('工单号【'+gvWorkorder_name+'】首件报工失败，错误信息：'+vO.S['result.message']+'！');
                end;
            end
          else if gvline_type='station' then    //工作站
            begin
              vO := SO(workticket_FINISH(gvWorkticket_id, gvApp_id, 1, vBadmode_lines));
              if vO.B['result.success'] then  //报工成功
                begin
                  frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+1);
                  frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+1);
                  RefreshWorkorder;
                  RefreshMaterials;
                end
              else
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】首件报工失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('工单号【'+gvWorkorder_name+'】首件报工失败，错误信息：'+vO.S['result.message']+'！', warn);
                end;
            end;
}         log(DateTimeToStr(now())+', [TAG] 焊接前已焊首件数量'+IntToStr(uvFirst_count));
          Inc(uvFirst_count);
          log(DateTimeToStr(now())+', [TAG] 焊接后已焊首件数量'+IntToStr(uvFirst_count)+'，要焊首件数量'+IntToStr(gvFirst_count));
          if uvFirst_count<gvFirst_count then
            begin
              frm_main.InfoTips('成功完成'+IntToStr(uvFirst_count)+'件首件，还要做'+IntToStr(gvFirst_count-uvFirst_count)+'件。',warn);
              Inc(uvFirst_count);
            end
          else
            begin
              frm_main.spb_first.Down := False;
              if data_module.cds_inspect.RecordCount>0 then
                frm_Inspect.ShowModal
              else
                begin
                  frm_main.rdg_unproductive.ItemIndex := -1;
                  frm_main.InfoTips('首件检查记录没有设置，请联系管理员',warn);
                end;
              frm_main.lbl_tag_qty.Caption:=IntToStr(uvFirst_count);
              uvFirst_count := 0;
              frm_main.lbl_tag_qty.Caption:=IntToStr(uvFirst_count);
            end;
        end;
      3:     //抽检的产量算作报废
        begin
          //vBadmode_lines := '[{"badmode_id": 205, "badmode_qty": 1}]';
{
          if gvline_type='flowing' then    //主线上
            begin
              vO := SO(Virtual_FINISH(gvProduct_id, 1, vBadmode_lines));
              if vO.B['result.success'] then  //报工成功
                begin
                  frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+1);
                  frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+1);
                  RefreshWorkorder;
                  RefreshMaterials(gvConsumelist);
                end
              else
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！');
                end;
            end
          else if gvline_type='station' then    //工作站
            begin
              vO := SO(workticket_FINISH(gvWorkticket_id, gvApp_id, 1, vBadmode_lines));
              if vO.B['result.success'] then  //报工成功
                begin
                  frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+1);
                  frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+1);
                  RefreshWorkorder;
                  RefreshMaterials;
                end
              else
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！', warn);
                end;
            end;
}
          log(DateTimeToStr(now())+', [TAG] 焊接前已焊抽检数量'+IntToStr(uvRandom_count));
          Inc(uvRandom_count);
          log(DateTimeToStr(now())+', [TAG] 焊接后已焊抽检数量'+IntToStr(uvRandom_count)+'，要焊抽检数量'+IntToStr(gvRandom_count));
          if uvRandom_count<gvRandom_count then
            begin
              frm_main.InfoTips('成功完成'+IntToStr(uvRandom_count)+'件抽检，还要做'+IntToStr(uvRandom_count-gvRandom_count)+'件。',warn);
              Inc(uvRandom_count);
            end
          else
            begin
              frm_main.spb_random.Down := False;
              if data_module.cds_inspect.RecordCount>0 then
                frm_Inspect.ShowModal
              else
                begin
                  frm_main.rdg_unproductive.ItemIndex := -1;
                  frm_main.InfoTips('抽检检查记录没有设置，请联系管理员',warn);
                end;
              uvRandom_count := 0;
            end;
        end;
      4:     //末件的产量算作报废
        begin
          //vBadmode_lines := '[{"badmode_id": 207, "badmode_qty": 1}]';
{
          if gvline_type='flowing' then    //主线上
            begin
              vO := SO(Virtual_FINISH(gvProduct_id, 1, vBadmode_lines));
              if vO.B['result.success'] then  //报工成功
                begin
                  frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+1);
                  frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+1);
                  RefreshWorkorder;
                  RefreshMaterials(gvConsumelist);
                end
              else
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！');
                end;
            end
          else if gvline_type='station' then    //工作站
            begin
              vO := SO(workticket_FINISH(gvWorkticket_id, gvApp_id, 1, vBadmode_lines));
              if vO.B['result.success'] then  //报工成功
                begin
                  frm_main.lbl_done_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_done_qty.Caption)+1);
                  frm_main.lbl_bad_qty.Caption:=IntToStr(StrToInt(frm_main.lbl_bad_qty.Caption)+1);
                  RefreshWorkorder;
                  RefreshMaterials;
                end
              else
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！', warn);
                end;
            end;
}
          log(DateTimeToStr(now())+', [TAG] 焊接前已焊末件数量'+IntToStr(uvLast_count));
          Inc(uvLast_count);
          log(DateTimeToStr(now())+', [TAG] 焊接后已焊末件数量'+IntToStr(uvLast_count)+'，要焊末件数量'+IntToStr(gvLast_count));
          if uvLast_count<gvLast_count then
            begin
              frm_main.InfoTips('成功完成'+IntToStr(uvLast_count)+'件末件，还要做'+IntToStr(uvLast_count-gvLast_count)+'件。',warn);
              Inc(uvLast_count);
            end
          else
            begin
              frm_main.spb_last.Down := False;
              if data_module.cds_inspect.RecordCount>0 then
                frm_Inspect.ShowModal
              else
                begin
                  frm_main.rdg_unproductive.ItemIndex := -1;
                  frm_main.InfoTips('末件检查记录没有设置，请联系管理员',warn);
                end;
              uvLast_count := 0;
            end;
        end;
      end;
      uvWeld_count := 0;
      //应做数量-合格数量-待报工数量<3提前提醒
      if gvInput_qty-StrToInt(frm_main.lbl_good_qty.Caption)-gvDoing_qty<6 then
        begin
          frm_main.InfoTips('恭喜!!!' + #13 + '就要做完成了注意');
        end;
    end;
end;

function Validity_check : Bool;
begin
  if gvline_type='flowing' then    //主线上
    begin
      //当前产线没有子工单
      if gvWorkorder_id <= 0 then
        begin
          frm_main.InfoTips('需要工单！' + #13 + '请先刷新工单，再操作！');
          Result := False;
          Exit;
        end;
      if gvProduct_id <= 0 then
        begin
          frm_main.InfoTips('需要选产品！' + #13 + '请先选择产品，再操作！');
          Result := False;
          Exit;
        end;
      if gvOutput_qty>gvInput_qty then
        begin
          frm_main.InfoTips('合格产品产品超出应做数量！');
          Result := False;
          Exit;
        end;
    end
  else if gvline_type='station' then    //工作站
    begin
      //当前工位没有子工单
      if gvWorkticket_id <= 0 then
        begin
          frm_main.InfoTips('需要工单！' + #13 + '请先扫描工单，再操作！');
          Result := False;
          Exit;
        end;
      if gvOutput_qty>gvInput_qty then
        begin
          frm_main.InfoTips('合格产品产品超出应做数量！');
          Result := False;
          Exit;
        end;
    end;
  //当前工位没有员工
  if gvStaff_code='' then
    begin
      frm_main.InfoTips('需要操作员！' + #13 + '请先扫员工条码，再操作！');
      Result := False;
      Exit;
    end;
  Result := True;
end;

procedure Operation_check;
begin
  if (gvStaff_code='') or (gvWorkorder_id<=0) then
    begin
      //Inc(uvTip_count);
      //if uvTip_count<4 then
        //begin
          if gvStaff_code='' then
            begin
              frm_main.InfoTips('当前没有操作员，请先扫条码，再操作机台！');
              //Application.MessageBox(PChar('当前没有操作员，请先扫操作工条码，再操作机台！'),'错误',MB_ICONERROR);
              Exit;
            end;
          if gvline_type='flowing' then    //主线上
            begin
              frm_main.InfoTips('当前没有工单，请先刷新工单，再操作机台!');
              //Application.MessageBox(PChar('当前没有工单，请先刷新工单，再操作机台！'),'错误',MB_ICONERROR);
              Exit;
            end
          else if gvline_type='station' then    //工作站
            begin
              frm_main.InfoTips('当前没有工单，请先刷新工单，再操作机台');
              //Application.MessageBox(PChar('当前没有工单，请先扫工单条码，再操作机台！'),'错误',MB_ICONERROR);
              Exit;
            end;
        //end;        //取消超过3次提示后不再提示
    end;
end;

procedure Get_InspectionList;
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
begin
  vO := SO(inspectionList);
  if vO.B['result.success'] then  //获取检验清单成功
    begin
      vA := vO.A['result.parameters'];
      if vA.Length>0 then
        begin
          gvProducttestid := vO.I['result.producttestid'];
          with data_module.cds_inspect do
            begin
              EmptyDataSet;
              FieldByName('name').ReadOnly := False;
              FieldByName('type').ReadOnly := False;
              FieldByName('code').ReadOnly := False;
              for i := 0 to vA.Length-1 do
                begin
                  Append;
                  vResult := SO(vA[i].AsString);
                  FieldByName('id').AsInteger := vResult.I['id'];
                  FieldByName('name').AsWideString := vResult.S['name'];
                  FieldByName('type').AsWideString := vResult.S['type'];
                  FieldByName('code').AsWideString := vResult.S['code'];
                  Post;
                end;
              FieldByName('name').ReadOnly := True;
              FieldByName('type').ReadOnly := True;
              FieldByName('code').ReadOnly := True;
              First;
            end;
        end
      else
        begin
          with data_module.cds_inspect do
            begin
              EmptyDataSet;
            end;
          log(DateTimeToStr(now())+', [INFO]检验清单记录为空！');
        end;
    end
  else
    begin
      with data_module.cds_inspect do
        begin
          EmptyDataSet;
        end;
      log(DateTimeToStr(now())+', [INFO]获取检验清单失败：'+vO.S['result.message']);
    end;
  //frm_Inspect.Caption := '安费诺宁德MES----';
  frm_Inspect.lbl_wo.Caption := gvWorkorder_name;
  frm_Inspect.lbl_product_code.Caption := gvFin_product_code;
  //frm_Inspect.lbl_input.Caption := FloatToStr(gvInput_qty);
end;

procedure Collection_Data(const fvFileName : String);
var
  vFile : TFileStream;
  vO : ISuperObject;
  lvDataJson, lvMdcJson, vTest_field, vTest_value,
  vTest_operator, vTest_SN_value, vTest_result_value, vData_type : String;
  vList, vData : TStringList;
  i, vP : integer;
begin
  vlist := TStringList.Create ;
  vData := TStringList.Create ;
  case frm_main.rdg_unproductive.ItemIndex of
  -1:    //正常生产的产量算作正常生产
    begin
      vData_type := 'production';
    end;
  0:     //调机的产量算作正常生产
    begin
      vData_type := 'debug';
    end;
  1:     //换型的产量算作正常生产
    begin
      vData_type := 'replace';
    end;
  2:     //首件的产量算作报废
    begin
      vData_type := 'first';
    end;
  3:     //抽检的产量算作报废
    begin
      vData_type := 'random';
    end;
  4:     //末件的产量算作报废
    begin
      vData_type := 'last';
    end;
  end;

  try
    case gvFile_type of
      0://普通文本文件
        begin
          log(DateTimeToStr(now())+', [INFO]开始打开文件：'+fvFileName);
          SplitStr(GetLastLine(fvFileName), gvDeli, gvCol_count, vData);
          if vData.Count>0 then
            begin
              Weld2yield;
              with data_module.cds_mdc do
                begin
                  try
                    Append;
                    if vData.Count<=gvHeader_list.Count then
                      begin
                        for i := 0 to vData.Count-1 do
                          begin
                            if gvHeader_list.ValueFromIndex[i]='String' then
                              FieldByName(gvHeader_list.Names[i]).AsWideString := vData.Strings[i]
                            else if gvHeader_list.ValueFromIndex[i]='Float' then
                              FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(vData.Strings[i])
                            else if gvHeader_list.ValueFromIndex[i]='Integer' then
                              FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(vData.Strings[i]);
                            if gvApp_testing then
                              begin
                                if gvHeader_list.Names[i]=gvTest_operator_field then vTest_operator := vData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_SN_field then vTest_SN_value := vData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_result_field then vTest_result_value := vData.Strings[i];
                              end;
                          end;
                      end
                    else
                      begin
                        for i := 0 to gvHeader_list.Count-1 do
                          begin
                            if gvHeader_list.ValueFromIndex[i]='String' then
                              FieldByName(gvHeader_list.Names[i]).AsWideString := vData.Strings[i]
                            else if gvHeader_list.ValueFromIndex[i]='Float' then
                              FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(vData.Strings[i])
                            else if gvHeader_list.ValueFromIndex[i]='Integer' then
                              FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(vData.Strings[i]);
                            if gvApp_testing then
                              begin
                                if gvHeader_list.Names[i]=gvTest_operator_field then vTest_operator := vData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_SN_field then vTest_SN_value := vData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_result_field then vTest_result_value := vData.Strings[i];
                              end;
                          end;
                      end;
                    Post;
                    log(DateTimeToStr(now())+', [INFO]完成插入clientdataset'+fvFileName);
                    if gvTest_operator_field<>'' then  //设置了操作员字段
                      begin
                        if gvStaff_code<>vTest_operator then   //采集到的操作员不在岗
                          begin
                            vO := SO(scanStaff('AM'+UpperCase(vTest_operator)));
                            if vO.B['result.success'] then  //扫码打卡成功
                              begin
                                RefreshStaff;
                              end
                            else  //扫码打卡失败
                              begin
                                log(DateTimeToStr(now())+', [INFO] 员工号【'+vTest_operator+'】上岗失败，错误信息：'+vO.S['result.message']);
                                frm_main.InfoTips('员工号【'+vTest_operator+'】上岗失败：'+vO.S['result.message']+'！');
                              end;
                          end;
                      end;
                    lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now), vData_type, gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'',vTest_SN_value,'',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                    TThread.CreateAnonymousThread(
                    procedure
                    var
                      Redis: IRedisClient;
                    begin
                      try
                        Redis := TRedisClient.Create(gvRedis_Host, gvRedis_Port);
                        Redis.Connect;
                        Redis.LPUSH(gvQueue_name, [lvMdcJson]);
                      finally
                        Redis := nil;
                      end;
                    end).Start;
                    gvSucceed:=gvSucceed+1;
                    frm_main.lbl_send_qty.Caption:=inttostr(gvSucceed);
                    //判断是否是测试机,如果是,则提交测试机数据
                    if gvApp_testing then
                      begin
                        if vTest_result_value=gvTest_pass_value then
                          begin
                            if testingRecord(vTest_SN_value, TRUE, vTest_result_value) then
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clGreen );
                              end
                            else
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clGreen );
                              end;
                          end
                        else
                          begin
                            if testingRecord(vTest_SN_value, FALSE, vTest_result_value) then
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clRed);
                              end
                            else
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clRed);
                              end;
                          end;
                        log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value+', 目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      end
                    else
                      begin
                        log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      end;
{自动首、末件，抽检数据采集
                    case frm_main.rdg_unproductive.ItemIndex of
                    2..4:    //首、末件，抽检数据采集
                      begin
                        vOInspect := SO(lvDataJson);
                        with data_module.cds_inspect do
                          begin
                            Filter := 'code<>''''';
                            Filtered := True;
                            if RecordCount>0 then
                              begin
                                First;
                                while not Eof do
                                  begin
                                    Edit;
                                    FieldByName('value').AsWideString := vOInspect.S[FieldByName('code').AsWideString];
                                    Post;
                                    Next;
                                  end;
                              end;
                            Filtered := False;
                          end;
                        frm_Inspect.Show;
                      end;
                    end;
}
                    Operation_check;
                  except on e:Exception do
                    begin
                      Delete;
                      gvFail:=gvFail+1;
                      frm_main.lbl_fail_qty.Caption:=inttostr(gvFail);
                      log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                    end;
                  end;
                end;
            end
          else
            begin
              log(DateTimeToStr(now())+', [FAIL] 没读到文件内容:'+fvFileName);
            end;
        end;
      1://扭矩焊文件
        begin
          vFile := TFileStream.Create(fvFileName, fmOpenRead);
          vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
          for i := gvBegin_row-1 to gvEnd_row-1 do
            begin
              vData.Add(vList[i]);
            end;
          log(DateTimeToStr(now())+', [INFO] 取得文件内容'+vData.Text);
          if vData.Count>0 then
            begin
              vO := XMLParseString(vData.Text,true);
              Weld2yield;
              log(DateTimeToStr(now())+', [INFO] 解析文件内容'+vO.AsString);
              if vO.asObject.Count>0 then
                begin
                  with data_module.cds_mdc do
                    begin
                      try
                        Append;
                        for i := 0 to gvHeader_list.Count-1 do
                          begin
                            if gvHeader_list.ValueFromIndex[i]='String' then
                              FieldByName(gvHeader_list.Names[i]).AsWideString := vO.S[gvHeader_list.Names[i]]
                            else if gvHeader_list.ValueFromIndex[i]='Float' then
                              FieldByName(gvHeader_list.Names[i]).AsFloat := vO.D[gvHeader_list.Names[i]]
                            else if gvHeader_list.ValueFromIndex[i]='Integer' then
                              FieldByName(gvHeader_list.Names[i]).AsInteger := vO.I[gvHeader_list.Names[i]];
                          end;
                        Post;
                        lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                        lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now), vData_type, gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                        TThread.CreateAnonymousThread(
                        procedure
                        var
                          Redis: IRedisClient;
                        begin
                          try
                            Redis := TRedisClient.Create(gvRedis_Host, gvRedis_Port);
                            Redis.Connect;
                            Redis.LPUSH(gvQueue_name, [lvMdcJson]);
                          finally
                            Redis := nil;
                          end;
                        end).Start;
                        gvSucceed:=gvSucceed+1;
                        frm_main.lbl_send_qty.Caption:=inttostr(gvSucceed);
                        log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
{自动首、末件，抽检数据采集
                        case frm_main.rdg_unproductive.ItemIndex of
                        2..4:    //首、末件，抽检数据采集
                          begin
                            vOInspect := SO(lvDataJson);
                            with data_module.cds_inspect do
                              begin
                                Filter := 'code<>''''';
                                Filtered := True;
                                if RecordCount>0 then
                                  begin
                                    First;
                                    while not Eof do
                                      begin
                                        Edit;
                                        FieldByName('value').AsWideString := vOInspect.S[FieldByName('code').AsWideString];
                                        Post;
                                        Next;
                                      end;
                                  end;
                                Filtered := False;
                              end;
                            frm_Inspect.Show;
                          end;
                        end;
}
                        Operation_check;
                      except on e:Exception do
                        begin
                          Delete;
                          gvFail:=gvFail+1;
                          frm_main.lbl_fail_qty.Caption:=inttostr(gvFail);
                          log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                        end;
                      end;
                    end;
                end;
            end
          else
            begin
              log(DateTimeToStr(now())+', [FAIL] 没读到文件内容:'+fvFileName);
            end;
        end;
      2://极柱焊文件
        begin
          vFile := TFileStream.Create(fvFileName, fmOpenRead);
          vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
          for i := gvBegin_row-1 to gvEnd_row-1 do
            begin
              vData.Add(vList[i]);
            end;
          log(DateTimeToStr(now())+', [INFO] 取得文件内容'+vData.Text);
          if vData.Count>0 then
            begin
              Weld2yield;
              with data_module.cds_mdc do
                begin
                  try
                    Append;
                    for i := 0 to gvHeader_list.Count-1 do
                      begin
                        if gvHeader_list.ValueFromIndex[i]='String' then
                          FieldByName(gvHeader_list.Names[i]).AsWideString := vData.Strings[i]
                        else if gvHeader_list.ValueFromIndex[i]='Float' then
                          FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(vData.Strings[i])
                        else if gvHeader_list.ValueFromIndex[i]='Integer' then
                          FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(vData.Strings[i]);
                      end;
                    Post;
                    lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now), vData_type, gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                    TThread.CreateAnonymousThread(
                    procedure
                    var
                      Redis: IRedisClient;
                    begin
                      try
                        Redis := TRedisClient.Create(gvRedis_Host, gvRedis_Port);
                        Redis.Connect;
                        Redis.LPUSH(gvQueue_name, [lvMdcJson]);
                      finally
                        Redis := nil;
                      end;
                    end).Start;
                    gvSucceed:=gvSucceed+1;
                    frm_main.lbl_send_qty.Caption:=inttostr(gvSucceed);
                    log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
{自动首、末件，抽检数据采集
                    case frm_main.rdg_unproductive.ItemIndex of
                    2..4:    //首、末件，抽检数据采集
                      begin
                        vOInspect := SO(lvDataJson);
                        with data_module.cds_inspect do
                          begin
                            Filter := 'code<>''''';
                            Filtered := True;
                            if RecordCount>0 then
                              begin
                                First;
                                while not Eof do
                                  begin
                                    Edit;
                                    FieldByName('value').AsWideString := vOInspect.S[FieldByName('code').AsWideString];
                                    Post;
                                    Next;
                                  end;
                              end;
                            Filtered := False;
                          end;
                        frm_Inspect.Show;
                      end;
                    end;
}
                    Operation_check;
                  except on e:Exception do
                    begin
                      Delete;
                      gvFail:=gvFail+1;
                      frm_main.lbl_fail_qty.Caption:=inttostr(gvFail);
                      log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                    end;
                  end;
                end;
            end
          else
            begin
              log(DateTimeToStr(now())+', [FAIL] 没读到文件内容:'+fvFileName);
            end;
        end;
      3://测试机2文件
        begin
          Sleep (gvDelay);
          vFile := TFileStream.Create(fvFileName, fmOpenRead);
          vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
          for i := gvBegin_row-1 to gvEnd_row-1 do
            begin
              vData.Add(vList[i]);
            end;
          log(DateTimeToStr(now())+', [INFO] 取得文件内容'+vData.Text);
          if vData.Count>0 then
            begin
              Weld2yield;
              with data_module.cds_mdc do
                begin
                  try
                    Append;
                    for i := 0 to vData.Count-1 do
                      begin
                        vP := PosEx(#9,vData.Strings[i]);
                        vTest_field := Copy(vData.Strings[i],1, vP-1);
                        vTest_value := Copy(vData.Strings[i],vP+1, Length(vData.Strings[i]));
                        if vTest_field=gvTest_operator_field then vTest_operator := vTest_value;
                        if vTest_field=gvTest_SN_field then vTest_SN_value := vTest_value;
                        if vTest_field=gvTest_result_field then vTest_result_value := vTest_value;
                        FieldByName(vTest_field).AsWideString := vTest_value;
                      end;
                    Post;
                    if gvTest_operator_field<>'' then  //设置了操作员字段
                      begin
                        if gvStaff_code<>vTest_operator then   //采集到的操作员不在岗
                          begin
                            vO := SO(scanStaff('AM'+UpperCase(vTest_operator)));
                            if vO.B['result.success'] then  //扫码打卡成功
                              begin
                                RefreshStaff;
                              end
                            else  //扫码打卡失败
                              begin
                                log(DateTimeToStr(now())+', [INFO] 员工号【'+vTest_operator+'】上岗失败，错误信息：'+vO.S['result.message']);
                                frm_main.InfoTips('员工号【'+vTest_operator+'】上岗失败：'+vO.S['result.message']+'！');
                              end;
                          end;
                      end;
                    lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now), vData_type, gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'',vTest_SN_value,'',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                    TThread.CreateAnonymousThread(
                    procedure
                    var
                      Redis: IRedisClient;
                    begin
                      try
                        Redis := TRedisClient.Create(gvRedis_Host, gvRedis_Port);
                        Redis.Connect;
                        Redis.LPUSH(gvQueue_name, [lvMdcJson]);
                      finally
                        Redis := nil;
                      end;
                    end).Start;
                    gvSucceed:=gvSucceed+1;
                    frm_main.lbl_send_qty.Caption:=inttostr(gvSucceed);
                    log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value+'目前总共提交成功'+inttostr(gvSucceed)+'条。');
                    if vTest_result_value=gvTest_pass_value then
                      begin
                        if testingRecord(vTest_SN_value, TRUE, vTest_result_value) then
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clGreen);
                          end
                        else
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clGreen);
                          end;
                      end
                    else
                      begin
                        if testingRecord(vTest_SN_value, FALSE, vTest_result_value) then
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clRed);
                          end
                        else
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value, clRed);
                          end;
                      end;
{自动首、末件，抽检数据采集
                    case frm_main.rdg_unproductive.ItemIndex of
                    2..4:    //首、末件，抽检数据采集
                      begin
                        vOInspect := SO(lvDataJson);
                        with data_module.cds_inspect do
                          begin
                            Filter := 'code<>''''';
                            Filtered := True;
                            if RecordCount>0 then
                              begin
                                First;
                                while not Eof do
                                  begin
                                    Edit;
                                    FieldByName('value').AsWideString := vOInspect.S[FieldByName('code').AsWideString];
                                    Post;
                                    Next;
                                  end;
                              end;
                            Filtered := False;
                          end;
                        frm_Inspect.Show;
                      end;
                    end;
}
                    Operation_check;
                  except on e:Exception do
                    begin
                      Delete;
                      gvFail:=gvFail+1;
                      frm_main.lbl_fail_qty.Caption:=inttostr(gvFail);
                      log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                    end;
                  end;
                end;
            end
          else
            begin
              log(DateTimeToStr(now())+', [FAIL] 没读到文件内容:'+fvFileName);
            end;
        end;
    end;
  finally
    vFile.Free;
    vlist.Destroy;
    vdata.Destroy;
  end;
end;

procedure Tfrm_main.dbg_workorderDblClick(Sender: TObject);
begin
  if gvDoing_qty = 0 then
    begin
      if dbg_workorder.DataSource.DataSet.RecNo>0 then
        begin
          gvWorkorder_rowno := dbg_workorder.DataSource.DataSet.RecNo;
          lbl_wo.Caption := gvWorkorder_name;
          with data_module.cds_workorder do
            begin
              gvProduct_id := FieldByName('product_id').AsInteger;
              gvProduct_code := FieldByName('product_code').AsWideString;
              lbl_product_code.Caption := gvProduct_code;
              lbl_todo_qty.Caption := FieldByName('input_qty').AsString;
              // := FieldByName('todo_qty').AsFloat;
              gvOutput_qty := FieldByName('output_qty').AsCurrency;
              lbl_good_qty.Caption := FloatToStr(gvOutput_qty);
              lbl_done_qty.Caption := FieldByName('actual_qty').AsString;
              lbl_bad_qty.Caption := FieldByName('badmode_qty').AsString;
              gvWeld_count := FieldByName('weld_count').AsInteger;
              lbl_weld_count.Caption := IntToStr(gvWeld_count);
              gvConsumelist := '{"consumelist":' + FieldByName('materiallist').AsString + '}';
            end;
          RefreshMaterials(gvConsumelist);
        end;
    end
  else
    begin
      if gvProduct_code = '' then
        begin
          if dbg_workorder.DataSource.DataSet.RecNo>0 then
            begin
              gvWorkorder_rowno := dbg_workorder.DataSource.DataSet.RecNo;
              lbl_wo.Caption := gvWorkorder_name;
              with data_module.cds_workorder do
                begin
                  gvProduct_id := FieldByName('product_id').AsInteger;
                  gvProduct_code := FieldByName('product_code').AsString;
                  lbl_product_code.Caption := gvProduct_code;
                  lbl_todo_qty.Caption := FieldByName('input_qty').AsString;
                  gvOutput_qty := FieldByName('output_qty').AsCurrency;
                  lbl_good_qty.Caption := FloatToStr(gvOutput_qty);
                  lbl_done_qty.Caption := FieldByName('actual_qty').AsString;
                  lbl_bad_qty.Caption := FieldByName('badmode_qty').AsString;
                  gvWeld_count := FieldByName('weld_count').AsInteger;
                  lbl_weld_count.Caption := IntToStr(gvWeld_count);
                  gvConsumelist := '{"consumelist":' + FieldByName('materiallist').AsString + '}';
                end;
              RefreshMaterials(gvConsumelist);
            end;
        end
      else
        begin
          if gvWorkorder_rowno <> dbg_workorder.DataSource.DataSet.RecNo then
            begin
              frm_main.InfoTips('有待报工数量为:'+IntToStr(gvDoing_qty)+'，请先报工再切换工单！');
              Exit;
            end;
        end;
    end;
  if gvWorkorder_rowno>0 then
    frm_main.lbl_wo_row.Caption := ' ' + IntToStr(gvWorkorder_rowno) + ' '
  else
    frm_main.lbl_wo_row.Caption := ' 0 ';
end;

procedure Tfrm_main.dbg_workorderDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if ((State = [gdSelected]) or (State=[gdSelected,gdFocused])) then
      begin
        dbg_workorder.Canvas.Font.Color :=ClYellow;
        dbg_workorder.Canvas.Brush.Color :=clblue;  //关键
        dbg_workorder.DefaultDrawColumnCell(Rect,DataCol,Column,State);
   end;
end;

procedure Tfrm_main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := False;
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
  ini_set := TMemIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'), TEncoding.UTF8);
  //获取INI中的General配置信息
  gvFirst_count := ini_set.ReadInteger('general', 'first_count', gvFirst_count);
  gvRandom_count := ini_set.ReadInteger('general', 'random_count', gvRandom_count);
  gvLast_count := ini_set.ReadInteger('general', 'last_count', gvLast_count);

  //获取ini中的server配置信息
  gvUse_Proxy := ini_set.ReadBool('server', 'use_proxy', gvUse_Proxy);
  gvDatabase := ini_set.ReadString('server', 'databse', gvDatabase);
  gvServer_Host := ini_set.ReadString('server', 'host', gvServer_Host);
  gvServer_Port := ini_set.ReadInteger('server', 'port', gvServer_Port);

  //取设备设置信息
  gvApp_code := ini_set.ReadString('equipment', 'app_code', gvApp_code);
  gvApp_secret := ini_set.ReadInteger('equipment', 'app_secret', gvApp_secret);
  gvApp_testing := ini_set.ReadBool('equipment', 'app_testing', gvApp_testing);
  gvTest_operator_field := ini_set.ReadString('equipment', 'test_operator_field', gvTest_operator_field);
  gvTest_SN_field := ini_set.ReadString('equipment', 'test_sn_field', gvTest_SN_field);
  gvTest_result_field := ini_set.ReadString('equipment', 'test_result_field', gvTest_result_field);
  gvTest_pass_value := ini_set.ReadString('equipment', 'test_pass_value', gvTest_pass_value);

  //取Redis服务器信息
  gvQueue_name := ini_set.ReadString('redis', 'queue_name', gvQueue_name);

  //取采集文件信息
  gvData_path := ini_set.ReadString('collection', 'data_path', gvData_path);
  gvSubfolder := ini_set.ReadBool('collection', 'subfolder', gvSubfolder);
  gvFile_type := ini_set.ReadInteger('collection', 'file_type', gvFile_type);
  gvMonitor_type := ini_set.ReadString('collection', 'monitor_type', gvMonitor_type);
  gvTemplate_file := ini_set.ReadString('collection', 'template_file', gvTemplate_file);
  gvHeader_row := ini_set.ReadInteger('collection', 'header_row', gvHeader_row);
  gvBegin_row := ini_set.ReadInteger('collection', 'begin_row', gvBegin_row);
  gvEnd_row := ini_set.ReadInteger('collection', 'end_row', gvEnd_row);
  gvDelay := ini_set.ReadInteger('collection', 'delay', gvDelay);
  gvDelimiter := ini_set.ReadString('collection', 'delimiter', gvDelimiter);
  if gvDelimiter='Tab' then
    gvDeli := #9
  else if gvDelimiter='分号' then
    gvDeli := ';'
  else if gvDelimiter='逗号' then
    gvDeli := ','
  else if gvDelimiter='空格' then
    gvDeli := ' ';
  gvHeader_lines := ini_set.ReadString('collection', 'header_lines', gvHeader_lines);
  gvPrimary_key := ini_set.ReadString('collection', 'primary_key', gvPrimary_key);
  gvCol_count := ini_set.ReadInteger('collection', 'col_count', gvCol_count);

  //获取用户信息
  gvSave_PWD := ini_set.ReadBool('profile', 'save_pwd', gvSave_PWD);
  gvUserName := ini_set.ReadString('profile', 'user_name', gvUserName);
  gvPassword := ini_set.ReadString('profile', 'password', gvPassword);
  gvPrinter_id := ini_set.ReadInteger('profile', 'printer_id', gvPrinter_id);
  gvPrinter_name := ini_set.ReadString('profile', 'printer_name', gvPrinter_name);

  //
  gvWorkorder_barcode := ini_set.ReadString('job', 'workorder', gvWorkorder_barcode);
  gvDoing_qty := ini_set.ReadInteger('job', 'doing_qty', gvDoing_qty);

  //实例化文件监控控件
  OxygenDirectorySpy1 := TOxygenDirectorySpy.Create(Self);
  OxygenDirectorySpy1.WatchSubTree := gvSubfolder;
  OxygenDirectorySpy1.OnChangeDirectory := OxygenDirectorySpy1ChangeDirectory;

  //将主窗口里字段置空
  lbl_equipment.Caption := '无';
  lbl_line.Caption := '无';
  lbl_station.Caption := '无';
  SendMessage(lbx_log.Handle, LB_SETHORIZONTALEXTENT, lbx_log.Width + 200, 0);
end;

procedure Tfrm_main.FormDestroy(Sender: TObject);
begin
  ini_set.WriteBool('server', 'use_proxy', gvUse_Proxy);
  if Length(Trim(gvDatabase))>0 then ini_set.WriteString('server', 'databse', gvDatabase);
  if Length(Trim(gvServer_Host))>0 then ini_set.WriteString('server', 'host', gvServer_Host);
  if gvServer_Port>0 then ini_set.Writeinteger('server', 'port', gvServer_Port);
  //写入基本设置信息
  if gvFirst_count>0 then ini_set.Writeinteger('general', 'first_count', gvFirst_count);
  if gvRandom_count>0 then ini_set.Writeinteger('general', 'random_count', gvRandom_count);
  if gvLast_count>0 then ini_set.Writeinteger('general', 'last_count', gvLast_count);
  ini_set.UpdateFile;
  ini_set.Destroy;
end;

procedure Tfrm_main.FormKeyPress(Sender: TObject; var Key: Char);
const
  vInputLen = 6;
var
  vFinish: DWORD;
  vO: ISuperObject;
begin
  if uvMInput = '' then uvMStart := GetTickCount();
  if (Length(uvMInput) >= vInputLen) AND (Key=#13) then
    begin
      vFinish := GetTickCount();
      if (vFinish - uvMStart) / Length(uvMInput) < 100 then
        begin
          uvMInput := UpperCase(uvMInput);
          if copy(uvMInput,1,2)='AM' then  //扫描到的是职员
            begin
              vO := SO(scanStaff(uvMInput));
              if vO.B['result.success'] then  //扫码打卡成功
                begin
                  RefreshStaff;
                end
              else  //扫码打卡失败
                begin
                  log(DateTimeToStr(now())+', [INFO] 员工号【'+copy(uvMInput,3,Length(uvMInput)-2)+'】扫码打卡失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('员工号【'+copy(uvMInput,3,Length(uvMInput)-2)+'】扫码打卡失败：'+vO.S['result.message']+'！');
                  //Application.MessageBox(PChar('员工号【'+copy(uvMInput,3,Length(uvMInput)-2)+'】扫码打卡失败：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
                end;
            end;
          if copy(uvMInput,1,2)='AQ' then  //扫描到的是工单
            begin
              if gvline_type='station' then    //工作站
                begin
                  if gvDoing_qty>0 then
                    begin
                      if gvProduct_code = '' then
                        begin
                          gvWorkorder_barcode:= uvMInput;
                          RefreshWorkorder;
                          RefreshMaterials;   //扫描到工单后刷新材料信息
                          RefreshStaff;
                        end
                      else
                        frm_main.InfoTips('有待报工数量为:'+IntToStr(gvDoing_qty)+'，请先报工再切换工单！',warn);
                    end
                  else
                    begin
                      gvWorkorder_barcode:= uvMInput;
                      RefreshWorkorder;
                      RefreshMaterials;   //扫描到工单后刷新材料信息
                      RefreshStaff;
                    end;
                end
              else
                begin
                  frm_main.InfoTips('此工位不接受【'+copy(uvMInput,3,Length(uvMInput)-2)+'】工单！',warn);
                end;
            end;
          if (copy(uvMInput,1,2)='AC') OR (copy(uvMInput,1,2)='AT') then  //扫描到的是物料
            begin
              vO := SO(feedMaterial(uvMInput));
              if vO.B['result.success'] then  //扫码上料成功
                begin
                  if gvline_type='flowing' then RefreshMaterials(gvConsumelist)
                  else RefreshMaterials;
                  frm_main.InfoTips('物料标签号【'+uvMInput+'】上料成功！',right);
                  //Application.MessageBox(PChar('[INFO] 物料标签号【'+uvMInput+'】上料成功！'),'提示信息',MB_ICONINFORMATION);
                  log(DateTimeToStr(now())+', [INFO] 物料标签号【'+uvMInput+'】上料成功，返回【'+vO.AsObject.S['result']);
                end
              else  //扫码上料失败
                begin
                  log(DateTimeToStr(now())+', [ERROR] 物料标签号【'+uvMInput+'】上料失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('物料标签号【'+uvMInput+'】上料失败：'+vO.S['result.message']+'！');
                  //Application.MessageBox(PChar(' 物料标签号【'+uvMInput+'】上料失败：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
                end;
            end;
        end
      else
        log(DateTimeToStr(now())+', [ERROR] 错误输入:' + uvMInput);
      uvMInput := '';
    end
  else
    begin
      uvMInput := uvMInput + Key;
    end;
end;

procedure Tfrm_main.FormShow(Sender: TObject);
begin
  if gvCol_count>0 then
    DataCollectionCDS(gvHeader_lines, gvPrimary_key, gvDeli)
  else
    begin
      frm_main.InfoTips('数据采集模板没有设置，请联系管理员设置！');
      frm_set.ShowModal;
      frm_set.tbs_collection.Show;
    end;
  WorkorderInfoCDS;
  MaterialsInfoCDS;
  BadmodeCDS;
  MESLineCDS;
  ReplaceWOCDS;
  PrinterCDS;
  StationCDS;
  InspectCDS;
  RefreshEquipment;
  RefreshWorkorder;
  RefreshMaterials;
  RefreshStaff;
  tbs_wo.Show;
  tbs_workorder.Show;
  if gvDoing_qty>0 then
    begin
      lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
    end;

  //测试机不显示料单页签和报工按钮
  tbs_workorder.TabVisible:=Not gvApp_testing;
  spb_submit.Visible:=Not gvApp_testing;
  if gvApp_testing then
    begin
      lbl_tag_doing_qty.Caption:='已测：';
      spb_debug.GroupIndex := 0;
      spb_debug.Enabled := False;
      spb_replace.GroupIndex := 0;
      spb_replace.Enabled := False;
      spb_first.GroupIndex := 0;
      spb_random.GroupIndex := 0;
      spb_random.Enabled := False;
      spb_last.GroupIndex := 0;
    end
  else
    begin
      lbl_tag_doing_qty.Caption:='待报：';
      spb_debug.GroupIndex := 1;
      spb_debug.Enabled := True;
      spb_replace.GroupIndex := 1;
      spb_replace.Enabled := True;
      spb_first.GroupIndex := 1;
      spb_random.GroupIndex := 1;
      spb_random.Enabled := True;
      spb_last.GroupIndex := 1;
    end;
  if DirectoryExists(gvData_path) then
     begin
        with OxygenDirectorySpy1 do begin
          Enabled := False;
          Directories.Add(gvData_path);
          Enabled := True;
        end;
     end
  else
    begin
      frm_main.InfoTips('数据采集目录没有设置，请联系管理员设置！');
      //Application.MessageBox(PChar('数据采集目录没有设置，请联系管理员设置！'),'错误',MB_ICONERROR);
      frm_set.ShowModal;
      frm_set.tbs_collection.Show;
    end;
end;

procedure Tfrm_main.lbl_lineDblClick(Sender: TObject);
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
begin
  if gvDoing_qty = 0 then
    begin
      vO := SO(queryMESLine);
      if vO.B['result.success'] then  //获取产线信息成功
        begin
          vA := vO.A['result.records'];
          if vA.Length>0 then
            begin
              with data_module.cds_mesline do
                begin
                  EmptyDataSet;
                  for i := 0 to vA.Length-1 do
                    begin
                      vResult := SO(vA[i].AsString);
                      if vResult.S['mesline_type']=gvline_type then
                        begin
                          Append;
                          FieldByName('mesline_id').AsInteger := vResult.I['mesline_id'];
                          FieldByName ('mesline_name').AsWideString := vResult.S['mesline_name'];
                          FieldByName('mesline_type').AsWideString := vResult.S['mesline_type'];
                          FieldByName('stationlist').AsWideString := vResult.S['stationlist'];
                          Post;
                        end;
                    end;
                  frm_MESLine.dlc_mesline.KeyValue := gvMESLine_id;
                end;
              frm_MESLine.lbl_line.Caption := gvMESLine_name;
              frm_MESLine.lbl_station.Caption := gvWorkstation_name;
              frm_MESLine.Show;
            end
          else
            begin
              frm_main.InfoTips('MES还没有生产线，请联系管理员');
              log(DateTimeToStr(now())+', [INFO] MES还没有生产线，请联系管理员');
            end;
        end
      else
        begin
          with data_module.cds_badmode do
            begin
              EmptyDataSet;
            end;
          frm_main.InfoTips('获取生产线信息失败:'+vO.S['result.message']);
          log(DateTimeToStr(now())+', [INFO] 获取生产线信息失败:'+vO.S['result.message']);
        end;
    end
  else
    begin
      if gvWorkorder_rowno <> dbg_workorder.DataSource.DataSet.RecNo then
        begin
          frm_main.InfoTips('待报工数量为:'+IntToStr(gvDoing_qty)+'，不能切换产线！');
          Exit;
        end;
    end;
end;

procedure Tfrm_main.lbl_tag_equipmentDblClick(Sender: TObject);
begin
  frm_set.ShowModal;
end;

procedure Tfrm_main.lbl_woDblClick(Sender: TObject);
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
begin
  if gvline_type='flowing' then    //主线上
    begin
      if gvDoing_qty <> 0 then
        begin
          frm_main.InfoTips('待报工数量为:'+IntToStr(gvDoing_qty)+'，不能切换工单！');
          Exit;
        end;
      if Validity_check then
        begin
          vO := SO(getLineWorkorder);
          if vO.B['result.success'] then  //获取产线信息成功
            begin
              vA := vO.A['result.orderlist'];
              if vA.Length>0 then
                begin
                  with data_module.cds_replacewo do
                    begin
                      EmptyDataSet;
                      for i := 0 to vA.Length-1 do
                        begin
                          vResult := SO(vA[i].AsString);
                          Append;
                          FieldByName('order_id').AsInteger := vResult.I['order_id'];
                          FieldByName ('order_name').AsWideString := vResult.S['order_name'];
                          FieldByName('product_code').AsWideString := vResult.S['product_code'];
                          FieldByName('input_qty').AsFloat := vResult.C['input_qty'];
                          Post;
                        end;
                    end;
                  frm_ReplaceWO.lbl_now_wo.Caption := gvWorkorder_name;
                  frm_ReplaceWO.lbl_now_product.Caption := gvProduct_code;
                  frm_ReplaceWO.lbl_now_input.Caption := lbl_todo_qty.Caption;
                  frm_ReplaceWO.Show;
                end
              else
                begin
                  frm_main.InfoTips('没有可切换的工单，请联系管理员', warn);
                  log(DateTimeToStr(now())+', [INFO] 没有可切换的工单，请联系管理员');
                end;
            end
          else
            begin
              with data_module.cds_replacewo do
                begin
                  EmptyDataSet;
                end;
              frm_main.InfoTips('获取生产线工单失败:'+vO.S['result.message']);
              log(DateTimeToStr(now())+', [INFO] 获取生产线工单失败:'+vO.S['result.message']);
            end;
        end;
    end;
end;

procedure Tfrm_main.OxygenDirectorySpy1ChangeDirectory(Sender: TObject; ChangeRecord: TDirectoryChangeRecord);
var
  vFileName: String;
  vDirSpy : TStringList;
begin
  vDirSpy := TStringList.Create ;
  try
    log(DateTimeToStr(now())+', [INFO] '+ChangeRecord2String(ChangeRecord));
    vDirSpy.Delimiter := '|';
    vDirSpy.StrictDelimiter := True;
    vDirSpy.DelimitedText := ChangeRecord2String(ChangeRecord);
    vFileName:=vDirSpy.Strings[1];
    //vPath:=ChangeFileExt(ExtractFileName(vFileName),'');
    if POS(vDirSpy.Strings[2],gvMonitor_type)>0 then
      begin
        Collection_Data(vFileName);
      end;
  finally
    vDirSpy.Destroy;
  end;
end;

procedure Tfrm_main.spb_debugClick(Sender: TObject);
begin
  if gvDoing_qty > 0 then
    begin
      frm_main.InfoTips('待报工数量为'+IntToStr(gvDoing_qty)+'，请先报工。'+#13+'再做调机！');
      if spb_debug.Down then spb_debug.Down := False else spb_debug.Down := True;
      Exit;
    end;
  if spb_debug.Down then rdg_unproductive.ItemIndex := 0 else rdg_unproductive.ItemIndex := -1;
end;

procedure Tfrm_main.spb_replaceClick(Sender: TObject);
begin
  if gvDoing_qty > 0 then
    begin
      frm_main.InfoTips('待报工数量为'+IntToStr(gvDoing_qty)+'，请先报工。'+#13+'再做换型！');
      if spb_replace.Down then spb_replace.Down := False else spb_replace.Down := True;
      Exit;
    end;
  if Validity_check then
    if spb_replace.Down then rdg_unproductive.ItemIndex := 1 else rdg_unproductive.ItemIndex := -1
  else
    if spb_replace.Down then spb_replace.Down := False else spb_replace.Down := True;
end;

procedure Tfrm_main.spb_firstClick(Sender: TObject);
begin
  if gvApp_testing then
    begin
      if Validity_check then
        begin
          rdg_unproductive.ItemIndex := 2;
          gvInspect_type := 'firstone';
          Get_InspectionList;
          if data_module.cds_inspect.RecordCount>0 then
            frm_Inspect.ShowModal
          else
            begin
              frm_main.rdg_unproductive.ItemIndex := -1;
              frm_main.InfoTips('首件检查记录没有设置，请联系管理员',warn);
            end;
        end;
    end
  else
    begin
      frm_main.lbl_tag_count.Caption:=IntToStr(gvFirst_count);
      frm_main.lbl_tag_qty.Caption:=IntToStr(uvFirst_count);
      if gvDoing_qty > 0 then
        begin
          frm_main.InfoTips('待报工数量为'+IntToStr(gvDoing_qty)+'，请先报工。'+#13+'再做首件！');
          if spb_first.Down then spb_first.Down := False else spb_first.Down := True;
          Exit;
        end;
      if Validity_check then
        if spb_first.Down then
          begin
            rdg_unproductive.ItemIndex := 2;
            gvInspect_type := 'firstone';
            log(DateTimeToStr(now())+', [TAG] 按下首件按钮');
            Get_InspectionList;
          end
        else rdg_unproductive.ItemIndex := -1
      else
        if spb_first.Down then spb_first.Down := False else spb_first.Down := True;
    end;
end;

procedure Tfrm_main.spb_randomClick(Sender: TObject);
begin
  if Validity_check then
    if spb_random.Down then
      begin
        rdg_unproductive.ItemIndex := 3;
        gvInspect_type := 'random';
        log(DateTimeToStr(now())+', [TAG] 按下抽检按钮');
        Get_InspectionList;
      end
    else rdg_unproductive.ItemIndex := -1
  else
    if spb_random.Down then spb_random.Down := False else spb_random.Down := True;
end;

procedure Tfrm_main.spb_lastClick(Sender: TObject);
begin
  if gvApp_testing then
    begin
      if Validity_check then
        begin
          rdg_unproductive.ItemIndex := 4;
          gvInspect_type := 'lastone';
          Get_InspectionList;
          if data_module.cds_inspect.RecordCount>0 then
            frm_Inspect.ShowModal
          else
            begin
              frm_main.rdg_unproductive.ItemIndex := -1;
              frm_main.InfoTips('末件检查记录没有设置，请联系管理员',warn);
            end;
        end;
    end
  else
    begin
      if gvDoing_qty > 0 then
        begin
          frm_main.InfoTips('待报工数量为'+IntToStr(gvDoing_qty)+'，请先报工。'+#13+'再做末件！');
          if spb_last.Down then spb_last.Down := False else spb_last.Down := True;
          Exit;
        end;
      if Validity_check then
        if spb_last.Down then
          begin
            rdg_unproductive.ItemIndex := 4;
            gvInspect_type := 'lastone';
            log(DateTimeToStr(now())+', [TAG] 按下末件按钮');
            Get_InspectionList;
          end
        else rdg_unproductive.ItemIndex := -1
      else
        if spb_last.Down then spb_last.Down := False else spb_last.Down := True;
    end;
end;

procedure Tfrm_main.spb_refreshClick(Sender: TObject);
begin
  RefreshEquipment;
  RefreshWorkorder;
  RefreshMaterials;
  RefreshStaff;
end;

procedure Tfrm_main.spb_startClick(Sender: TObject);
var
  vO: ISuperObject;
begin
  vO := SO(workticket_START(gvWorkticket_id, gvApp_id));
  if vO.B['result.success'] then
    begin
      RefreshWorkorder;
      log(DateTimeToStr(now())+', [INFO] '+gvWorkorder_name+'工单开工成功，开工人：'+gvStaff_code);
    end
  else
    begin
      frm_main.InfoTips(gvWorkorder_name+'工单开工失败:'+vO.S['result.message']);
      log(DateTimeToStr(now())+', [INFO] '+gvWorkorder_name+'工单开工失败:'+vO.S['result.message']);
    end;
end;

procedure Tfrm_main.spb_submitClick(Sender: TObject);
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
begin
  RefreshStaff;
  if gvDoing_qty = 0 then
    begin
      frm_main.InfoTips('待报工数量为0，不能报工！');
      Exit;
    end;
  log(DateTimeToStr(now())+', [INFO]报工开始');
  if Validity_check then
    begin
      vO := SO(queryBadmode);
      if vO.B['result.success'] then  //获取不良模式成功
        begin
          vA := vO.A['result.badmodelist'];
          if vA.Length>0 then
            begin
              with data_module.cds_badmode do
                begin
                  EmptyDataSet;
                  FieldByName('badmode_name').ReadOnly := False;
                  for i := 0 to vA.Length-1 do
                    begin
                      Append;
                      vResult := SO(vA[i].AsString);
                      FieldByName('badmode_id').AsInteger := vResult.I['badmode_id'];
                      FieldByName('badmode_name').AsWideString := vResult.S['badmode_name'];
                      FieldByName('badmode_qty').AsInteger := 0;
                      Post;
                    end;
                  FieldByName('badmode_name').ReadOnly := True;
                  Aggregates.Items[0].OnUpdate:=data_module.cds_badmodeAggregates0Update;
                end;
            end
          else
            begin
              with data_module.cds_badmode do
                begin
                  EmptyDataSet;
                end;
              log(DateTimeToStr(now())+', [INFO]不良模式记录为空！');
            end;
        end
      else
        begin
          with data_module.cds_badmode do
            begin
              EmptyDataSet;
            end;
          log(DateTimeToStr(now())+', [INFO]获取不良模式失败：'+vO.S['result.message']);
        end;
      frm_finish.lbl_product_code.Caption := gvProduct_code;
      frm_finish.lbl_doing_qty.Caption := IntToStr(gvDoing_qty);
      frm_finish.spn_ignore.MaxValue := gvDoing_qty;
      frm_finish.spn_submit.MaxValue := gvDoing_qty;
      frm_finish.spn_submit.MinValue := 0;
      frm_finish.spn_submit.Value := gvDoing_qty;
      if gvline_type='flowing' then    //主线上
        begin
          frm_finish.lbl_tag_container.Visible := False;
          frm_finish.lbl_container.Visible := False;
          frm_finish.spn_submit.Enabled := False;
          frm_finish.spn_submit.Color := clBtnFace;
          frm_finish.Show;
        end
      else if gvline_type='station' then    //工作站
        begin
          if gvLastworkcenter and (gvOutput_manner='container') then    //如果是最后一道工序报工需要扫描容器或者产出标签
            begin
              frm_container.Show;
            end
          else
            begin
              frm_finish.Show;
            end;
        end;
    end;
end;

procedure Tfrm_main.tim_cleartipsTimer(Sender: TObject);
begin

  lbl_tip.Caption := '';
  Self.Color := clBtnFace;
  tbs_wo.Show;
  tim_cleartips.Enabled := False;
end;

//stb_tipsbar.Panels[1].Text:= FormatDateTime('yyyy"年"m"月"d"日"hh:nn:ss',now);
end.
