﻿unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, O2DirSpy, Redis.Client, Redis.Commons, Redis.Values,
  Redis.NetLib.Factory, Redis.NetLib.INDY, sliderPanel;

type
  Tfrm_main = class(TForm)
    pnl_top: TPanel;
    pnl_middle: TPanel;
    PageControl1: TPageControl;
    tbs_collection: TTabSheet;
    tbs_log: TTabSheet;
    lbx_log: TListBox;
    dbg_collection: TDBGrid;
    pnl_collection: TPanel;
    lbl_tag_send_qty: TLabel;
    lbl_send_qty: TLabel;
    lbl_tag_fail_qty: TLabel;
    lbl_fail_qty: TLabel;
    lbl_equipment_state: TLabel;
    shp_equipment_state: TShape;
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
    lbl_tag_title: TLabel;
    pnl_workorder: TPanel;
    lbl_tag_workorder: TLabel;
    Splitter1: TSplitter;
    pnl_materiel: TPanel;
    lbl_tag_materiel: TLabel;
    dbg_workorder: TDBGrid;
    dbg_materiel: TDBGrid;
    spb_submit: TSpeedButton;
    spb_refresh: TSpeedButton;
    lbl_tag_state: TLabel;
    lbl_state: TLabel;
    spb_start: TSpeedButton;
    lbl_tag_weld_count: TLabel;
    lbl_weld_count: TLabel;
    pnl_tipsbar: TPanel;
    tim_cleartips: TTimer;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure spb_startClick(Sender: TObject);
    procedure spb_submitClick(Sender: TObject);
    procedure InfoTips(fvContent : String; fvColor : TColor = clRed);
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

var
  frm_main: Tfrm_main;
  uvTip_count : Integer = 0;
  uvWeld_count : Integer = 0;
  uvList, uvData, uvDirSpy : TStringList;
  uvInput : String = '';
  uvStart : DWORD;

implementation

{$R *.dfm}

uses frmSet, publicLib, SuperObject, SuperXmlParser, dataModule, frmFinish, frmContainer, frmMESLine;

procedure Tfrm_main.InfoTips(fvContent : String; fvColor : TColor = clRed);
begin
  pnl_tipsbar.Caption := fvContent;
  pnl_tipsbar.Font.Color := fvColor;
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
              frm_main.lbl_equipment_state.Font.Color := clMoneyGreen;
              frm_main.shp_equipment_state.Brush.Color := clMoneyGreen;
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
                  frm_set.TabSheet2.Show;
                  frm_set.lbl_host.Caption:='';
                  frm_set.lbl_port.Caption:='';
                end;
            end
          else
            begin
              frm_main.InfoTips('Redis队列名称必须设置，请联系管理员！');
              //Application.MessageBox(PChar('Redis队列名称必须设置，请联系管理员设置！'),'错误',MB_ICONERROR);
              frm_set.ShowModal;
              frm_set.TabSheet2.Show;
              frm_set.lbl_host.Caption:='';
              frm_set.lbl_port.Caption:='';
            end;
        end
      else
        begin
          frm_main.InfoTips('设备信息获取失败，请联系管理员！');
          frm_set.ShowModal;
          frm_set.TabSheet1.Show;
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
      frm_set.TabSheet1.Show;
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
      vO := SO(getLineWorkorder);
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
              gvProduct_id :=  vO.I['result.product_id'];
              gvProduct_code := vO.S['result.product_code'];
              frm_main.lbl_product_code.Caption := gvProduct_code;
              gvInput_qty :=  vO.C['result.input_qty'];
              frm_main.lbl_todo_qty.Caption := FloatToStr(gvInput_qty);
            end
          else
            begin
              gvMainorder_id := vO.I['result.mainorder_id'];
              gvMainorder_name := vO.S['result.mainorder_name'];
              gvWorkorder_id := vO.I['result.workorder_id'];
              gvWorkorder_name := vO.S['result.workorder_name'];
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
                          FieldByName('product_code').AsString := vResult_v.S['product_code'];
                          FieldByName('input_qty').AsFloat := vResult_v.C['input_qty'];
                          FieldByName('todo_qty').AsFloat := vResult_v.C['todo_qty'];
                          FieldByName('output_qty').AsFloat := vResult_v.C['output_qty'];
                          FieldByName('actual_qty').AsFloat := vResult_v.C['actual_qty'];
                          FieldByName('badmode_qty').AsFloat := vResult_v.C['badmode_qty'];
                          if vResult_v.I['weld_count']=0 then FieldByName('weld_count').AsInteger := 1
                          else FieldByName('weld_count').AsInteger := vResult_v.I['weld_count'];
                          FieldByName('materiallist').AsString := vResult_v.S['materiallist'];
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
      frm_main.spb_refresh.Show;
    end
  else if gvline_type='station' then
    begin
      vO := SO(scanWorkticket(gvWorkorder_barcode));
      if vO.B['result.success'] then  //成功刷新工单
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
          log(DateTimeToStr(now())+', [INFO] 工单号【'+gvWorkorder_barcode+'】的扫描成功成功！');
        end
      else  //刷新工单失败
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_barcode+'】的不应该出现在本道工位，错误信息：'+vO.S['result.message']);
        end;
      frm_main.spb_start.Show;
      frm_main.spb_refresh.Hide;
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
  vO_c, vO_m, vResult_c, vResult_m: ISuperObject;
  vMaterials, vConsume : TSuperArray;
  c , m: Integer;
begin
  vO_m := SO(getFeedMaterials);
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
                  FieldByName('material_code').AsString := vResult_c.S['material_code'];
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
                          FieldByName('materiallot_name').AsString := vResult_m.S['materiallot_name'];
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
                  FieldByName('material_code').AsString := vResult_c.S['material_code'];
                  FieldByName('input_qty').AsFloat := vResult_c.C['input_qty'];
                  FieldByName('consume_qty').AsFloat := vResult_c.C['consume_qty'];
                  FieldByName('material_qty').AsFloat := 0;
                  FieldByName('consume_unit').AsFloat := vResult_c.C['consume_unit'];
                  FieldByName('leave_qty').AsFloat := vResult_c.C['leave_qty'];
                  FieldByName('materiallot_id').AsInteger := 0;
                  FieldByName('materiallot_name').AsString := '';
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
                  FieldByName('material_code').AsString := vResult_m.S['material_code'];
                  FieldByName('input_qty').AsFloat := 0;
                  FieldByName('consume_qty').AsFloat := 0;
                  FieldByName('material_qty').AsFloat := vResult_m.C['material_qty'];
                  FieldByName('consume_unit').AsFloat := 0;
                  FieldByName('leave_qty').AsFloat := 0;
                  FieldByName('materiallot_id').AsInteger := vResult_m.I['materiallot_id'];
                  FieldByName('materiallot_name').AsString := vResult_m.S['materiallot_name'];
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
      uvWeld_count := 0;
    end;
end;

procedure Operation_check;
begin
  if (gvStaff_code='') or (gvWorkorder_id<=0) then
    begin
      Inc(uvTip_count);
      if uvTip_count<4 then
        begin
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
        end;
    end;
end;

procedure Collection_Data(const fvFileName : String);
var
  vFile : TFileStream;
  vO, vTest: ISuperObject;
  lvDataJson, lvMdcJson, vTest_field, vTest_value,
  vTest_operator, vTest_SN_value, vTest_result_value : String;
  i, vP : integer;
begin
  try
    case gvFile_type of
      0://普通文本文件
        begin
          SplitStr(GetLastLine(fvFileName), gvDeli, gvCol_count, uvData);
          if uvData.Count>0 then
            begin
              with data_module.cds_mdc do
                begin
                  try
                    //DisableControls;
                    Append;
                    if uvData.Count<=gvHeader_list.Count then
                      begin
                        for i := 0 to uvData.Count-1 do
                          begin
                            if gvHeader_list.ValueFromIndex[i]='String' then
                              FieldByName(gvHeader_list.Names[i]).AsString := uvData.Strings[i]
                            else if gvHeader_list.ValueFromIndex[i]='Float' then
                              FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(uvData.Strings[i])
                            else if gvHeader_list.ValueFromIndex[i]='Integer' then
                              FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(uvData.Strings[i]);
                            if gvApp_testing then
                              begin
                                if gvHeader_list.Names[i]=gvTest_operator_field then vTest_operator := uvData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_SN_field then vTest_SN_value := uvData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_result_field then vTest_result_value := uvData.Strings[i];
                              end;
                          end;
                      end
                    else
                      begin
                        for i := 0 to gvHeader_list.Count-1 do
                          begin
                            if gvHeader_list.ValueFromIndex[i]='String' then
                              FieldByName(gvHeader_list.Names[i]).AsString := uvData.Strings[i]
                            else if gvHeader_list.ValueFromIndex[i]='Float' then
                              FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(uvData.Strings[i])
                            else if gvHeader_list.ValueFromIndex[i]='Integer' then
                              FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(uvData.Strings[i]);
                            if gvApp_testing then
                              begin
                                if gvHeader_list.Names[i]=gvTest_operator_field then vTest_operator := uvData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_SN_field then vTest_SN_value := uvData.Strings[i];
                                if gvHeader_list.Names[i]=gvTest_result_field then vTest_result_value := uvData.Strings[i];
                              end;
                          end;
                      end;
                    Post;
                    if gvTest_operator_field<>'' then  //设置了操作员字段
                      begin
                        if gvStaff_code<>vTest_operator then   //采集到的操作员不在岗
                          begin
                            vO := SO(scanStaff('AM'+vTest_operator));
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
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'',vTest_SN_value,'',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
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
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                              end
                            else
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                              end;
                          end
                        else
                          begin
                            if testingRecord(vTest_SN_value, FALSE, vTest_result_value) then
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                              end
                            else
                              begin
                                log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                              end;
                          end;
                        log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value+', 目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      end
                    else
                      begin
                        log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      end;
                    Weld2yield;
                    Operation_check;
                    //EnableControls;
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
        end;
      1://扭矩焊文件
        begin
          vFile := TFileStream.Create(fvFileName, fmOpenRead);
          uvList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
          for i := gvBegin_row-1 to gvEnd_row-1 do
            begin
              uvData.Add(uvList[i]);
            end;
          if uvData.Text<>'' then vO := XMLParseString(uvData.Text,true);
          if vO.asObject.Count>0 then
            begin
              with data_module.cds_mdc do
                begin
                  try
                    //DisableControls;
                    Append;
                    for i := 0 to gvHeader_list.Count-1 do
                      begin
                        if gvHeader_list.ValueFromIndex[i]='String' then
                          FieldByName(gvHeader_list.Names[i]).AsString := vO.S[gvHeader_list.Names[i]]
                        else if gvHeader_list.ValueFromIndex[i]='Float' then
                          FieldByName(gvHeader_list.Names[i]).AsFloat := vO.D[gvHeader_list.Names[i]]
                        else if gvHeader_list.ValueFromIndex[i]='Integer' then
                          FieldByName(gvHeader_list.Names[i]).AsInteger := vO.I[gvHeader_list.Names[i]];
                      end;
                    Post;
                    lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                    log(lvDataJson);
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                    log(lvMdcJson);
                    Weld2yield;
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
                    Operation_check;
                    //EnableControls;
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
        end;
      2://极柱焊文件
        begin
          vFile := TFileStream.Create(fvFileName, fmOpenRead);
          uvList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
          for i := gvBegin_row-1 to gvEnd_row-1 do
            begin
              uvData.Add(uvList[i]);
            end;
          if uvData.Count>0 then
            begin
              with data_module.cds_mdc do
                begin
                  try
                    //DisableControls;
                    Append;
                    for i := 0 to gvHeader_list.Count-1 do
                      begin
                        if gvHeader_list.ValueFromIndex[i]='String' then
                          FieldByName(gvHeader_list.Names[i]).AsString := uvData.Strings[i]
                        else if gvHeader_list.ValueFromIndex[i]='Float' then
                          FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(uvData.Strings[i])
                        else if gvHeader_list.ValueFromIndex[i]='Integer' then
                          FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(uvData.Strings[i]);
                      end;
                    Post;
                    lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                    Weld2yield;
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
                    Operation_check;
                    //EnableControls;
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
        end;
      3://测试机2文件
        begin
          vFile := TFileStream.Create(fvFileName, fmOpenRead);
          uvList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
          for i := gvBegin_row-1 to gvEnd_row-1 do
            begin
              uvData.Add(uvList[i]);
            end;
          if uvData.Count>0 then
            begin
              with data_module.cds_mdc do
                begin
                  try
                    //DisableControls;
                    Append;
                    for i := 0 to uvData.Count-1 do
                      begin
                        vP := PosEx(#9,uvData.Strings[i]);
                        vTest_field := Copy(uvData.Strings[i],1, vP-1);
                        vTest_value := Copy(uvData.Strings[i],vP+1, Length(uvData.Strings[i]));
                        if vTest_field=gvTest_operator_field then vTest_operator := vTest_value;
                        if vTest_field=gvTest_SN_field then vTest_SN_value := vTest_value;
                        if vTest_field=gvTest_result_field then vTest_result_value := vTest_value;
                        FieldByName(vTest_field).AsString := vTest_value;
                      end;
                    Post;
                    if gvTest_operator_field<>'' then  //设置了操作员字段
                      begin
                        if gvStaff_code<>vTest_operator then   //采集到的操作员不在岗
                          begin
                            vO := SO(scanStaff('AM'+vTest_operator));
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
                    lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvWorkstation_code, gvStaff_code, gvStaff_name, gvProduct_code,'',vTest_SN_value,'',IntToStr(gvMainorder_id), gvMainorder_name, IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
                    Weld2yield;
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
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                          end
                        else
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                          end;
                      end
                    else
                      begin
                        if testingRecord(vTest_SN_value, FALSE, vTest_result_value) then
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据成功，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                          end
                        else
                          begin
                            log(DateTimeToStr(now())+', [INFO] 提交测试机数据失败，序列号：'+vTest_SN_value+'测试值：'+vTest_result_value);
                          end;
                      end;
                    Operation_check;
                    //EnableControls;
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
        end;
    end;
  finally
    vFile.Free;
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
              gvProduct_code := FieldByName('product_code').AsString;
              lbl_product_code.Caption := gvProduct_code;
              lbl_todo_qty.Caption := FieldByName('input_qty').AsString;
              // := FieldByName('todo_qty').AsFloat;
              lbl_good_qty.Caption := FieldByName('output_qty').AsString;
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
                  // := FieldByName('todo_qty').AsFloat;
                  lbl_good_qty.Caption := FieldByName('output_qty').AsString;
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
              //Application.MessageBox(PChar('有待报工数量为:'+IntToStr(gvDoing_qty)+'，请先报工再切换工单！'),'错误',MB_ICONERROR);
              Exit;
            end;
        end;
    end;
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

  //
  gvWorkorder_barcode := ini_set.ReadString('job', 'workorder', gvWorkorder_barcode);
  gvDoing_qty := ini_set.ReadInteger('job', 'doing_qty', gvDoing_qty);

  uvDirSpy := TStringList.Create;
  uvList := TStringList.Create;
  uvData := TStringList.Create;

  //实例化文件监控控件
  OxygenDirectorySpy1 := TOxygenDirectorySpy.Create(Self);
  OxygenDirectorySpy1.WatchSubTree := gvSubfolder;
  OxygenDirectorySpy1.OnChangeDirectory := OxygenDirectorySpy1ChangeDirectory;

  //将主窗口里字段置空
  lbl_equipment.Caption := '无';
  lbl_line.Caption := '无';
  lbl_station.Caption := '无';
end;

procedure Tfrm_main.FormDestroy(Sender: TObject);
begin
  ini_set.WriteBool('server', 'use_proxy', gvUse_Proxy);
  if Length(Trim(gvDatabase))>0 then ini_set.WriteString('server', 'databse', gvDatabase);
  if Length(Trim(gvServer_Host))>0 then ini_set.WriteString('server', 'host', gvServer_Host);
  if gvServer_Port>0 then ini_set.Writeinteger('server', 'port', gvServer_Port);
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
  if uvInput = '' then uvStart := GetTickCount();
  if (Length(uvInput) >= vInputLen) AND (Key=#13) then
    begin
      vFinish := GetTickCount();
      if (vFinish - uvStart) / Length(uvInput) < 100 then
        begin
          uvInput := UpperCase(uvInput);
          if copy(uvInput,1,2)='AM' then  //扫描到的是职员
            begin
              vO := SO(scanStaff(uvInput));
              if vO.B['result.success'] then  //扫码打卡成功
                begin
                  RefreshStaff;
                end
              else  //扫码打卡失败
                begin
                  log(DateTimeToStr(now())+', [INFO] 员工号【'+copy(uvInput,3,Length(uvInput)-2)+'】扫码打卡失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('员工号【'+copy(uvInput,3,Length(uvInput)-2)+'】扫码打卡失败：'+vO.S['result.message']+'！');
                  //Application.MessageBox(PChar('员工号【'+copy(uvInput,3,Length(uvInput)-2)+'】扫码打卡失败：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
                end;
            end;
          if copy(uvInput,1,2)='AQ' then  //扫描到的是工单
            begin
              gvWorkorder_barcode:= uvInput;
              RefreshWorkorder;
              RefreshMaterials;   //扫描到工单后刷新材料信息
              RefreshStaff;
            end;
          if (copy(uvInput,1,2)='AC') OR (copy(uvInput,1,2)='AT') then  //扫描到的是物料
            begin
              vO := SO(feedMaterial(uvInput));
              if vO.B['result.success'] then  //扫码上料成功
                begin
                  if gvline_type='flowing' then RefreshMaterials(gvConsumelist)
                  else RefreshMaterials;
                  frm_main.InfoTips('物料标签号【'+uvInput+'】上料成功！');
                  //Application.MessageBox(PChar('[INFO] 物料标签号【'+uvInput+'】上料成功！'),'提示信息',MB_ICONINFORMATION);
                  log(DateTimeToStr(now())+', [INFO] 物料标签号【'+uvInput+'】上料成功，返回【'+vO.AsObject.S['result']);
                end
              else  //扫码上料失败
                begin
                  log(DateTimeToStr(now())+', [ERROR] 物料标签号【'+uvInput+'】上料失败，错误信息：'+vO.S['result.message']);
                  frm_main.InfoTips('物料标签号【'+uvInput+'】上料失败：'+vO.S['result.message']+'！');
                  //Application.MessageBox(PChar(' 物料标签号【'+uvInput+'】上料失败：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
                end;
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

procedure Tfrm_main.FormShow(Sender: TObject);
begin
  if gvCol_count>0 then
    DataCollectionCDS(gvHeader_lines, gvPrimary_key, gvDeli)
  else
    begin
      frm_main.InfoTips('数据采集模板没有设置，请联系管理员设置！');
      frm_set.ShowModal;
      frm_set.TabSheet2.Show;
    end;
  WorkorderInfoCDS;
  MaterialsInfoCDS;
  BadmodeCDS;
  MESLineCDS;
  StationCDS;
  RefreshEquipment;
  RefreshWorkorder;
  RefreshMaterials;
  RefreshStaff;
  if gvDoing_qty>0 then
    begin
      lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
    end;

  //测试机不显示料单页签和报工按钮
  tbs_workorder.TabVisible:=Not gvApp_testing;
  spb_submit.Visible:=Not gvApp_testing;
  if gvApp_testing then lbl_tag_doing_qty.Caption:='已测试' else lbl_tag_doing_qty.Caption:='待报工';
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
      frm_set.TabSheet2.Show;
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
      if gvline_type='flowing' then    //主线上
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
                          if vResult.S['mesline_type']='flowing' then
                            begin
                              Append;
                              FieldByName('mesline_id').AsInteger := vResult.I['mesline_id'];
                              FieldByName ('mesline_name').AsString := vResult.S['mesline_name'];
                              FieldByName('mesline_type').AsString := vResult.S['mesline_type'];
                              FieldByName('stationlist').AsString := vResult.S['stationlist'];
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
      else if gvline_type='station' then    //工作站
        begin
          frm_main.InfoTips('非主线设备不能切换生产线！');
          log(DateTimeToStr(now())+', [INFO] 非主线设备不能切换生产线！');
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

procedure Tfrm_main.OxygenDirectorySpy1ChangeDirectory(Sender: TObject; ChangeRecord: TDirectoryChangeRecord);
var
  vFileName: String;
begin
  uvDirSpy.Clear;
  uvList.Clear;
  uvData.Clear;
  log(DateTimeToStr(now())+', [INFO] '+ChangeRecord2String(ChangeRecord));
  uvDirSpy.Delimiter := '|';
  uvDirSpy.StrictDelimiter := True;
  uvDirSpy.DelimitedText := ChangeRecord2String(ChangeRecord);
  vFileName:=uvDirSpy.Strings[1];
  //vPath:=ChangeFileExt(ExtractFileName(vFileName),'');
  if POS(uvDirSpy.Strings[2],gvMonitor_type)>0 then
    begin
      Collection_Data(vFileName);
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
      //Application.MessageBox(PChar(vO.S['result.message']),'错误',MB_ICONERROR);
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
  if gvStaff_code='' then
    begin
      frm_main.InfoTips('当前没有操作员，不能报工！');
      //Application.MessageBox(PChar('当前没有操作员，不能报工！'),'错误',MB_ICONERROR);
      Exit;
    end;
  if gvDoing_qty = 0 then
    begin
      frm_main.InfoTips('待报工数量为0，不能报工！');
      //Application.MessageBox(PChar('待报工数量为0，不能报工！'),'错误',MB_ICONERROR);
      Exit;
    end;
  if gvWorkorder_id<=0 then
    begin
      frm_main.InfoTips('当前没有工单，不能报工！');
      //Application.MessageBox(PChar('当前没有工单，不能报工！'),'错误',MB_ICONERROR);
      Exit;
    end;
  vO := SO(queryBadmode);
  if vO.B['result.success'] then  //获取不良模式成功
    begin
      vA := vO.A['result.badmodelist'];
      if vA.Length>0 then
        begin
          with data_module.cds_badmode do
            begin
              EmptyDataSet;
              for i := 0 to vA.Length-1 do
                begin
                  Append;
                  vResult := SO(vA[i].AsString);
                  FieldByName('badmode_id').AsInteger := vResult.I['badmode_id'];
                  FieldByName('badmode_name').AsString := vResult.S['badmode_name'];
                  FieldByName('badmode_qty').AsInteger := 0;
                  Post;
                end;
              Aggregates.Items[0].OnUpdate:=data_module.cds_badmodeAggregates0Update;
            end;
        end;
    end
  else
    begin
      with data_module.cds_badmode do
        begin
          EmptyDataSet;
        end;
    end;
  if gvline_type='flowing' then    //主线上
    begin
      vO := SO(Virtual_FINISH(gvProduct_id,gvDoing_qty));
      if vO.B['result.success'] then  //报工成功
        begin
          lbl_doing_qty.Caption:='0';
          gvDoing_qty:=0;
          RefreshWorkorder;
          RefreshMaterials(gvConsumelist);
        end
      else
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']);
          frm_main.InfoTips('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！');
          //Application.MessageBox(PChar('工单号【'+gvWorkorder_name+'】报工失败，错误信息：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
        end;
    end
  else if gvline_type='station' then    //工作站
    begin
      frm_finish.lbl_product_code.Caption := lbl_product_code.Caption;
      frm_finish.lbl_doing_qty.Caption := lbl_doing_qty.Caption;
      if gvLastworkcenter then    //如果是最后一道工序必须扫描容器
        begin
          frm_container.Show;
        end
      else
        begin
          frm_finish.Show;
        end;
    end;
end;
procedure Tfrm_main.tim_cleartipsTimer(Sender: TObject);
begin
  pnl_tipsbar.Caption := '';
  pnl_tipsbar.Color := clBtnFace;
  tim_cleartips.Enabled := False;
end;

//stb_tipsbar.Panels[1].Text:= FormatDateTime('yyyy"年"m"月"d"日"hh:nn:ss',now);
end.
