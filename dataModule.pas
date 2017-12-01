unit dataModule;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Data.DB, Datasnap.DBClient, Vcl.Forms, IdTCPClient, IdTCPConnection,  IdComponent, IdBaseComponent,
  Redis.Client, Redis.Commons, Redis.Values, Redis.NetLib.Factory, Redis.NetLib.INDY;

type
  Tdata_module = class(TDataModule)
    cds_mdc: TClientDataSet;
    dsc_mdc: TDataSource;
    dsc_badmode: TDataSource;
    cds_badmode: TClientDataSet;
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

uses publicLib, frmFinish;

procedure Tdata_module.cds_badmodeAggregates0Update(Agg: TAggregate);
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

procedure Tdata_module.cds_mdcNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('mdc_state').AsInteger := 0;
end;

end.
