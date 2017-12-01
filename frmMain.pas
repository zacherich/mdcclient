﻿unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Data.DB, O2DirSpy, Redis.Client, Redis.Commons, Redis.Values,
  Redis.NetLib.Factory, Redis.NetLib.INDY;

type
  Tfrm_main = class(TForm)
    pnl_top: TPanel;
    pnl_middle: TPanel;
    PageControl1: TPageControl;
    tst_collection: TTabSheet;
    tst_log: TTabSheet;
    lbx_log: TListBox;
    dbg_collection: TDBGrid;
    pnl_collection: TPanel;
    lbl_tag_send_qty: TLabel;
    lbl_send_qty: TLabel;
    lbl_tag_fail_qty: TLabel;
    lbl_fail_qty: TLabel;
    lbl_equipment_state: TLabel;
    shp_equipment_state: TShape;
    lbl_tag_wo: TLabel;
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
    tst_workorder: TTabSheet;
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
    stb_tipsbar: TStatusBar;
    sbt_submit: TSpeedButton;
    sbt_refresh: TSpeedButton;
    Timer1: TTimer;
    lbl_tag_state: TLabel;
    lbl_state: TLabel;
    sbt_start: TSpeedButton;

    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure sbt_startClick(Sender: TObject);
    procedure sbt_submitClick(Sender: TObject);
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
  procedure BadmodeCDS;

var
  frm_main: Tfrm_main;
  uvInput : String;
  uvStart : DWORD;

implementation

{$R *.dfm}

uses frmSet, publicLib, SuperObject, SuperXmlParser, dataModule, frmFinish;

procedure RefreshEquipment;
begin
  if gvApp_code<>'' then
    begin
      frm_set.edt_app_code.Text := gvApp_code;
      if queryEquipment(gvApp_code) then   //jsonRPC获取设备数据成功
        begin
          //主窗口设备信息
          frm_main.lbl_equipment.Caption := '【'+ gvApp_code + '】' + #13 + gvApp_name;
          frm_main.lbl_line.Caption := gvline_code;
          frm_main.lbl_station.Caption := gvStation_code + ' ' + gvStation_name;
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
          frm_set.lbl_line_id.Caption := IntToStr(gvline_id);
          frm_set.lbl_line_code.Caption := gvline_code;
          frm_set.lbl_station_id.Caption := IntToStr(gvStation_id);
          frm_set.lbl_station_code.Caption := gvStation_code;
          frm_set.lbl_station_name.Caption := gvStation_name;
          if gvline_code<>'' then
            begin
              if queryLineType(gvline_code) then
                begin
                  log(DateTimeToStr(now())+', [Info] 生产线【'+gvline_code+'】获取产线类型：'+gvline_type);
                  //获取到了产线类型
                end
              else
                begin
                  log(DateTimeToStr(now())+', [Eror] 生产线【'+gvline_code+'】获取产线类型失败！');
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
                  Application.MessageBox(PChar('MDC服务地址获取失败，请联系管理员重新设置！'),'错误',MB_ICONERROR);
                  frm_set.ShowModal;
                  frm_set.TabSheet2.Show;
                  frm_set.lbl_host.Caption:='';
                  frm_set.lbl_port.Caption:='';
                end;
            end
          else
            begin
              Application.MessageBox(PChar('Redis队列名称必须设置，请联系管理员设置！'),'错误',MB_ICONERROR);
              frm_set.ShowModal;
              frm_set.TabSheet2.Show;
              frm_set.lbl_host.Caption:='';
              frm_set.lbl_port.Caption:='';
            end;
        end
      else
        begin
          Application.MessageBox(PChar('设备信息获取失败，请联系管理员重新设置！'),'错误',MB_ICONERROR);
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
      Application.MessageBox(PChar('设备编码必须设置，请联系管理员设置！'),'错误',MB_ICONERROR);
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
  vO: ISuperObject;
begin
  if gvline_type='flowing' then
    begin
      frm_main.sbt_start.Hide;
      frm_main.sbt_refresh.Show;
    end
  else if gvline_type='station' then
    begin
      vO := SO(scanWorkticket(gvApp_code, gvWorkorder_barcode));
      if vO.B['result.success'] then  //成功刷新工单
        begin
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
          log(DateTimeToStr(now())+', [INFO] 工单号【'+copy(uvInput,3,Length(uvInput)-2)+'】的扫描成功成功！');
        end
      else  //刷新工单失败
        begin
          log(DateTimeToStr(now())+', [ERROR]  工单号【'+copy(uvInput,3,Length(uvInput)-2)+'】的不应该出现在本道工位，错误信息：'+vO.S['result.message']);
        end;
      frm_main.sbt_start.Show;
      frm_main.sbt_refresh.Hide;
    end;
end;

procedure Weld2yield;
begin
  gvWeld_count:=gvWeld_count+1;
  if gvWeld_count=1 then
    begin
      gvWeld_count:=0;
      gvDoing_qty:=gvDoing_qty+1;
      frm_main.lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
      ini_set.WriteString('job', 'workorder', gvWorkorder_barcode);
      ini_set.WriteInteger('job', 'doing_qty', gvDoing_qty);
      ini_set.UpdateFile;
    end;
end;

procedure BadmodeCDS;
var i: Integer;
begin
  with data_module.cds_badmode do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('badmode_id', ftInteger, 0, True);
      FieldDefs.Add('badmode_name', ftString, 30,False);
      FieldDefs.Add('badmode_qty', ftInteger, 0, True);
      IndexDefs.Add('idx_badmode_name', 'badmode_name', []);
      AggregatesActive:=False;
      with Aggregates.Add do
        begin
          AggregateName:='badmode_qty_sum';
          expression:='Sum(badmode_qty)';
          IndexName:= 'idx_badmode_name';
          GroupingLevel:=0;
          Active:=True;
        end;
      AggregatesActive:=True;
      CreateDataSet;
      Open;
    end;
  for i:=0 to frm_finish.dbg_badmode.Columns.Count-1 do
    begin
      if frm_finish.dbg_badmode.Columns[i].FieldName='badmode_id' then
        begin
          frm_finish.dbg_badmode.Columns[i].Visible := False;
        end;
      if frm_finish.dbg_badmode.Columns[i].FieldName='badmode_name' then
        begin
          frm_finish.dbg_badmode.Columns[i].Title.Caption := '不良模式';
        end;
      if frm_finish.dbg_badmode.Columns[i].FieldName='badmode_qty' then
        begin
          frm_finish.dbg_badmode.Columns[i].Title.Caption := '数量';
        end;
      frm_finish.dbg_badmode.Columns[i].Title.Alignment := taCenter;
    end;
end;
procedure Tfrm_main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  CanClose := False;
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
  uvInput := '';
  Self.KeyPreview := True;
  ini_set := TMemIniFile.Create(ChangeFileExt(ParamStr(0), '.ini'), TEncoding.UTF8);
  //获取ini中的server配置信息
  gvUse_Proxy := ini_set.ReadBool('server', 'use_proxy', gvUse_Proxy);
  gvDatabase := ini_set.ReadString('server', 'databse', gvDatabase);
  gvServer_Host := ini_set.ReadString('server', 'host', gvServer_Host);
  gvServer_Port := ini_set.ReadInteger('server', 'port', gvServer_Port);

  //取设备设置信息
  gvApp_code := ini_set.ReadString('equipment', 'app_code', gvApp_code);

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

  //实例化文件监控控件
  OxygenDirectorySpy1 := TOxygenDirectorySpy.Create(Self);
  OxygenDirectorySpy1.WatchSubTree := gvSubfolder;
  OxygenDirectorySpy1.OnChangeDirectory := OxygenDirectorySpy1ChangeDirectory;
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
  vStaff_code, vStaff_name: String;
begin
  if uvInput = '' then uvStart := GetTickCount();
  if (Length(uvInput) >= vInputLen) AND (Key=#13) then
    begin
      vFinish := GetTickCount();
      if (vFinish - uvStart) / Length(uvInput) < 100 then
        begin
          if copy(uvInput,1,2)='AM' then  //扫描到的是职员
            begin
              vO := SO(scanStaff(gvApp_code, uvInput));
              if vO.B['result.success'] then  //扫码打卡成功
                begin
                  if vO.S['result.action']='working' then  //操作工上岗
                    begin
                      vStaff_code := vO.S['result.employee_code'];
                      vStaff_name := vO.S['result.employee_name'];
                      log(DateTimeToStr(now())+', [INFO] 员工号【'+vStaff_code+'】的'+vStaff_name+'扫码上岗成功！');
                    end
                  else  //操作工离岗
                    begin
                      log(DateTimeToStr(now())+', [INFO] 员工号【'+copy(uvInput,3,Length(uvInput)-2)+'】扫码离岗成功！');
                    end;
                  if queryStaffExist(gvApp_code) then  //设备上有操作工
                    begin
                      lbl_operator.Caption := gvStaff_code;
                      log(DateTimeToStr(now())+', [INFO] 设备号【'+gvApp_code+'】上，有员工号【'+gvStaff_code+'】的'+gvStaff_name+'在岗！');
                    end
                  else  //设备上没有操作工
                    begin
                      lbl_operator.Caption := '';
                    end;
                end
              else  //扫码打卡失败
                begin
                  log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】的'+gvStaff_name+'扫码打卡失败，错误信息：'+vO.S['result.message']);
                  Application.MessageBox(PChar('扫码打卡失败：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
                end;
            end;
          if copy(uvInput,1,2)='AQ' then  //扫描到的是工单
            begin
              gvWorkorder_barcode:= uvInput;
              vO := SO(scanWorkticket(gvApp_code, gvWorkorder_barcode));
              if vO.B['result.success'] then  //成功扫描到工单
                begin
                  if lbl_doing_qty.Caption='0' then
                    begin
                      gvWorkorder_id := vO.I['result.workorder_id'];
                      gvWorkorder_name := vO.S['result.workorder_name'];
                      lbl_wo.Caption := gvWorkorder_name;
                      gvWorkticket_id := vO.I['result.workticket_id'];
                      gvWorkticket_name := vO.S['result.workticket_name'];
                      gvWorkticket_state := vO.S['result.state'];
                      lbl_state.Caption := gvWorkticket_state;
                      gvProduct_code := vO.S['result.product_code'];
                      lbl_product_code.Caption := gvProduct_code;
                      gvInput_qty := vO.C['result.input_qty'];
                      lbl_todo_qty.Caption := FloatToStr(gvInput_qty);
                      gvOutput_qty := vO.C['result.output_qty'];
                      lbl_good_qty.Caption := FloatToStr(gvOutput_qty);
                      gvBadmode_qty := vO.C['result.badmode_qty'];
                      lbl_bad_qty.Caption := FloatToStr(gvBadmode_qty);
                      lbl_done_qty.Caption := FloatToStr(gvOutput_qty+gvBadmode_qty);
                      gvLastworkcenter := vO.B['result.lastworkcenter'];
                      log(DateTimeToStr(now())+', [INFO] 工单号【'+copy(uvInput,3,Length(uvInput)-2)+'】的扫描成功成功！');
                    end
                  else
                    begin
                      log(DateTimeToStr(now())+', [ERROR] 工单号【'+lbl_wo.Caption+'】的有未提交的记录，请先提交');
                      Application.MessageBox(PChar('工单号【'+lbl_wo.Caption+'】的有未提交的记录，请先提交'),'错误',MB_ICONERROR);
                    end;
                end
              else  //扫描工单失败
                begin
                  log(DateTimeToStr(now())+', [ERROR]  工单号【'+copy(uvInput,3,Length(uvInput)-2)+'】的不应该出现在本道工位，错误信息：'+vO.S['result.message']);
                end;
            end;
          if copy(uvInput,1,2)='AC' then  //扫描到的是物料
            begin
              vO := SO(feedMaterial(gvApp_code, uvInput));
              if vO.B['result.success'] then  //扫码上料成功
                begin
                  Application.MessageBox(PChar('[INFO] 物料标签号【'+uvInput+'】上料成功！'),'提示信息',MB_ICONINFORMATION);
                  log(DateTimeToStr(now())+', [INFO] 物料标签号【'+uvInput+'】上料成功，返回【'+vO.AsObject.S['result']);
                end
              else  //扫码打卡失败
                begin
                  log(DateTimeToStr(now())+', [INFO] 员工号【'+gvStaff_code+'】的'+gvStaff_name+'扫码打卡失败，错误信息：'+vO.S['result.message']);
                  Application.MessageBox(PChar('扫码打卡失败：'+vO.S['result.message']+'！'),'错误',MB_ICONERROR);
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
  RefreshEquipment;
  BadmodeCDS;
  if gvDoing_qty>0 then
    begin
      RefreshWorkorder;
      lbl_doing_qty.Caption:=IntToStr(gvDoing_qty);
    end
  else
    begin
      if gvline_type='flowing' then
        begin
         sbt_start.Hide;
          sbt_refresh.Show;
        end
      else if gvline_type='station' then
        begin
          sbt_start.Show;
          sbt_refresh.Hide;
        end;
    end;
  if queryStaffExist(gvApp_code) then  //设备上有操作工
    begin
      lbl_operator.Caption := gvStaff_code;
      log(DateTimeToStr(now())+', [INFO] 设备号【'+gvApp_code+'】上，有员工号【'+gvStaff_code+'】的'+gvStaff_name+'在岗！');
    end
  else  //设备上没有操作工
    begin
      lbl_operator.Caption := '';
    end;
  if gvCol_count>0 then
    CreateDataSet(gvHeader_lines, gvPrimary_key, gvDeli)
  else
    begin
      Application.MessageBox(PChar('数据采集模板没有设置，请联系管理员设置！'),'错误',MB_ICONERROR);
      frm_set.ShowModal;
      frm_set.TabSheet2.Show;
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
      Application.MessageBox(PChar('数据采集目录没有设置，请联系管理员设置！'),'错误',MB_ICONERROR);
      frm_set.ShowModal;
      frm_set.TabSheet2.Show;
    end;
end;

procedure Tfrm_main.OxygenDirectorySpy1ChangeDirectory(Sender: TObject; ChangeRecord: TDirectoryChangeRecord);
var
  vList, vData : TStringList;
  vPath, vFileName : String;
  vFile : TFileStream;
  vO : ISuperObject;
  lvDataJson, lvMdcJson : String;
  i : integer;
begin
  vList := TStringList.Create;
  vData := TStringList.Create;
  log(DateTimeToStr(now())+', [INFO] '+ChangeRecord2String(ChangeRecord));
  try
    vList.Delimiter := '|';
    vList.StrictDelimiter := True;
    vList.DelimitedText := ChangeRecord2String(ChangeRecord);
    vFileName:=vList.Strings[1];
    vPath:=ChangeFileExt(ExtractFileName(vFileName),'');
    if (vList.Strings[2]=gvMonitor_type) then
      begin
        case gvFile_type of
          0://普通文本文件
          begin
            vList.Clear;
            vData.Clear;
            //memo1.Text:= GetLastLine(vFileName);
            SplitStr(GetLastLine(vFileName), gvDeli, gvCol_count, vData);
            if vData.Count>0 then
              begin
                with data_module.cds_mdc do
                  begin
                    try
                      //DisableControls;
                      Append;
                      if vData.Count<=gvHeader_list.Count then
                        begin
                          for i := 0 to vData.Count-1 do
                            begin
                              if gvHeader_list.ValueFromIndex[i]='String' then
                                FieldByName(gvHeader_list.Names[i]).AsString := vData.Strings[i]
                              else if gvHeader_list.ValueFromIndex[i]='Float' then
                                FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(vData.Strings[i])
                              else if gvHeader_list.ValueFromIndex[i]='Integer' then
                                FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(vData.Strings[i]);
                            end;
                        end
                      else
                        begin
                          for i := 0 to gvHeader_list.Count-1 do
                            begin
                              if gvHeader_list.ValueFromIndex[i]='String' then
                                FieldByName(gvHeader_list.Names[i]).AsString := vData.Strings[i]
                              else if gvHeader_list.ValueFromIndex[i]='Float' then
                                FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(vData.Strings[i])
                              else if gvHeader_list.ValueFromIndex[i]='Integer' then
                                FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(vData.Strings[i]);
                            end;
                        end;
                      Post;
                      lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                      lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvStation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','','809','1545615', IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
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
                      lbl_send_qty.Caption:=inttostr(gvSucceed);
                      log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      //EnableControls;
                    except on e:Exception do
                      begin
                        Delete;
                        gvFail:=gvFail+1;
                        lbl_fail_qty.Caption:=inttostr(gvFail);
                        log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                      end;
                    end;
                  end;
              end;
          end;
          1://扭矩焊文件
          begin
            vList.Clear;
            vData.Clear;
            vFile := TFileStream.Create(vFileName, fmOpenRead);
            vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
            for i := gvBegin_row-1 to gvEnd_row-1 do
              begin
                vData.Add(vList[i]);
              end;
            if vData.Text<>'' then vO := XMLParseString(vData.Text,true);
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
                      lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvStation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','','809','1545615', IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
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
                      lbl_send_qty.Caption:=inttostr(gvSucceed);
                      log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      //EnableControls;
                    except on e:Exception do
                      begin
                        Delete;
                        gvFail:=gvFail+1;
                        lbl_fail_qty.Caption:=inttostr(gvFail);
                        log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                      end;
                    end;
                  end;
              end;
          end;
          2://极柱焊文件
          begin
            vList.Clear;
            vData.Clear;
            vFile := TFileStream.Create(vFileName, fmOpenRead);
            vList.LoadFromStream(vFile);  //这与 LoadFromFile的区别很大, 特别是当文件很大的时候
            for i := gvBegin_row-1 to gvEnd_row-1 do
              begin
                vData.Add(vList[i]);
              end;
            if vData.Count>0 then
              begin
                with data_module.cds_mdc do
                  begin
                    try
                      //DisableControls;
                      Append;
                      for i := 0 to gvHeader_list.Count-1 do
                        begin
                          if gvHeader_list.ValueFromIndex[i]='String' then
                            FieldByName(gvHeader_list.Names[i]).AsString := vData.Strings[i]
                          else if gvHeader_list.ValueFromIndex[i]='Float' then
                            FieldByName(gvHeader_list.Names[i]).AsFloat := StrToFloat(vData.Strings[i])
                          else if gvHeader_list.ValueFromIndex[i]='Integer' then
                            FieldByName(gvHeader_list.Names[i]).AsInteger := StrToInt(vData.Strings[i]);
                        end;
                      Post;
                      lvDataJson := CDS1LineToJson(data_module.cds_mdc);
                      lvMdcJson := EncodeUniCode(MDCEncode(gvApp_code, IntToStr(gvApp_secret), FormatDateTime('yyyy-mm-dd hh:mm:ss',now),'P', gvStation_code, gvStaff_code, gvStaff_name, gvProduct_code,'','','','809','1545615', IntToStr(gvWorkorder_id), gvWorkorder_name, lvDataJson));
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
                      lbl_send_qty.Caption:=inttostr(gvSucceed);
                      log(DateTimeToStr(now())+', [INFO] 提交redis队列成功，目前总共提交成功'+inttostr(gvSucceed)+'条。');
                      //EnableControls;
                    except on e:Exception do
                      begin
                        Delete;
                        gvFail:=gvFail+1;
                        lbl_fail_qty.Caption:=inttostr(gvFail);
                        log(DateTimeToStr(now())+', [INFO] 采集数据失败，插入clientdataset异常，目前总共提交失败'+inttostr(gvSucceed)+'条。');
                      end;
                    end;
                  end;
              end;
          end;
        end;
      end;
  finally
    vList.Destroy;
    vData.Destroy;
  end;
end;

procedure Tfrm_main.sbt_startClick(Sender: TObject);
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
      Application.MessageBox(PChar(vO.S['result.message']),'错误',MB_ICONERROR);
      log(DateTimeToStr(now())+', [INFO] '+gvWorkorder_name+'工单开工失败:'+vO.S['result.message']);
    end;
end;

procedure Tfrm_main.sbt_submitClick(Sender: TObject);
var
  vO, vResult: ISuperObject;
  vA: TSuperArray;
  i: Integer;
begin
  if lbl_doing_qty.Caption <> '0' then
    begin
      vO := SO(queryBadmod(gvWorkcenter_id));
      if vO.B['result.success'] then  //获取不良模式成功
        begin
          vA := vO['result.badmodelist'].AsArray;
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
        end
      else
        begin
          with data_module.cds_badmode do
            begin
              EmptyDataSet;
            end;
        end;
      frm_finish.Show;
      frm_finish.lbl_product_code.Caption := lbl_product_code.Caption;
      frm_finish.lbl_doing_qty.Caption := lbl_doing_qty.Caption;
      if gvline_type='flowing' then
        begin
          //
        end
      else if gvline_type='station' then
        begin
          if gvLastworkcenter then
            begin
              //
            end
          else
            begin
              //
            end;
        end;
    end
  else
    begin
      Application.MessageBox(PChar('待报工数量为0，不能报工！'),'错误',MB_ICONERROR);
    end;
end;

procedure Tfrm_main.Timer1Timer(Sender: TObject);
begin
  stb_tipsbar.Panels[1].Text:= FormatDateTime('yyyy"年"m"月"d"日"hh:nn:ss',now);
end;

end.
