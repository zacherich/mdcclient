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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_finish: Tfrm_finish;

implementation

uses dataModule;

{$R *.dfm}

end.
