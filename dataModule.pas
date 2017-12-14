﻿unit dataModule;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants, Data.DB, Datasnap.DBClient, Vcl.Forms;

type
  Tdata_module = class(TDataModule)
    cds_mdc: TClientDataSet;
    dsc_mdc: TDataSource;
    dsc_badmode: TDataSource;
    cds_badmode: TClientDataSet;
    dsc_workorder: TDataSource;
    cds_workorder: TClientDataSet;
    dsc_materials: TDataSource;
    cds_materials: TClientDataSet;
    procedure cds_mdcNewRecord(DataSet: TDataSet);
    procedure cds_badmodeAggregates0Update(Agg: TAggregate);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  data_module: Tdata_module;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses frmMain, publicLib, frmFinish;

procedure WorkorderInfoCDS;
var i: Integer;
begin
  with data_module.cds_workorder do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('product_id', ftInteger, 0, True);  //产品编号
      FieldDefs.Add('product_code', ftString, 30, True);  //产品编号
      FieldDefs.Add('input_qty', ftFloat, 0, False);    //计划数量
      FieldDefs.Add('todo_qty', ftFloat, 0, False);   //待做数量
      FieldDefs.Add('output_qty', ftFloat, 0, False);  //产出数量
      FieldDefs.Add('actual_qty', ftFloat, 0,False);  //实做数量
      FieldDefs.Add('badmode_qty', ftFloat, 0, False);   //不良数量
      FieldDefs.Add('weld_count', ftInteger, 0, False);  //焊接次数
      FieldDefs.Add('materiallist', ftString, 255, False);  //原料列表
      IndexDefs.Add('idx_product_id', 'product_id', [IxPrimary]);
      CreateDataSet;
      Open;
    end;
  for i:=0 to frm_main.dbg_workorder.Columns.Count-1 do
    begin
      if frm_main.dbg_workorder.Columns[i].FieldName='product_id' then
        begin
          frm_main.dbg_workorder.Columns[i].Visible := False;
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='product_code' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '产品编码';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='input_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '计划数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='todo_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '待做数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='output_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '产出数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='actual_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '实做数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='badmode_qty' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '不良数量';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='weld_count' then
        begin
          frm_main.dbg_workorder.Columns[i].Title.Caption := '焊接次数';
        end;
      if frm_main.dbg_workorder.Columns[i].FieldName='materiallist' then
        begin
          frm_main.dbg_workorder.Columns[i].Visible := False;
        end;
      frm_main.dbg_workorder.Columns[i].Title.Alignment := taCenter;
    end;
end;

procedure MaterialsInfoCDS;
var i: Integer;
begin
  with data_module.cds_materials do
    begin
      FieldDefs.Clear;
      Close;
      FieldDefs.Add('material_id', ftInteger, 0, True);  //原料编号
      FieldDefs.Add('material_code', ftString, 25, True);  //原料编号
      FieldDefs.Add('input_qty', ftFloat, 0, False);    //计划消耗数量
      FieldDefs.Add('consume_qty', ftFloat, 0, False);  //消耗数量
      FieldDefs.Add('material_qty', ftFloat, 0, False);   //工位数量
      FieldDefs.Add('consume_unit', ftFloat, 0,False);  //单位消耗数量
      FieldDefs.Add('leave_qty', ftFloat, 0, False);   //剩余数量
      FieldDefs.Add('materiallot_id', ftInteger, 0, False);  //工位原料批号ID
      FieldDefs.Add('materiallot_name', ftString, 20, False);  //工位原料批号
      IndexDefs.Add('idx_material_id', 'material_id', [IxPrimary]);
      CreateDataSet;
      Open;
    end;
  for i:=0 to frm_main.dbg_materiel.Columns.Count-1 do
    begin
      if frm_main.dbg_materiel.Columns[i].FieldName='material_id' then
        begin
          frm_main.dbg_materiel.Columns[i].Visible := False;
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='material_code' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '原料编码';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='consume_unit' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '单位消耗';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='input_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '计划消耗';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='consume_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '已耗数量';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='leave_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '待耗数量';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='material_qty' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '上料数量';
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='materiallot_id' then
        begin
          frm_main.dbg_materiel.Columns[i].Visible := False;
        end;
      if frm_main.dbg_materiel.Columns[i].FieldName='materiallot_name' then
        begin
          frm_main.dbg_materiel.Columns[i].Title.Caption := '原料批号';
        end;
      frm_main.dbg_materiel.Columns[i].Title.Alignment := taCenter;
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

procedure Tdata_module.cds_badmodeAggregates0Update(Agg: TAggregate);
begin
  if Not VarIsNull(data_module.cds_badmode.Aggregates.Items[0].Value) then
    begin
      if data_module.cds_badmode.Aggregates.Items[0].Value>StrToInt(frm_finish.lbl_doing_qty.Caption) then
        begin
          Application.MessageBox(PChar('不合格数量不能超过待报工数量！'),'错误',MB_ICONERROR);
        end
      else
        begin
          frm_finish.lbl_bad_qty.Caption := IntToStr(data_module.cds_badmode.Aggregates.Items[0].Value);
          frm_finish.lbl_good_qty.Caption := IntToStr(StrToInt(frm_finish.lbl_doing_qty.Caption)-StrToInt(frm_finish.lbl_bad_qty.Caption));
        end;
    end;
end;

procedure Tdata_module.cds_mdcNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('mdc_state').AsInteger := 0;
end;

procedure Tdata_module.DataModuleCreate(Sender: TObject);
begin
  WorkorderInfoCDS;
  MaterialsInfoCDS;
  BadmodeCDS;
end;

end.
