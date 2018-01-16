unit dataModule;

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
    dsc_mesline: TDataSource;
    cds_mesline: TClientDataSet;
    dsc_station: TDataSource;
    cds_station: TClientDataSet;
    procedure cds_mdcNewRecord(DataSet: TDataSet);
    procedure cds_badmodeAggregates0Update(Agg: TAggregate);
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

procedure Tdata_module.cds_badmodeAggregates0Update(Agg: TAggregate);
begin
  if Not VarIsNull(data_module.cds_badmode.Aggregates.Items[0].Value) then
    begin
      if data_module.cds_badmode.Aggregates.Items[0].Value>StrToInt(frm_finish.edt_submit.Text) then
        begin
          Application.MessageBox(PChar('不合格数量不能超过待报工数量！'),'错误',MB_ICONERROR);
        end
      else
        begin
          frm_finish.lbl_bad_qty.Caption := IntToStr(data_module.cds_badmode.Aggregates.Items[0].Value);
          frm_finish.lbl_good_qty.Caption := IntToStr(StrToInt(frm_finish.edt_submit.Text)-StrToInt(frm_finish.lbl_bad_qty.Caption));
        end;
    end;
end;

procedure Tdata_module.cds_mdcNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('mdc_state').AsInteger := 0;
end;

end.
